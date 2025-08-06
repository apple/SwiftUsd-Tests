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

import XCTest
import OpenUSD

final class TfDiagnosticsWrapperTests: TemporaryDirectoryHelper {
    func test_TF_ERROR_1() {
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
            TF_ERROR(pxr.TfEnum(), "TF_ERROR_1")
            XCTAssertFalse($0.IsClean())
            XCTAssertEqual(Array($0.errors).count, 1)
            let error = Array($0.errors).first!

            XCTAssertTrue(String(error.GetSourceFileName()).hasSuffix("Tests/UnitTests/Wrapping/TfDiagnosticsWrapperTests.swift"))
            XCTAssertEqual(error.GetSourceLineNumber(), 27)
            XCTAssertEqual(String(error.GetCommentary()), "TF_ERROR_1")
            XCTAssertEqual(error.GetSourceFunction(), "test_TF_ERROR_1()")
            XCTAssertEqual(error.GetDiagnosticCode().GetValue(), 0 as CInt)
            XCTAssertFalse(error.IsCodingError())
        }
    }
        
    func test_TF_ERROR_2() {
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
            TF_ERROR(.TF_DIAGNOSTIC_RUNTIME_ERROR_TYPE, "TF_ERROR_2" as std.string)
            XCTAssertFalse($0.IsClean())
            XCTAssertEqual(Array($0.errors).count, 1)
            let error = Array($0.errors).first!
            
            XCTAssertTrue(String(error.GetSourceFileName()).hasSuffix("Tests/UnitTests/Wrapping/TfDiagnosticsWrapperTests.swift"))
            XCTAssertEqual(error.GetSourceLineNumber(), 44)
            XCTAssertEqual(String(error.GetCommentary()), "TF_ERROR_2")
            XCTAssertEqual(error.GetSourceFunction(), "test_TF_ERROR_2()")
            XCTAssertEqual(error.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_RUNTIME_ERROR_TYPE)
            XCTAssertFalse(error.IsCodingError())
        }
    }
        
    func test_TF_ERROR_3() {
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
            let m: std.string = "TF_ERROR_3"
            TF_ERROR(pxr.TfDiagnosticInfo(), pxr.TfEnum(), m)
            XCTAssertFalse($0.IsClean())
            XCTAssertEqual(Array($0.errors).count, 1)
            let error = Array($0.errors).first!
            
            XCTAssertTrue(String(error.GetSourceFileName()).hasSuffix("Tests/UnitTests/Wrapping/TfDiagnosticsWrapperTests.swift"))
            XCTAssertEqual(error.GetSourceLineNumber(), 62)
            XCTAssertEqual(String(error.GetCommentary()), "TF_ERROR_3")
            XCTAssertEqual(error.GetSourceFunction(), "test_TF_ERROR_3()")
            XCTAssertEqual(error.GetDiagnosticCode().GetValue(), 0 as CInt)
            XCTAssertFalse(error.IsCodingError())
        }
    }
    
    func test_TF_RUNTIME_ERROR() {
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
            TF_RUNTIME_ERROR("my tf runtime error")
            XCTAssertFalse($0.IsClean())
            XCTAssertEqual(Array($0.errors).count, 1)
            let error = Array($0.errors).first!
            
            XCTAssertTrue(String(error.GetSourceFileName()).hasSuffix("Tests/UnitTests/Wrapping/TfDiagnosticsWrapperTests.swift"))
            XCTAssertEqual(error.GetSourceLineNumber(), 79)
            XCTAssertEqual(String(error.GetCommentary()), "my tf runtime error")
            XCTAssertEqual(error.GetSourceFunction(), "test_TF_RUNTIME_ERROR()")
            XCTAssertEqual(error.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_RUNTIME_ERROR_TYPE)
            XCTAssertFalse(error.IsCodingError())
        }
    }
    
    func test_TF_CODING_ERROR() {
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
            TF_CODING_ERROR("my tf coding error")
            XCTAssertFalse($0.IsClean())
            XCTAssertEqual(Array($0.errors).count, 1)
            let error = Array($0.errors).first!
            
            XCTAssertTrue(String(error.GetSourceFileName()).hasSuffix("Tests/UnitTests/Wrapping/TfDiagnosticsWrapperTests.swift"))
            XCTAssertEqual(error.GetSourceLineNumber(), 96)
            XCTAssertEqual(String(error.GetCommentary()), "my tf coding error")
            XCTAssertEqual(error.GetSourceFunction(), "test_TF_CODING_ERROR()")
            XCTAssertEqual(error.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
            XCTAssertTrue(error.IsCodingError())
        }
    }
    
    // TfStatus and TfWarning are hard to test, because they print without being caught by TfErrorMark
    func test_TF_STATUS_1() {
        TF_STATUS("tf status 1")
    }
    
    func test_TF_STATUS_2() {
        TF_STATUS(pxr.TfEnum(), "tf status 2")
    }
    
    func test_TF_STATUS_3() {
        TF_STATUS(pxr.TfDiagnosticInfo(), pxr.TfEnum(), "tf status 3")
    }
    
    func test_TF_WARN_1() {
        TF_WARN("tf warn 1")
    }
    
    func test_TF_WARN_2() {
        TF_WARN(pxr.TfEnum(), "tf warn 2")
    }
    
    func test_TF_WARN_3() {
        TF_WARN(.TF_DIAGNOSTIC_CODING_ERROR_TYPE, "tf warn 3")
    }
    
    func test_TF_WARN_4() {
        TF_WARN(pxr.TfDiagnosticInfo(), pxr.TfEnum(), "tf warn 4")
    }
    
    func test_TF_QUIET_ERROR_1() {
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
            TF_QUIET_ERROR(pxr.TfEnum(), pxr.TfDiagnosticInfo(), "tf quiet error 1")
            XCTAssertFalse($0.IsClean())
            XCTAssertEqual(Array($0.errors).count, 1)
            let error = Array($0.errors).first!
            
            XCTAssertTrue(String(error.GetSourceFileName()).hasSuffix("Tests/UnitTests/Wrapping/TfDiagnosticsWrapperTests.swift"))
            XCTAssertEqual(error.GetSourceLineNumber(), 142)
            XCTAssertEqual(String(error.GetCommentary()), "tf quiet error 1")
            XCTAssertEqual(error.GetSourceFunction(), "test_TF_QUIET_ERROR_1()")
            XCTAssertEqual(error.GetDiagnosticCode().GetValue(), 0 as CInt)
            XCTAssertFalse(error.IsCodingError())
        }
    }
    
    func test_TF_QUIET_ERROR_2() {
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
            TF_QUIET_ERROR(pxr.TfEnum(), "tf quiet error 2")
            XCTAssertFalse($0.IsClean())
            XCTAssertEqual(Array($0.errors).count, 1)
            let error = Array($0.errors).first!
            
            XCTAssertTrue(String(error.GetSourceFileName()).hasSuffix("Tests/UnitTests/Wrapping/TfDiagnosticsWrapperTests.swift"))
            XCTAssertEqual(error.GetSourceLineNumber(), 159)
            XCTAssertEqual(String(error.GetCommentary()), "tf quiet error 2")
            XCTAssertEqual(error.GetSourceFunction(), "test_TF_QUIET_ERROR_2()")
            XCTAssertEqual(error.GetDiagnosticCode().GetValue(), 0 as CInt)
            XCTAssertFalse(error.IsCodingError())
        }
    }
    
    func test_TF_CODING_WARNING() {
        TF_CODING_WARNING("my tf coding warning")
    }
    
    func test_TF_FATAL_CODING_ERROR() {
        if false {
            let _: Never = TF_FATAL_CODING_ERROR("my tf fatal coding error")
        }
    }
    
    func test_TF_FATAL_ERROR() {
        if false {
            let _: Never = TF_FATAL_ERROR("my tf fatal error")
        }
    }
    
    func test_TF_DIAGNOSTIC_FATAL_ERROR() {
        if false {
            let _: Never = TF_DIAGNOSTIC_FATAL_ERROR("my tf diagnostic fatal error")
        }
    }
    
    func test_TF_DIAGNOSTIC_NONFATAL_ERROR() {
        TF_DIAGNOSTIC_NONFATAL_ERROR("my diagnostic non fatal error")
    }
    
    func test_TF_DIAGNOSTIC_WARNING() {
        TF_DIAGNOSTIC_WARNING("my diagnostic warning")
    }
    
    func test_TF_VERIFY_1() {
        #TF_VERIFY(true)
    }
    
    func test_TF_VERIFY_2() {
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
            #TF_VERIFY(false)
            XCTAssertFalse($0.IsClean())
            
            XCTAssertEqual(Array($0.errors).count, 1)
            let error = Array($0.errors).first!
            
            XCTAssertTrue(String(error.GetSourceFileName()).hasSuffix("Tests/UnitTests/Wrapping/TfDiagnosticsWrapperTests.swift"))
            XCTAssertEqual(error.GetSourceLineNumber(), 210)
            XCTAssertEqual(String(error.GetCommentary()), "Failed verification: ' false '")
            XCTAssertEqual(error.GetSourceFunction(), "test_TF_VERIFY_2()")
            XCTAssertEqual(error.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
            XCTAssertTrue(error.IsCodingError())
        }
    }
    
    func test_TF_VERIFY_3() {
        #TF_VERIFY(true, "my message")
    }
    
    func test_TF_VERIFY_4() {
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
            #TF_VERIFY(1 > 2, "my message")
            XCTAssertFalse($0.IsClean())
            
            XCTAssertEqual(Array($0.errors).count, 1)
            let error = Array($0.errors).first!
            
            XCTAssertTrue(String(error.GetSourceFileName()).hasSuffix("Tests/UnitTests/Wrapping/TfDiagnosticsWrapperTests.swift"))
            XCTAssertEqual(error.GetSourceLineNumber(), 232)
            XCTAssertEqual(String(error.GetCommentary()), "Failed verification: ' 1 > 2 ' -- \"my message\"")
            XCTAssertEqual(error.GetSourceFunction(), "test_TF_VERIFY_4()")
            XCTAssertEqual(error.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
            XCTAssertTrue(error.IsCodingError())
        }
    }
    
    func test_TF_AXIOM_1() {
        XCTAssertTrue(#TF_AXIOM(1 < 2))
    }
    
    func test_TF_AXIOM_2() {
        if false {
            let _: Bool = #TF_AXIOM(1 > 2)
        }
    }
    
    func test_TF_DEV_AXIOM_1() {
        var x = 0
        XCTAssertTrue(#TF_DEV_AXIOM(
            {
                #if DEBUG
                x += 1
                #else
                x += 2
                XCTFail("Should not be evaluated in Release")
                #endif
                return 1 < 2
            }()
        ))
        #if DEBUG
        XCTAssertEqual(x, 1)
        #else
        XCTAssertEqual(x, 0)
        #endif
    }
    
    func test_TF_DEV_AXIOM_2() {
        #if !DEBUG
        
        var x = 0
        XCTAssertTrue(#TF_DEV_AXIOM(
            {
                #if DEBUG
                x += 1
                #else
                x += 2
                XCTFail("Should not be evaluated in Release")
                #endif
                return 1 > 2
            }()
        ))
        #if DEBUG
        XCTAssertEqual(x, 1)
        #else
        XCTAssertEqual(x, 0)
        #endif

        #endif
    }
}
