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

// Helpers for reading/writing to images in memory, as well as
// reading/writing them via pxr::HioImage

import Foundation
import OpenUSD

extension Comparable {
    fileprivate func clamped(to: ClosedRange<Self>) -> Self {
        max(min(self, to.upperBound), to.lowerBound)
    }
}

// MARK: MemoryHelper

// Low-level pointers and numeric conversion
fileprivate enum MemoryHelper {}
extension MemoryHelper {
    /// Returns the overall data size that should be allocated for this storageSpec
    static func dataSize(storageSpec: Overlay.HioImageWrapper.StorageSpec) -> Int {
        pxr.HioGetDataSize(storageSpec.format, pxr.GfVec3i(storageSpec.width, storageSpec.height, storageSpec.depth))
    }
    
    /// Offsets `p` using the pixel coordinates, component, and image properties
    static func offset(p: UnsafeMutableRawBufferPointer, x: Int32, y: Int32, component: Int32, storageSpec: Overlay.HioImageWrapper.StorageSpec) -> UnsafeMutableRawPointer {
        var offset = Int(y)
        offset = (offset * Int(storageSpec.width)) + Int(x)
        offset = (offset * Int(pxr.HioGetComponentCount(storageSpec.format))) + Int(component)
        offset = offset * pxr.HioGetDataSizeOfType(storageSpec.format)
        
        return p.baseAddress!.advanced(by: offset)
    }
    
    /// Reads the value at `p`, converting from the original numeric type to Double
    static func readPtr(p: UnsafeMutableRawPointer, format: pxr.HioFormat) -> Double {
        switch pxr.HioGetHioType(format) {
        case .HioTypeUnsignedByte:
            let x = p.load(as: UInt8.self)
            return Double(x) / Double(UInt8.max)
            
        case .HioTypeUnsignedByteSRGB:
            let x = p.load(as: UInt8.self)
            return Double(x) / Double(UInt8.max)

        case .HioTypeSignedByte:
            let x = p.load(as: Int8.self)
            return Double(x) / Swift.abs(Double(Int8.min))
            
        case .HioTypeUnsignedShort:
            let x = p.load(as: UInt16.self)
            return Double(x) / Double(UInt16.max)
            
        case .HioTypeSignedShort:
            let x = p.load(as: Int16.self)
            return Double(x) / Swift.abs(Double(Int16.min))
            
        case .HioTypeUnsignedInt:
            let x = p.load(as: UInt32.self)
            return Double(x) / Double(UInt32.max)
            
        case .HioTypeInt:
            let x = p.load(as: Int32.self)
            return Double(x) / Swift.abs(Double(Int32.min))
            
        case .HioTypeHalfFloat:
            let x = p.load(as: pxr.GfHalf.self)
            return Double(Float(x))
            
        case .HioTypeFloat:
            let x = p.load(as: Float.self)
            return Double(x)
            
        case .HioTypeDouble:
            let x = p.load(as: Double.self)
            return x
            
        default:
            fatalError("Unknown component type")
        }
    }
       
    /// Writes a value at `p`, converting from Double to the original numeric type
    static func writePtr(p: UnsafeMutableRawPointer, format: pxr.HioFormat, value: Double) {
        switch pxr.HioGetHioType(format) {
        case .HioTypeUnsignedByte:
            let scaled = value * Double(UInt8.max)
            let clamped = scaled.clamped(to: Double(UInt8.min)...Double(UInt8.max))
            let converted = UInt8(clamped)
            p.storeBytes(of: converted, as: UInt8.self)
            
        case .HioTypeUnsignedByteSRGB:
            let scaled = value * Double(UInt8.max)
            let clamped = scaled.clamped(to: Double(UInt8.min)...Double(UInt8.max))
            let converted = UInt8(clamped)
            p.storeBytes(of: converted, as: UInt8.self)
            
        case .HioTypeSignedByte:
            let scaled = value * Swift.abs(Double(Int8.min))
            let clamped = scaled.clamped(to: Double(Int8.min)...Double(Int8.max))
            let converted = Int8(clamped)
            p.storeBytes(of: converted, as: Int8.self)
            
        case .HioTypeUnsignedShort:
            let scaled = value * Double(UInt16.max)
            let clamped = scaled.clamped(to: Double(UInt16.min)...Double(UInt16.max))
            let converted = UInt16(clamped)
            p.storeBytes(of: converted, as: UInt16.self)
            
        case .HioTypeSignedShort:
            let scaled = value * Swift.abs(Double(Int16.min))
            let clamped = scaled.clamped(to: Double(Int16.min)...Double(Int16.max))
            let converted = Int16(clamped)
            p.storeBytes(of: converted, as: Int16.self)
            
        case .HioTypeUnsignedInt:
            let scaled = value * Double(UInt32.max)
            let clamped = scaled.clamped(to: Double(UInt32.min)...Double(UInt32.max))
            let converted = UInt32(clamped)
            p.storeBytes(of: converted, as: UInt32.self)
            
        case .HioTypeInt:
            let scaled = value * Swift.abs(Double(Int32.min))
            let clamped = scaled.clamped(to: Double(Int32.min)...Double(Int32.max))
            let converted = Int32(clamped)
            p.storeBytes(of: converted, as: Int32.self)
            
        case .HioTypeHalfFloat:
            let converted = pxr.GfHalf(Float(value))
            p.storeBytes(of: converted, as: pxr.GfHalf.self)
            
        case .HioTypeFloat:
            let converted = Float(value)
            p.storeBytes(of: converted, as: Float.self)
            
        case .HioTypeDouble:
            let converted = value
            p.storeBytes(of: converted, as: Double.self)
            
        default:
            fatalError("Unknown component type")

        }
    }
}

// MARK: ImageHelper

/// Convenient interface over HioImage
internal final class ImageHelper {
    private var shouldWriteInDeinit: Bool
    private var hioImage: Overlay.HioImageWrapper
    private var storageSpec: Overlay.HioImageWrapper.StorageSpec
    private var bytes: UnsafeMutableRawBufferPointer? {
        willSet {
            bytes?.deallocate()
        }
    }
    
    deinit {
        if shouldWriteInDeinit {
            hioImage.Write(storageSpec, .init())
        }
        bytes = nil
    }
    
    func writeToDisk() {
        guard shouldWriteInDeinit else {
            fatalError("Internal error! ImageHelper was written twice, or was opened for reading and then attempted to be written")
        }
        hioImage.Write(storageSpec, .init())
        shouldWriteInDeinit = false
        bytes = nil
    }
    
    static private func makeStorageSpecAndBytes(width: Int32, height: Int32, format: pxr.HioFormat) -> (storageSpec: Overlay.HioImageWrapper.StorageSpec, bytes: UnsafeMutableRawBufferPointer) {
        var storageSpec = Overlay.HioImageWrapper.StorageSpec()
        storageSpec.width = width
        storageSpec.height = height
        storageSpec.depth = 1
        storageSpec.format = format
        storageSpec.flipped = false
        
        let dataSize = MemoryHelper.dataSize(storageSpec: storageSpec)
        let bytes = UnsafeMutableRawBufferPointer.allocate(byteCount: dataSize, alignment: 8)
        storageSpec.data = bytes.baseAddress!
        
        return (storageSpec, bytes)
    }

    init?(reading: URL) {
        shouldWriteInDeinit = false
        hioImage = Overlay.HioImageWrapper.OpenForReading(std.string(reading.path(percentEncoded: false)))
        guard Bool(hioImage) else { return nil }
        guard hioImage.GetNumMipLevels() == 1 else { return nil }
        
        (storageSpec, bytes) = Self.makeStorageSpecAndBytes(width: hioImage.GetWidth(), height: hioImage.GetHeight(), format: hioImage.GetFormat())
        
        hioImage.Read(storageSpec)
    }
    
    init?(writing: URL, width: Int32, height: Int32, format: pxr.HioFormat) {
        shouldWriteInDeinit = true
        hioImage = Overlay.HioImageWrapper.OpenForWriting(std.string(writing.path(percentEncoded: false)))
        guard Bool(hioImage) else { return nil }
        
        (storageSpec, bytes) = Self.makeStorageSpecAndBytes(width: width, height: height, format: format)
    }
    
    convenience init?(writing: URL, format: ImageHelper) {
        self.init(writing: writing, width: format.width, height: format.height, format: format.storageSpec.format)
    }
    
    var width: Int32 { storageSpec.width }
    var height: Int32 { storageSpec.height }
    var depth: Int32 { storageSpec.depth }
    var numberOfComponents: Int32 { pxr.HioGetComponentCount(storageSpec.format) }
    
    func value(x: Int32, y: Int32, component: Int32) -> Double {
        let p = MemoryHelper.offset(p: bytes!, x: x, y: y, component: component, storageSpec: storageSpec)
        return MemoryHelper.readPtr(p: p, format: storageSpec.format)
    }
    
    func setValue(x: Int32, y: Int32, component: Int32, value: Double) {
        let p = MemoryHelper.offset(p: bytes!, x: x, y: y, component: component, storageSpec: storageSpec)
        MemoryHelper.writePtr(p: p, format: storageSpec.format, value: value)
    }
}

