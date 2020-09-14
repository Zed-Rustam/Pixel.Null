//
//  UIGif.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 13.09.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import MobileCoreServices
import UIKit

class UIGif {
    private var frames: [UIImage] = []
    private var delays: [Int] = []
    
    var framesCount: Int {
        get {
            return frames.count
        }
    }
    
    subscript(index: Int) -> (image: UIImage, delay: Int) {
        get {
            return (frames[index], delays[index])
        }
    }

    init(gif: Data) {
        let source = CGImageSourceCreateWithData(gif as CFData, nil)!
        
        for i in 0..<CGImageSourceGetCount(source) {
            frames.append(UIImage(cgImage: CGImageSourceCreateImageAtIndex(source, i, nil)!))
            delays.append(Int(UIImage.delayForImageAtIndex(i, source: source) * 1000))
        }
    }
    
    init(frames: [UIImage], delays: [Int]) {
        self.frames = frames
        self.delays = delays
    }
    
    func saveGif(to: URL) {
        let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]  as CFDictionary
        let resData : CFMutableData = CFDataCreateMutable(nil, .zero)

        if let destination = CGImageDestinationCreateWithURL(to as CFURL, kUTTypeGIF, frames.count, nil) {
            CGImageDestinationSetProperties(destination, fileProperties)
            for image in 0..<frames.count {
                let frameImg = frames[image]
                
                let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFDelayTime as String): CGFloat(delays[image]) / 1000.0, kCGImagePropertyHasAlpha : true, kCGImagePropertyGIFImageColorMap : false]] as CFDictionary
            
                CGImageDestinationAddImage(destination, frameImg.cgImage!, frameProperties)
            }
            
            if !CGImageDestinationFinalize(destination) {
               print("Failed to finalize the image destination")
            }
        }
        
        CGImageSourceCreateWithData(resData, nil)
    }
}
