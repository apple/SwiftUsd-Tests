//
//  EmbreeTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 4/1/25.
//

import XCTest
import OpenUSD

// TODO: Unify this with the main Hydra renderer in the unit tests
// That renderer doesn't support selecting a renderer,
// and it would only do a single call to `engine.Render()`,
// so we use a really simple renderer to have more control,
// so we can test rendering with Embree

fileprivate typealias BufferReadbackType = Overlay.GfHalf_Vector
fileprivate let USE_EMBREE = true
fileprivate let CONVERGE_LIMIT = 10000

fileprivate class Renderer {
    var worldCenter: pxr.GfVec3d = pxr.GfVec3d()
    var worldSize: Double = 0.0
    var material: pxr.GlfSimpleMaterial = .init()
    var sceneAmbient: pxr.GfVec4f = pxr.GfVec4f(0.1, 0.1, 0.1, 1)

    var hgi: Overlay.HgiWrapper!
    var engine: Overlay.UsdImagingGLEngineWrapper!
    var stage: pxr.UsdStage!
    
    deinit {
        // Important: UsdImagingGLEngine requires its Hgi to
        // be alive for the engine's lifetime, but Swift
        // does not guarantee the deinitilization order of
        // stored properties in types. So, we must destroy
        // the engine by setting to nil before the hgi
        // is implicitly destroyed (by the compiler) or
        // by us (by explicitly setting to nil)
        engine = nil
        hgi = nil
    }

    init(path: String) {
        stage = Overlay.Dereference(pxr.UsdStage.Open(std.string(path), .LoadAll))
        setupMaterial()
        calculateWorldCenterAndSize()
        initializeEngine()
    }

    func setupMaterial() {
        let kA: Float = 0.2
        let kS: Float = 0.1
        material.SetAmbient(pxr.GfVec4f(kA, kA, kA, 1))
        material.SetSpecular(pxr.GfVec4f(kS, kS, kS, 1))
        material.SetShininess(32)
    }

    func getCameraTransform() -> pxr.GfMatrix4d {
        pxr.GfMatrix4d.MakeTranslate(
            pxr.GfVec3d(worldCenter[0], worldCenter[1], worldCenter[2] + worldSize)
        )
    }

    func computeFrustum(viewSize: pxr.GfVec2i) -> pxr.GfFrustum {
        let filmbackWidthMM: Float = 24
        let focalLength: Double = 18
        let hFOVInRadians = 2 * atan(0.5 * Double(filmbackWidthMM) / focalLength)
        let fov = 180 * hFOVInRadians / .pi
        let targetAspect = Double(viewSize[0]) / Double(viewSize[1])

        var camera = pxr.GfCamera(
            pxr.GfMatrix4d(1.0),
            .Perspective,
            Float(pxr.GfCamera.DEFAULT_HORIZONTAL_APERTURE),
            Float(pxr.GfCamera.DEFAULT_VERTICAL_APERTURE),
            0.0,
            0.0,
            50.0,
            pxr.GfRange1f(1, 100000),
            [],
            0.0,
            0.0
        )
        camera.SetTransform(getCameraTransform())
        camera.SetFocalLength(Float(focalLength))

        var frustum = camera.GetFrustum()
        frustum.SetPerspective(fov, targetAspect, 1, 100000)
        return frustum
    }

    func computeLights() -> pxr.GlfSimpleLightVector {
        var cameraLight = pxr.GlfSimpleLight(pxr.GfVec4f(0, 0, 0, 1))
        let cameraPosition = pxr.GfVec3f(getCameraTransform().ExtractTranslation())
        cameraLight.SetPosition(pxr.GfVec4f(cameraPosition[0], cameraPosition[1], cameraPosition[2], 1))

        var domeLight = pxr.GlfSimpleLight(pxr.GfVec4f(0, 0, 0, 1))
        domeLight.SetIsDomeLight(true)
        
        return [cameraLight, domeLight]
    }

    func initializeEngine() {
        print("Plugin arguments:")
        for pluginId in Overlay.UsdImagingGLEngineWrapper.GetRendererPlugins() {
            let displayName = Overlay.UsdImagingGLEngineWrapper.GetRendererDisplayName(pluginId)
            print("pluginId: \(pluginId), displayName: \(displayName)")
        }
        
        let excludedPaths = pxr.SdfPathVector()
        hgi = Overlay.HgiWrapper.CreatePlatformDefaultHgi()
        let driver = pxr.HdDriver(name: .HgiTokens.renderDriver, driver: hgi.VtValueWrappingHgiRawPtr())
        engine = Overlay.UsdImagingGLEngineWrapper(stage.GetPseudoRoot().GetPath(),
                                                   excludedPaths, pxr.SdfPathVector(),
                                                   pxr.SdfPath.AbsoluteRootPath(), driver,
                                                   pxr.TfToken(),
                                                   true,
                                                   false,
                                                   false)
        
        if USE_EMBREE {
            engine.SetRendererPlugin("HdEmbreeRendererPlugin")
        }
        print("Using \(engine.GetCurrentRendererId())")
        engine.SetEnablePresentation(false)
        engine.SetRendererAov(.HdAovTokens.color)
    }

    func drawWithHydra(timeCode: Double, viewSize: pxr.GfVec2i) -> pxr.HgiTextureHandle {
        let frustum = computeFrustum(viewSize: viewSize)
        let modelViewMatrix = frustum.ComputeViewMatrix()
        let projMatrix = frustum.ComputeProjectionMatrix()
        engine.SetCameraState(modelViewMatrix, projMatrix)

        let viewport = pxr.GfVec4d(0, 0, Double(viewSize[0]), Double(viewSize[1]))
        engine.SetRenderViewport(viewport)
        engine.SetWindowPolicy(Overlay.CameraUtilMatchVertically)

        let lights = computeLights()
        engine.SetLightingState(lights, material, sceneAmbient)

        var params = pxr.UsdImagingGLRenderParams()
        params.clearColor = pxr.GfVec4f(0, 0, 0, 0)
        params.colorCorrectionMode = .HdxColorCorrectionTokens.sRGB
        params.frame = .init(timeCode)

        let tic = Date()
        var convergeCount = 0
        repeat {
            engine.Render(stage.GetPseudoRoot(), params)
            convergeCount += 1
        } while(convergeCount < CONVERGE_LIMIT)
        let toc = Date()
        print(toc.timeIntervalSince(tic))
        print(convergeCount)
        return engine.GetAovTexture(.HdAovTokens.color)
    }

    func computeBboxCache() -> pxr.UsdGeomBBoxCache {
        let purposes: pxr.TfTokenVector = [.UsdGeomTokens.default_, .UsdGeomTokens.proxy]

        let useExtentHints = true
        var timeCode = pxr.UsdTimeCode.Default()
        if stage.HasAuthoredTimeCodeRange() {
            timeCode = .init(stage.GetStartTimeCode())
        }
        let bboxCache = pxr.UsdGeomBBoxCache(timeCode, purposes, useExtentHints, true)
        return bboxCache
    }

    func calculateWorldCenterAndSize() {
        #if os(Linux)
        // Quick hack, ~UsdGeomBBoxCache crashes for me deep in the stl (ported from Linux)
        worldCenter = pxr.GfVec3d(0, 0, 0)
        worldSize = 20
        #else
        var bboxCache = computeBboxCache()
        var bbox = bboxCache.ComputeWorldBound(stage.GetPseudoRoot())

        if bbox.GetRange().IsEmpty() ||
           bbox.GetRange().GetMin().GetLength().isInfinite ||
           bbox.GetRange().GetMax().GetLength().isInfinite {
           bbox = .init(.init(.init(-10, -10, -10), .init(10, 10, 10)))
       }
       let world = bbox.ComputeAlignedRange()

       worldCenter = (world.GetMin() + world.GetMax()) / 2
       worldSize = world.GetSize().GetLength()
       #endif
    }

    func renderToFile(filepath: String, viewSize: pxr.GfVec2i) {
        let colorTexture = drawWithHydra(timeCode: pxr.UsdTimeCode.Default().GetValue(), viewSize: viewSize)
        if colorTexture.__convertToBool() {
            var buffer = BufferReadbackType()
            let textureSize = readbackTexture(hgi: hgi, textureHandle: colorTexture, buffer: &buffer)
            print(buffer.size())
            print("After reading back texture, texture size was \(textureSize)")
            let writeSucceeded = writeTextureToFile(textureDesc: Overlay.GetDescriptor(colorTexture),
                                                    buffer: buffer,
                                                    filename: .init(filepath),
                                                    flipped: true)
            print("Write succeeded? \(writeSucceeded)")
        } else {
            print("After drawing with hydra, the color texture was bad!")
        }
    }

    func readbackTexture(hgi: Overlay.HgiWrapper, textureHandle: pxr.HgiTextureHandle, buffer: inout BufferReadbackType) -> pxr.GfVec2i {
        var widthHeight = pxr.GfVec2i()

        if textureHandle.__convertToBool() {
            let textureDesc = Overlay.GetDescriptor(textureHandle)
            let formatByteSize = pxr.HgiGetDataSizeOfFormat(textureDesc.format)
            print(textureDesc.format)
            let width = textureDesc.dimensions[0]
            let height = textureDesc.dimensions[1]
            widthHeight[0] = width
            widthHeight[1] = height
            let dataSize = width * height
            var dataByteSize = Int(dataSize) * formatByteSize
            
            let alignedBuffer = pxr.HdStTextureUtils.HgiTextureReadback(hgi.__getUnsafe(), textureHandle, &dataByteSize)
            buffer.resize(dataByteSize)
            let dest = UnsafeMutableRawPointer(buffer.__dataMutatingUnsafe()!)
            let src = UnsafeRawPointer(alignedBuffer.__getUnsafe()!)
            dest.copyMemory(from: src, byteCount: dataByteSize)
        }
        return widthHeight
    }

    func writeTextureToFile(textureDesc: pxr.HgiTextureDesc, buffer: BufferReadbackType, filename: String, flipped: Bool) -> Bool  {
        let formatByteSize = pxr.HgiGetDataSizeOfFormat(textureDesc.format)
        let width = textureDesc.dimensions[0]
        let height = textureDesc.dimensions[1]
        let dataByteSize = Int(width) * Int(height) * formatByteSize

        if buffer.size() < dataByteSize {
            return false
        }
        if textureDesc.format.rawValue < 0 || textureDesc.format.rawValue >= Overlay.HgiFormatCount.rawValue {
            return false
        }

        var storage = Overlay.HioImageWrapper.StorageSpec()
        storage.width = width
        storage.height = height
        storage.format = pxr.HdxGetHioFormat(textureDesc.format)
        storage.flipped = flipped
        storage.data = UnsafeMutableRawPointer(mutating: buffer.__dataUnsafe()!)

        do {
            let metadata = pxr.VtDictionary()
            var image = Overlay.HioImageWrapper.OpenForWriting(std.string(filename))
            let writeSuccess = Bool(image) && image.Write(storage, metadata)

            if !writeSuccess {
                print("Failed to write image")
                return false
            }
        }
        
        return true
    }
}


#if canImport(SwiftUsd_PXR_ENABLE_EMBREE_SUPPORT)
final class EmbreeTests: HydraHelper {
    func testBiplane() {
        let modelUrl = urlForResource(subPath: "Embree/toy_biplane_idle.usdz")
        let renderer = Renderer(path: modelUrl.path(percentEncoded: false))
        
        let renderUrl = tempDirectory.appending(path: UUID().uuidString + ".png")
        renderer.renderToFile(filepath: renderUrl.path(percentEncoded: false), viewSize: pxr.GfVec2i(512, 512))
        
        assertImagesEqual(urlForResource(subPath: "Embree/toy_biplane_idle.png"), renderUrl, isEmbreeRender: true, file: #file, line: #line)
    }
}
#endif // #if canImport(SwiftUsd_PXR_ENABLE_EMBREE_SUPPORT)
