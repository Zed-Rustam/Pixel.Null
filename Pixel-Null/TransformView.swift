//
//  TransformView.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 20.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class TransformView : UIView {
    var scale : CGFloat = 1
    var angle : CGFloat = 0
    var position : CGRect = CGRect(x: 0, y: 0, width: 32, height: 32)
    var offset : CGPoint = .zero
    var activeMode : TransformMode = .none
    var startPosition : CGPoint = .zero
    var lastSize : CGSize = .zero
    
    enum TransformMode {
        case move
        case scaleUpLeft
        case scaleUpRight
        case scaleDownLeft
        case scaleDownRight
        case left
        case right
        case up
        case down
        case rotate
        case none
    }
    
    func getTransformMode(location : CGPoint) {
        startPosition = location
        startPosition = getResultLocation(point: startPosition)
        lastSize = CGSize(width: ((position.origin.x + position.size.width / 2.0)), height: ((position.origin.y + position.size.height / 2.0)))

        
        if CGRect(x: offset.x + position.origin.x * scale - 12, y: offset.y + position.origin.y * scale - 12, width: 24, height: 24).contains(startPosition){
            activeMode = .scaleUpLeft
        } else if CGRect(x: offset.x + (position.origin.x + position.size.width) * scale - 12, y: offset.y + position.origin.y * scale - 12, width: 24, height: 24).contains(startPosition){
            activeMode = .scaleUpRight
        } else if CGRect(x: offset.x + (position.origin.x + position.size.width / 2.0) * scale - 12, y: offset.y + position.origin.y * scale - 12, width: 24, height: 24).contains(startPosition){
            activeMode = .up
        } else if CGRect(x: offset.x + (position.origin.x + position.size.width / 2.0) * scale - 12, y: offset.y + (position.origin.y + position.size.height) * scale - 12, width: 24, height: 24).contains(startPosition){
            activeMode = .down
        } else if CGRect(x: offset.x + (position.origin.x) * scale - 12, y: offset.y + (position.origin.y + position.size.height / 2.0) * scale - 12, width: 24, height: 24).contains(startPosition){
            activeMode = .left
        } else if CGRect(x: offset.x + (position.origin.x + position.size.width) * scale - 12, y: offset.y + (position.origin.y + position.size.height / 2.0) * scale - 12, width: 24, height: 24).contains(startPosition){
            activeMode = .right
        } else if CGRect(x: offset.x + (position.origin.x) * scale - 12, y: offset.y + (position.origin.y + position.size.height) * scale - 12, width: 24, height: 24).contains(startPosition){
            activeMode = .scaleDownLeft
        } else if CGRect(x: offset.x + (position.origin.x + position.size.width) * scale - 12, y: offset.y + (position.origin.y + position.size.height) * scale - 12, width: 24, height: 24).contains(startPosition){
            activeMode = .scaleDownRight
        } else if getPosition().contains(startPosition) {
            activeMode = .move
            startPosition = location
        } else if CGRect(x: offset.x + (position.origin.x + position.size.width) * scale + (position.size.width > 0 ? 0 : position.width * scale) + 64, y: offset.y + (position.origin.y + position.size.height / 2.0) * scale - 12, width: 24, height: 24).contains(startPosition){
            activeMode = .rotate
            lastSize = CGSize(width: ((position.origin.x + position.size.width / 2.0)), height: ((position.origin.y + position.size.height / 2.0)))
            //startPosition = CGPoint(x: offset.x + position.width / 2.0, y: offset.y + position.height / 2.0)
        } else {
            activeMode = .none
        }
        
        startPosition.x = floor((startPosition.x - offset.x) / scale)
        startPosition.y = floor((startPosition.y - offset.y) / scale)
    }
    
    func rotate(nextLocation : CGPoint) {
        angle = getAngle(centerPoint: CGPoint(x: offset.x + lastSize.width * scale, y: offset.y + lastSize.height * scale), touchPoint: nextLocation)
        setNeedsDisplay()
    }
    
    func getResultLocation(point : CGPoint) -> CGPoint {
        var resPoint = point
        resPoint = resPoint.applying(CGAffineTransform(translationX: -lastSize.width * scale - offset.x, y: -lastSize.height * scale - offset.y))
        resPoint = resPoint.applying(CGAffineTransform(rotationAngle: -angle))
        resPoint = resPoint.applying(CGAffineTransform(translationX: lastSize.width * scale + offset.x, y: lastSize.height * scale + offset.y))
        return resPoint
       }
    func getRotateLocation(point : CGPoint,centerRotate : CGPoint) -> CGPoint {
        var resPoint = point
        resPoint = resPoint.applying(CGAffineTransform(translationX: -centerRotate.x, y: -centerRotate.y))
        resPoint = resPoint.applying(CGAffineTransform(rotationAngle: angle))
        resPoint = resPoint.applying(CGAffineTransform(translationX: centerRotate.x, y: centerRotate.y))
     return resPoint
    }
    
    func move(nextLocation : CGPoint) {
        var nowLocation = nextLocation
        nowLocation.x = floor((nowLocation.x - offset.x) / scale)
        nowLocation.y = floor((nowLocation.y - offset.y) / scale)
        
        position.origin.x += nowLocation.x - startPosition.x
        position.origin.y += nowLocation.y - startPosition.y
        
        lastSize = CGSize(width: ((position.origin.x + position.size.width / 2.0)), height: ((position.origin.y + position.size.height / 2.0)))

        startPosition = nowLocation
        setNeedsDisplay()
    }
    
    func Radians(_ angle : CGFloat) -> CGFloat{
        return angle * CGFloat.pi / 180.0
    }
    
    func Degress(_ radians : CGFloat) -> CGFloat{
        return radians / CGFloat.pi * 180.0
    }
    
    func getAngle(centerPoint : CGPoint, touchPoint : CGPoint) -> CGFloat{
        let xv = touchPoint.x - centerPoint.x
        let yv = touchPoint.y - centerPoint.y
        var value = Int(Degress(atan2(yv, xv)))
        
        if value < 0 {value = 180 + (180 + value)}
        
        value = value % 360
        print(value)
        return atan2(yv, xv)
    }
    
    func resize(nextLocation : CGPoint){
        var nowLocation = getResultLocation(point: nextLocation)
        nowLocation.x = floor((nowLocation.x - offset.x) / scale)
        nowLocation.y = floor((nowLocation.y - offset.y) / scale)
        
        switch activeMode {
        case .scaleUpLeft:
            position.size.width -= nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).x - position.origin.x
            position.size.height -= nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).y - position.origin.y
            position.origin = nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y)
        case .scaleUpRight:
            position.size.width += nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).x - position.origin.x
            position.size.height -= nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).y - position.origin.y
            position.origin = nowLocation.offset(x: -nowLocation.x + position.origin.x, y: position.origin.y - startPosition.y)
        case .scaleDownLeft:
            position.size.width -= nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).x - position.origin.x
            position.size.height += nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).y - position.origin.y
            position.origin = nowLocation.offset(x: position.origin.x - startPosition.x, y: -nowLocation.y + position.origin.y)
        case .scaleDownRight:
            position.size.width += nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).x - position.origin.x
            position.size.height += nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).y - position.origin.y
        case .up:
            position.size.height -= nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).y - position.origin.y
            position.origin.y = nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).y
        case .down:
            position.size.height += nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).y - position.origin.y
        case .left:
            position.size.width -= nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).x - position.origin.x
            position.origin.x = nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).x
        case .right:
            position.size.width += nowLocation.offset(x: position.origin.x - startPosition.x, y: position.origin.y - startPosition.y).x - position.origin.x
        default:
            break
        }
        
        startPosition = nowLocation
        setNeedsDisplay()
    }
    
    func finishReSize(){
        let center = getRotateLocation(point: CGPoint(x: position.origin.x + position.size.width / 2.0, y: position.origin.y + position.size.height / 2.0), centerRotate: CGPoint(x: lastSize.width, y: lastSize.height))
        
        position.origin.x = CGFloat(Int(round(center.x - position.size.width / 2.0)))
        position.origin.y = CGFloat(Int(round(center.y - position.size.height / 2.0)))
        position.size.width = round(position.size.width)
        position.size.height = round(position.size.height)
        
        lastSize = CGSize(width: ((position.origin.x + position.size.width / 2.0)), height: ((position.origin.y + position.size.height / 2.0)))

        setNeedsDisplay()
    }
    
    func getPosition() -> CGRect {
        return CGRect(x: offset.x + position.origin.x * scale, y: offset.y + position.origin.y * scale,width: position.size.width * scale, height : position.size.height * scale)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.clear(self.bounds)
        context.translateBy(x: offset.x + lastSize.width * scale, y: offset.y + lastSize.height * scale)
        context.rotate(by: angle)
        context.translateBy(x: -lastSize.width * scale - offset.x, y: -lastSize.height * scale - offset.y)

        context.setStrokeColor(ProjectStyle.uiSelectColor.cgColor)
        context.setLineWidth(2)
        context.setLineJoin(.round)
        context.setLineCap(.round)
        context.setLineDash(phase: 2, lengths: [10,10])
        context.move(to: getPosition().origin)
        context.addLine(to: CGPoint(x: getPosition().origin.x + getPosition().size.width, y: getPosition().origin.y))
        context.addLine(to: CGPoint(x: getPosition().origin.x + getPosition().size.width, y: getPosition().origin.y + getPosition().size.height))
        context.addLine(to: CGPoint(x: getPosition().origin.x, y: getPosition().origin.y + getPosition().size.height))
        context.addLine(to: CGPoint(x: getPosition().origin.x, y: getPosition().origin.y))
        context.closePath()
        
        context.strokePath()
        
        context.setFillColor(ProjectStyle.uiSelectColor.cgColor)
        context.addEllipse(in: CGRect(x: offset.x + position.origin.x * scale - 12, y: offset.y + position.origin.y * scale - 12, width: 24, height: 24))
        context.addEllipse(in: CGRect(x: offset.x + (position.origin.x + position.size.width) * scale - 12, y: offset.y + position.origin.y * scale - 12, width: 24, height: 24))
        context.addEllipse(in: CGRect(x: offset.x + position.origin.x * scale - 12, y: offset.y + (position.origin.y + position.size.height) * scale - 12, width: 24, height: 24))
        context.addEllipse(in: CGRect(x: offset.x + (position.origin.x + position.size.width) * scale - 12, y: offset.y + (position.origin.y + position.size.height) * scale - 12, width: 24, height: 24))
        
        context.addEllipse(in: CGRect(x: offset.x + (position.origin.x + position.size.width / 2.0) * scale - 12, y: offset.y + position.origin.y * scale - 12, width: 24, height: 24))

        context.addEllipse(in: CGRect(x: offset.x + (position.origin.x + position.size.width / 2.0) * scale - 12, y: offset.y + (position.origin.y + position.size.height) * scale - 12, width: 24, height: 24))
        
        context.addEllipse(in: CGRect(x: offset.x + (position.origin.x + position.size.width) * scale - 12, y: offset.y + (position.origin.y + position.size.height / 2.0) * scale - 12, width: 24, height: 24))
        
        context.addEllipse(in: CGRect(x: offset.x + (position.origin.x + position.size.width) * scale + (position.size.width > 0 ? 0 : position.width * scale) + 64, y: offset.y + (position.origin.y + position.size.height / 2.0) * scale - 12, width: 24, height: 24))

        context.addEllipse(in: CGRect(x: offset.x + (position.origin.x) * scale - 12, y: offset.y + (position.origin.y + position.size.height / 2.0) * scale - 12, width: 24, height: 24))

        context.setShadow(offset: .zero, blur: 4, color: ProjectStyle.uiShadowColor.withAlphaComponent(0.5).cgColor)
        context.fillPath()
        
        //context.rotate(by: -angle)
        //context.translateBy(x: -(offset.x + (position.width / 2.0 * scale)), y: -(offset.y + (position.height / 2.0 * scale)))
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        isUserInteractionEnabled = true
        //lastSize = position.size
        lastSize = CGSize(width: ((position.origin.x + position.width / 2.0)), height: ((position.origin.y + position.height / 2.0)))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
