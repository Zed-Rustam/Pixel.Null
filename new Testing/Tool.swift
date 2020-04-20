//
//  Tool.swift
//  new Testing
//
//  Created by Рустам Хахук on 02.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class Tool {
}

class Pencil : Tool {
    
    var size : Double = 1
    var color : String = UIColor.toHex(color: UIColor.red)
    var smooth : Int = 0
    var pixPerfect : Bool = false
    
    func setSettings(penSize : Int, penColor : UIColor, smth : Int, pixelPerf : Bool){
        size = Double(penSize)
        color = UIColor.toHex(color: penColor)
        smooth = smth
        pixPerfect = pixelPerf
    }
    
    private var points : [CGPoint] = []
    
    func setStartPoint(point : CGPoint){
        points.removeAll()
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
    
    func drawOn(image : UIImage,point : CGPoint, selection : UIImage?, symmetry : CGPoint) -> UIImage{
       
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
        //points.append(CGPoint(x: CGFloat(Double(Int(point.x)) + 0.5), y: CGFloat(Int(point.y)) + 0.5))

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
                
        return myImage.withTintColor(UIColor(hex: color)!)

    }
}

class Selection : Tool {
    
    enum SelectionType {
        case draw
        case rectangle
        case ellipse
        case fill
    }
    
    var color : String = UIColor.toHex(color: ProjectStyle.uiSelectColor)
    
    func setSettings(){

    }
    
    func reverse(select : UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(select.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor(hex: color)!.cgColor)
        context.fill(CGRect(origin: .zero, size: select.size))
        
        select.draw(at: .zero, blendMode: .destinationOut, alpha: 1)
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return myImage
    }
    
    var lastSelection : UIImage? = nil
    private var points : [CGPoint] = []
    
    func restart(img : UIImage, startPoint : CGPoint){
        lastSelection = img
        points.removeAll()
        points.append(startPoint)
    }
    
    func drawOn(image : UIImage,point : CGPoint, symmetry : CGPoint) -> UIImage{
        points.append(CGPoint(x: CGFloat(Double(Int(point.x)) + 0.5), y: CGFloat(Int(point.y)) + 0.5))
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor(hex: color)!.cgColor)
        context.setShouldAntialias(false)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        context.clear(CGRect(origin: .zero ,size: image.size))
        context.setLineWidth(1)
        context.move(to: points[0])
        for i in points {
            context.addLine(to: i)
        }
        context.fillPath()
        
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
        
        context.clear(CGRect(origin: .zero, size: image.size))
        myImage.draw(at: .zero)
        lastSelection?.draw(at: .zero)

        
        myImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
                
        return myImage.withTintColor(UIColor(hex: color)!)
    }
}

extension CGPoint {
    func offset(x : CGFloat, y : CGFloat) -> CGPoint{
        return CGPoint(x: self.x + x, y: self.y + y)
    }
}

class Fill : Tool {
    
    private struct line {
        var start : CGPoint
        var lenght : Int
    }
    private enum orientation {
        case horizontal
        case vertical
    }

    var color : UIColor = .red
    var colorForChange : UIColor = .clear

    func setSettings(fillColor : UIColor){
        color = fillColor
    }
    
    private var points : [CGPoint] = []

    private var changedColors: [Bool] = []
    
    func setStartPoint(point : CGPoint){
        points.removeAll()
    }
    
    func getChanged(imgSize : CGSize,pixel : CGPoint) -> Bool? {
       if CGRect(origin: .zero, size: imgSize).contains(pixel) {
           let startIndex: Int = ((Int(imgSize.width) * Int(pixel.y)) + Int(pixel.x))
           
           return changedColors[startIndex]
       } else {
           return nil
       }
    }
    
    func changeChanged(imgSize : CGSize,pixel : CGPoint) {
        let startIndex: Int = ((Int(imgSize.width) * Int(pixel.y)) + Int(pixel.x))
        changedColors[startIndex] = false
    }

    
    private func fillH(from : CGPoint, imageSize : CGSize,canvas : CGContext){
        var pos = from
        var start = from
        var end = from

        var wasAddUp = false
        var wasAddDown = false

        if getChanged(imgSize: imageSize, pixel: from) == false {
            return
        }
        
        changeChanged(imgSize: imageSize, pixel: pos)
               
        if getChanged(imgSize: imageSize, pixel: pos.offset(x: 0, y: -1)) == true {
            points.append(pos.offset(x: 0, y: -1))
            wasAddUp = true
        }
        if getChanged(imgSize: imageSize, pixel: pos.offset(x: 0, y: 1)) == true {
            points.append(pos.offset(x: 0, y: 1))
            wasAddDown = true
        }
        
        DispatchQueue.init(label: "first").async {
            //some actions
        }
        
        DispatchQueue.init(label: "second").async {
            //some actions
        }
        
        
        while getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: 0)) == true {
            
            if !wasAddUp && getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: -1)) == true {
                points.append(pos.offset(x: -1, y: -1))
                wasAddUp = true
            } else if getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: -1)) != true {
                wasAddUp = false
            }
            if !wasAddDown && getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: 1)) == true {
                points.append(pos.offset(x: -1, y: 1))
                wasAddDown = true
            } else if getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: 1)) != true {
                wasAddDown = false
            }
            
            pos = pos.offset(x: -1, y: 0)
            changeChanged(imgSize: imageSize, pixel: pos)
        }
        start = pos
        //canvas.fill(CGRect(x: pos.x, y: pos.y, width: from.x - pos.x, height: 1))
        
        pos = from
        wasAddUp = false
        wasAddDown = false

        while getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: 0)) == true {
            if !wasAddUp && getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: -1)) == true {
                points.append(pos.offset(x: 1, y: -1))
                wasAddUp = true
            } else if getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: -1)) != true {
                wasAddUp = false
            }
            
            if !wasAddDown && getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: 1)) == true {
                points.append(pos.offset(x: 1, y: 1))
                wasAddDown = true
            } else if getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: 1)) != true {
                wasAddDown = false
            }
            
            pos = pos.offset(x: 1, y: 0)
            changeChanged(imgSize: imageSize, pixel: pos)
        }
        end = pos
        //print(end.x - start.x + 1)
        canvas.fill(CGRect(x: start.x, y: start.y, width: end.x - start.x + 1, height: 1))

    }
    
    private func fillV(from : CGPoint, imageSize : CGSize,canvas : CGContext){
        var pos = from
        var start = from
        var end = from

        var wasAddUp = false
        var wasAddDown = false

        if getChanged(imgSize: imageSize, pixel: from) == false {
            return
        }
        
        changeChanged(imgSize: imageSize, pixel: pos)
               
        if getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: 0)) == true {
            points.append(pos.offset(x: -1, y: 0))
            wasAddUp = true
        }
        if getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: 0)) == true {
            points.append(pos.offset(x: 1, y: 0))
            wasAddDown = true
        }
        
        DispatchQueue.init(label: "first").async {
            //some actions
        }
        
        DispatchQueue.init(label: "second").async {
            //some actions
        }
        
        
        while getChanged(imgSize: imageSize, pixel: pos.offset(x: 0, y: -1)) == true {
            
            if !wasAddUp && getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: -1)) == true {
                points.append(pos.offset(x: -1, y: -1))
                wasAddUp = true
            } else if getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: -1)) != true {
                wasAddUp = false
            }
            if !wasAddDown && getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: -1)) == true {
                points.append(pos.offset(x: 1, y: -1))
                wasAddDown = true
            } else if getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: -1)) != true {
                wasAddDown = false
            }
            
            pos = pos.offset(x: 0, y: -1)
            changeChanged(imgSize: imageSize, pixel: pos)
        }
        start = pos
        //canvas.fill(CGRect(x: pos.x, y: pos.y, width: from.x - pos.x, height: 1))
        
        pos = from
        wasAddUp = false
        wasAddDown = false

        while getChanged(imgSize: imageSize, pixel: pos.offset(x: 0, y: 1)) == true {
            if !wasAddUp && getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: 1)) == true {
                points.append(pos.offset(x: -1, y: 1))
                wasAddUp = true
            } else if getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: 1)) != true {
                wasAddUp = false
            }
            
            if !wasAddDown && getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: 1)) == true {
                points.append(pos.offset(x: 1, y: 1))
                wasAddDown = true
            } else if getChanged(imgSize: imageSize, pixel: pos.offset(x: 1, y: 1)) != true {
                wasAddDown = false
            }
            
            pos = pos.offset(x: 0, y: 1)
            changeChanged(imgSize: imageSize, pixel: pos)
        }
        end = pos
        canvas.fill(CGRect(x: start.x, y: start.y, width: 1, height: end.y - start.y + 1))
    }

    func makeStroke(imageSize : CGSize,from : CGPoint){
        var pos = from
        while getChanged(imgSize: imageSize, pixel: pos.offset(x: -1, y: 0)) == true {
            pos = pos.offset(x: -1, y: 0)
            //changeColor(imgSize: imageSize, pixel: pos)
        }
        
        let realStart = pos
        
        var newPos = realStart
        
        while(newPos != realStart) {
            switch getMoving(point: newPos) {
            case 0:
                newPos = newPos.offset(x: 0, y: -1)
                points.append(newPos)
            default:
                break
            }
        }
    }
    
    func getMoving(point : CGPoint) -> Int {
        return 0
    }
    
    func drawOn(image : UIImage,point : CGPoint, selection : UIImage?) -> UIImage{
        colorForChange = image.getColor(point: point)

        points.removeAll()
        changedColors.removeAll()
        changedColors = .init(repeating: false, count: Int(image.size.width) * Int(image.size.height))
        for y in 0..<Int(image.size.height) {
            for x in 0..<Int(image.size.width) {
                if image.getColor(point: CGPoint(x: x, y: y)) == colorForChange {
                    changedColors[Int(image.size.width) * y + x] = true
                }
                
            }
        }
        print("now start")
        
        if image.getColor(point: point) != color {
            points.append(point)
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
                               
            let context = UIGraphicsGetCurrentContext()!
            image.draw(at: .zero)
            
            context.setFillColor(color.cgColor)
            
            
            while points.count > 0 {
                fillH(from: points.remove(at: 0), imageSize: image.size, canvas: context)
            }
            
            selection?.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
            
            let myImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
             
            return myImage
        } else {
            return image
        }
    }
    
    
}

class Square : Tool {
    
    enum SquareType {
        case rectangle
        case oval
        case line
    }
    
    var size : Double = 1
    var color : String = UIColor.toHex(color: UIColor.red)
    var smooth : Int = 0
    var pixPerfect : Bool = false
    
    func setSettings(penSize : Int, penColor : UIColor, smth : Int, pixelPerf : Bool){
        size = Double(penSize)
        color = UIColor.toHex(color: penColor)
        smooth = smth
        pixPerfect = pixelPerf
    }
    
    private var points : [CGPoint] = []
    
    func setStartPoint(point : CGPoint){
        points.removeAll()
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
    
    func drawOn(image : UIImage,point : CGPoint) -> UIImage{
       
        if CGPoint(x: Int(points.last!.x),y : Int(points.last!.y)) != CGPoint(x: point.x, y: point.y){
            switch Int(size) % 2 {
               case 0:
                    points.append(CGPoint(x: CGFloat(Double(Int(point.x))), y: CGFloat(Int(point.y))))
               case 1:
                    points.append(CGPoint(x: CGFloat(Double(Int(point.x)) + 0.5), y: CGFloat(Int(point.y)) + 0.5))
               default:
                    break
            }
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
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
                
        return myImage!.withTintColor(UIColor(hex: color)!)

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
    private var offset : CGPoint = .zero
    var wasStart : Bool = false
    
    func setImage(image : UIImage, startpos : CGPoint,selection : UIImage?) {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
               
        image.draw(at: .zero)
        selection?.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        let moveImg = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        moveImage = moveImg
        wasStart = true
        offset = startpos
    }
    
    func drawOn(move : CGPoint) -> UIImage{
        wasStart = true
        UIGraphicsBeginImageContextWithOptions(moveImage.size, false, 1)
        
        moveImage.draw(at: CGPoint(x: move.x - offset.x, y: move.y - offset.y))
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
                
        return myImage!
    }
}

class Gradient : Tool {
    private var startPoint : CGPoint = .zero
    private var endPoint : CGPoint = .zero

    var startColor : UIColor = .black
    var endColor : UIColor = .white
    var stepCount = 10
    
    func setStartPoint(point : CGPoint) {
        startPoint = CGPoint(x: point.x + 0.5, y: point.y + 0.5)
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
                
        return myImage

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
