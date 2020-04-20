//
//  CircleSelector.swift
//  new Testing
//
//  Created by Рустам Хахук on 01.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class CircleSelector : UIView {
    
    lazy private var bg : UIView = {
        let mainView = UIView()
        let view = UIView()
        mainView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        return mainView
    }()
    
    private var selectAngle : Float = 0
    
    lazy private var selectView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        var inView = UIView()
        view.addSubview(inView)
        inView.setCorners(corners: 15
        )
        inView.translatesAutoresizingMaskIntoConstraints = false
        inView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        inView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        inView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        inView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -6).isActive = true
        inView.backgroundColor = .red
        
        view.transform = CGAffineTransform.init(rotationAngle: 4 * CGFloat.pi / 3)
        view.setShadow(color: .black, radius: 8, opasity: 0.25)
        return view
    }()
    
    lazy private var tapgesture : UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(tap(sender:)))
        gesture.minimumPressDuration = 0
        return gesture
    }()
    
    func getAnglefromPoint(_ point : CGPoint) -> CGFloat{
        let xv = point.x - frame.width / 2
        let yv = frame.height / 2 - point.y
        var value = Int(Degress(atan2(xv, yv)) - 90)
        
        if value < 0 {value = 180 + (180 + value)}
        
        value = value % 360
        return Radians(CGFloat(value))
    }
    
    func Radians(_ angle : CGFloat) -> CGFloat{
        return angle * CGFloat.pi / 180.0
    }
    
    func Degress(_ radians : CGFloat) -> CGFloat{
        return radians / CGFloat.pi * 180.0
    }
    
    init() {
        super.init(frame : .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bg)
        addSubview(selectView)
        addGestureRecognizer(tapgesture)

        bg.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bg.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        bg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        selectView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        selectView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        selectView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        selectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    var delegate : (UIColor)->() = {res in}
    
    override func layoutSubviews() {
        layoutIfNeeded()
        bg.subviews[0].layer.masksToBounds = true
        bg.subviews[0].layer.cornerRadius = bg.frame.width / 2
        
        let maskView = UIView()
        maskView.frame = CGRect(x: 0, y: 0, width: bg.frame.width, height: bg.frame.width)
        maskView.setCorners(corners: (bg.frame.width) / 2)
        maskView.layer.borderWidth = 18
        maskView.layer.borderColor = UIColor.red.cgColor
        
        bg.subviews[0].mask = maskView
        
        let gradient = CAGradientLayer()
        gradient.type = .conic
        gradient.frame = bg.bounds
        gradient.colors = [UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.cyan.cgColor,UIColor.blue.cgColor,UIColor.magenta.cgColor,UIColor.red.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        bg.subviews[0].layer.addSublayer(gradient)
    }
    
    func setAngle(angle : CGFloat) {
        selectAngle = Float(angle)
        UIView.animate(withDuration: 0.25, animations: {
            self.selectView.subviews[0].backgroundColor = UIColor.getColorInGradient(position: CGFloat(Int(self.selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red)
            self.selectView.transform = CGAffineTransform.init(rotationAngle: self.Radians(CGFloat(self.selectAngle) + 180))
        })
        delegate(UIColor.getColorInGradient(position: CGFloat(Int(self.selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red))
    }
    
    @objc private func tap(sender : UILongPressGestureRecognizer){
        switch sender.state {
        case .began:
            selectAngle = Float(Degress(getAnglefromPoint(sender.location(in: self))))
            
            UIView.animate(withDuration: 0.25, animations: {
                self.selectView.subviews[0].transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                self.selectView.subviews[0].backgroundColor = UIColor.getColorInGradient(position: CGFloat(Int(self.selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red)
                
                self.selectView.transform = CGAffineTransform.init(rotationAngle: self.Radians(CGFloat(self.selectAngle) + 180))
            })
            delegate(UIColor.getColorInGradient(position: CGFloat(Int(self.selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red))
        case .changed:
            selectAngle = Float(Degress(getAnglefromPoint(sender.location(in: self))))

            UIView.animate(withDuration: 0.25, animations: {
                self.selectView.transform = CGAffineTransform.init(rotationAngle: self.Radians(CGFloat(self.selectAngle) + 180))
                self.selectView.subviews[0].backgroundColor = UIColor.getColorInGradient(position: CGFloat(Int(self.selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red)
            })
            delegate(UIColor.getColorInGradient(position: CGFloat(Int(self.selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red))
        case .ended:
            selectAngle = Float(Degress(getAnglefromPoint(sender.location(in: self))))
            
            UIView.animate(withDuration: 0.25, animations: {
                self.selectView.subviews[0].transform = CGAffineTransform(scaleX: 1, y: 1)
                self.selectView.transform = CGAffineTransform.init(rotationAngle: self.Radians(CGFloat(self.selectAngle) + 180))
                self.selectView.subviews[0].backgroundColor = UIColor.getColorInGradient(position: CGFloat(Int(self.selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red)
            })
            delegate(UIColor.getColorInGradient(position: CGFloat(Int(self.selectAngle + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red))
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
