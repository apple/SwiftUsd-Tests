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

import ArgumentParser
import Foundation

@main
struct ReconfigurePbxprojPackageDependency: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Reconfigures Swift Package dependencies in project.pbxproj files",
                                                    discussion: """
    Local dependencies can be specified as the local dependency path. 
    Remote dependencies can be specified as the repository URL, optionally followed by a colon and the dependency kind, optionally followed by zero or more refs separated by colons. 
    Valid dependencies kinds are `upToNextMajor`, `upToNextMinor`, `exactVersion`, `versionRange`, `branch`, `commit`
    
    Examples:
    `../SwiftUsd`: Local dependency
    `https://github.com/apple/SwiftUsd`:upToNextMajor:5.1.0`: Remote dependency for 5.1.0..<6
    `https://github.com/apple/SwiftUsd:branch:dev`: Remote dependency on the dev branch
    
    `--replace https://github.com/apple/SwiftUsd --with ../SwiftUsd`: Replace the remote dependency with url `https://github.com/apple/SwiftUsd` (regardless of dependency kind) with the local dependency `../SwiftUsd`
    """)
    
    enum Dependency: ExpressibleByArgument {
        case remote(RemoteDependency)
        case local(LocalDependency)
        
        init?(argument: String) {
            if argument.starts(with: "http") {
                if let x = RemoteDependency(argument: argument) {
                    self = .remote(x)
                    return
                }
            }
            
            if argument.contains(":") { return nil }
            if let x = LocalDependency(argument: argument) {
                self = .local(x)
                return
            }
            
            return nil
        }
        
        var asModelDependency: Model.Dependency {
            get throws {
                switch self {
                case let .remote(x): try x.asModelDependency
                case let .local(x): try x.asModelDependency
                }
            }
        }
    }
    
    struct RemoteDependency: ExpressibleByArgument {
        var url: URL
        var kind: String
        var refs: [String]
        
        init?(argument: String) {
            var components = argument.split(separator: ":")
            if (components[0] == "http" || components[0] == "https") && components.count > 1 && components[1].starts(with: "//") {
                guard let x = URL(string: components[0] + ":" + components[1]) else { return nil }
                self.url = x
                components.removeFirst(2)
            } else {
                guard let x = URL(string: String(components[0])) else { return nil }
                self.url = x
                components.removeFirst(1)
            }
            
            kind = components.isEmpty ? "" : String(components[0])
            refs = components.dropFirst().map { String($0) }
        }
        
        var asModelDependency: Model.Dependency {
            get throws {
                let requirement: Model.Dependency.Remote.Requirement = switch kind {
                case "": .upToNextMajorVersion("1.0.0")
                case "upToNextMajor": .upToNextMajorVersion(refs.first ?? "1.0.0")
                case "upToNextMinor": .upToNextMinorVersion(refs.first ?? "1.0.0")
                case "exactVersion": .exactVersion(refs.first ?? "1.0.0")
                case "versionRange": .versionRange(refs.first ?? "1.0.0", refs.count > 1 ? refs[1] : "2.0.0")
                case "branch": .branch(refs.first ?? "main")
                case "commit": .revision(refs.first ?? "\"\"")
                default: throw ValidationError("Unknown remote dependency kind: \(kind)")
                }
                
                return .remote(.init(repositoryURL: "\"\(url.absoluteString)\"", requirement: requirement))
            }
        }
    }
    
    struct LocalDependency: ExpressibleByArgument {
        init?(argument: String) {
            self.url = URL(filePath: argument)
        }
        
        var url: URL
        
        var asModelDependency: Model.Dependency {
            get throws {
                .local(.init(relativePath: url.relativePath))
            }
        }
    }
    
    // reconfigure project.pbxproj --replace https://github.com/apple/SwiftUsd:upToNextMajor:5.1.0 --with ../SwiftUsd
    
    @Argument(help: "The project.pbxproj file to modify.",
              transform: URL.init(fileURLWithPath:))
    var pbxprojFile: URL
    
    @Option(help: "The Swift Package dependency to replace.")
    var replace: Dependency
    @Option(help: "The Swift Package dependency to go in place of `--replace`.")
    var with: Dependency
    
    @Flag(name: .customLong("dryRun"),
          help: "If true, do not modify the file, just print the resulting model.")
    var dryRun: Bool = false
    
    @Option(help: "If passed, copy the pbxproj file to this path before modifying it.",
            transform: URL.init(fileURLWithPath:)) var backup: URL?
    
    mutating func run() throws {
        let tokenizer = try Tokenizer(fileURL: pbxprojFile)
        let tokens = try tokenizer.tokenize()
        let combined = TrivaCombiner().combine(tokens: tokens)
        let value = try Parser().parse(tokens: combined)
        
        var model = Model(value: value)
        
        try model.replace(dependency: replace.asModelDependency, with: with.asModelDependency)
        
        if dryRun {
            print(model.exportAsString())
            return
        }
        
        if let backup {
            try FileManager.default.copyItem(at: pbxprojFile, to: backup)
        }
        
        try model.export(to: pbxprojFile)
    }
}
