//
//  TraversingAStageTests.swift
//  UsdInteropTests
//
//  Created by Maddy Adams on 8/7/23.
//

import XCTest
import OpenUSD

// This file is a translation of https://openusd.org/release/tut_traversing_stage.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/TraversingAStage` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/traversingStage.


final class TraversingAStage: TutorialsHelper {
    override class var name: String { "TraversingAStage" }
    
    private func _descriptionForPrim(_ p: pxr.UsdPrim) -> String {
        let stage = Overlay.Dereference(p.GetStage())
        let rootLayerIdentifier = Overlay.Dereference(stage.GetRootLayer()).GetIdentifier()
        let sessionLayerIdentifier = Overlay.Dereference(stage.GetSessionLayer()).GetIdentifier()
        let typeName = p.GetTypeName()
        let inactiveString = p.IsActive() ? "" : "inactive "
        let interpolatedTypeName = typeName == "" ? "" : "'\(typeName)' "
        let path = p.GetPath()
        return "\(inactiveString)\(interpolatedTypeName)prim <\(path)> on stage with rootLayer @\(rootLayerIdentifier)@, sessionLayer @\(sessionLayerIdentifier)@"
    }
    
    private func _descriptionForPrim(_ stage: pxr.UsdStage, _ path: pxr.SdfPath) -> String {
        _descriptionForPrim(stage.GetPrimAtPath(path))
    }
    
    private func _descriptionsForPrims(_ stage: pxr.UsdStage, _ paths: pxr.SdfPath...) -> String {
        "[\(paths.map { _descriptionForPrim(stage, $0) }.joined(separator: ", ") )]"
    }
    
    private func _descriptionsForPrims<T>(_ stage: pxr.UsdStage, _ paths: (pxr.SdfPath, T)...) -> String {
        String(paths.map { "\(_descriptionForPrim(stage, $0.0)), \($0.1)" }.joined(separator: "\n"))
    }
    
    func testTutorial() throws {
        _ = try copyResourceToWorkingDirectory(subPath: "Tutorials/TraversingAStage/1.txt", destName: "HelloWorld.usda")
        let stagePath = try copyResourceToWorkingDirectory(subPath: "Tutorials/TraversingAStage/2.txt", destName: "RefExample.usda")
        
        let stage = Overlay.Dereference(pxr.UsdStage.Open(stagePath, .LoadAll))
                
        var prims = Array(stage.Traverse())
        XCTAssertEqual(String(describing: prims), _descriptionsForPrims(stage, "/refSphere", "/refSphere/world", "/refSphere2", "/refSphere2/world"))

        prims = stage.Traverse().filter { $0.IsA(SchemaType: pxr.UsdGeomSphere.self) }
        XCTAssertEqual(String(describing: prims), _descriptionsForPrims(stage, "/refSphere/world", "/refSphere2/world"))
                
        var printValues = [String]()
        for (iter, prim) in pxr.UsdPrimRange.PreAndPostVisit(stage.GetPseudoRoot()).withIterator() {
            printValues.append("\(prim), \(iter.IsPostVisit())")
        }
        XCTAssertEqual(printValues.joined(separator: "\n"), _descriptionsForPrims(stage, 
                                                                                  ("/", false), 
                                                                                  ("/refSphere", false),
                                                                                  ("/refSphere/world", false), 
                                                                                  ("/refSphere/world", true),        
                                                                                  ("/refSphere", true),
                                                                                  ("/refSphere2", false),                
                                                                                  ("/refSphere2/world", false),
                                                                                  ("/refSphere2/world", true),                                                                               
                                                                                  ("/refSphere2", true),
                                                                                  ("/", true)))
        
        
        let target = stage.GetEditTargetForLocalLayer(stage.GetSessionLayer())
        try? Overlay.withUsdEditContext(stage, target) {
            let refSphere2 = stage.GetPrimAtPath("/refSphere2")
            refSphere2.SetActive(false)
            let sessionLayer = Overlay.Dereference(stage.GetSessionLayer())
            XCTAssertEqual(sessionLayer.ExportToString(), try expected(6))
            
            var prims = Array(stage.Traverse())
            XCTAssertEqual(String(describing: prims), _descriptionsForPrims(stage, "/refSphere", "/refSphere/world"))
            
            prims = Array(stage.TraverseAll())
            XCTAssertEqual(String(describing: prims), _descriptionsForPrims(stage, "/refSphere", "/refSphere/world", "/refSphere2"))
        }
    }
}
