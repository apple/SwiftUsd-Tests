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


struct Tokenizer {
    enum TokenizerError: Error {
        case noNewlineInFile
        case unknownFileEncoding
        case unterminatedMultilineComment
        case unterminatedQuotedString
    }
    
    
    
    struct Token: CustomStringConvertible {
        var kind: Kind
        var startIndex: String.Index
        var endIndex: String.Index
        
        enum Kind {
            case lBrace
            case rBrace
            case lParen
            case rParen
            case equals
            case semiColon
            case comma
            case whitespace(String)
            case multilineComment(String)
            case quotedString(String)
            case bareString(String)
        }
        
        var description: String {
            switch kind {
            case .lBrace: "LBRACE"
            case .rBrace: "RBRACE"
            case .lParen: "LPAREN"
            case .rParen: "RPAREN"
            case .equals: "EQUALS"
            case .semiColon: "SEMICOLON"
            case .comma: "COMMA"
            case let .whitespace(x): "WHITESPACE(\(x))"
            case let .multilineComment(x): "MULTILINECOMMENT(\(x))"
            case let .quotedString(x): "QUOTEDSTRING(\(x))"
            case let .bareString(x): "BARESTRING(\(x))"
            }
        }

    }
    
    var fileContents: String
    
    init(fileURL: URL) throws {
        let fileData = try String(contentsOf: fileURL, encoding: .utf8)
        guard let firstNewlineIndex = fileData.firstIndex(where: { $0.isNewline }) else {
            throw TokenizerError.noNewlineInFile
        }
        let firstLine = fileData[..<firstNewlineIndex]
        guard firstLine.wholeMatch(of: #/// *!\$\*UTF8\*\$! */#) != nil else {
            print("Unknown file encoding. First line is '\(firstLine)'")
            throw TokenizerError.unknownFileEncoding
        }
        
        fileContents = String(fileData[fileData.index(after: firstNewlineIndex)...])
    }
    
    init(fileContents: String) {
        self.fileContents = fileContents
    }
    
    func tokenize() throws -> [Token] {
        var result = [Token]()
        
        var index = fileContents.startIndex
        
        func indexIsValid() -> Bool { index < fileContents.endIndex }
        func currentCharacter() -> Character { fileContents[index] }
        func nextIndex() -> String.Index { fileContents.index(after: index) }
        func advance() { index = nextIndex() }
        func canAdvance() -> Bool { nextIndex() < fileContents.endIndex }
        func nextCharacter() -> Character { fileContents[nextIndex()] }
        
        while indexIsValid() {
            switch currentCharacter() {
            case "{": result.append(.init(kind: .lBrace, startIndex: index, endIndex: nextIndex())); advance()
            case "}": result.append(.init(kind: .rBrace, startIndex: index, endIndex: nextIndex())); advance()
            case "(": result.append(.init(kind: .lParen, startIndex: index, endIndex: nextIndex())); advance()
            case ")": result.append(.init(kind: .rParen, startIndex: index, endIndex: nextIndex())); advance()
            case "=": result.append(.init(kind: .equals, startIndex: index, endIndex: nextIndex())); advance()
            case ";": result.append(.init(kind: .semiColon, startIndex: index, endIndex: nextIndex())); advance()
            case ",": result.append(.init(kind: .comma, startIndex: index, endIndex: nextIndex())); advance()
                
            case _ where currentCharacter().isWhitespace:
                let startIndex = index
                var whitespace = ""
                while indexIsValid() && currentCharacter().isWhitespace {
                    whitespace.append(currentCharacter()); advance()
                }
                result.append(.init(kind: .whitespace(whitespace), startIndex: startIndex, endIndex: index))
                
            case "/" where nextCharacter() == "*":
                let startIndex = index
                var comment = ""
                var foundTerminator = false
                while indexIsValid() {
                    comment.append(currentCharacter()); advance()
                    if comment.hasSuffix("*/") {
                        result.append(.init(kind: .multilineComment(comment), startIndex: startIndex, endIndex: index))
                        foundTerminator = true
                        break
                    }
                }
                guard foundTerminator else { throw TokenizerError.unterminatedMultilineComment }
                
            case "\"":
                let startIndex = index
                var quotedString = ""
                var foundTerminator = false
                while indexIsValid() {
                    quotedString.append(currentCharacter()); advance()
                    if quotedString.count > 1 && quotedString.last == "\"" {
                        result.append(.init(kind: .quotedString(quotedString), startIndex: startIndex, endIndex: index))
                        foundTerminator = true
                        break
                    }
                }
                guard foundTerminator else { throw TokenizerError.unterminatedQuotedString }
                
            default:
                let startIndex = index
                var bareString = ""
                while indexIsValid() {
                    func isAtTerminator() -> Bool {
                        switch currentCharacter() {
                        case "{", "}", "(", ")", "=", ";", ",": true
                        case _ where currentCharacter().isWhitespace: true
                        case "/" where canAdvance() && nextCharacter() == "*": true
                        case "\"": true
                        default: false
                        }
                    }
                    
                    if isAtTerminator() { break }
                    bareString.append(currentCharacter()); advance()
                }
                result.append(.init(kind: .bareString(bareString), startIndex: startIndex, endIndex: index))
            }
        }
        
        return result
    }
}
