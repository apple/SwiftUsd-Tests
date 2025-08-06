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

final class Observation_MutateUsdStage_ReadUsdStage: ObservationHelper {
    
    // MARK: Load
    
    func test_Load_Traverse() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        // With LoadNone, this prim isn't loadable, so it's still loaded
        XCTAssertEqual(Array(mainStage.Traverse()), [mainStage.GetPrimAtPath("/smallModel")])
        
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.Traverse())
        // After AddPayload, the prim is loadable, so with LoadNone it isn't loaded and doesn't get caught by Traverse()
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], mainStage.Load("/smallModel", Overlay.UsdLoadWithDescendants))
        XCTAssertEqual(Array(mainStage.Traverse()), [mainStage.GetPrimAtPath("/smallModel"), mainStage.GetPrimAtPath("/smallModel/bigModel")])
    }
    
    // MARK: Unload
    
    func test_Unload_Traverse() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.Traverse())
        XCTAssertEqual(Array(value), [mainStage.GetPrimAtPath("/smallModel"), mainStage.GetPrimAtPath("/smallModel/bigModel")])
        
        expectingSomeNotifications([token], mainStage.Unload("/smallModel"))
        XCTAssertEqual(Array(mainStage.Traverse()), [])
    }
    
    // MARK: LoadAndUnload
    
    func test_LoadAndUnload_Traverse() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.Traverse())
        XCTAssertEqual(Array(value), [mainStage.GetPrimAtPath("/smallModel"), mainStage.GetPrimAtPath("/smallModel/bigModel")])
        
        expectingSomeNotifications([token], mainStage.LoadAndUnload([], ["/smallModel"], Overlay.UsdLoadWithDescendants))
        XCTAssertEqual(Array(mainStage.Traverse()), [])
    }
    
    // MARK: SetLoadRules

    #if os(Linux)
    #warning("UsdStageLoadRules test disabled on Linux because the stl vector copy constructor blows up")
    #else
    func test_SetLoadRules_GetLoadRules() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let (token, value) = registerNotification(stage.GetLoadRules())
        XCTAssertEqual(value, pxr.UsdStageLoadRules.LoadAll())
        
        expectingSomeNotifications([token], stage.SetLoadRules(pxr.UsdStageLoadRules.LoadNone()))
        XCTAssertEqual(stage.GetLoadRules(), pxr.UsdStageLoadRules.LoadNone())
    }
    #endif // #if os(Linux)
    
    // MARK: SetPopulationMask
    
    #if os(Linux)
    #warning("UsdStagePopulationMask test disabled on Linux because the stl vector copy constructor blows up")
    #else
    func test_SetPopulationMask_GetPopulationMask() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(stage.GetPopulationMask())
        XCTAssertEqual(value, pxr.UsdStagePopulationMask.All())
        
        expectingSomeNotifications([token], stage.SetPopulationMask(pxr.UsdStagePopulationMask()))
        XCTAssertEqual(stage.GetPopulationMask(), pxr.UsdStagePopulationMask())
    }
    #endif // #if os(Linux)
    
    // MARK: SetEditTarget
    
    func test_SetEditTarget_ResolveIdentifierToEditTarget() {
        do {
            let higherModel = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
            let lowerModel = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Folder/Model.usda"), Overlay.UsdStage.LoadAll))
            withExtendedLifetime(higherModel) {}
            withExtendedLifetime(lowerModel) {}
        }
        
        let higherMain = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let lowerMain = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Folder/Main.usda"), Overlay.UsdStage.LoadAll))
        
        Overlay.Dereference(higherMain.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Folder/Main.usda"), 0)
        
        let (token, value) = registerNotification(higherMain.ResolveIdentifierToEditTarget("Model.usda"))
        XCTAssertEqual(value, pathForStage(named: "Model.usda"))
        
        let lowerEditTarget = pxr.UsdEditTarget(lowerMain.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        expectingSomeNotifications([token], higherMain.SetEditTarget(lowerEditTarget))
        XCTAssertEqual(higherMain.ResolveIdentifierToEditTarget("Model.usda"), pathForStage(named: "Folder/Model.usda"))
    }

    func test_SetEditTarget_GetEditTarget() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let token = registerNotification(stage.GetEditTarget()).token
                
        let rootPrim = stage.DefinePrim("/hello", "Plane")
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("red", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("red")
        let editTarget = vset.GetVariantEditTarget(pxr.SdfLayerHandle())
        expectingSomeNotifications([token], stage.SetEditTarget(editTarget))
        XCTAssertEqual(stage.GetEditTarget(), editTarget)
    }
    
    // MARK: MuteLayer
    
    func test_MuteLayer_GetMutedLayers() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let (token, value) = registerNotification(main.GetMutedLayers())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], main.MuteLayer(Overlay.Dereference(model.GetRootLayer()).GetIdentifier()))
        XCTAssertEqual(main.GetMutedLayers(), [pathForStage(named: "Model.usda")])
    }
    
    func test_MuteLayer_IsLayerMuted() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let modelPath = pathForStage(named: "Model.usda")

        let (token, value) = registerNotification(main.IsLayerMuted(modelPath))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.MuteLayer(modelPath))
        XCTAssertTrue(main.IsLayerMuted(modelPath))
        withExtendedLifetime(model) {}
    }
    
    func test_MuteLayer_Export() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            model.DefinePrim("/hi", "Sphere")
        }

        let out1Path = pathForStage(named: "Out1.txt")
        let (token, value) = registerNotification(main.Export(out1Path, true, pxr.SdfLayer.FileFormatArguments()))
        XCTAssertTrue(value)
        XCTAssertEqual(try contentsOfStage(named: "Out1.txt"), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )
        
        def Sphere "hi"
        {
        }
        
        
        """#)
        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        let out2Path = pathForStage(named: "Out2.txt")
        XCTAssertTrue(main.Export(out2Path, true, pxr.SdfLayer.FileFormatArguments()))
        XCTAssertEqual(try contentsOfStage(named: "Out2.txt"), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )
        
        
        """#)
    }
    
    func test_MuteLayer_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            model.DefinePrim("/hi", "Sphere")
        }

        let (token, value) = registerNotification(main.ExportToString(addSourceFileComment: true))
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )
        
        def Sphere "hi"
        {
        }
        
        
        """#)
        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertEqual(main.ExportToString(addSourceFileComment: true), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )
        
        
        """#)
    }
    
    func test_MuteLater_Flatten() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            model.DefinePrim("/hi", "Sphere")
        }
        
        let (token, value) = registerNotification(main.Flatten(true))
        var temp = std.string()
        XCTAssertTrue(Overlay.Dereference(value).ExportToString(&temp))
        XCTAssertEqual(temp, std.string(#"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )
        
        def Sphere "hi"
        {
        }
        
        
        """#))
        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertTrue(Overlay.Dereference(main.Flatten(true)).ExportToString(&temp))
        XCTAssertEqual(temp, std.string(#"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )
        
        
        """#))
    }
    
    func test_MuteLayer_GetPrimAtPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            model.DefinePrim("/hi", "Sphere")
        }
        
        let (token, value) = registerNotification(main.GetPrimAtPath("/hi"))
        XCTAssertTrue(Bool(value))
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertFalse(Bool(main.GetPrimAtPath("/hi")))
    }
    
    func test_MuteLayer_GetObjectAtPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            model.DefinePrim("/hi", "Sphere")
        }
        
        let (token, value) = registerNotification(main.GetObjectAtPath("/hi"))
        XCTAssertTrue(value.IsValid())
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertFalse(main.GetObjectAtPath("/hi").IsValid())
    }
    
    // MARK: UnmuteLayer
    
    func test_UnmuteLayer_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            model.DefinePrim("/hi", "Sphere")
        }

        main.MuteLayer(pathForStage(named: "Model.usda"))
        
        let (token, value) = registerNotification(main.Traverse())
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], main.UnmuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertEqual(Array(main.Traverse()), [main.GetPrimAtPath("/hi")])
    }
    
    // MARK: MuteAndUnmuteLayers
    
    func test_MuteAndUnmuteLayers_GetAttributeAtPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            model.DefinePrim("/hi", "Sphere")
        }
        
        let (token, value) = registerNotification(main.GetAttributeAtPath("/hi.radius"))
        XCTAssertTrue(value.IsValid())
        expectingSomeNotifications([token], main.MuteAndUnmuteLayers([pathForStage(named: "Model.usda")], []))
        XCTAssertFalse(main.GetAttributeAtPath("/hi.radius").IsValid())
    }
    
    // MARK: SetMetadata
    
    func test_SetMetadata_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        var startTimeCode = 7.0
        let (token, value) = registerNotification(main.GetMetadata("startTimeCode", &startTimeCode))
        XCTAssertTrue(value)
        XCTAssertEqual(startTimeCode, 0)
        
        expectingSomeNotifications([token], main.SetMetadata("startTimeCode", 4.0))
        XCTAssertTrue(main.GetMetadata("startTimeCode", &startTimeCode))
        XCTAssertEqual(startTimeCode, 4)
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetStartTimeCode(5)
        
        let (token, value) = registerNotification(main.HasAuthoredMetadata("startTimeCode"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadata("startTimeCode"))
        XCTAssertFalse(main.HasAuthoredMetadata("startTimeCode"))
    }
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_GetMetadataByDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        var choice = std.string()
        let (token, value) = registerNotification(main.GetMetadataByDictKey("expressionVariables", "VARIANT_CHOICE", &choice))
        XCTAssertFalse(value)
        
        XCTAssertTrue(expectingSomeNotifications([token], main.SetMetadataByDictKey("expressionVariables", "VARIANT_CHOICE", "variantA" as std.string)))
        
        XCTAssertTrue(main.GetMetadataByDictKey("expressionVariables", "VARIANT_CHOICE", &choice))
        XCTAssertEqual(choice, "variantA")
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_HasMetadataByDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "VARIANT_CHOICE", "variantA" as std.string)
        
        let (token, value) = registerNotification(main.HasMetadataDictKey("expressionVariables", "VARIANT_CHOICE"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadataByDictKey("expressionVariables", "VARIANT_CHOICE"))
        XCTAssertFalse(main.HasMetadataDictKey("expressionVariables", "VARIANT_CHOICE"))
    }
    
    // MARK: SetStartTimeCode
    
    func test_SetStartTimeCode_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.GetStartTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], main.SetStartTimeCode(7))
        XCTAssertEqual(main.GetStartTimeCode(), 7)
    }
    
    func test_SetStartTimeCode_HasAuthoredTimeCodeRange() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetEndTimeCode(17)
        
        let (token, value) = registerNotification(main.HasAuthoredTimeCodeRange())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetStartTimeCode(7))
        XCTAssertTrue(main.HasAuthoredTimeCodeRange())
    }
    
    // MARK: SetEndTimeCode
    
    func test_SetEndTimeCode_GetEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.GetEndTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], main.SetEndTimeCode(7))
        XCTAssertEqual(main.GetEndTimeCode(), 7)
    }
    
    // MARK: SetTimeCodesPerSecond
    
    func test_SetTimeCodesPerSecond_GetTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.GetTimeCodesPerSecond())
        XCTAssertEqual(value, 24)
        
        expectingSomeNotifications([token], main.SetTimeCodesPerSecond(7))
        XCTAssertEqual(main.GetTimeCodesPerSecond(), 7)
    }
    
    // MARK: SetFramesPerSecond
    
    func test_SetFramesPerSecond_GetFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.GetFramesPerSecond())
        XCTAssertEqual(value, 24)
        
        expectingSomeNotifications([token], main.SetFramesPerSecond(7))
        XCTAssertEqual(main.GetFramesPerSecond(), 7)
    }
    
    // MARK: SetInterpolationType
    
    func test_SetInterpolationType_GetInterpolationType() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.GetInterpolationType())
        XCTAssertEqual(value, Overlay.UsdInterpolationTypeLinear)
        
        expectingSomeNotifications([token], main.SetInterpolationType(Overlay.UsdInterpolationTypeHeld))
        XCTAssertEqual(main.GetInterpolationType(), Overlay.UsdInterpolationTypeHeld)
    }
    
    // MARK: Reload
    
    func test_Reload_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetStartTimeCode(4)
        
        let (token, value) = registerNotification(main.GetStartTimeCode())
        XCTAssertEqual(value, 4)
        
        expectingSomeNotifications([token], main.Reload())
        XCTAssertEqual(main.GetStartTimeCode(), 0)
    }
        
    // MARK: SetColorConfigFallbacks
    
    func test_SetColorConfigFallbacks_GetColorConfigFallbacks() {
        // Note: These are static methods on UsdStage
        
        pxr.UsdStage.SetColorConfigFallbacks(pxr.SdfAssetPath("/foo/bar"), "fizzbuzz")
        
        var firstColorConfiguration = pxr.SdfAssetPath()
        var firstColorManagementSystem = pxr.TfToken()
        let (token, value): (ObservationHelper.Token, Void) = registerNotification(pxr.UsdStage.GetColorConfigFallbacks(&firstColorConfiguration, &firstColorManagementSystem))
        XCTAssertEqual(firstColorConfiguration, pxr.SdfAssetPath("/foo/bar"))
        XCTAssertEqual(firstColorManagementSystem, "fizzbuzz")
        
        expectingSomeNotifications([token], pxr.UsdStage.SetColorConfigFallbacks(pxr.SdfAssetPath("/bar/foo"), "buzzfizz"))
        var secondColorConfiguration = pxr.SdfAssetPath()
        var secondColorManagementSystem = pxr.TfToken()
        pxr.UsdStage.GetColorConfigFallbacks(&secondColorConfiguration, &secondColorManagementSystem)
        XCTAssertEqual(secondColorConfiguration, pxr.SdfAssetPath("/bar/foo"))
        XCTAssertEqual(secondColorManagementSystem, "buzzfizz")
        withExtendedLifetime(value) {}
    }
    
    // MARK: SetColorConfiguration
    
    func test_SetColorConfiguration_GetColorConfiguration() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        main.SetColorConfiguration(pxr.SdfAssetPath("/foo/bar"))
        let (token, value) = registerNotification(main.GetColorConfiguration())
        XCTAssertEqual(value, pxr.SdfAssetPath("/foo/bar"))
        
        expectingSomeNotifications([token], main.SetColorConfiguration(pxr.SdfAssetPath("/bar/foo")))
        XCTAssertEqual(main.GetColorConfiguration(), pxr.SdfAssetPath("/bar/foo"))
    }
    
    // MARK: SetColorManagementSystem
    
    func test_SetColorManagementSystem_GetColorManagementSystem() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        main.SetColorManagementSystem("fizzbuzz")
        let (token, value) = registerNotification(main.GetColorManagementSystem())
        XCTAssertEqual(value, "fizzbuzz")
        
        expectingSomeNotifications([token], main.SetColorManagementSystem("buzzfizz"))
        XCTAssertEqual(main.GetColorManagementSystem(), "buzzfizz")
    }
    
    // MARK: SetDefaultPrim
    
    func test_SetDefaultPrim_GetDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        main.SetDefaultPrim(foo)
        
        let (token, value) = registerNotification(main.GetDefaultPrim())
        XCTAssertEqual(value, foo)
        
        expectingSomeNotifications([token], main.SetDefaultPrim(bar))
        XCTAssertEqual(main.GetDefaultPrim(), bar)
    }
    
    // MARK: ClearDefaultPrim
    
    func test_ClearDefaultPrim_HasDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        main.SetDefaultPrim(foo)
        
        let (token, value) = registerNotification(main.HasDefaultPrim())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearDefaultPrim())
        XCTAssertFalse(main.HasDefaultPrim())
    }
    
    // MARK: OverridePrim
    
    func test_OverridePrim_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.ExportToString(addSourceFileComment: false))
        XCTAssertEqual(value, #"""
        #usda 1.0
        
        
        """#)
        
        expectingSomeNotifications([token], main.OverridePrim("/foo"))
        XCTAssertEqual(main.ExportToString(addSourceFileComment: false), #"""
        #usda 1.0
        
        over "foo"
        {
        }
        
        
        """#)
        
    }
    
    // MARK: DefinePrim
    
    func test_DefinePrim_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        
        """#)
        
        expectingSomeNotifications([token], main.DefinePrim("/foo", "Cube"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
        }

        
        """#)
    }
    
    func test_DefinePrim_GetPrimAtPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.GetPrimAtPath("/foo"))
        XCTAssertFalse(Bool(value))
        
        expectingSomeNotifications([token], main.DefinePrim("/foo", "Cube"))
        XCTAssertTrue(Bool(main.GetPrimAtPath("/foo")))
    }
    
    func test_DefinePrim_GetObjectAtPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.GetObjectAtPath("/foo.size"))
        XCTAssertFalse(value.IsValid())
        
        expectingSomeNotifications([token], main.DefinePrim("/foo", "Cube"))
        XCTAssertTrue(main.GetObjectAtPath("/foo.size").IsValid())
    }
    
    func test_DefinePrim_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.Traverse())
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], main.DefinePrim("/foo", "Cube"))
        XCTAssertEqual(Array(main.Traverse()), [main.GetPrimAtPath("/foo")])
    }
    
    func test_DefinePrim_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.TraverseAll())
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], main.DefinePrim("/foo", "Cube"))
        XCTAssertEqual(Array(main.TraverseAll()), [main.GetPrimAtPath("/foo")])
    }
    
    // MARK: CreateClassPrim
    
    func test_CreateClassPrim_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        
        """#)
        
        expectingSomeNotifications([token], main.CreateClassPrim("/_class_foo"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        class "_class_foo"
        {
        }

        
        """#)
    }
    
    func test_CreateClassPrim_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let (token, value) = registerNotification(main.TraverseAll())
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], main.CreateClassPrim("/_class_foo"))
        XCTAssertEqual(Array(main.TraverseAll()), [main.GetPrimAtPath("/_class_foo")])
    }
    
    // MARK: RemovePrim
    
    func test_RemovePrim_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(main.TraverseAll())
        XCTAssertEqual(Array(value), [main.GetPrimAtPath("/foo")])
        
        expectingSomeNotifications([token], main.RemovePrim("/foo"))
        XCTAssertEqual(Array(main.TraverseAll()), [])
    }
}
