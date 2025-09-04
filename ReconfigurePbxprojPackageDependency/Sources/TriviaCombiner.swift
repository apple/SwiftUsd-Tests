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

struct TrivaCombiner {
    struct Token: CustomStringConvertible {
        enum Kind {
            case lBrace
            case rBrace
            case lParen
            case rParen
            case equals
            case semiColon
            case comma
            case quotedString
            case bareString
        }
        
        var kind: Kind
        var tokenText: String
        var leadingTrivia: String?
        var trailingTrivia: String?
        
        init(kind: Kind, tokenText: String, leadingTrivia: String?, trailingTrivia: String? = nil) {
            self.kind = kind
            self.tokenText = tokenText
            self.leadingTrivia = leadingTrivia
            self.trailingTrivia = trailingTrivia
        }
        
        var description: String {
            "(kind: \(kind), tokenText: \(tokenText), leadingTrivia: '\(leadingTrivia ?? "nil")', trailingTrivia: '\(trailingTrivia ?? "nil")')"
        }
    }
    
    init() {}

    func combine(tokens: [Tokenizer.Token]) -> [TrivaCombiner.Token] {
        var result = [TrivaCombiner.Token]()
        
        var initialTrivia: String?
        
        for token in tokens {
            switch token.kind {
            case .lBrace:
                result.append(.init(kind: .lBrace, tokenText: "{", leadingTrivia: initialTrivia))
                if initialTrivia != nil { initialTrivia = nil }
                
            case .rBrace:
                result.append(.init(kind: .rBrace, tokenText: "}", leadingTrivia: initialTrivia))
                if initialTrivia != nil { initialTrivia = nil }
                
            case .lParen:
                result.append(.init(kind: .lParen, tokenText: "(", leadingTrivia: initialTrivia))
                if initialTrivia != nil { initialTrivia = nil }
                
            case .rParen:
                result.append(.init(kind: .rParen, tokenText: ")", leadingTrivia: initialTrivia))
                if initialTrivia != nil { initialTrivia = nil }
                
            case .equals:
                result.append(.init(kind: .equals, tokenText: "=", leadingTrivia: initialTrivia))
                if initialTrivia != nil { initialTrivia = nil }

            case .semiColon:
                result.append(.init(kind: .semiColon, tokenText: ";", leadingTrivia: initialTrivia))
                if initialTrivia != nil { initialTrivia = nil }
                
            case .comma:
                result.append(.init(kind: .comma, tokenText: ",", leadingTrivia: initialTrivia))
                if initialTrivia != nil { initialTrivia = nil }

            case let .whitespace(x), let .multilineComment(x):
                if result.isEmpty { initialTrivia = (initialTrivia ?? "") + x }
                else {
                    result[result.count - 1].trailingTrivia = (result[result.count - 1].trailingTrivia ?? "") + x
                }
                
            case let .quotedString(x):
                result.append(.init(kind: .quotedString, tokenText: x, leadingTrivia: initialTrivia))
                if initialTrivia != nil { initialTrivia = nil }
                
            case let .bareString(x):
                result.append(.init(kind: .bareString, tokenText: x, leadingTrivia: initialTrivia))
                if initialTrivia != nil { initialTrivia = nil }
            }
        }
        
        return result
    }
}
