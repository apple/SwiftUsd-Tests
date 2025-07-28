//
//  Observation_MutateUsdRelationship_ReadUsdStage.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/22/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdRelationship_ReadUsdStage: ObservationHelper {

    // MARK: AddTarget
    
    func test_AddTarget_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def PointInstancer "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def PointInstancer "foo"
        {
            rel prototypes = </foo.radius>
        }

        
        """#)
    }
    
    // MARK: RemoveTarget
    
    func test_RemoveTarget_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def PointInstancer "foo"
        {
            rel prototypes = </foo.radius>
        }

        
        """#)
        
        expectingSomeNotifications([token], rel.RemoveTarget(".radius"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def PointInstancer "foo"
        {
            rel prototypes
        }

        
        """#)
    }

    // MARK: SetTargets
    
    func test_SetTargets_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def PointInstancer "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def PointInstancer "foo"
        {
            rel prototypes = </foo.radius>
        }

        
        """#)
    }
    
    // MARK: ClearTargets
    
    func test_ClearTargets_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def PointInstancer "foo"
        {
            rel prototypes = </foo.radius>
        }

        
        """#)
        
        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def PointInstancer "foo"
        {
            rel prototypes
        }

        
        """#)
    }
}
