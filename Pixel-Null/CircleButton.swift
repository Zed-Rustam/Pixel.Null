//
//  CircleButton.swift
//  new Testing
//
//  Created by Рустам Хахук on 05.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class CircleButton : UIView, UIGestureRecognizerDelegate {
    private var icon = UIImageView()
    private var bg = UIView()
    
    private var enabled = true
    var longPressDelegate : ()->() = {}
    
    var delegate : ()->() = {}
    private var panGesture : UILongPressGestureRecognizer!
    
    private var shadowColor : UIColor = UIColor(named: "shadowColor")!
    private var iconColor : UIColor = UIColor(named: "enableColor")!

    private var longPanGesture : UILongPressGestureRecognizer!
    
    private var iconScale : CGFloat = 0.5
    
    var isEnabled : Bool {
        get{
            enabled
        }
        set {
            enabled = newValue
            UIView.animate(withDuration: 0.2, animations: {
                switch newValue {
                case true:
                    self.icon.tintColor = self.iconColor
                case false:
                    self.icon.tintColor = UIColor(named: "disableColor")!
                }
            })
            
        }
    }

    var corners : CGFloat {
        get{
            return bg.layer.cornerRadius
        } set {
            bg.setCorners(corners: newValue)
        }
    }
    
    func setbgColor(color : UIColor){
        bg.backgroundColor = color
    }
    
    func setShadowColor(color : UIColor){
        shadowColor = color
    }
    
    func setIconColor(color : UIColor){
        iconColor = color
        self.icon.tintColor = self.iconColor
    }
    
    func setIcon(ic : UIImage){
        icon.image = ic.withRenderingMode(.alwaysTemplate)
    }
    
    init(icon ic : UIImage,frame: CGRect, icScale : CGFloat = 0.5) {
        //bg = UIView(frame: frame)
        
        super.init(frame: frame)
        
        iconScale = icScale
        
        addSubview(bg)
        addSubview(icon)

        bg.backgroundColor = UIColor(named: "backgroundColor")!
        
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        bg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        bg.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        icon.image = ic.withRenderingMode(.alwaysTemplate)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        icon.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        icon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: iconScale).isActive = true
        icon.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: iconScale).isActive = true
        
        bg.setCorners(corners: 18)


        isEnabled = true
        
        //setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 1, offset: .zero)
        
        self.isUserInteractionEnabled = true

        panGesture = UILongPressGestureRecognizer(target: self, action: #selector(tap(sender:)))
        panGesture.minimumPressDuration = 0
        panGesture.delegate = self
        
        longPanGesture = UILongPressGestureRecognizer(target: self, action: #selector(longtap(sender:)))
        longPanGesture.minimumPressDuration = 0.25
        longPanGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(longPanGesture)

    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        self.setShadow(color: shadowColor, radius: 8, opasity: 1)
        self.icon.tintColor = self.iconColor
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    @objc func tap(sender : UILongPressGestureRecognizer) {

        switch sender.state {
        case .began:
            if(enabled) {
                UIView.animate(withDuration: 0.25){
                    self.icon.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                }
            }
        case .changed:
            if !self.bounds.contains(sender.location(in: self)) {
                UIView.animate(withDuration: 0.25){
                    self.icon.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            } else {
                UIView.animate(withDuration: 0.25){
                    self.icon.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                }
            }
        case .ended:
            if(enabled && self.bounds.contains(sender.location(in: self))) {
                UIView.animate(withDuration: 0.25){
                    self.icon.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                delegate()
            }
        case .cancelled:
            UIView.animate(withDuration: 0.25){
                self.icon.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        default:
            break
        }
    }
    
    @objc func longtap(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            print("long")
            longPressDelegate()
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
