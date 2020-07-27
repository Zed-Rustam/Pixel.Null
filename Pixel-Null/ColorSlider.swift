//
//  ColorSlider.swift
//  new Testing
//
//  Created by Рустам Хахук on 31.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ColorSlider : UIView {
    
    public enum Orientation {
        case horizontal
        case vertical
    }
    
    public enum Preview {
        case up
        case down
        case left
        case right
        case none
    }
    
    var orientation : Orientation = .horizontal
    var preview : Preview = .up
    
    lazy private var gradient : CAGradientLayer = {
        var gr = CAGradientLayer()
        gr.colors = [startColor.cgColor,endColor.cgColor]
        gr.locations = [0,1]
        switch orientation {
         case .horizontal:
             gr.startPoint = CGPoint(x: 0, y: 0.5)
             gr.endPoint = CGPoint(x: 1, y: 0.5)
         case .vertical:
             gr.startPoint = CGPoint(x: 0.5, y: 0)
             gr.endPoint = CGPoint(x: 0.5, y: 1)
        }
        return gr
    }()
    
    var startColor : UIColor = getAppColor(color: .disable)
    var endColor : UIColor = getAppColor(color: .enable)
    
    lazy private var bgView : UIView = {
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.setCorners(corners: 12,needMask: true)
        mainview.layer.magnificationFilter = .nearest
        return mainview
    }()
    
    lazy private var selectView : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.setShadow(color: UIColor.black, radius: 4, opasity: 0.1)
        mainView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 24, height: 24), cornerRadius: 12).cgPath
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = startColor
        view.setCorners(corners: 12,needMask: false)

        
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.setCorners(corners: 12,needMask: false)
        bgView.layer.magnificationFilter = .nearest
        
        bgView.addSubview(view)
        mainView.addSubview(bgView)
        
        view.leftAnchor.constraint(equalTo: bgView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: bgView.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: bgView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
        
        bgView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        bgView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        bgView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        
        mainView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        bgView.layer.borderColor = getAppColor(color: .background).cgColor
        bgView.StrokeAnimate(duration: 0, width: 3, repeats: 0)
        return mainView
    }()
    
    lazy private var tapGesture : UILongPressGestureRecognizer = {
        let gest = UILongPressGestureRecognizer(target: self, action: #selector(tap(sender:)))
        gest.minimumPressDuration = 0
        return gest
    }()
    
    private var nowPosition : Double = 0

    var delegate : (Double) -> () = {pos in}

    var resultColor : UIColor {
        get{
            let sc = CIColor(color : startColor)
            let ec = CIColor(color : endColor)

            let reddiv = Double(ec.red - sc.red) * nowPosition
            let greendiv = Double(ec.green - sc.green) * nowPosition
            let bluediv = Double(ec.blue - sc.blue) * nowPosition
            let alphadiv = Double(ec.alpha - sc.alpha) * nowPosition
            return UIColor.init(red: sc.red + CGFloat(reddiv), green: sc.green + CGFloat(greendiv), blue: sc.blue + CGFloat(bluediv), alpha: sc.alpha + CGFloat(alphadiv))
        }
    }
    
    @objc private func tap(sender : UILongPressGestureRecognizer){
        var position : CGPoint = .zero
        switch orientation {
            case .horizontal:
                position = CGPoint(x: sender.location(in: self).x, y: 0)
                if position.x < 12 {
                    position.x = 12
                } else if position.x > self.frame.width - 12 {
                    position.x = self.frame.width - 12
                }
            
            case .vertical:
                position = CGPoint(x: 0, y: sender.location(in: self).y)
                if position.y < 12 {
                    position.y = 12
                } else if position.y > self.frame.height - 12 {
                    position.y = self.frame.height - 12
                }
        }
        
        
        switch sender.state {
        case .began:
            switch orientation {
                case .horizontal:
                    nowPosition = Double(position.x - 12) / Double(self.frame.width - 24)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.selectView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                        self.selectView.center.x = position.x
                        self.selectView.subviews[0].subviews[0].backgroundColor = self.resultColor
                        switch self.preview {
                        case .down:
                            self.selectView.center.y = 60
                        case .none:
                            break
                        default:
                            self.selectView.center.y = -30
                        }
                    })
                case .vertical:
                    nowPosition = Double(position.y - 12) / Double(self.frame.height - 24)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.selectView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                            self.selectView.center.y = position.y
                        self.selectView.subviews[0].subviews[0].backgroundColor = self.resultColor
                        switch self.preview {
                        case .right:
                            self.selectView.center.x = 60
                        case .none:
                            break
                        default:
                            self.selectView.center.x = -30
                        }
                    })
            }
            delegate(nowPosition)
        case .changed:
            switch orientation {
              case .horizontal:
                  nowPosition = Double(position.x - 12) / Double(self.frame.width - 24)
                  UIView.animate(withDuration: 0.25, animations: {
                      self.selectView.center.x = position.x
                        self.selectView.subviews[0].subviews[0].backgroundColor = self.resultColor
                  })
              case .vertical:
                  nowPosition = Double(position.y - 12) / Double(self.frame.height - 24)
                  UIView.animate(withDuration: 0.25, animations: {
                      self.selectView.center.y = position.y
                    self.selectView.subviews[0].subviews[0].backgroundColor = self.resultColor
                  })
              }
              delegate(nowPosition)
        case .ended:
            switch orientation {
                case .horizontal:
                    nowPosition = Double(position.x - 12) / Double(self.frame.width - 24)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.selectView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.selectView.center.x = position.x
                        self.selectView.subviews[0].subviews[0].backgroundColor = self.resultColor
                        self.selectView.frame.origin.y = 6
                    })
                case .vertical:
                    nowPosition = Double(position.y - 12) / Double(self.frame.height - 24)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.selectView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.selectView.center.y = position.y
                        self.selectView.subviews[0].subviews[0].backgroundColor = self.resultColor
                        self.selectView.frame.origin.x = 6
                    })
            }
            delegate(nowPosition)
            
         default:
            break
        }
    }
    
    func resetGradient(start : UIColor,end : UIColor){
        startColor = start
        endColor = end
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        selectView.subviews[0].subviews[0].backgroundColor = self.resultColor
    }
    
    func setPosition(pos : Double) {
        nowPosition = pos
        print("some shit 2 \(self.frame.height)")
        
        switch orientation {
            case .horizontal:
                UIView.animate(withDuration: 0.25, animations: {
                    self.selectView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.selectView.center.x = CGFloat(12 + self.nowPosition * Double(self.frame.width - 24))
                    self.selectView.subviews[0].subviews[0].backgroundColor = self.resultColor
                })
            case .vertical:
                UIView.animate(withDuration: 0.25, animations: {
                    self.selectView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.selectView.center.y = CGFloat(12 + self.nowPosition * Double(self.frame.height - 24))
                    self.selectView.subviews[0].subviews[0].backgroundColor = self.resultColor
                })
        }
    }
    
    init(startColor start : UIColor, endColor end : UIColor, orientation orient : Orientation) {
        startColor = start
        endColor = end
        orientation = orient
        
        super.init(frame : .zero)
        
        addSubview(bgView)
        addSubview(selectView)
        
        
        switch orientation {
        case .horizontal:
            bgView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            bgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            bgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
            bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
        case .vertical:
            bgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
            bgView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -6).isActive = true
            bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        selectView.leftAnchor.constraint(equalTo: bgView.leftAnchor).isActive = true
        selectView.topAnchor.constraint(equalTo: bgView.topAnchor).isActive = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func reset(){
        setPosition(pos: nowPosition)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        gradient.frame = bgView.bounds
        bgView.layer.addSublayer(gradient)
        setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
        layer.shadowPath = UIBezierPath(roundedRect: bgView.bounds, cornerRadius: 12).cgPath
        
        bgView.backgroundColor = UIColor(patternImage: UIImage(cgImage:#imageLiteral(resourceName: "background").cgImage! , scale: 1.0/6, orientation: .down))
        
        selectView.subviews[0].backgroundColor = UIColor(patternImage: UIImage(cgImage:#imageLiteral(resourceName: "background").cgImage!, scale: 1.0 / 7.5, orientation: .down))
        setPosition(pos: self.nowPosition)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
