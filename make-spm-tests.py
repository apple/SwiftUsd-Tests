# ===-------------------------------------------------------------------=== #
# This source file is part of github.com/apple/SwiftUsd-Tests
#
# Copyright © 2025 Apple Inc. and the SwiftUsd-Tests authors. All Rights Reserved. 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at: 
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.     
# 
# SPDX-License-Identifier: Apache-2.0
# ===-------------------------------------------------------------------=== #

import pathlib
import argparse
import shutil
import os

DEFAULT_SWIFTUSD_VERSION = "5.0.1"

def package_manifest_contents(args):
    version_dependency_line = f"        .package(url: \"https://github.com/apple/SwiftUsd\", from: \"{args.version}\"),\n"
    branch_dependency_line = f"        .package(url: \"https://github.com/apple/SwiftUsd\", branch: \"{args.branch}\"),\n"
    local_dependency_line = f"        .package(path: \"SwiftUsd\"),"

    if args.dependency == "version":
        dependency_lines = f"{version_dependency_line}//{branch_dependency_line}//{local_dependency_line}"

    elif args.dependency == "branch":
        dependency_lines = f"//{version_dependency_line}{branch_dependency_line}//{local_dependency_line}"

    elif args.dependency == "local":
        dependency_lines = f"//{version_dependency_line}//{branch_dependency_line}{local_dependency_line}"

    else:
        raise ValueError(f"Illegal dependency kind {args.dependency}")
        
    
    return f"""// swift-tools-version: 6.0
// ===-------------------------------------------------------------------===//
// This source file is part of github.com/apple/SwiftUsd-Tests
//
// Copyright © 2025 Apple Inc. and the SwiftUsd-Tests authors. All Rights Reserved. 
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at: 
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.     
// 
// SPDX-License-Identifier: Apache-2.0
// ===-------------------------------------------------------------------===//
    
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPM-Tests",
    platforms: [.macOS(.v15)],
    dependencies: [
{dependency_lines}
    ],
    targets: [
        .target(name: "XLangTestingUtil",
                dependencies: [
                    .product(name: "OpenUSD", package: "SwiftUsd")
                ]),        
        
        .testTarget(name: "UnitTests",
                    dependencies: [
                        .product(name: "OpenUSD", package: "SwiftUsd"),
                        "XLangTestingUtil"
                    ],
                    resources: [
                        .copy("Resources")
                    ],
                    swiftSettings: [.interoperabilityMode(.Cxx)])
    ],
    swiftLanguageVersions: [.v5],
    cxxLanguageStandard: .gnucxx17
)"""

if __name__ == "__main__":
    # Find the SwiftUsdTests cloned repo, and make sure we have the required files/folders
    swiftUsdTests_repo = pathlib.Path(__file__).parent
    if not (swiftUsdTests_repo / "SwiftUsdTests.xcodeproj").is_dir():
        raise ValueError("Could not find SwiftUsdTests.xcodeproj")
    if not (swiftUsdTests_repo / "UnitTests").is_dir():
        raise ValueError("Could not find UnitTests dir")

    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--version", type=str, nargs="?", const=DEFAULT_SWIFTUSD_VERSION, default=None, help=f"Make the package depend on SwiftUsd remotely from this version. Default: {DEFAULT_SWIFTUSD_VERSION}")
    parser.add_argument("--branch", type=str, nargs="?", const="dev", default=None, help="Make the package depend on SwiftUsd remotely from this branch: Default: dev")
    parser.add_argument("--local", action="store_true", default=None, help="Make the package depend on SwiftUsd locally")
    
    args = parser.parse_args()

    if args.version is not None:
        args.dependency = "version"
    elif args.branch is not None:
        args.dependency = "branch"
    elif args.local is not None:
        args.dependency = "local"
    else:
        if (swiftUsdTests_repo / "SwiftUsd").is_symlink():
            args.dependency = "local"
        else:
            args.dependency = "version"            

    if args.version is None: args.version = DEFAULT_SWIFTUSD_VERSION
    if args.branch is None: args.branch = "dev"
    
    # Clear out existing SPM-Tests
    spm_tests_dir = swiftUsdTests_repo / "SPM-Tests"
    if spm_tests_dir.exists() and not args.force:
        raise ValueError("SPM-Tests already exists. Remove or rerun with --force")
    if spm_tests_dir.exists():
        shutil.rmtree(spm_tests_dir, ignore_errors=True)

    # Start making the package structure
    spm_tests_dir.mkdir()
    package_manifest_file = spm_tests_dir / "Package.swift"
    with open(package_manifest_file, "w") as f:
        f.write(package_manifest_contents(args))

    sources_dir = spm_tests_dir / "Sources"
    sources_dir.mkdir()
    xlangtestingutil_dir = sources_dir / "XLangTestingUtil"
    xlangtestingutil_dir.mkdir()
    include_dir = xlangtestingutil_dir / "include"
    include_dir.mkdir()

    tests_dir = spm_tests_dir / "Tests"
    tests_dir.mkdir()
    unittests_dir = tests_dir / "UnitTests"
    unittests_dir.mkdir()

    # Symlink all the things in
    xcodeproj_unit_tests_dir = swiftUsdTests_repo / "UnitTests"
    for _dirpath, dirnames, filenames in os.walk(xcodeproj_unit_tests_dir):
        dirpath = pathlib.Path(_dirpath).relative_to(xcodeproj_unit_tests_dir)

        if "Resources" in [x.stem for x in list(dirpath.parents) + [dirpath]]:
            # Copy resources instead of symlinking, because runtime copying
            # of symlinked files not in the resources bundle doesn't work
            if dirpath.stem == "Resources":
                # shutil.copy_tree(x, unittests_dir / dirpath)
                copy_from = xcodeproj_unit_tests_dir / dirpath
                copy_to = unittests_dir / dirpath
                copy_to.rmdir()
                shutil.copytree(copy_from, copy_to)
            
            continue

        
        for dirname in dirnames:
            (unittests_dir / dirpath / dirname).mkdir()

        for filename in filenames:
            if filename == ".DS_Store":
                continue
            
            extension = pathlib.Path(filename).suffix
            is_header = extension == ".h" or extension == ".hpp"
            is_cpp = extension == ".cpp" or extension == ".mm"
            
            if is_header:
                make_symlink_at = include_dir / filename
                make_symlink_to = pathlib.Path("../../../..")
            elif is_cpp:
                make_symlink_at = xlangtestingutil_dir / filename
                make_symlink_to = pathlib.Path("../../..")
            else:
                make_symlink_at = unittests_dir / dirpath / filename
                make_symlink_to = pathlib.Path("../../..")
                for i in range(len(dirpath.parents)):
                    make_symlink_to = make_symlink_to / ".."
                
            make_symlink_to = make_symlink_to / "UnitTests" / dirpath / filename
            make_symlink_at.symlink_to(make_symlink_to)

    # If the dev made a local SwiftUsd symlink, copy that into SPM-Tests for convenience
    if args.dependency == "local":
        (spm_tests_dir / "SwiftUsd").symlink_to("../SwiftUsd")
