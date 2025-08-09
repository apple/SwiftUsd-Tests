#===----------------------------------------------------------------------===#
# This source file is part of github.com/apple/SwiftUsd-Tests
#
# Copyright © 2025 Apple Inc. and the SwiftUsd-Tests project authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
#===----------------------------------------------------------------------===#

import re
import sys

class Pruner:
    def __init__(self, lines):
        self.i = -1
        self.lines = lines

        while self.i + 1 < len(self.lines):
            self.i += 1

            prune_methods = [
                self.prune_test_case,
                self.prune_test_suite,
                self.prune_coding_error,
                self.prune_pixar_warning,
                self.prune_executed_zero_failures_zero_unexpected,
            ]

            for method in prune_methods:
                if method():
                    self.i -= 1
                    break

        for l in self.lines:
            print(l, end="")

    def prune_test_case(self):
        this_match = re.fullmatch("Test Case '(.*)' started at .*\n", self.lines[self.i])
        if this_match is None:
            return False
        
        for j in range(len(self.lines)):
            other_match = re.fullmatch("Test Case '(.*)' passed .*\n", self.lines[j])
            if other_match is None:
                continue
            
            if this_match.group(1) == other_match.group(1):
                del self.lines[j]
                del self.lines[self.i]
                return True

        return False

    def prune_test_suite(self):
        this_match = re.fullmatch("Test Suite '(.*)' started at .*\n", self.lines[self.i])
        if this_match is None:
            return False
        
        for j in range(len(self.lines)):
            other_match = re.fullmatch("Test Suite '(.*)' passed .*\n", self.lines[j])
            if other_match is None:
                continue
            
            if this_match.group(1) == other_match.group(1) and this_match.group(1) != 'All tests':
                del self.lines[j]
                del self.lines[self.i]
                return True

        return False

    def _prune_single_line(self, pattern):
        if re.fullmatch(pattern, self.lines[self.i]):
            del self.lines[self.i]
            return True
        return False
        
    def prune_coding_error(self):
        return self._prune_single_line("Coding Error: in .* at line .* of .*\n")

    def prune_pixar_warning(self):
        return self._prune_single_line("Warning: in .* at line .* of .*\n")

    def prune_executed_zero_failures_zero_unexpected(self):
        p = ".*Executed .* tests?, with 0 failures \\(0 unexpected\\) in .* seconds.*\n"

        # Don't prune it for All tests
        if self.i > 0 and re.fullmatch("Test Suite 'All tests' passed .*\n", self.lines[self.i - 1]) != None:
            if re.fullmatch(p, self.lines[self.i]):
                return False

        
        return self._prune_single_line(p)

if __name__ == "__main__":
    lines = []
    for l in sys.stdin:
        print(l, end="")
        lines.append(l)

    print("\n\n\n\n\n\n\n\n\n\n")
    Pruner(lines)
