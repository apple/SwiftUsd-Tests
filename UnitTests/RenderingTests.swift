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

import XCTest
import Foundation
import OpenUSD

#if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)

struct RenderConfig {
    typealias TupleVector = (Double, Double, Double, Double)
    typealias TupleMatrix = (TupleVector, TupleVector, TupleVector, TupleVector)
    
    private static func toGfVec4d(_ v: TupleVector) -> pxr.GfVec4d {
        .init(v.0, v.1, v.2, v.3)
    }
    
    private static func toVector(_ v: TupleVector) -> Overlay.Double_Vector {
        [v.0, v.1, v.2, v.3]
    }
    
    private static func toGfMatrix4d(_ m: TupleMatrix) -> pxr.GfMatrix4d {
        .init(toVector(m.0), toVector(m.1), toVector(m.2), toVector(m.3))
    }
    
    var model: URL
    var size: CGSize
    var frame: pxr.UsdTimeCode
    var drawMode: pxr.UsdImagingGLDrawMode
    var lights: [(isDomeLight: Bool, position: pxr.GfVec4d, transform: pxr.GfMatrix4d)]
    var modelViewMatrix: pxr.GfMatrix4d
    var projMatrix: pxr.GfMatrix4d
    
    init(model: URL, size: CGSize = CGSize(width: 1000, height: 1000),
         frame: pxr.UsdTimeCode, drawMode: pxr.UsdImagingGLDrawMode,
         lights: [(isDomeLight: Bool, position: TupleVector, transform: TupleMatrix)],
         modelViewMatrix: TupleMatrix,
         projMatrix: TupleMatrix) {
        self.model = model
        self.size = size
        self.frame = frame
        self.drawMode = drawMode
        self.lights = lights.map { ($0.0, Self.toGfVec4d($0.1), Self.toGfMatrix4d($0.2))}
        self.modelViewMatrix = Self.toGfMatrix4d(modelViewMatrix)
        self.projMatrix = Self.toGfMatrix4d(projMatrix)
    }
    
    func render(to dest: URL) {
        let drawableSize = pxr.GfVec2i(Int32(size.width), Int32(size.height))
        
        // Hydra init
        let stage = Overlay.Dereference(pxr.UsdStage.Open(std.string(model.absoluteURL.relativePath), .LoadAll))
        var hgi: Overlay.HgiWrapper! = Overlay.HgiWrapper.CreatePlatformDefaultHgi()
        var driver = pxr.HdDriver()
        driver.name = .HgiTokens.renderDriver
        driver.driver = hgi.VtValueWrappingHgiRawPtr()
        var engine: Overlay.UsdImagingGLEngineWrapper! = Overlay.UsdImagingGLEngineWrapper("/", [], [], "/", driver, "", true, false, false, true)
        engine.SetEnablePresentation(false)
        engine.SetRendererAov(.HdAovTokens.color)
        
        // Prepare to render
        let viewPort = pxr.GfVec4d(0, 0, Double(drawableSize[0]), Double(drawableSize[1]))
        
        var framing = pxr.CameraUtilFraming()
        framing.displayWindow = pxr.GfRange2f(pxr.GfVec2f(0), pxr.GfVec2f(drawableSize))
        framing.dataWindow = pxr.GfRect2i(pxr.GfVec2i(0), drawableSize - pxr.GfVec2i(1))
        framing.pixelAspectRatio = 1
        
        let targetAspect = Float(drawableSize[0]) / Float(max(1, drawableSize[1]))
        
        engine.SetCameraState(modelViewMatrix, projMatrix)
        engine.SetRenderViewport(viewPort)
        engine.SetRenderBufferSize(drawableSize)
        engine.SetFraming(framing)
        engine.SetWindowPolicy(Overlay.CameraUtilMatchVertically)

        var lightVector = pxr.GlfSimpleLightVector()
        for (isDomeLight, position, transform) in lights {
            var l = pxr.GlfSimpleLight(pxr.GfVec4f(0, 0, 0, 1))
            if isDomeLight {
                l.SetIsDomeLight(true)
                l.SetTransform(transform)
            } else {
                l.SetAmbient(pxr.GfVec4f(0, 0, 0, 0))
                l.SetPosition(pxr.GfVec4f(Float(position[0]), Float(position[1]), Float(position[2]), 1))
            }
            lightVector.push_back(l)
        }
        var material = pxr.GlfSimpleMaterial()
        material.SetAmbient(pxr.GfVec4f(0.2, 0.2, 0.2, 1))
        material.SetSpecular(pxr.GfVec4f(0.1, 0.1, 0.1, 1))
        material.SetShininess(32)
        
        let sceneAmbient = pxr.GfVec4f(0.01, 0.01, 0.01, 0.01)

        engine.SetLightingState(lightVector, material, sceneAmbient)
        
        var renderParams = pxr.UsdImagingGLRenderParams()
        renderParams.complexity = 1
        renderParams.cullStyle = pxr.UsdImagingGLCullStyle.CULL_STYLE_NOTHING
        renderParams.enableLighting = true
        renderParams.enableSceneMaterials = true
        renderParams.colorCorrectionMode = .HdxColorCorrectionTokens.sRGB
        renderParams.clearColor = pxr.GfVec4f(0.3, 0.3, 0.3, 1)
        renderParams.frame = frame
        renderParams.drawMode = drawMode
        
        // Render
        var convergeCount = 0
        repeat {
            engine.Render(stage.GetPseudoRoot(), renderParams)
            convergeCount += 1
        } while (!engine.IsConverged() && convergeCount < 10)
        engine.GetAovTexture(.HdAovTokens.color)
        
        var writer: TextureBufferWriter! = TextureBufferWriter(engine)
        writer.Write(dest, hgi: hgi)
        // Important: The writer holds on to the engine, but the engine
        // has to not outlive the hgi.
        writer = nil
        
        // Important: TextureBufferWriter.Write() requires
        // the Hgi to be alive
        withExtendedLifetime(hgi) {}
        // Important: UsdImagingGLEngine requires its Hgi to
        // be alive for the engine's lifetime
        engine = nil
        withExtendedLifetime(hgi) {}
        hgi = nil
    }
    
    // Adapted from pxr/usdImaging/usdAppUtils/frameRecorder.cpp
    class TextureBufferWriter {
        var engine: Overlay.UsdImagingGLEngineWrapper!
        
        var colorTextureHandle: pxr.HgiTextureHandle = .init()
        var buffer: Overlay.GfHalf_Vector = .init()
        
        init(_ engine: Overlay.UsdImagingGLEngineWrapper) {
            self.engine = engine
            
            assert(engine.GetGPUEnabled())
            colorTextureHandle = engine.GetAovTexture(.HdAovTokens.color)
            if !colorTextureHandle.__convertToBool() {
                TF_CODING_ERROR("No color texture to write out.")
            }
        }
        
        @discardableResult
        func Write(_ dest: URL, hgi: Overlay.HgiWrapper) -> Bool {
            guard _ValidSource() else { return false }
            
            var storage = Overlay.HioImageWrapper.StorageSpec()
            storage.width = Int32(_GetWidth())
            storage.height = Int32(_GetHeight())
            storage.format = _GetFormat()
            storage.flipped = true
            storage.data = _Map(hgi: hgi)
            
            do {
                // writing image
                
                var image = Overlay.HioImageWrapper.OpenForWriting(std.string(dest.absoluteURL.relativePath))
                let writeSuccess = Bool(image) && image.Write(storage, .init())
                
                if !writeSuccess {
                    TF_RUNTIME_ERROR(std.string("Failed to write image to \(dest)"))
                    return false
                }
            }
            
            return true
        }
        
        private func _ValidSource() -> Bool {
            return colorTextureHandle.__convertToBool()
        }
        
        private func _GetWidth() -> Int {
            if colorTextureHandle.__convertToBool() {
                return Int(Overlay.GetDescriptor(colorTextureHandle).dimensions[0])
            } else {
                return 0
            }
        }
        
        private func _GetHeight() -> Int {
            if colorTextureHandle.__convertToBool() {
                return Int(Overlay.GetDescriptor(colorTextureHandle).dimensions[1])
            } else {
                return 0
            }
        }
        
        private func _GetFormat() -> pxr.HioFormat {
            if colorTextureHandle.__convertToBool() {
                return pxr.HdxGetHioFormat(Overlay.GetDescriptor(colorTextureHandle).format)
            } else {
                return .HioFormatInvalid
            }
        }
        
        private func _Map(hgi: Overlay.HgiWrapper) -> UnsafeMutableRawPointer? {
            if colorTextureHandle.__convertToBool() {
                var size = 0
                // Readback into an aligned buffer
                let alignedBuffer = pxr.HdStTextureUtils.HgiTextureReadback(hgi.__getUnsafe(), colorTextureHandle, &size)
                // Copy from aligned buffer into vector<GfHalf>
                let dataByteSize = _GetWidth() * _GetHeight() * pxr.HioGetDataSizeOfFormat(_GetFormat())
                buffer.resize(dataByteSize)
                let copyDest = UnsafeMutableRawPointer(buffer.__dataMutatingUnsafe()!)
                let copySrc = UnsafeRawPointer(alignedBuffer.__getUnsafe()!)
                copyDest.copyMemory(from: copySrc, byteCount: dataByteSize)
                return copyDest
            } else {
                return nil
            }
        }
    }
}

class HydraHelper: TemporaryDirectoryHelper {
    @discardableResult
    @MainActor func assertRendersEqual(subPath: String, config: RenderConfig, file: StaticString = #filePath, line: UInt = #line) -> URL {
        print("----New render----")
        print("subPath: \(subPath)")
        
        let otherUrl = tempDirectory.appending(path: UUID().uuidString + ".png")
        config.render(to: otherUrl)
        
        assertImagesEqual(urlForResource(subPath: subPath), otherUrl, file: file, line: line)
        return otherUrl
    }
    
    func assertImagesEqual(_ lhs: URL, _ rhs: URL, isEmbreeRender: Bool = false, file: StaticString, line: UInt) {
        // Make sure the files exist...
        guard FileManager.default.fileExists(atPath: lhs.path(percentEncoded: false)) else {
            XCTFail("No data at lhs url: \(lhs)", file: file, line: line)
            print(rhs)
            print("")
            return
        }
        
        guard FileManager.default.fileExists(atPath: rhs.path(percentEncoded: false)) else {
            XCTFail("No data at rhs url: \(rhs)", file: file, line: line)
            print(rhs)
            print("")
            return
        }
        
        guard let lhsImage = NSImage(contentsOf: lhs) else {
            XCTFail("Couldn't create lhs image: \(lhs)", file: file, line: line)
            print("")
            return
        }
        
        guard let rhsImage = NSImage(contentsOf: rhs) else {
            XCTFail("Couldn't create rhs image: \(rhs)", file: file, line: line)
            print("")
            return
        }
        
        // Make sure the files have the same dimensions
        let lhsCgImage = lhsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let rhsCgImage = rhsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        
        if lhsCgImage.width != rhsCgImage.width || lhsCgImage.height != rhsCgImage.height {
            XCTFail("Image sizes differ: (\(lhsCgImage.width), \(lhsCgImage.height)) vs (\(rhsCgImage.width), \(rhsCgImage.height))", file: file, line: line)
        }
        
        // Create the difference image...
        var context = CGContext(data: nil, width: lhsCgImage.width, height: lhsCgImage.height,
                                bitsPerComponent: lhsCgImage.bitsPerComponent, bytesPerRow: lhsCgImage.bytesPerRow,
                                space: lhsCgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: lhsCgImage.bitmapInfo.rawValue)
        if context == nil {
            // Embree images have no bitmapInfo, so the first CGContext init fails
            context = CGContext(data: nil, width: lhsCgImage.width, height: lhsCgImage.height,
                                bitsPerComponent: lhsCgImage.bitsPerComponent, bytesPerRow: lhsCgImage.bytesPerRow,
                                space: lhsCgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue).rawValue)
            
        }
        guard let context else { fatalError() }
        

        context.setBlendMode(.copy)
        context.draw(lhsCgImage, in: CGRect(origin: .zero, size: CGSize(width: lhsCgImage.width, height: lhsCgImage.height)), byTiling: false)
        context.setBlendMode(.difference)
        context.draw(rhsCgImage, in: CGRect(origin: .zero, size: CGSize(width: lhsCgImage.width, height: lhsCgImage.height)), byTiling: false)
        
        // Save the difference image to disk...
        let differenceImage = context.makeImage()!
        let differenceUrl = tempDirectory.appending(path: UUID().uuidString + ".png")
        
        let imageRep = NSBitmapImageRep(cgImage: differenceImage)
        imageRep.size = CGSize(width: lhsCgImage.width, height: lhsCgImage.height)
        let differencePngData = imageRep.representation(using: .png, properties: [:])!
        try! differencePngData.write(to: differenceUrl)

        
        let differencePixelData: UnsafeMutableRawPointer = context.data!
        
        var badPixelCount = 0
        var maxBadComponent: UInt8 = 0
        for x in 0..<lhsCgImage.width {
            for y in 0..<lhsCgImage.height {
                let pixelAddress = differencePixelData.advanced(by: y * lhsCgImage.bytesPerRow + 4 * x * lhsCgImage.bitsPerPixel / 8).assumingMemoryBound(to: UInt8.self)
                let r = pixelAddress.pointee
                let g = pixelAddress.advanced(by: 1).pointee
                let b = pixelAddress.advanced(by: 2).pointee
                let a = pixelAddress.advanced(by: 3).pointee
                
                let badPixel = if a != 255 && a != 0 { true }
                               else if r >= 8 || g >= 8 || b >= 8 { true }
                               else { false }
                
                if badPixel {
                    badPixelCount += 1
                    maxBadComponent = max(maxBadComponent, r, g, b)
                    if !isEmbreeRender {
                        XCTFail("Found bad pixel at (\(x), \(y)): (\(r), \(g), \(b), \(a))", file: file, line: line)
                        print(differenceUrl)
                        print(lhs)
                        print(rhs)
                        print("")
                        return
                    }
                }
            }
        }
        
        if isEmbreeRender {
            let fractionBadPixels = Double(badPixelCount) / (Double(lhsCgImage.width) * Double(lhsCgImage.height))
            if fractionBadPixels > 0.01 {
                XCTFail("\(fractionBadPixels * 100)% Embree render pixels were bad")
            }
            if maxBadComponent > 108 {
                XCTFail("Embree had maximum bad color component \(maxBadComponent)")
            }
        }
    }
}

// Storm may be non-deterministic, so these tests may sometimes fail. In that case, manually compare the images and decide if the test should pass or not
final class RenderingTests: HydraHelper {
    @MainActor func test_rendering_noArguments() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/spinning_top.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, -2.7226517, -0.004380574, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 2.220446049250313e-16, 1, 0), (0, -1, 2.220446049250313e-16, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 2.220446049250313e-16, -1, 0), (0, 1, 2.220446049250313e-16, 0), (0, 0.004380574145194438, -2.7226517495742693, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/noArguments.png", config: config)
    }
    
    // MARK: Default model
    
    @MainActor func test_rendering_defaultModel_timeCode_5() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/spinning_top.usdz"), frame: 5, drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, -2.7226517, -0.004380574, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 2.220446049250313e-16, 1, 0), (0, -1, 2.220446049250313e-16, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 2.220446049250313e-16, -1, 0), (0, 1, 2.220446049250313e-16, 0), (0, 0.004380574145194438, -2.7226517495742693, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/defaultModel_timeCode_5.png", config: config)
    }
    
    @MainActor func test_rendering_defaultModel_timeCode_20_flatShading() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/spinning_top.usdz"), frame: 20, drawMode: .DRAW_SHADED_FLAT,
                                  lights: [(false, (0, -2.7226517, -0.004380574, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 2.220446049250313e-16, 1, 0), (0, -1, 2.220446049250313e-16, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 2.220446049250313e-16, -1, 0), (0, 1, 2.220446049250313e-16, 0), (0, 0.004380574145194438, -2.7226517495742693, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/defaultModel_timeCode_20_flatShading.png", config: config)
    }
    
    @MainActor func test_rendering_defaultModel_timeCode_0_domeLightOnly() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/spinning_top.usdz"), frame: 0, drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 2.220446049250313e-16, 1, 0), (0, -1, 2.220446049250313e-16, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 2.220446049250313e-16, -1, 0), (0, 1, 2.220446049250313e-16, 0), (0, 0.004380574145194438, -2.7226517495742693, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/defaultModel_timeCode_0_domeLightOnly.png", config: config)
    }
    
    @MainActor func test_rendering_defaultModel_timeCode_0_ambientLightOnly() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/spinning_top.usdz"), frame: 0, drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, -2.7226517, -0.004380574, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 2.220446049250313e-16, -1, 0), (0, 1, 2.220446049250313e-16, 0), (0, 0.004380574145194438, -2.7226517495742693, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/defaultModel_timeCode_0_ambientLightOnly.png", config: config)
    }
    
    @MainActor func test_rendering_defaultModel_raw4x4Rig_Z5() throws {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/spinning_top.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, -5, 1.110223e-15, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 2.220446049250313e-16, 1, 0), (0, -1, 2.220446049250313e-16, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 2.220446049250313e-16, -1, 0), (0, 1, 2.220446049250313e-16, 0), (0, 0, -5, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/defaultModel_raw4x4Rig_Z5.png", config: config)
    }
    
    @MainActor func test_rendering_defaultModel_raw4x4Rig_identity() throws {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/spinning_top.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 2.220446049250313e-16, 1, 0), (0, -1, 2.220446049250313e-16, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 2.220446049250313e-16, -1, 0), (0, 1, 2.220446049250313e-16, 0), (0, 0, 0, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/defaultModel_raw4x4Rig_identity.png", config: config)
    }
    
    @MainActor func test_rendering_defaultModel_raw4x4Rig_Z3_yaw15() throws {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/spinning_top.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, -3, 6.661338e-16, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 2.220446049250313e-16, 1, 0), (0, -1, 2.220446049250313e-16, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (0.9659258262890683, -2.7755575615628914e-17, -0.25881904510252074, 0), (-0.25881904510252074, 0, -0.9659258262890683, 0), (2.7755575615628914e-17, 1, 0, 0), (-0.7764571353075622, -6.661338147750939e-16, -2.897777478867205, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/defaultModel_raw4x4Rig_Z3_yaw15.png", config: config)
    }
    
    // MARK: Asset url
    
    @MainActor func test_rendering_url_nil() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/empty.usda"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 34.641018, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, -34.64101615137755, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/url_nil.png", config: config)
    }
    
    @MainActor func test_rendering_url_biplane() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/toy_biplane_idle.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (-0.038681507, 8.896807, 29.214699, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0.0386815071105957, -8.896806240081787, -29.214699464954176, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/url_biplane.png", config: config)
    }
    
    @MainActor func test_rendering_url_biplane_timeCode_17() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/toy_biplane_idle.usdz"), frame: 17, drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (-0.038681507, 8.896807, 29.214699, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0.0386815071105957, -8.896806240081787, -29.214699464954176, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/url_biplane_timeCode_17.png", config: config)
    }
    
    @MainActor func test_rendering_url_biplane_timeCode_54() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/toy_biplane_idle.usdz"), frame: 54, drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (-0.038681507, 8.896807, 29.214699, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0.0386815071105957, -8.896806240081787, -29.214699464954176, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/url_biplane_timeCode_54.png", config: config)
    }
    
    @MainActor func test_rendering_url_biplane_domeLightOnly() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/toy_biplane_idle.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0.0386815071105957, -8.896806240081787, -29.214699464954176, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/url_biplane_domeLightOnly.png", config: config)
    }
    
    @MainActor func test_rendering_url_biplane_ambientLightOnly() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/toy_biplane_idle.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (-0.038681507, 8.896807, 29.214699, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0.0386815071105957, -8.896806240081787, -29.214699464954176, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/url_biplane_ambientLightOnly.png", config: config)
    }
    
    @MainActor func test_rendering_url_biplane_raw4x4Rig_Z5() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/toy_biplane_idle.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 5, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, -5, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/url_biplane_raw4x4Rig_Z5.png", config: config)
    }

    @MainActor func test_rendering_url_biplane_raw4x4Rig_identity() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/toy_biplane_idle.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/url_biplane_raw4x4Rig_identity.png", config: config)
    }
    
    @MainActor func test_rendering_url_biplane_raw4x4Rig_Z3_yaw15() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/toy_biplane_idle.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 3, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (0.9659258262890682, 0, -0.25881904510252124, 0), (0, 1, 0, 0), (0.25881904510252124, 0, 0.9659258262890682, 0), (-0.7764571353075638, 0, -2.8977774788672046, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/url_biplane_raw4x4Rig_Z3_yaw15.png", config: config)
    }
    
    // MARK: Stage object
    
    @MainActor func test_rendering_stage_nil() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/empty.usda"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 34.641018, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, -34.64101615137755, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/stage_nil.png", config: config)
    }
    
    private func openInteriorUsdz() -> pxr.UsdStage {
        Overlay.Dereference(pxr.UsdStage.Open(std.string(urlForResource(subPath: "Rendering/Interior.usdz").path(percentEncoded: false)), Overlay.UsdStage.LoadAll))
    }
    
    @MainActor func test_rendering_stage_interior() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/Interior.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 1.3676523, 8.650644, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, -1.3676523007452488, -8.650644250494127, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/stage_interior.png", config: config)
    }
    
    @MainActor func test_rendering_stage_interior_domeLightOnly() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/Interior.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, -1.3676523007452488, -8.650644250494127, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/stage_interior_domeLightOnly.png", config: config)
    }
    
    @MainActor func test_rendering_stage_interior_ambientLightOnly() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/Interior.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 1.3676523, 8.650644, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, -1.3676523007452488, -8.650644250494127, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/stage_interior_ambientLightOnly.png", config: config)
    }

    @MainActor func test_rendering_stage_interior_raw4x4Rig_Z5() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/Interior.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 5, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, -5, 1) ), projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/stage_interior_raw4x4Rig_Z5.png", config: config)
    }
    
    @MainActor func test_rendering_stage_interior_raw4x4Rig_identity() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/Interior.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/stage_interior_raw4x4Rig_identity.png", config: config)
    }
    
    @MainActor func test_rendering_stage_interior_raw4x4Rig_Z3_yaw15() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/Interior.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 3, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (0.9659258262890682, 0, -0.25881904510252124, 0), (0, 1, 0, 0), (0.25881904510252124, 0, 0.9659258262890682, 0), (-0.7764571353075638, 0, -2.8977774788672046, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/stage_interior_raw4x4Rig_Z3_yaw15.png", config: config)
    }
    
    @MainActor func test_rendering_mxmetallic() {
        // `SwiftUsdTests/UnitTests/Resources/Rendering/mxmetallic.usdz` is a usdzip'd version of
        // https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/pxr/usdImaging/usdImagingGL/testenv/testUsdImagingGLMaterialXvsNative/materialXmetallic.usda.
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/mxmetallic.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, -103.80751, -37, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 2.220446049250313e-16, 1, 0), (0, -1, 2.220446049250313e-16, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 2.220446049250313e-16, -1, 0), (0, 1, 2.220446049250313e-16, 0), (0, 37, -103.80751417888784, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/mxmetallic.png", config: config)
    }
    
    #if canImport(SwiftUsd_PXR_ENABLE_OPENVDB_SUPPORT)
    @MainActor func test_rendering_openvdb_smoke() {
        let config = RenderConfig(model: urlForResource(subPath: "Rendering/smoke.usdz"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (0, 0, 34.641018, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, -34.64101615137755, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "Rendering/smoke.png", config: config)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_OPENVDB_SUPPORT)
    
    #if canImport(SwiftUsd_PXR_ENABLE_OPENIMAGEIO_SUPPORT) || canImport(SwiftUsd_PXR_ENABLE_IMAGEIO_SUPPORT)
    @MainActor func test_rendering_openimageio_simpleShading() {
        // `SwiftUsdTests/UnitTests/Resources/OpenImageIO/simpleShading.usda` is a modified version of
        // https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/simpleShading/simpleShading.usda
        // `SwiftUsdTests/UnitTests/Resources/OpenImageIO/USDLogoLrg.tiff` is a modified version of
        // https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/simpleShading/USDLogoLrg.png
        let config = RenderConfig(model: urlForResource(subPath: "OpenImageIO/simpleShading.usda"), frame: .EarliestTime(), drawMode: .DRAW_SHADED_SMOOTH,
                                  lights: [(false, (-300, 0, 400, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )), (true, (0, 0, 0, 1), ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) ))],
                                  modelViewMatrix: ( (0.7071067811865475, 0, -0.7071067811865476, 0), (0, 1, 0, 0), (0.7071067811865476, 0, 0.7071067811865475, 0), (-70.71067811865478, 0, -494.97474683058323, 1) ),
                                  projMatrix: ( (1.7320507843521864, 0, 0, 0), (0, 1.7320507843521864, 0, 0), (0, 0, -1.000002000002, -1), (0, 0, -2.000002000002, 0) ))
        assertRendersEqual(subPath: "OpenImageIO/expected.png", config: config)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_OPENIMAGEIO_SUPPORT) || canImport(SwiftUsd_PXR_ENABLE_IMAGEIO_SUPPORT)
}

#endif // #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)
