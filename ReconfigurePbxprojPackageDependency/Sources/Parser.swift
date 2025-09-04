//===----------------------------------------------------------------------===//
// This source file is part of github.com/apple/SwiftUsd-Tests
//
// Copyright © 2025 Apple Inc. and the SwiftUsd-Tests project authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0
//===----------------------------------------------------------------------===//

import Foundation

struct Parser {
    init() {}
    
    enum ParserError: Error {
        case objectKeyWithoutValue
        case objectValueWithoutSemiColon
        case illegalObjectKey(TrivaCombiner.Token)
        case unterminatedObject
        case illegalTokenAfterListElement(TrivaCombiner.Token)
        case unterminatedList
        case illegalToken(TrivaCombiner.Token)
        case unexpectedEOF
    }
    
    func parse(tokens: [TrivaCombiner.Token]) throws -> Parser.Value {
        var index = 0
        return try _parse(tokens: tokens, index: &index)
    }
    
    private func _parse(tokens: [TrivaCombiner.Token], index: inout Int) throws -> Parser.Value {
        
        func indexIsValid() -> Bool { index < tokens.count }
        func currentToken() -> TrivaCombiner.Token { tokens[index] }
        func advance() { index += 1 }
        func canAdvance() -> Bool { index + 1 < tokens.count }
        func nextToken() -> TrivaCombiner.Token { tokens[index + 1] }
        
        while indexIsValid() {
            switch currentToken().kind {
            case .lBrace:
                var result = Object(lBrace: .init(value: currentToken()))
                advance()
                
                while indexIsValid() {
                    switch currentToken().kind {
                    case .rBrace:
                        result.rBrace = .init(value: currentToken()); advance()
                        return .object(result)
                    case .bareString, .quotedString:
                        let key = currentToken(); advance()
                        
                        guard indexIsValid(), currentToken().kind == .equals else { throw ParserError.objectKeyWithoutValue }
                        let equals = currentToken(); advance()
                        
                        guard indexIsValid() else {
                            throw ParserError.objectKeyWithoutValue
                        }
                        let value = try _parse(tokens: tokens, index: &index)
                        
                        
                        guard indexIsValid(), currentToken().kind == .semiColon else {
                            throw ParserError.objectValueWithoutSemiColon
                        }
                        let semiColon = currentToken(); advance()
                        
                        result.add(.init(value: key), .init(value: equals), value, .init(value: semiColon))

                    default:
                        throw ParserError.illegalObjectKey(currentToken())
                    }
                }
                
                throw ParserError.unterminatedObject
                
            case .lParen:
                let lParen = currentToken()
                var result = [(Value, Token)]()
                advance()
                
                while indexIsValid() {
                    switch currentToken().kind {
                    case .rParen:
                        let rParen = currentToken(); advance()
                        return .list(.init(value: lParen), result, .init(value: rParen))
                    default:
                        let value = try _parse(tokens: tokens, index: &index)
                        guard indexIsValid(), currentToken().kind == .comma else {
                            throw ParserError.illegalTokenAfterListElement(currentToken())
                        }
                        let comma = currentToken(); advance()
                        
                        result.append((value, .init(value: comma)))
                    }
                }
                
                throw ParserError.unterminatedList
                
            case .quotedString, .bareString:
                let result = Value.string(.init(value: currentToken()))
                advance()
                return result
                
            case .rBrace, .rParen, .equals, .semiColon, .comma:
                throw ParserError.illegalToken(currentToken())
            }
        }
        
        throw ParserError.unexpectedEOF
    }
    
    struct Token: Equatable, Hashable {
        var value: TrivaCombiner.Token
        
        static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.value.tokenText == rhs.value.tokenText
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(value.tokenText)
        }
        
        var asString: String {
            (value.leadingTrivia ?? "") + value.tokenText + (value.trailingTrivia ?? "")
        }
    }
    
    struct Object {
        init(lBrace: Token) {
            self.lBrace = lBrace
        }
        
        private(set) var keyOrder: [Token] = []
        private(set) var keyEqualsValueSemiColonPairs: [Token : (Parser.Token, Value, Parser.Token)] = [:]
        
        let lBrace: Token
        var rBrace: Token!
        
        func key(named: String) -> Token? {
            keyOrder.first { $0.value.tokenText == named }
        }
        
        mutating func add(_ key: Token, _ equals: Token, _ value: Value, _ semiColon: Token) {
            if keyEqualsValueSemiColonPairs[key] == nil {
                keyOrder.append(key)
                keyEqualsValueSemiColonPairs[key] = (equals, value, semiColon)
            } else {
                keyOrder = keyOrder.map { $0 == key ? key : $0 }
                let old = keyEqualsValueSemiColonPairs[key]!
                let new = (old.0, value, old.2)
                keyEqualsValueSemiColonPairs[key] = nil
                keyEqualsValueSemiColonPairs[key] = new
            }
        }
        
        subscript (key: Token) -> Value? {
            get {
                keyEqualsValueSemiColonPairs[key]?.1
            } set {
                if let newValue {
                    add(key,
                        .init(value: .init(kind: .equals, tokenText: "=", leadingTrivia: nil, trailingTrivia: " ")),
                              newValue,
                        .init(value: .init(kind: .semiColon, tokenText: ";", leadingTrivia: nil, trailingTrivia: "\n")))
                } else {
                    keyOrder = keyOrder.filter { $0 != key }
                    keyEqualsValueSemiColonPairs[key] = nil
                }
            }
        }
        
        var asString: String {
            var result = [lBrace.asString]
            for k in keyOrder {
                let (equals, value, semiColon) = keyEqualsValueSemiColonPairs[k]!
                result.append("\(k.asString)\(equals.asString)\(value.asString)\(semiColon.asString)")
            }
            result.append(rBrace.asString)
            return result.joined()
        }
    }
    
    enum Value: Sendable {
        case object(Object)
        case string(Token)
        case list(Token, [(Value, Token)], Token)
        
        var asString: String {
            switch self {
            case let .object(o): return o.asString
            case let .string(s): return s.asString
            case let .list(lParen, l, rParen):
                var result = [lParen.asString]
                for (x, comma) in l {
                    result.append(x.asString)
                    result.append(comma.asString)
                }
                result.append(rParen.asString)
                return result.joined()
            }
        }
    }
}
