//
//  ColorStyle.swift
//  new Testing
//
//  Created by Рустам Хахук on 05.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

func getAppColor(color : Theme) -> UIColor{
        return UIColor(named: color.rawValue)!
}

enum Theme : String {
    case background = "backgroundColor"
    case enable = "enableColor"
    case disable = "disableColor"
    case shadow = "shadowColor"
    case select = "selectColor"
    case red = "redColor"
}

extension UIImage {
    
    convenience init?(size : CGSize){
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
   static func miniature(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
      let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
      let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
    
      let maxDimentionInPixels = max(pointSize.width, pointSize.height) * scale
    
      let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
    kCGImageSourceShouldCacheImmediately: true,
    kCGImageSourceCreateThumbnailWithTransform: true,
    kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels] as CFDictionary
     let downsampledImage =     CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)!
    
      return UIImage(cgImage: downsampledImage)
   }
    
    func withAlpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    static func merge(images : [UIImage]) -> UIImage? {
        if images.count == 0 {return nil}
        
        UIGraphicsBeginImageContext(images[0].size)
        
        for i in 0..<images.count{
            images[i].draw(in: CGRect(origin: .zero, size: images[i].size))
        }
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func getColorsArray() -> [pixelData] {
        var array : [pixelData] = []
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(self.cgImage!.dataProvider!.data)
        
        for i in 0..<Int(self.size.width * self.size.height) {
            array.append(pixelData(a: data[i * 4 + 3],
                                   r: data[i * 4 + 2],
                                   g: data[i * 4 + 1],
                                   b: data[i * 4]))
        }
        
        return array
    }
    
    func getImageFromRect(rect : CGRect) -> UIImage {
        UIGraphicsBeginImageContext(rect.size)
        
        self.draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        
        let resImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resImage
    }
    
    static func animatedGif(from images: [UIImage]) {
        let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]  as CFDictionary
        let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFDelayTime as String): 0.1]] as CFDictionary
        
        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL: URL? = documentsDirectoryURL?.appendingPathComponent("animated.gif")
        
        if let url = fileURL as CFURL? {
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) {
                CGImageDestinationSetProperties(destination, fileProperties)
                for image in images {
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destination, cgImage, frameProperties)
                    }
                }
                if !CGImageDestinationFinalize(destination) {
                    print("Failed to finalize the image destination")
                }
                print("Url = \(fileURL!)")
            }
        }
    }
    
    func cutImage(img : UIImage) -> UIImage {
        let innerRect = img.getContextRect()
        UIGraphicsBeginImageContext(innerRect.size)
        
        self.draw(at: CGPoint(x: -innerRect.origin.x, y: -innerRect.origin.y))
        img.draw(at: CGPoint(x: -innerRect.origin.x, y: -innerRect.origin.y), blendMode: .destinationIn, alpha: 1)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    func getContextRect() -> CGRect {
        var startx : Int = 0
        var starty : Int = 0
        var endx : Int = 0
        var endy : Int = 0
        
        let data = getColorsArray()
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        group.enter()
        group.enter()

        DispatchQueue.global(qos: .userInteractive).async {
            outFor : for y in 0..<Int(self.size.height) {
                for x in 0..<Int(self.size.width) {
                    if data[Int(self.size.width) * y + x].a > 0 {
                        starty = y
                        break outFor
                    }
                }
            }
            group.leave()
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            outFor : for y in (0..<Int(self.size.height)).reversed() {
                for x in 0..<Int(self.size.width) {
                    if data[Int(self.size.width) * y + x].a > 0 {
                        endy = y
                        break outFor
                    }
                }
            }
            group.leave()
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            outFor : for x in 0..<Int(self.size.width) {
                for y in 0..<Int(self.size.height) {
                    if data[Int(self.size.width) * y + x].a > 0 {
                        startx = x
                        break outFor
                    }
                }
            }
            group.leave()
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            outFor : for x in (0..<Int(self.size.width)).reversed() {
                for y in 0..<Int(self.size.height) {
                    if data[Int(self.size.width) * y + x].a > 0 {
                        endx = x
                        break outFor
                    }
                }
            }
            group.leave()
        }
        
        group.wait()
        
        return CGRect(x: startx, y: starty, width: endx - startx + 1, height: endy - starty + 1)
    }
}

func getTintImage(image : UIImage, color : UIColor) -> UIImage {
    UIGraphicsBeginImageContext(image.size)
    
    UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
    
    UIGraphicsGetCurrentContext()!.addRect(CGRect(origin: .zero, size: image.size))
    UIGraphicsGetCurrentContext()!.fillPath()
    
    image.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
    
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return result
}

import UIKit
import ImageIO

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.01
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.01 {
            delay = 0.01
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
    
    func cut(image : UIImage?) -> UIImage {
        if image != nil {
        UIGraphicsBeginImageContextWithOptions(image!.size, false, 1)            
            self.draw(at: .zero)
            image!.draw(at: .zero, blendMode: .destinationOut, alpha: 1)
        let moveImg = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return moveImg!
        } else {
            return UIImage(size: self.size)!
        }
    }
    
    func inner(image : UIImage?) -> UIImage {
        if image != nil {
        UIGraphicsBeginImageContextWithOptions(image!.size, false, 1)
            self.draw(at: .zero)
            image!.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        let moveImg = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return moveImg!
        } else {
            return self
        }
    }
    
    func flip(xFlip : Bool, yFlip : Bool) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: self.size.width / 2.0, y: self.size.height / 2.0)
        context.scaleBy(x: xFlip ? -1 : 1, y: yFlip ? -1 : 1)
        context.translateBy(x: -self.size.width / 2.0, y: -self.size.height / 2.0)

        self.draw(at: .zero)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
}
