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

class Pencil : Tool {
    var size : Double = 1
    var pixPerfect : Bool = false
    var startImage : UIImage? = nil
    
    func setSettings(penSize : Int, pixelPerf : Bool){
        size = Double(penSize)
        pixPerfect = pixelPerf
    }
    
    private var points : [CGPoint] = []
    
    func setStartPoint(point : CGPoint,startimg : UIImage){
        points.removeAll()
        startImage = startimg
    }
    
    func normalise(radius : Double) -> Double {
        if radius <= 2 {
            return sqrt(radius)
        }
        
        let realRad = sqrt(2) / 2.0 * radius
        if realRad - floor(realRad) >= 0.5 {
            return sqrt(2 * pow(floor(realRad), 2))
        } else {
            return sqrt(2 * pow(floor(realRad) - 0.5, 2))
        }
    }
    
   
    func pixelPerfect(){
       main : while true {
            if points.count > 3 {
                for i in 3...points.count {
                    if abs(points[i - 3].x - points[i - 1].x) > 1 || abs(points[i - 3].y - points[i - 1].y) > 1 {
                        
                    } else {
                        points.remove(at:i - 2)
                        continue main
                    }
                }
            }
            break main
        }
    }
    
    func drawOn(image : UIImage,point : CGPoint, selection : UIImage?, symmetry : CGPoint,color : UIColor) -> UIImage{
       
        switch Int(size) % 2 {
           case 0:
            if points.count == 0 || points[points.count - 1] != CGPoint(x: CGFloat(Double(Int(point.x))), y: CGFloat(Int(point.y))) {
                points.append(CGPoint(x: CGFloat(Double(Int(point.x))), y: CGFloat(Int(point.y))))
                points.append(CGPoint(x: CGFloat(Double(Int(point.x))), y: CGFloat(Int(point.y))))
            }
           case 1:
            if points.count == 0 || points[points.count - 1] != CGPoint(x: CGFloat(Double(Int(point.x)) + 0.5), y: CGFloat(Int(point.y)) + 0.5) {
                points.append(CGPoint(x: CGFloat(Double(Int(point.x)) + 0.5), y: CGFloat(Int(point.y)) + 0.5))
                points.append(CGPoint(x: CGFloat(Double(Int(point.x)) + 0.5), y: CGFloat(Int(point.y)) + 0.5))
            }
           default:
                break
        }

        if pixPerfect {
            pixelPerfect()
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!

        context.setStrokeColor(UIColor.black.cgColor)
        context.setShouldAntialias(false)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        context.clear(CGRect(origin: .zero ,size: image.size))
        context.setLineWidth(CGFloat(normalise(radius : size)))
        context.addLines(between: points)
        context.strokePath()
        
        var myImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        if symmetry.x != 0 {
            context.clear(CGRect(origin: .zero ,size: image.size))
            context.translateBy(x: image.size.width, y: 0)
            context.scaleBy(x: -1, y: 1)
            myImage.draw(in: CGRect(x: (image.size.width / 2.0 - symmetry.x) * 2, y: 0, width: myImage.size.width, height: myImage.size.height))


            myImage = UIImage.merge(images: [myImage,UIImage(cgImage : context.makeImage()!)])!
            context.scaleBy(x: -1, y: 1)
            context.translateBy(x:  -image.size.width, y: 0)
        }
        
        if symmetry.y != 0 {
            context.clear(CGRect(origin: .zero ,size: image.size))
            context.translateBy(x: 0, y: image.size.height)
            context.scaleBy(x: 1, y: -1)
            
            myImage.draw(in: CGRect(x: 0, y: (image.size.height / 2.0 - symmetry.y) * 2, width: myImage.size.width, height: myImage.size.height))
            
            myImage = UIImage.merge(images: [myImage,UIImage(cgImage : context.makeImage()!)])!
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -image.size.height)
        }
        
        context.clear(CGRect(origin: .zero ,size: image.size))
        myImage.draw(at: .zero)
        selection?.draw(at: .zero, blendMode: .destinationIn, alpha: 1)

        myImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
                
        return UIImage.merge(images: [startImage!, myImage.withTintColor(color)])!
    }
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

class Square : Tool {
    
    enum SquareType {
        case rectangle
        case oval
        case line
    }
    
    var isFixed = false
    var startImage : UIImage? = nil
    
    func normalise(radius : Double) -> Double {
        if radius <= 2 {
            return sqrt(radius)
        }
        
        let realRad = sqrt(2) / 2.0 * radius
        if realRad - floor(realRad) >= 0.5 {
            return sqrt(2 * pow(floor(realRad), 2))
        } else {
            return sqrt(2 * pow(floor(realRad) - 0.5, 2))
        }
    }
    
    var size : Double = 1
    
    var squareType : SquareType = .rectangle
    
    private var startPoint : CGPoint = .zero
    
    func setStartPoint(point : CGPoint,startImg : UIImage){
        switch Int(size) % 2 {
           case 0:
            startPoint = point
           case 1:
            startPoint = CGPoint(x: point.x + 0.5, y: point.y + 0.5)
           default:
                break
        }
        
        startImage = startImg
    }
    
    func setSettings(penSize : Int){
        size = Double(penSize)
    }
    
    func drawOn(image : UIImage,point : CGPoint, color : UIColor,symmetry : CGPoint,selection : UIImage?) -> UIImage{
        
        var endPoint = CGPoint.zero
        
        switch Int(size) % 2 {
           case 0:
            endPoint = point
           case 1:
            endPoint = CGPoint(x: point.x + 0.5, y: point.y + 0.5)
           default:
                break
        }
        
        if isFixed {
            let width = endPoint.x - startPoint.x
            let height = endPoint.y - startPoint.y
            
            let finalSize = max(abs(width),abs(height))
            
            endPoint = CGPoint(x: startPoint.x + finalSize * (width / abs(width)), y: startPoint.y + finalSize * (height / abs(height)))
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        //context.setStrokeColor(color.cgColor)
        context.setShouldAntialias(false)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(CGFloat(normalise(radius: size)))
        
        switch squareType {
        case .rectangle:
            context.addRect(CGRect(x: min(startPoint.x,endPoint.x), y: min(startPoint.y,endPoint.y), width: abs(endPoint.x - startPoint.x), height: abs(endPoint.y - startPoint.y)))
            
        case .oval:
            context.addEllipse(in: CGRect(x: min(startPoint.x,endPoint.x), y: min(startPoint.y,endPoint.y), width: abs(endPoint.x - startPoint.x), height: abs(endPoint.y - startPoint.y)))
            
        case .line:
            context.addLines(between: [startPoint,endPoint])
        }
        context.strokePath()
        
        var myImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        if symmetry.x != 0 {
            context.clear(CGRect(origin: .zero ,size: image.size))
            context.translateBy(x: image.size.width, y: 0)
            context.scaleBy(x: -1, y: 1)
            myImage.draw(in: CGRect(x: (image.size.width / 2.0 - symmetry.x) * 2, y: 0, width: myImage.size.width, height: myImage.size.height))


            myImage = UIImage.merge(images: [myImage,UIImage(cgImage : context.makeImage()!)])!
            context.scaleBy(x: -1, y: 1)
            context.translateBy(x:  -image.size.width, y: 0)
        }
        
        if symmetry.y != 0 {
            context.clear(CGRect(origin: .zero ,size: image.size))
            context.translateBy(x: 0, y: image.size.height)
            context.scaleBy(x: 1, y: -1)
            
            myImage.draw(in: CGRect(x: 0, y: (image.size.height / 2.0 - symmetry.y) * 2, width: myImage.size.width, height: myImage.size.height))
            
            myImage = UIImage.merge(images: [myImage,UIImage(cgImage : context.makeImage()!)])!
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -image.size.height)
        }
        
        context.clear(CGRect(origin: .zero ,size: image.size))
        myImage.draw(at: .zero)
        selection?.draw(at: .zero, blendMode: .destinationIn, alpha: 1)

        myImage = UIGraphicsGetImageFromCurrentImageContext()!
        
    
        UIGraphicsEndImageContext()
                
        return UIImage.merge(images: [startImage!, myImage.withTintColor(color)])!

    }
}

class Erase : Tool {
    var size : Double = 1
    
    private var startPoint = CGPoint.zero
    
    func setSettings(penSize : Int){
        size = Double(penSize)
    }
        
    func setStartPoint(point : CGPoint){
        switch Int(size) % 2 {
        case 0:
             startPoint = CGPoint(x: CGFloat(Double(Int(point.x))), y: CGFloat(Int(point.y)))
        case 1:
             startPoint = CGPoint(x: CGFloat(Double(Int(point.x)) + 0.5), y: CGFloat(Int(point.y)) + 0.5)
        default:
            break
        }
    }
    
    func normalise(radius : Double) -> Double {
        if radius <= 2 {
            return sqrt(radius)
        }
        
        let realRad = sqrt(2) / 2.0 * radius
        if realRad - floor(realRad) >= 0.5 {
            return sqrt(2 * pow(floor(realRad), 2))
        } else {
            return sqrt(2 * pow(floor(realRad) - 0.5, 2))
        }
    }
    
    func drawOn(image : UIImage,point : CGPoint, selection : UIImage?,symmetry : CGPoint) -> UIImage{
        var lastPoint : CGPoint = .zero
        
        switch Int(size) % 2 {
           case 0:
                lastPoint = CGPoint(x: CGFloat(Double(Int(point.x))), y: CGFloat(Int(point.y)))
           case 1:
                lastPoint = CGPoint(x: CGFloat(Double(Int(point.x)) + 0.5), y: CGFloat(Int(point.y)) + 0.5)
           default:
                break
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(UIColor.black.cgColor)
        context.setShouldAntialias(false)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        context.setLineWidth(CGFloat(normalise(radius : size)))
        context.addLines(between: [startPoint, lastPoint])
        context.strokePath()
        
        
        var myImage = UIGraphicsGetImageFromCurrentImageContext()!

        if symmetry.x != 0 {
            context.clear(CGRect(origin: .zero ,size: image.size))
            context.translateBy(x: image.size.width, y: 0)
            context.scaleBy(x: -1, y: 1)
            myImage.draw(in: CGRect(x: (image.size.width / 2.0 - symmetry.x) * 2, y: 0, width: myImage.size.width, height: myImage.size.height))


            myImage = UIImage.merge(images: [myImage,UIImage(cgImage : context.makeImage()!)])!
            context.scaleBy(x: -1, y: 1)
            context.translateBy(x:  -image.size.width, y: 0)
        }
        
        if symmetry.y != 0 {
            context.clear(CGRect(origin: .zero ,size: image.size))
            context.translateBy(x: 0, y: image.size.height)
            context.scaleBy(x: 1, y: -1)
            
            myImage.draw(in: CGRect(x: 0, y: (image.size.height / 2.0 - symmetry.y) * 2, width: myImage.size.width, height: myImage.size.height))
            
            myImage = UIImage.merge(images: [myImage,UIImage(cgImage : context.makeImage()!)])!
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -image.size.height)
        }
        
        context.clear(CGRect(origin: .zero ,size: image.size))
        
        
        myImage.draw(in: CGRect(origin: .zero ,size: image.size))
        selection?.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        myImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        context.clear(CGRect(origin: .zero ,size: image.size))
        image.draw(in: CGRect(origin: .zero ,size: image.size))
        myImage.draw(in: CGRect(origin: .zero ,size: image.size), blendMode: .destinationOut, alpha: 1)
        myImage = UIGraphicsGetImageFromCurrentImageContext()!


        UIGraphicsEndImageContext()
                
        startPoint = lastPoint
        return myImage

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

class Gradient : Tool {
    private var startPoint : CGPoint = .zero
    private var endPoint : CGPoint = .zero
    
    var startColor : UIColor = .black
    var endColor : UIColor = .white
    var stepCount = 10
    var startImage : UIImage? = nil
    
    func setStartPoint(point : CGPoint,startImg : UIImage) {
        startPoint = CGPoint(x: point.x + 0.5, y: point.y + 0.5)
        startImage = startImg
    }
    
    func makeArray() -> [CGFloat] {
        var array : [CGFloat] = []
        let color = CIColor(color: startColor)
        
        array.append(color.red)
        array.append(color.green)
        array.append(color.blue)
        array.append(color.alpha)
        
        let color2 = CIColor(color: endColor)
        
        array.append(color2.red)
        array.append(color2.green)
        array.append(color2.blue)
        array.append(color2.alpha)
        return array
    }
    
    func drawOn(image : UIImage,point : CGPoint,selection : UIImage?) -> UIImage{
        endPoint = CGPoint(x: point.x + 0.5, y: point.y + 0.5)

        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
        
        var myImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        if stepCount == 0 {
        let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: makeArray(), locations: nil, count: 2)!
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation,.drawsAfterEndLocation])
            
            myImage = UIGraphicsGetImageFromCurrentImageContext()!
        } else {
            drawStepGradient(context: context)
            
            context.rotate(by: -getAngle(p1: startPoint, p2: endPoint))
            context.translateBy(x: -startPoint.x , y: -startPoint.y)
            myImage = UIGraphicsGetImageFromCurrentImageContext()!
        }
        
        context.clear(CGRect(origin: .zero, size: image.size))
        myImage.draw(at: .zero)
        selection?.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        
        myImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
                
        return UIImage.merge(images: [ startImage!,myImage])!
    }
    
    func lenght(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
    }
    
    func getAngle(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        let angle = atan2(p2.y - p1.y, p2.x - p1.x)
        
        return angle
    }
    
    func drawStepGradient(context : CGContext){
        let oneStep = CGFloat(lenght(p1: startPoint, p2: endPoint)) / CGFloat(stepCount + 2)
        let radius = 10000
        
        context.translateBy(x: startPoint.x , y: startPoint.y)
        context.rotate(by: getAngle(p1: startPoint, p2: endPoint))

        context.setFillColor(UIColor.getColorInGradient(position: 0, colors: startColor,endColor).cgColor)
        context.fill(CGRect(x: -CGFloat(radius), y: -CGFloat(radius), width: CGFloat(radius), height: CGFloat(radius * 2)))
        
        
        for i in 0..<stepCount + 1 {
            context.setFillColor(UIColor.getColorInGradient(position: CGFloat(i) / CGFloat(stepCount + 2), colors: startColor,endColor).cgColor)
            
            context.setBlendMode(.clear)
            context.fill(CGRect(x: ceil(CGFloat(i) * oneStep) - 0.5, y: -CGFloat(radius), width: (ceil(CGFloat(i + 1) * oneStep) - ceil(CGFloat(i) * oneStep)), height: CGFloat(radius * 2)))
            context.setBlendMode(.normal)
             context.fill(CGRect(x: ceil(CGFloat(i) * oneStep) - 0.5, y: -CGFloat(radius), width: (ceil(CGFloat(i + 1) * oneStep) - ceil(CGFloat(i) * oneStep)), height: CGFloat(radius * 2)))
        }
        
        context.setFillColor(UIColor.getColorInGradient(position: 1, colors: startColor,endColor).cgColor)
        
        context.setBlendMode(.clear)
        context.fill(CGRect(x: ceil(CGFloat(stepCount + 1) * oneStep) - 0.5, y: -CGFloat(radius), width: CGFloat(radius), height: CGFloat(radius * 2)))
        
        context.setBlendMode(.normal)
        context.fill(CGRect(x: ceil(CGFloat(stepCount + 1) * oneStep) - 0.5, y: -CGFloat(radius), width: CGFloat(radius), height: CGFloat(radius * 2)))
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
