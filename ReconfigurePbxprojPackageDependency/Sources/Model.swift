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

fileprivate extension Parser.Object {
    init(indentation: Int, kvPairs: (String, Parser.Value)...) {
        self.init(lBrace: .init(value: .init(kind: .lBrace, tokenText: "{", leadingTrivia: nil, trailingTrivia: "\n")))
        for kvPair in kvPairs {
            add(.init(value: .init(kind: .bareString, tokenText: kvPair.0, leadingTrivia: String(repeating: "\t", count: indentation))),
                .init(value: .init(kind: .equals, tokenText: "=", leadingTrivia: " ", trailingTrivia: " ")),
                kvPair.1,
                .init(value: .init(kind: .semiColon, tokenText: ";", leadingTrivia: nil, trailingTrivia: "\n")))
        }
        rBrace = .init(value: .init(kind: .rBrace, tokenText: "}", leadingTrivia: String(repeating: "\t", count: indentation - 1)))
    }
}

fileprivate extension Parser.Value {
    init(_ s: String) {
        self = .string(.init(value: .init(kind: .bareString, tokenText: s, leadingTrivia: nil)))
    }
}

struct Model {
    var value: Value
    
    init(value: Parser.Value) {
        self.value = Value(value)
    }
    
    enum Dependency {
        struct Local {
            var relativePath: String
        }
        
        struct Remote {
            var repositoryURL: String
            var requirement: Requirement
            
            enum Requirement {
                case upToNextMajorVersion(String)
                case upToNextMinorVersion(String)
                case exactVersion(String)
                case versionRange(String, String)
                case branch(String)
                case revision(String)
                
                var asValue: Parser.Value {
                    let indentation = 4
                    
                    return switch self {
                    case let .upToNextMajorVersion(x):
                            .object(.init(indentation: indentation, kvPairs:
                                            ("kind", .init("upToNextMajorVersion")),
                                          ("minimumVersion", .init(x))
                                         ))
                        
                    case let .upToNextMinorVersion(x):
                            .object(.init(indentation: indentation, kvPairs:
                                            ("kind", .init("upToNextMinorVersion")),
                                          ("minimumVersion", .init(x))
                                         ))
                        
                    case let .exactVersion(x):
                            .object(.init(indentation: indentation, kvPairs:
                                            ("kind", .init("exactVersion")),
                                          ("minimumVersion", .init(x))
                                         ))
                    case let .versionRange(min, max):
                            .object(.init(indentation: indentation, kvPairs:
                                            ("kind", .init("versionRange")),
                                          ("maximumVersion", .init(max)),
                                          ("minimumVersion", .init(min))
                                         ))
                        
                    case let .branch(branch):
                            .object(.init(indentation: indentation, kvPairs:
                                            ("kind", .init("branch")),
                                          ("branch", .init(branch))
                                         ))
                        
                    case let .revision(revision):
                            .object(.init(indentation: indentation, kvPairs:
                                            ("kind", .init("revision")),
                                          ("revision", .init(revision))
                                         ))

                    }
                }
            }
        }
        
        case local(Local)
        case remote(Remote)
        
        var asValue: Parser.Value {
            switch self {
            case let .local(local):
                    .object(.init(indentation: 3, kvPairs:
                                    ("isa", .init("XCLocalSwiftPackageReference")),
                                  ("relativePath", .init(local.relativePath))
                                 ))
                
            case let .remote(remote):
                    .object(.init(indentation: 3, kvPairs:
                                    ("isa", .init("XCRemoteSwiftPackageReference")),
                                  ("repositoryURL", .init(remote.repositoryURL)),
                                  ("requirement", remote.requirement.asValue)
                                 ))
            }
        }
    }
    
    enum ModelError: Error {
        case valueIsNotObject(Parser.Value)
        case missingKey(String)
        case valueIsNotString(Parser.Value)
        case valueIsNotList(Parser.Value)
        case unknownPackageReferenceIsaValue(Parser.Value)
        case unknownPackageReferenceRequirementKindValue(Parser.Value)
        case noSuchDependency(Model.Dependency)
    }
    
    struct Value {
        init(_ impl: Parser.Value) {
            self.impl = impl
        }
        
        private(set) var impl: Parser.Value
        
        var objectKeys: [Parser.Token] {
            get throws {
                switch impl {
                case let .object(object): return object.keyOrder
                default: throw ModelError.valueIsNotObject(impl)
                }
            }
        }
        
        subscript(objectKey objectKey: String) -> Value {
            get throws {
                switch impl {
                case let .object(object):
                    guard let value = object.keyEqualsValueSemiColonPairs[.init(value: .init(kind: .bareString, tokenText: objectKey, leadingTrivia: nil))]?.1 else {
                        throw ModelError.missingKey(objectKey)
                    }
                    return Value(value)
                default: throw ModelError.valueIsNotObject(impl)
                }
            }
        }
        
        subscript(objectKeys objectKeys: String...) -> Value {
            get throws {
                try self[objectKeys: objectKeys]
            }
        }
        
        subscript (objectKeys objectKeys: [String]) -> Value {
            get throws {
                var result = self
                for k in objectKeys {
                    result = try result[objectKey: k]
                }
                return result
            }
        }
        
        var asToken: String {
            get throws {
                switch impl {
                case let .string(x): x.value.tokenText
                default: throw ModelError.valueIsNotString(impl)
                }
            }
        }
        
        var asList: [Value] {
            get throws {
                switch impl {
                case let .list(_, l, _): return l.map { .init($0.0) }
                default: throw ModelError.valueIsNotList(impl)
                }
            }
        }
        
        mutating func replace(_ newValue: Parser.Value, at keys: String..., trailingTrivia: String? = nil) throws {
            var stack = [impl]
            for k in keys {
                stack.append(try Model.Value(stack.last!)[objectKey: k].impl)
            }
            stack[stack.count - 1] = newValue
            
            for i in (0..<stack.count - 1).reversed() {
                guard case var .object(obj) = stack[i] else { fatalError("impossible") }
                guard var key = obj.key(named: keys[i]) else { fatalError("impossible") }
                if i == stack.count - 1 {
                    key.value.trailingTrivia = trailingTrivia
                }
                obj[key] = stack[i + 1]
                stack[i] = .object(obj)
            }
            impl = stack[0]
        }
    }
        
    private func dependencies() throws -> [(Dependency, String)] {
        let projectId = try value[objectKey: "rootObject"].asToken
        let project = try value[objectKeys: "objects", projectId]
        let packageReferencesList = try project[objectKey: "packageReferences"]
        let packageReferencesIds = try packageReferencesList.asList.map { try $0.asToken }
        
        return try packageReferencesIds.map { (try value[objectKeys: "objects", $0], $0) }.map {
            switch try $0[objectKey: "isa"].asToken {
            case "XCLocalSwiftPackageReference":
                let relativePath = try $0[objectKey: "relativePath"].asToken
                return (.local(.init(relativePath: relativePath)), $1)
                
            case "XCRemoteSwiftPackageReference":
                let repositoryURL = try $0[objectKey: "repositoryURL"].asToken
                switch try $0[objectKeys: "requirement", "kind"].asToken {
                case "upToNextMajorVersion":
                    let minimumVersion = try $0[objectKeys: "requirement", "minimumVersion"].asToken
                    return (.remote(.init(repositoryURL: repositoryURL, requirement: .upToNextMajorVersion(minimumVersion))), $1)
                    
                case "upToNextMinorVersion":
                    let minimumVersion = try $0[objectKeys: "requirement", "minimumVersion"].asToken
                    return (.remote(.init(repositoryURL: repositoryURL, requirement: .upToNextMinorVersion(minimumVersion))), $1)
                    
                case "exactVersion":
                    let version = try $0[objectKeys: "requirement", "version"].asToken
                    return (.remote(.init(repositoryURL: repositoryURL, requirement: .exactVersion(version))), $1)
                    
                case "versionRange":
                    let minimum = try $0[objectKeys: "requirement", "minimumVersion"].asToken
                    let maximum = try $0[objectKeys: "requirement", "maximumVersion"].asToken
                    return (.remote(.init(repositoryURL: repositoryURL, requirement: .versionRange(minimum, maximum))), $1)
                    
                case "branch":
                    let branch = try $0[objectKeys: "requirement", "branch"].asToken
                    return (.remote(.init(repositoryURL: repositoryURL, requirement: .branch(branch))), $1)
                    
                case "revision":
                    let revision = try $0[objectKeys: "requirement", "revision"].asToken
                    return (.remote(.init(repositoryURL: repositoryURL, requirement: .revision(revision))), $1)
                    
                default:
                    throw ModelError.unknownPackageReferenceRequirementKindValue($0.impl)
                }
                
            default:
                throw ModelError.unknownPackageReferenceIsaValue($0.impl)
            }
        }
    }
        
    mutating func replace(dependency old: Dependency, with new: Dependency) throws {
        for (existing, id) in try dependencies() {
            var shouldReplace = false
            
            switch (existing, old) {
            case let (.local(existingLocal), .local(oldLocal)):
                if existingLocal.relativePath == oldLocal.relativePath {
                    shouldReplace = true
                }
                
            case let (.remote(existingRemote), .remote(oldRemote)):
                if existingRemote.repositoryURL == oldRemote.repositoryURL {
                    shouldReplace = true
                }
                
            default: break
            }
            
            if shouldReplace {
                try value.replace(new.asValue, at: "objects", id, trailingTrivia: " /* SwiftPackageReference modified by script */ ")
                return
            }
        }
        
        throw ModelError.noSuchDependency(old)
    }
    
    func exportAsString() -> String {
        "// !$*UTF8*$!\n\(value.impl.asString)\n"
    }
    
    func export(to: URL) throws {
        try exportAsString().write(to: to, atomically: true, encoding: .utf8)
    }
}
