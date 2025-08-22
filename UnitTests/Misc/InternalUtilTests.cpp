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

#include "InternalUtilTests.hpp"
#include "swiftUsd/Util/TypeTraits.h"

struct Unrelated {};
struct Pattern {};
struct Replacement {};

// Pushes the given message, and whether replacing all occurrences of `Pattern` with `Replacement` in `In` yields
// `ExpectedOut`, onto the vector argument
template <typename In, typename ExpectedOut>
void test(const std::string& msg, std::vector<std::pair<std::string, bool>>& vec) {
    vec.push_back(std::make_pair(msg, std::is_same_v<_Overlay::replace_all_t<In, Pattern, Replacement>, ExpectedOut>));
}

std::vector<std::pair<std::string, bool>> testReplaceAllResults() {
    std::vector<std::pair<std::string, bool>> result;
    
    test<void, void>("replace_all doesn't replace unrelated void", result);
    test<nullptr_t, nullptr_t>("replace_all doesn't replace unrelated nullptr_t", result);
    test<int, int>("replace_all doesn't replace unrelated integrals", result);
    test<const int, const int>("replace_all doesn't replace unrelated const integrals", result);
    test<volatile int, volatile int>("replace_all doesn't replace unrelated volatile integrals", result);
    test<const volatile int, const volatile int>("replace_all doesn't replace unrelated const volatile integrals", result);
    test<float, float>("replace_all doesn't replace unrelated floating points", result);
    test<Unrelated&, Unrelated&>("replace_all doesn't replace unrelated lvalue references", result);
    test<Unrelated&&, Unrelated&&>("replace_all doesn't replace unrelated rvalue references", result);
    test<Unrelated*, Unrelated*>("replace_all doesn't replace unrelated pointers", result);
    test<Unrelated**, Unrelated**>("replace_all doesn't replace unrelated nested pointers", result);
    test<Unrelated const* const*, Unrelated const* const*>("replace_all doesn't replace unrelated nested const pointers", result);
    test<Unrelated(*)(Unrelated), Unrelated(*)(Unrelated)>("replace_all doesn't replace unrelated pointers to function types", result);
    test<Unrelated Unrelated::*, Unrelated Unrelated::*>("replace_all doesn't replace unrelated pointers to data members", result);
    test<Unrelated Unrelated::*(Unrelated), Unrelated Unrelated::*(Unrelated)>("replace_all doesn't replace unrelated pointers to member functions", result);
    test<Unrelated[], Unrelated[]>("replace_all doesn't replace unrelated arrays", result);
    test<Unrelated[4], Unrelated[4]>("replace_all doesn't replace unrelated fixed-size arrays", result);
    test<Unrelated(Unrelated), Unrelated(Unrelated)>("replace_all doesn't replace unrelated functions", result);
        
    
    test<Pattern, Replacement>("replace_all does replace bare patterns", result);
    test<const Pattern, const Replacement>("replace_all does replace const patterns", result);
    test<volatile Pattern, volatile Replacement>("replace_all does replace volatile patterns", result);
    test<const volatile Pattern, const volatile Replacement>("replace_all does replace const volatile patterns", result);
    test<Pattern&, Replacement&>("replace_all does replace lvalue references", result);
    test<Pattern&&, Replacement&&>("replace_all does replace rvalue references", result);

    test<Pattern*, Replacement*>("replace_all does replace pointers", result);
    test<Pattern**, Replacement**>("replace_all does replace nested pointers", result);
    test<Pattern const* const*, Replacement const* const*>("replace_all does replace nested const pointers", result);
    test<Pattern(*)(Pattern), Replacement(*)(Replacement)>("replace_all does replace pointers to function types", result);
    test<Pattern Pattern::*, Replacement Replacement::*>("replace_all does replace pointers to data members", result);
    test<Pattern Pattern::*(Pattern), Replacement Replacement::*(Replacement)>("replace_all does replace pointers to member functions", result);
    test<Pattern[], Replacement[]>("replace_all does replace arrays", result);
    test<Pattern[4], Replacement[4]>("replace_all does replace fixed-size arrays", result);
    test<Pattern(Pattern), Replacement(Replacement)>("replace_all does replace functions", result);
    
    return result;
}
