//
//  Tool.swift
//  new Testing
//
//  Created by Рустам Хахук on 02.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

struct pixelData : Equatable {
    var a : UInt8
    var r : UInt8
    var g : UInt8
    var b : UInt8
}

class Tool {
    
}

class Selection : Tool {
    
    enum SelectionType : Int {
        case draw = 0
        case rectangle = 1
        case ellipse = 2
        case magicTool = 3
    }
    
    enum selectMode {
        case add
        case delete
    }
    
    var type : SelectionType = .rectangle
    var mode : selectMode = .add
        
    var points : [CGPoint] = []

    
    var colorForChange : UIColor = .clear
    
    private var imageData : [pixelData] = []
    private var resultData : [pixelData] = []

    func getPixelData(imgSize : CGSize, point : CGPoint) -> pixelData? {
        if point.x < 0 || point.x >= imgSize.width || point.y < 0 || point.y >= imgSize.height {return nil}
        return imageData[Int(imgSize.width * point.y + point.x)]
    }
    
    func setPixelData(imgSize : CGSize, point : CGPoint, color : pixelData) {
        imageData[Int(imgSize.width * point.y + point.x)] = color
        resultData[Int(imgSize.width * point.y + point.x)] = pixelData(a: 255, r: 0, g: 0, b: 0)
    }
    
    private func fillH(from : CGPoint, imageSize : CGSize){
        var pos = from

        var wasAddUp = false
        var wasAddDown = false
        
        if getPixelData(imgSize: imageSize, point: from) != colorForChange.getPixelData() {
            return
        }
        
        setPixelData(imgSize: imageSize, point: pos, color: getAppColor(color: .select).getPixelData())

        if getPixelData(imgSize: imageSize, point: pos.offset(x: 0, y: -1)) == colorForChange.getPixelData() {
            points.append(pos.offset(x: 0, y: -1))
            wasAddUp = true
        }
        if getPixelData(imgSize: imageSize, point: pos.offset(x: 0, y: 1)) == colorForChange.getPixelData() {
            points.append(pos.offset(x: 0, y: 1))
            wasAddDown = true
        }
        
        while getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: 0)) == colorForChange.getPixelData() {
            
            if !wasAddUp && getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: -1)) == colorForChange.getPixelData() {
                points.append(pos.offset(x: -1, y: -1))
                wasAddUp = true
            } else if getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: -1)) != colorForChange.getPixelData() {
                wasAddUp = false
            }
            if !wasAddDown && getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: 1)) == colorForChange.getPixelData() {
                points.append(pos.offset(x: -1, y: 1))
                wasAddDown = true
            } else if getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: 1)) != colorForChange.getPixelData() {
                wasAddDown = false
            }
            
            pos = pos.offset(x: -1, y: 0)
            setPixelData(imgSize: imageSize, point: pos, color: getAppColor(color: .select).getPixelData())
            
        }
        
        pos = from
        wasAddUp = false
        wasAddDown = false

        while getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: 0)) == colorForChange.getPixelData() {
            if !wasAddUp && getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: -1)) == colorForChange.getPixelData() {
                points.append(pos.offset(x: 1, y: -1))
                wasAddUp = true
            } else if getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: -1)) != colorForChange.getPixelData() {
                wasAddUp = false
            }
            
            if !wasAddDown && getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: 1)) == colorForChange.getPixelData() {
                points.append(pos.offset(x: 1, y: 1))
                wasAddDown = true
            } else if getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: 1)) != colorForChange.getPixelData() {
                wasAddDown = false
            }
            
            pos = pos.offset(x: 1, y: 0)
            setPixelData(imgSize: imageSize, point: pos, color: getAppColor(color: .select).getPixelData())
            
        }
    }

    
    func magicSelection(image : UIImage,point : CGPoint) {
        points.removeAll()
        points.append(point)
        colorForChange = image.pixelColor(x: Int(point.x), y: Int(point.y))

        imageData = image.getPixelsArray()
        resultData = .init(repeating: pixelData(a: 0, r: 0, g: 0, b: 0), count: imageData.count)
        
        
        while points.count > 0 {
            fillH(from: points.remove(at: 0), imageSize: image.size)
        }
        
        nowSelection = imageFromARGB32Bitmap(pixels: resultData, width: UInt(image.size.width), height: UInt(image.size.height)).withTintColor(getAppColor(color: .select))
    }
    
    func reverse(select : UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(select.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(getAppColor(color: .select).cgColor)
        context.fill(CGRect(origin: .zero, size: select.size))
        
        select.draw(at: .zero, blendMode: .destinationOut, alpha: 1)
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return myImage
    }
    
    func isSelectEmpty(select : UIImage) -> Bool {
        let info = select.getPixelsArray()
        let group = DispatchGroup()
        var finalResult = true
        let partCount = 8
        
        for i in 0..<partCount {
            group.enter()

            DispatchQueue.global(qos: .userInteractive).async {
                
                for p in Int(CGFloat(i) * (CGFloat(info.count) / CGFloat(partCount)))..<Int(CGFloat(i + 1) * (CGFloat(info.count) / CGFloat(partCount)))  {
                    if info[p].a > 0 || finalResult == false {
                        finalResult = false
                        break
                    }
                }
                
                group.leave()
            }
        }
        
        group.wait()
        
        return finalResult
    }
    
    func finishSelection() -> UIImage {
        switch mode {
        case .add:
            return UIImage.merge(images: [lastSelection!,nowSelection])!
        case .delete:
            return lastSelection!.cut(image: nowSelection)
        }
    }
    
    var lastSelection : UIImage? = nil
    var nowSelection : UIImage!
        
    func restart(img : UIImage, startPoint : CGPoint){
        lastSelection = img
        points.removeAll()
        points.append(startPoint)
    }
    
    func drawOn(image : UIImage,point : CGPoint, symmetry : CGPoint) -> UIImage{
        points.append(CGPoint(x: CGFloat(Double(Int(point.x)) + 0.5), y: CGFloat(Int(point.y)) + 0.5))
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        
        switch mode {
        case .add:
            context.setFillColor(getAppColor(color: .select).cgColor)
        case .delete:
            context.setFillColor(getAppColor(color: .red).cgColor)
        }
        
        context.setShouldAntialias(false)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.clear(CGRect(origin: .zero ,size: image.size))
        context.setLineWidth(1)
        context.move(to: points[0])

        
        switch type {
        case .draw:
            for i in points {
                context.addLine(to: i)
            }
        case .rectangle:
            context.addRect(CGRect(x: min(points[0].x,points[points.count - 1].x), y: min(points[0].y,points[points.count - 1].y), width: abs(points[points.count - 1].x - points[0].x), height: abs(points[points.count - 1].y - points[0].y)))
          
        case .ellipse:
            context.addEllipse(in: CGRect(x: min(points[0].x,points[points.count - 1].x), y: min(points[0].y,points[points.count - 1].y), width: abs(points[points.count - 1].x - points[0].x), height: abs(points[points.count - 1].y - points[0].y)))

        default:
            break
        }
        
        context.fillPath()
        
        nowSelection = UIGraphicsGetImageFromCurrentImageContext()!
        
        if symmetry.x != 0 {
            context.clear(CGRect(origin: .zero ,size: image.size))
            context.translateBy(x: image.size.width, y: 0)
            context.scaleBy(x: -1, y: 1)
            nowSelection!.draw(in: CGRect(x: (image.size.width / 2.0 - symmetry.x) * 2, y: 0, width: nowSelection!.size.width, height: nowSelection!.size.height))


            nowSelection = UIImage.merge(images: [nowSelection!,UIImage(cgImage : context.makeImage()!)])!
            context.scaleBy(x: -1, y: 1)
            context.translateBy(x:  -image.size.width, y: 0)
        }
        
        if symmetry.y != 0 {
            context.clear(CGRect(origin: .zero ,size: image.size))
            context.translateBy(x: 0, y: image.size.height)
            context.scaleBy(x: 1, y: -1)
            
            nowSelection!.draw(in: CGRect(x: 0, y: (image.size.height / 2.0 - symmetry.y) * 2, width: nowSelection!.size.width, height: nowSelection!.size.height))
            
            nowSelection = UIImage.merge(images: [nowSelection!,UIImage(cgImage : context.makeImage()!)])!
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -image.size.height)
        }
        
        context.clear(CGRect(origin: .zero, size: image.size))
        lastSelection?.draw(at: .zero)
        nowSelection!.draw(at: .zero,blendMode: .exclusion,alpha: 1)
        nowSelection!.draw(at: .zero,blendMode: .normal,alpha: 1)

        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
                
        return myImage
    }
}

extension CGPoint {
    func offset(x : CGFloat, y : CGFloat) -> CGPoint{
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}

class Fill : Tool {
    
    enum FillStyle : Int {
        case layer
        case frame
    }
    
    var style : FillStyle = .layer
    var color : UIColor = .blue
    var colorForChange : UIColor = .clear

    func setSettings(fillColor : UIColor){
        color = fillColor
    }
    
    private var points : [CGPoint] = []

    private func fillH(from : CGPoint, imageSize : CGSize){
        var pos = from

        var wasAddUp = false
        var wasAddDown = false
        
        if getPixelData(imgSize: imageSize, point: from) != colorForChange.getPixelData() {
            return
        }
        
        setPixelData(imgSize: imageSize, point: pos, color: color.getPixelData())

        if getPixelData(imgSize: imageSize, point: pos.offset(x: 0, y: -1)) == colorForChange.getPixelData() {
            points.append(pos.offset(x: 0, y: -1))
            wasAddUp = true
        }
        if getPixelData(imgSize: imageSize, point: pos.offset(x: 0, y: 1)) == colorForChange.getPixelData() {
            points.append(pos.offset(x: 0, y: 1))
            wasAddDown = true
        }
        
        while getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: 0)) == colorForChange.getPixelData() {
            
            if !wasAddUp && getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: -1)) == colorForChange.getPixelData() {
                points.append(pos.offset(x: -1, y: -1))
                wasAddUp = true
            } else if getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: -1)) != colorForChange.getPixelData() {
                wasAddUp = false
            }
            if !wasAddDown && getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: 1)) == colorForChange.getPixelData() {
                points.append(pos.offset(x: -1, y: 1))
                wasAddDown = true
            } else if getPixelData(imgSize: imageSize, point: pos.offset(x: -1, y: 1)) != colorForChange.getPixelData() {
                wasAddDown = false
            }
            
            pos = pos.offset(x: -1, y: 0)
            setPixelData(imgSize: imageSize, point: pos, color: color.getPixelData())
            
        }
        
        pos = from
        wasAddUp = false
        wasAddDown = false

        while getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: 0)) == colorForChange.getPixelData() {
            if !wasAddUp && getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: -1)) == colorForChange.getPixelData() {
                points.append(pos.offset(x: 1, y: -1))
                wasAddUp = true
            } else if getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: -1)) != colorForChange.getPixelData() {
                wasAddUp = false
            }
            
            if !wasAddDown && getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: 1)) == colorForChange.getPixelData() {
                points.append(pos.offset(x: 1, y: 1))
                wasAddDown = true
            } else if getPixelData(imgSize: imageSize, point: pos.offset(x: 1, y: 1)) != colorForChange.getPixelData() {
                wasAddDown = false
            }
            
            pos = pos.offset(x: 1, y: 0)
            setPixelData(imgSize: imageSize, point: pos, color: color.getPixelData())
        }
    }
    
    private var imageData : [pixelData] = []
    private var resultData : [pixelData] = []

    func getPixelData(imgSize : CGSize, point : CGPoint) -> pixelData? {
        if point.x < 0 || point.x >= imgSize.width || point.y < 0 || point.y >= imgSize.height {return nil}
        return imageData[Int(imgSize.width * point.y + point.x)]
    }
    
    func setPixelData(imgSize : CGSize, point : CGPoint, color : pixelData) {
        imageData[Int(imgSize.width * point.y + point.x)] = color
        resultData[Int(imgSize.width * point.y + point.x)] = pixelData(a: 255, r: 0, g: 0, b: 0)
    }
    
    func drawOn(image : UIImage,point : CGPoint, selection : UIImage?, fillColor : UIColor) -> UIImage{
        colorForChange = image.pixelColor(x: Int(point.x), y: Int(point.y))
        color = fillColor
        
        imageData = image.getPixelsArray()
        resultData = .init(repeating: pixelData(a: 0, r: 0, g: 0, b: 0), count: imageData.count)
        
        points.removeAll()
        
        if getPixelData(imgSize: image.size, point: point) != color.getPixelData() {
            points.append(point)
            
            while points.count > 0 {
                fillH(from: points.remove(at: 0), imageSize: image.size)
            }
            let resImg = imageFromARGB32Bitmap(pixels: resultData, width: UInt(image.size.width), height: UInt(image.size.height)).withTintColor(color)
            
            UIGraphicsBeginImageContext(image.size)
            
            resImg.draw(at: .zero)
            selection?.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
            
            var returnImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsGetCurrentContext()!.clear(CGRect(origin: .zero, size: image.size))
            
            image.draw(at: .zero)
            returnImage.draw(at: .zero)
            returnImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            return returnImage
        } else {
            print("dont")
            return image
        }
    }
    
    func drawOnFrame(image : UIImage,point : CGPoint, selection : UIImage?, fillColor : UIColor) -> UIImage {
        colorForChange = image.pixelColor(x: Int(point.x), y: Int(point.y))
        color = fillColor
        
        imageData = image.getPixelsArray()
        resultData = .init(repeating: pixelData(a: 0, r: 0, g: 0, b: 0), count: imageData.count)
        
        points.removeAll()
        
        if getPixelData(imgSize: image.size, point: point) != color.getPixelData() {
            points.append(point)
            
            while points.count > 0 {
                fillH(from: points.remove(at: 0), imageSize: image.size)
            }
            let resImg = imageFromARGB32Bitmap(pixels: resultData, width: UInt(image.size.width), height: UInt(image.size.height)).withTintColor(color)
            
            UIGraphicsBeginImageContext(image.size)
            
            resImg.draw(at: .zero)
            selection?.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
            
            var returnImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            //UIGraphicsGetCurrentContext()!.clear(CGRect(origin: .zero, size: image.size))
            
            //image.draw(at: .zero)
            //returnImage.draw(at: .zero)
            //returnImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            return returnImage
        } else {
            print("dont")
            return UIImage(size: image.size)!
        }
    }
}

class Move : Tool {
    private var moveImage : UIImage!
    private var startImage : UIImage!
    
    var selectionImage : UIImage!
    private var offset : CGPoint = .zero
    var wasStart : Bool = false
    var realSize : CGSize = .zero
    
    func setImage(image : UIImage, startpos : CGPoint,selection : UIImage?,size : CGSize,startImg : UIImage) {

        realSize = size
        moveImage = image
        selectionImage = selection ?? UIImage(size: moveImage.size)
        wasStart = true
        offset = startpos
        
        startImage = startImg
    }
    
    func flipImage(flipX : Bool, flipY : Bool) {
        moveImage = moveImage.flip(xFlip: flipX, yFlip: flipY)
        selectionImage = selectionImage.flip(xFlip: flipX, yFlip: flipY)
    }
    
    func getPixelData(data : [pixelData],x : Int, y : Int) -> pixelData? {
        if x < 0 || x >= Int(moveImage.size.width) || y < 0 || y >= Int(moveImage.size.height) {
            return nil
        }

        return data[Int(moveImage.size.width) * y + x]
    }
    func setPixelData( data : inout [pixelData],x : Int, y : Int,pixel : pixelData?) {
        if x < 0 || x >= Int(moveImage.size.width) || y < 0 || y >= Int(moveImage.size.height) || pixel == nil {
            return
        }
        data[Int(moveImage.size.width) * y + x] = pixel!
    }
    
    func drawOn(position : CGRect, rotation : CGFloat, rotateCenter : CGPoint) -> UIImage{
        wasStart = true
        UIGraphicsBeginImageContextWithOptions(realSize, false, 1)
        let flipX = position.size.width < 0
        let flipY = position.size.height < 0
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
        context.setAllowsAntialiasing(false)
        context.interpolationQuality = .none

        context.translateBy(x: rotateCenter.x, y: rotateCenter.y)
        context.rotate(by: rotation)
        context.translateBy(x: -rotateCenter.x, y: -rotateCenter.y)
        
        moveImage.flip(xFlip: flipX, yFlip: flipY).draw(in: CGRect(x: min(position.origin.x,position.origin.x + position.size.width), y: min(position.origin.y,position.origin.y + position.size.height), width: position.width, height: position.height))
 
        let myImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()
 
        return UIImage.merge(images: [startImage, myImage])!
    }
    
    func drawSelectionOn(position : CGRect, rotation : CGFloat, rotateCenter : CGPoint) -> UIImage{
        wasStart = true
       UIGraphicsBeginImageContextWithOptions(realSize, false, 1)
       let flipX = position.size.width < 0
       let flipY = position.size.height < 0

       let context = UIGraphicsGetCurrentContext()!
       context.setShouldAntialias(false)
       context.setAllowsAntialiasing(false)
       context.interpolationQuality = .none

       context.translateBy(x: rotateCenter.x, y: rotateCenter.y)
       context.rotate(by: rotation)
       context.translateBy(x: -rotateCenter.x, y: -rotateCenter.y)
       
       selectionImage.flip(xFlip: flipX, yFlip: flipY).draw(in: CGRect(x: min(position.origin.x,position.origin.x + position.size.width), y: min(position.origin.y,position.origin.y + position.size.height), width: position.width, height: position.height))

       let myImage = UIGraphicsGetImageFromCurrentImageContext()!

       UIGraphicsEndImageContext()

       return myImage
    }
}

func imageFromARGB32Bitmap(pixels:[pixelData], width:UInt, height:UInt)->UIImage {
    let bitsPerComponent:UInt = 8
    let bitsPerPixel:UInt = 32
    
    assert(pixels.count == Int(width * height))
    
    var data = pixels // Copy to mutable []
    let providerRef = CGDataProvider(
        data: NSData(bytes: &data, length: data.count * MemoryLayout<pixelData>.size)
        )

    let cgim = CGImage(
        width: Int(width),
        height: Int(height),
        bitsPerComponent: Int(bitsPerComponent),
        bitsPerPixel: Int(bitsPerPixel),
        bytesPerRow: Int(width * UInt(MemoryLayout<pixelData>.size)),
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
        provider: providerRef!,
        decode: nil,
        shouldInterpolate: true,
        intent: .defaultIntent
        )
    return UIImage(cgImage: cgim!)
}
