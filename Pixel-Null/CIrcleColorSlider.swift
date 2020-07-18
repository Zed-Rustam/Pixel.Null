//
//  CIrcleColorSlider.swift
//  new Testing
//
//  Created by Рустам Хахук on 07.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class CircleSlider : UIView {
    private var selectAngle : CGFloat = 0
    private var bg : CAShapeLayer
    private var gradientBg : CAGradientLayer
    private var selectPoint : CAShapeLayer
    weak var delegate : CircleSLiderDelegate? = nil
    
    func Radians(_ angle : CGFloat) -> CGFloat{
        return angle * CGFloat.pi / 180.0
    }
    
    func Degress(_ radians : CGFloat) -> CGFloat{
        return radians / CGFloat.pi * 180.0
    }
    
    func getAnglefromPoint(_ point : CGPoint) -> CGFloat{
        let xv = point.x - frame.width / 2
        let yv = frame.height / 2 - point.y
        var value = Int(Degress(atan2(xv, yv)) - 90)
        
        if value < 0 {value = 180 + (180 + value)}
        
        value = value % 360
        //print(Radians(Degress(atan2(xv, yv)) + 90))
        return Radians(CGFloat(value))
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print(point)
        if self.bounds.contains(point) {return self}
        else {return nil}
    }
    
    func setAngle(angle : CGFloat){
        selectAngle = angle
        
        if delegate != nil {delegate!.ChangeSelection(select: selectAngle)}
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        bg.transform = CATransform3DMakeRotation(Radians(selectAngle), 0, 0, 1)
        selectPoint.transform = CATransform3DMakeRotation(Radians(selectAngle), 0, 0, 1)
        selectPoint.fillColor = UIColor.getColorInGradient(position: CGFloat(Int(selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red).cgColor
        CATransaction.commit()
    }
    
    override init(frame: CGRect) {
        bg = CAShapeLayer()
        
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        gradientBg = CAGradientLayer()
        selectPoint = CAShapeLayer()
        
        super.init(frame : frame)
        
        let b = UIBezierPath()
            b.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: frame.width / 2 - 12, startAngle: Radians(selectAngle - 20), endAngle: Radians(selectAngle + 20), clockwise: false)
            
        bg.path = b.cgPath
        bg.fillColor = UIColor.clear.cgColor
        bg.strokeColor = UIColor.red.cgColor
        bg.lineWidth = 24
        bg.lineCap = .round
        bg.frame = bounds

        gradientBg.frame = bounds
        gradientBg.colors = [UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.cyan.cgColor,UIColor.blue.cgColor,UIColor.magenta.cgColor,UIColor.red.cgColor]
        gradientBg.type = .conic
        gradientBg.startPoint = CGPoint(x: 0.5,y: 0.5)
        gradientBg.mask = bg
        
        selectPoint.frame = bounds
        let b2 = UIBezierPath(ovalIn: CGRect(x: frame.width - 20, y: frame.width / 2 - 10, width: 20, height: 20))
        selectPoint.path = b2.cgPath
        
        selectPoint.fillColor = UIColor.getColorInGradient(position: CGFloat(Int(selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red).cgColor
        
        layer.addSublayer(gradientBg)
        layer.addSublayer(selectPoint)
        
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1
        layer.shadowColor = getAppColor(color: .shadow).cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectAngle = Degress(getAnglefromPoint(touches.first!.location(in: self)))
        if delegate != nil {delegate!.ChangeSelection(select: selectAngle)}
        
        //bg.duration = 0.2
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        bg.transform = CATransform3DMakeRotation(getAnglefromPoint(touches.first!.location(in: self)), 0, 0, 1)
        selectPoint.transform = CATransform3DMakeRotation(getAnglefromPoint(touches.first!.location(in: self)), 0, 0, 1)
        selectPoint.fillColor = UIColor.getColorInGradient(position: CGFloat(Int(Degress((getAnglefromPoint(touches.first!.location(in: self)))) + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red).cgColor
        
        CATransaction.commit()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectAngle = Degress(getAnglefromPoint(touches.first!.location(in: self)))
        if delegate != nil {delegate!.ChangeSelection(select: selectAngle)}
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        bg.transform = CATransform3DMakeRotation(getAnglefromPoint(touches.first!.location(in: self)), 0, 0, 1)
        selectPoint.transform = CATransform3DMakeRotation(getAnglefromPoint(touches.first!.location(in: self)), 0, 0, 1)
        selectPoint.fillColor = UIColor.getColorInGradient(position: CGFloat(Int(Degress((getAnglefromPoint(touches.first!.location(in: self)))) + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red).cgColor
        CATransaction.commit()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol CircleSLiderDelegate : class {
    func ChangeSelection(select : CGFloat)
}
