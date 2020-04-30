//
//  SliderView.swift
//  new Testing
//
//  Created by Рустам Хахук on 31.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SliderView : UIView {

    enum SliderOrientation{
        case horizontal
        case vertical
    }

    var orientation : SliderOrientation = .horizontal
    var delegate : (CGFloat) -> () = {pos in}
        
    private var nowPosition : CGFloat = 0

    lazy private var bg : UIView = {
        let view = UIView()
        view.backgroundColor = ProjectStyle.uiDisableColor.withAlphaComponent(0.25)
        view.setCorners(corners: 9)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var bg2 : UIView = {
        let view = UIView()
        view.backgroundColor = ProjectStyle.uiEnableColor
        view.setCorners(corners: 9)
        view.frame.size.height = 18
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
        
    lazy private var selectorView : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.setShadow(color: .black, radius: 8, opasity: 0.25)
        let view = UIView()
        view.backgroundColor = ProjectStyle.uiEnableColor
        view.setCorners(corners: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(view)
        view.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return mainView
    }()
        
    lazy private var tapGesture : UILongPressGestureRecognizer = {
        let gest = UILongPressGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        gest.minimumPressDuration = 0
        return gest
    }()

    init() {
        super.init(frame: .zero)
        self.addSubview(bg)
        bg.addSubview(bg2)
        self.addSubview(selectorView)
        self.layer.masksToBounds = false
        self.addGestureRecognizer(tapGesture)
        
        bg.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        bg.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        bg.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
        
        bg2.frame = CGRect(x: 0, y: 0, width: 0, height: 24)

        selectorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        selectorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        selectorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        selectorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func reset(){
        setPosition(pos: nowPosition)
    }
    
    func getPosition() -> CGFloat {
        return nowPosition
    }
    
    func setPosition(pos : CGFloat) {
        nowPosition = pos
        layoutIfNeeded()
        switch orientation {
            case .horizontal:
                UIView.animate(withDuration: 0.25, animations: {
                    self.bg2.frame.size.width =  15 + self.nowPosition * (self.frame.width - 30)
                    self.selectorView.center.x = 15 + self.nowPosition * (self.frame.width - 30)
                })
            case .vertical:
                UIView.animate(withDuration: 0.25, animations: {
                    self.bg2.frame.size.height = 15 + self.nowPosition * (self.frame.height - 30)
                    self.selectorView.center.y = 15 + self.nowPosition * (self.frame.height - 30)
                })
        }
    }

    @objc private func onTap(sender : UILongPressGestureRecognizer) {
        var position : CGPoint = .zero
        switch orientation {
            case .horizontal:
                position = CGPoint(x: sender.location(in: self).x, y: 0)
                if position.x < 15 {
                    position.x = 15
                } else if position.x > self.frame.width - 15 {
                    position.x = self.frame.width - 15
                }
            
            case .vertical:
                position = CGPoint(x: 0, y: sender.location(in: self).y)
                if position.y < 15 {
                    position.y = 15
                } else if position.y > self.frame.height - 15 {
                    position.y = self.frame.height - 15
                }
        }

        
        switch sender.state {
        case .began:
            switch orientation {
                case .horizontal:
                    nowPosition = (position.x - 15) / (self.frame.width - 30)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.selectorView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                        self.selectorView.center.x = position.x
                        self.bg2.frame.size.width = position.x

                    })
                case .vertical:
                    nowPosition = (position.y - 15) / (self.frame.height - 30)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.selectorView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                            self.selectorView.center.y = position.y
                       self.bg2.frame.size.height = position.y

                    })
            }
            delegate(nowPosition)
            
        case .changed:
            switch orientation {
            case .horizontal:
                nowPosition = (position.x - 15) / (self.frame.width - 30)
                UIView.animate(withDuration: 0.25, animations: {
                    self.bg2.frame.size.width = position.x
                })
                UIView.animate(withDuration: 0.25, animations: {
                    self.selectorView.center.x = position.x
                })
            case .vertical:
                nowPosition = (position.y - 15) / (self.frame.height - 30)
                UIView.animate(withDuration: 0.25, animations: {
                    self.selectorView.center.y = position.y
                })
                UIView.animate(withDuration: 0.25, animations: {
                    self.bg2.frame.size.height = position.y
                })
            }
            delegate(nowPosition)
          
        case .ended:
            switch orientation {
                case .horizontal:
                    UIView.animate(withDuration: 0.25, animations: {
                        self.selectorView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.selectorView.center.x = position.x
                        //self.bg2.frame.size.width = position.x
                    })
                case .vertical:
                    UIView.animate(withDuration: 0.25, animations: {
                        self.selectorView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.selectorView.center.y = position.y
                        //self.bg2.frame.size.height = position.y
                    })
            }
            delegate(nowPosition)
                
        default:
            break
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
