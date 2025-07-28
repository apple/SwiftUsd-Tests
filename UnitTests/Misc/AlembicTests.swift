//
//  AlembicTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 7/11/25.
//

import XCTest
import OpenUSD

final class AlembicTests: TemporaryDirectoryHelper {
    #if canImport(SwiftUsd_PXR_ENABLE_ALEMBIC_SUPPORT)
    func test_loadAndExportAlembic() throws {
        let url = urlForResource(subPath: "Alembic/Cube.abc")
        let path = std.string(url.path(percentEncoded: false))
        guard let stage = Overlay.DereferenceOrNil(pxr.UsdStage.Open(path, .LoadAll)) else {
            XCTFail("Couldn't open Cube.abc")
            return
        }
        
        guard let actual = stage.ExportToString(addSourceFileComment: false) else {
            XCTFail("Couldn't export to string")
            return
        }
        
        let expected = try contentsOfResource(subPath: "Alembic/Cube.txt")
         XCTAssertEqual(expected, actual)

    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_ALEMBIC_SUPPORT)
}
