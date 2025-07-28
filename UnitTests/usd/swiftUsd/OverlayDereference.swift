//
//  OverlayDereference.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/12/23.
//

import XCTest
import OpenUSD

final class OverlayDereference: TemporaryDirectoryHelper {    
    func test_ref_stage() {
        do {
            var stage: pxr.UsdStage!
            do {
                let stageP: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
                assertOpen("HelloWorld.usda")
                stage = Overlay.Dereference(stageP)
                stage.SetStartTimeCode(5)
                assertOpen("HelloWorld.usda")
            }
            assertOpen("HelloWorld.usda")
            stage.SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_ref_layer() {
        do {
            var layer: pxr.SdfLayer!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                let layerP: pxr.SdfLayerRefPtr = Overlay.TfRefPtr(stage.GetRootLayer())
                layer = Overlay.Dereference(layerP)
                assertOpen("HelloWorld.usda")
                layer.SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            layer.SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_weak_stage() {
        do {
            var stage: pxr.UsdStage!
            do {
                let stageP: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
                assertOpen("HelloWorld.usda")
                let stageWeakP: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(stageP)
                stage = Overlay.Dereference(stageWeakP)
                assertOpen("HelloWorld.usda")
                stage.SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            stage.SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_weak_layer() {
        do {
            var layer: pxr.SdfLayer!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                let layerWeakP: pxr.SdfLayerHandle = stage.GetRootLayer()
                layer = Overlay.Dereference(layerWeakP)
                assertOpen("HelloWorld.usda")
                layer.SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            layer.SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
}
