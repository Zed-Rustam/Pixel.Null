//
//  HSLCircle.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 07.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit


class HSLCircle: UIView {
    
    var delegate: (UIColor) -> () = {clr in}
    
    var color: UIColor {
        get{
            return selector.backgroundColor!
        }
    }
    
    lazy private var moveGesture: UILongPressGestureRecognizer = {
        let gest = UILongPressGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        gest.minimumPressDuration = 0
        
        return gest
    }()
    
    lazy private var Colors: CAGradientLayer = {
        let lay = CAGradientLayer()
        lay.colors = [UIColor.red.cgColor,
                      UIColor.yellow.cgColor,
                      UIColor.green.cgColor,
                      UIColor.cyan.cgColor,
                      UIColor.blue.cgColor,
                      UIColor.magenta.cgColor,
                      UIColor.red.cgColor]
        lay.type = .conic
        
        lay.startPoint = CGPoint(x: 0.5, y: 0.5)
        lay.endPoint = CGPoint(x: 0.5, y: 0)
        
        return lay
    }()
    
    lazy private var Whiter: CAGradientLayer = {
        let lay = CAGradientLayer()
        lay.colors = [UIColor.white.cgColor,UIColor.white.withAlphaComponent(0).cgColor]
        lay.type = .radial
        
        lay.startPoint = CGPoint(x: 0.5, y: 0.5)
        lay.endPoint = .zero
        return lay
    }()
    
    lazy private var selector: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        //view.widthAnchor.constraint(equalToConstant: 36).isActive = true
        //view.heightAnchor.constraint(equalToConstant: 36).isActive = true
        view.frame.size = CGSize(width: 36, height: 36)
        view.backgroundColor = .white
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        view.setCorners(corners: 18)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        
        addGestureRecognizer(moveGesture)
        isUserInteractionEnabled = true
        
        layer.addSublayer(Colors)
        layer.addSublayer(Whiter)

        addSubview(selector)
        selector.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if lenght(p1: point, p2: CGPoint(x: frame.width / 2, y: frame.width / 2)) <= frame.width / 2 {
            return self
        } else {
            return nil
        }
    }
    
    override func layoutSubviews() {
        Colors.frame = bounds
        
        Whiter.frame = bounds
        
        setCorners(corners: frame.width / 2,needMask: true, curveType: .circular)
        print("yes2")
        selector.setShadow(color: .black, radius: 12, opasity: 0.2)
        selector.layer.shadowPath = UIBezierPath(roundedRect: selector.bounds, cornerRadius: 18).cgPath
    }
    
    override func tintColorDidChange() {
        selector.setShadow(color: .black, radius: 12, opasity: 0.2)
        selector.layer.shadowPath = UIBezierPath(roundedRect: selector.bounds, cornerRadius: 18).cgPath
    }
    
    @objc func onTap(sender: UILongPressGestureRecognizer){
        UIView.animate(withDuration: 0.2, animations: {
            self.selector.center = self.convertLocation(point: sender.location(in: self))
        })
        
        self.selector.backgroundColor = getResultColor(point: self.convertLocation(point: sender.location(in: self)))
        delegate(self.selector.backgroundColor!)
    }
    
    private func convertLocation(point: CGPoint) -> CGPoint {
        let maxLenght = frame.width / 2 - 18
        let center = CGPoint(x: frame.width / 2, y: frame.width / 2)
        
        if lenght(p1: point, p2: center) > maxLenght {
            return CGPoint(x: ((point.x - center.x) / lenght(p1: point, p2: center)) * maxLenght ,y: ((point.y - center.y) / lenght(p1: point, p2: center)) * maxLenght).offset(x: frame.width / 2, y: frame.width / 2)
        } else {
            return point
        }
    }
    
    private func lenght(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
    }
    
    private func Radians(_ angle : CGFloat) -> CGFloat{
        return angle * CGFloat.pi / 180.0
    }
    
    private func Degress(_ radians : CGFloat) -> CGFloat{
        return radians / CGFloat.pi * 180.0
    }
    
    private func getAnglefromPoint(_ point : CGPoint) -> CGFloat{
        let xv = point.x - frame.width / 2
        let yv = frame.height / 2 - point.y
        
        var value = Int(Degress(atan2(xv, yv)))
        
        if value < 0 {value = 180 + (180 + value)}
        
        value = value % 360
        return CGFloat(value)
    }
    
    private func getResultColor(point: CGPoint) -> UIColor {
        let color = UIColor.getColorInGradient(position: getAnglefromPoint(point) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red)
        
        let mult = 1 - lenght(p1: point, p2: CGPoint(x: frame.width / 2, y: frame.width / 2)) / (frame.width / 2 - 18)

        let addR = Int(CGFloat(255 - color.getComponents().red) * mult);
        let addG = Int(CGFloat(255 - color.getComponents().green) * mult);
        let addB = Int(CGFloat(255 - color.getComponents().blue) * mult);

        
        return UIColor(r: color.getComponents().red + addR, g: color.getComponents().green + addG, b: color.getComponents().blue + addB, a: 255)
    }
    
    func setColor(color: UIColor){
        print(color.getComponents())
        
        let whiteColor = addWhite(color: color)
        
        let ang = Radians(getAngle(r: CGFloat(whiteColor.getComponents().red), g: CGFloat(whiteColor.getComponents().green), b: CGFloat(whiteColor.getComponents().blue)))
        
        
        let lenght = Double(min(whiteColor.getComponents().red,whiteColor.getComponents().green,whiteColor.getComponents().blue)) / 255.0
        let max = CGFloat(Double(frame.size.width / 2 - 18) * (1 - lenght))
        
        print("yes3 \(max * sin(ang))")

        print(max)
        print(lenght)
        print(frame.size.width / 2 - 18)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.selector.center = CGPoint(x: max * sin(ang), y: max * -cos(ang)).offset(x: self.frame.size.width / 2, y: self.frame.size.width / 2)
        })
        print("position \(self.selector.center)")
        
        self.selector.backgroundColor = getResultColor(point: self.selector.center)
    }
    
    func addWhite(color: UIColor) -> UIColor {
        let mult = CGFloat(max(color.getComponents().red,color.getComponents().green,color.getComponents().blue)) / 255.0
        
        if mult == 0 {
            return .white
        }
        
        return UIColor(r: Int(CGFloat(color.getComponents().red) / mult), g: Int(CGFloat(color.getComponents().green) / mult), b: Int(CGFloat(color.getComponents().blue) / mult), a: color.getComponents().alpha)
    }
    
    func getAngle(r : CGFloat, g : CGFloat, b : CGFloat) -> CGFloat{
        var angle : CGFloat = 0
        if r > g && r > b {
            if g > b {
                angle += 60 * (1 - ((1 - (g / r)) / (1 - (b / r))))
            } else if b > g {
                angle -= 60 * (1 - ((1 - (b / r)) / (1 - (g / r))))
            }
        } else if g > r && g > b {
            angle += 120
            if r > b {
                angle -= 60 * (1 - ((1 - (r / g)) / (1 - (b / g))))
            } else if b > r {
                angle += 60 * (1 - ((1 - (b / g)) / (1 - (r / g))))
            }
        } else if b > r && b > g {
            angle += 240
            if r > g {
                angle += 60 * (1 - ((1 - (r / b)) / (1 - (g / b))))
            } else if g > r {
                angle -= 60 * (1 - ((1 - (g / b)) / (1 - (r / b))))
            }
            
        } else if r == g && r > b {
            angle += 60
        } else if r == b && r > g {
            angle += 300
        } else if g == b && g > r {
            angle += 180
        } else if r == g && g == b {
            angle += 0
        }
        
        //print("check here red : \(r)")

        return angle
    }
}
