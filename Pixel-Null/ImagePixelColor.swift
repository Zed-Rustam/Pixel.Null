//
//  ImagePixelColor.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 01.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

extension UIImage {

    var pixelWidth: Int {
        return cgImage?.width ?? 0
    }

    var pixelHeight: Int {
        return cgImage?.height ?? 0
    }

    func pixelColor(x: Int, y: Int) -> UIColor {
        assert(
            0..<pixelWidth ~= x && 0..<pixelHeight ~= y,
            "Pixel coordinates are out of bounds")

        guard
            let cgImage = cgImage,
            let data = cgImage.dataProvider?.data,
            let dataPtr = CFDataGetBytePtr(data),
            let colorSpaceModel = cgImage.colorSpace?.model,
            let componentLayout = cgImage.bitmapInfo.componentLayout
        else {
            assertionFailure("Could not get the color of a pixel in an image")
            return .clear
        }

        assert(
            colorSpaceModel == .rgb,
            "The only supported color space model is RGB")
        assert(
            cgImage.bitsPerPixel == 32 || cgImage.bitsPerPixel == 24,
            "A pixel is expected to be either 4 or 3 bytes in size")

        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel/8
        let pixelOffset = y*bytesPerRow + x*bytesPerPixel

        if componentLayout.count == 4 {
            let components = (
                dataPtr[pixelOffset + 0],
                dataPtr[pixelOffset + 1],
                dataPtr[pixelOffset + 2],
                dataPtr[pixelOffset + 3]
            )

            var alpha: UInt8 = 0
            var red: UInt8 = 0
            var green: UInt8 = 0
            var blue: UInt8 = 0

            switch componentLayout {
            case .bgra:
                alpha = components.3
                red = components.2
                green = components.1
                blue = components.0
            case .abgr:
                alpha = components.0
                red = components.3
                green = components.2
                blue = components.1
            case .argb:
                alpha = components.0
                red = components.1
                green = components.2
                blue = components.3
            case .rgba:
                alpha = components.3
                red = components.0
                green = components.1
                blue = components.2
            default:
                return .clear
            }

            // If chroma components are premultiplied by alpha and the alpha is `0`,
            // keep the chroma components to their current values.
            if cgImage.bitmapInfo.chromaIsPremultipliedByAlpha && alpha != 0 {
                let invUnitAlpha = 255/CGFloat(alpha)
                red = UInt8((CGFloat(red)*invUnitAlpha).rounded())
                green = UInt8((CGFloat(green)*invUnitAlpha).rounded())
                blue = UInt8((CGFloat(blue)*invUnitAlpha).rounded())
            }

            return .init(red: red, green: green, blue: blue, alpha: alpha)

        } else if componentLayout.count == 3 {
            let components = (
                dataPtr[pixelOffset + 0],
                dataPtr[pixelOffset + 1],
                dataPtr[pixelOffset + 2]
            )

            var red: UInt8 = 0
            var green: UInt8 = 0
            var blue: UInt8 = 0

            switch componentLayout {
            case .bgr:
                red = components.2
                green = components.1
                blue = components.0
            case .rgb:
                red = components.0
                green = components.1
                blue = components.2
            default:
                return .clear
            }

            return .init(red: red, green: green, blue: blue, alpha: UInt8(255))

        } else {
            assertionFailure("Unsupported number of pixel components")
            return .clear
        }
    }
    
    func getPixelsArray() -> [pixelData] {
        let data = cgImage!.dataProvider?.data,
        
        dataPtr = CFDataGetBytePtr(data)!
        let componentLayout = cgImage!.bitmapInfo.componentLayout!
        print("components : \(componentLayout)")
        var array : [pixelData] = []
        
        let bytesPerRow = cgImage!.bytesPerRow
        let bytesPerPixel = cgImage!.bitsPerPixel/8
        
        for y in 0..<Int(size.height) {
            for x in 0..<Int(size.width){
                
                let pixelOffset = y*bytesPerRow + x*bytesPerPixel

                var pix = pixelData(a: 0, r: 0, g: 0, b: 0)
                
                if componentLayout.count == 4 {
                    let components = (
                        dataPtr[pixelOffset + 0],
                        dataPtr[pixelOffset + 1],
                        dataPtr[pixelOffset + 2],
                        dataPtr[pixelOffset + 3]
                    )

                    switch componentLayout {
                    case .bgra:
                        pix.a = components.3
                        pix.r = components.2
                        pix.g = components.1
                        pix.b = components.0
                    case .abgr:
                        pix.a = components.0
                        pix.r = components.3
                        pix.g = components.2
                        pix.b = components.1
                    case .argb:
                        pix.a = components.0
                        pix.r = components.1
                        pix.g = components.2
                        pix.b = components.3
                    case .rgba:
                        pix.a = components.3
                        pix.r = components.0
                        pix.g = components.1
                        pix.b = components.2
                    default:
                        break
                    }

                    // If chroma components are premultiplied by alpha and the alpha is `0`,
                    // keep the chroma components to their current values.
                    if cgImage!.bitmapInfo.chromaIsPremultipliedByAlpha && pix.a != 0 {
                        let invUnitAlpha = 255/CGFloat(pix.a)
                        pix.r = UInt8((CGFloat(pix.r)*invUnitAlpha).rounded())
                        pix.g = UInt8((CGFloat(pix.g)*invUnitAlpha).rounded())
                        pix.b = UInt8((CGFloat(pix.b)*invUnitAlpha).rounded())
                    }
                } else if componentLayout.count == 3 {
                    pix.a = 255
                    
                    let components = (
                        dataPtr[pixelOffset + 0],
                        dataPtr[pixelOffset + 1],
                        dataPtr[pixelOffset + 2]
                    )

                    switch componentLayout {
                    case .bgr:
                        pix.r = components.2
                        pix.g = components.1
                        pix.b = components.0
                    case .rgb:
                        pix.r = components.0
                        pix.g = components.1
                        pix.b = components.2
                    default:
                        break
                    }
                }
                array.append(pix)
            }
        }
        
        return array
    }
}

public extension UIColor {

    convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(
            red: CGFloat(red)/255,
            green: CGFloat(green)/255,
            blue: CGFloat(blue)/255,
            alpha: CGFloat(alpha)/255)
    }
}

public extension CGBitmapInfo {

    enum ComponentLayout {

        case bgra
        case abgr
        case argb
        case rgba
        case bgr
        case rgb

        var count: Int {
            switch self {
            case .bgr, .rgb: return 3
            default: return 4
            }
        }

    }

    var componentLayout: ComponentLayout? {
        guard let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue) else { return nil }
        let isLittleEndian = contains(.byteOrder32Little)

        if alphaInfo == .none {
            return isLittleEndian ? .bgr : .rgb
        }
        let alphaIsFirst = alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst

        if isLittleEndian {
            return alphaIsFirst ? .bgra : .abgr
        } else {
            return alphaIsFirst ? .argb : .rgba
        }
    }

    var chromaIsPremultipliedByAlpha: Bool {
        let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue)
        return alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast
    }
}
