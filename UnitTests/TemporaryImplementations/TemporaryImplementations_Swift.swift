//
//  TemporaryImplementations_Swift.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/18/23.
//

import Foundation
import OpenUSD

// TemporaryImplementations is for holding symbols, functions, and types
// that haven't been moved into the framework yet, tested, and documented

#warning("non-empty temporary implementations")

// MARK: CustomStringConvertible
// rdar://122021150 (Conforming std::set specialization to CxxSequence in a framework crashes swiftc when using the framework)
// Because of that, we can't move pxr.SdfPathSet: CustomStringConvertible in, because it relies on Sequence conformance
extension pxr.SdfPathSet: CustomStringConvertible {
    public var description: String {
        "[" + map { String($0) }.joined(separator: ", ") + "]"
    }
}


// MARK: Sequence, IteratorProtocol
// rdar://122021150 (Conforming std::set specialization to CxxSequence in a framework crashes swiftc when using the framework)
extension pxr.SdfPathSet: CxxSequence {}
extension Overlay.String_Set: CxxSequence {}


extension Overlay.UsdRelationship_Vector: CxxSequence {}
extension Overlay.UsdProperty_Vector: CxxSequence {}
