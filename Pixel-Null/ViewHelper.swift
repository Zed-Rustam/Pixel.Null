//
//  ViewHelper.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 15.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

extension UIView {
    func StrokeAnimate(duration : Double = 0, width : CGFloat, repeats : Float = 1){
       if duration == 0 {
           CATransaction.begin()
           CATransaction.setAnimationDuration(0)
       } else {
            let animation = CABasicAnimation(keyPath: "borderWidth")
            animation.fromValue = layer.borderWidth
            animation.toValue = width
            animation.duration = duration
            animation.repeatCount = repeats
            
            layer.add(animation, forKey: "borderAnimation")
        }
        layer.borderWidth = width
        if duration == 0 {
            CATransaction.commit()
        }
    }
    
    func ShadowColorAnimate(duration : Double = 0, color : UIColor, repeats : Float = 1){
         if duration == 0 {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
        } else {
            let animation = CABasicAnimation(keyPath: "shadowColor")
            animation.fromValue = layer.shadowColor!
            animation.toValue = color.cgColor
            animation.duration = duration
            animation.repeatCount = repeats
            
            layer.add(animation, forKey: "shadowColorAnimation")
        }
        layer.shadowColor = color.cgColor
        if duration == 0 {
            CATransaction.commit()
        }
    }
    
    func ShadowRadiusAnimate(duration : Double = 0.0, radius : CGFloat, repeats : Float = 1){
        if duration == 0.0 {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
                   
        } else {
            let animation = CABasicAnimation(keyPath: "shadowRadius")
            animation.fromValue = layer.shadowRadius
            animation.toValue = radius
            animation.duration = duration
            animation.repeatCount = repeats
            layer.add(animation, forKey: "shadowRadiusAnimation")
        }

        layer.shadowRadius = radius
        
        if duration == 0.0 {
            CATransaction.commit()
        }
    }
    
    func setShadow(color : UIColor, radius : CGFloat, opasity : Float, offset : CGSize = .zero){
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opasity
    }
    
    func setCorners(corners : CGFloat){
        layer.cornerRadius = corners
        layer.masksToBounds = true
    }
}

