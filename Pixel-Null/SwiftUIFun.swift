//
//  SwiftUIFun.swift
//  new Testing
//
//  Created by Рустам Хахук on 13.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

func makeStack(orientation : NSLayoutConstraint.Axis, alignment : UIStackView.Alignment = .center, distribution : UIStackView.Distribution = .equalCentering) -> UIStackView {
    let stack = UIStackView()
    stack.axis = orientation
    stack.alignment = alignment
    stack.distribution = distribution
    stack.translatesAutoresizingMaskIntoConstraints = false
    
    return stack
}

extension UIStackView {
    func addViews(views : [UIView]) -> UIStackView {
        for i in views {
            addArrangedSubview(i)
        }
        
        return self
    }
}
extension UIView {
    
    func setViewSize(size : CGSize) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        return self
    }
    
    func addSubviewFullSize(view : UIView, paddings : (left : CGFloat,right : CGFloat,top : CGFloat,bottom : CGFloat) = (0,0,0,0)) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: paddings.left).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: paddings.right).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: paddings.top).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: paddings.bottom).isActive = true
    }
    
    func Shadow(clr : UIColor, rad : CGFloat, opas : Float) -> UIView{
         self.setShadow(color: clr, radius: rad, opasity: opas)
         return self
     }
    
    func addFullSizeView(view : UIView) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        //view.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true

        return self
    }
}

extension UILabel {
    func setText(text : String) -> UILabel {
        self.text = text
        return self
    }
    
    func addAttributedText(text : String) -> UILabel {
        
        return self
    }
    
    //private func getAttributedText(text : String) -> NSMutableAttributedString {
        
    //}
    
    func setTextColor(color : UIColor) -> UILabel {
        self.textColor = color
        return self
    }
    func setFont(font : UIFont) -> UILabel {
        self.font = font
        return self
    }
    func setBreakMode(mode : NSLineBreakMode) -> UILabel {
        lineBreakMode = mode
        numberOfLines = 0
        textAlignment = .justified

        return self
    }
    func setMaxWidth(width : CGFloat) -> UILabel {
        preferredMaxLayoutWidth = width
        return self
    }
    
    func appendText(text : String, fortt : UIFont, textClr : UIColor? = nil) -> UILabel {
        translatesAutoresizingMaskIntoConstraints = false
        var string = NSMutableAttributedString()
        
        if self.attributedText != nil {
            string = NSMutableAttributedString(attributedString: self.attributedText!)
        }
        
        let color = textClr == nil ? self.textColor : textClr
        
        string.append(NSMutableAttributedString(string:text, attributes:[NSAttributedString.Key.font : fortt, NSAttributedString.Key.foregroundColor : color as Any]))
        
        self.attributedText = string
        
        return self
    }
}

extension UIImageView {
    func setSize(size : CGSize) -> UIImageView {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        return self
    }
    
    func setWidthAnchor(constaint : CGFloat, layout : NSLayoutAnchor<NSLayoutDimension>) -> UIImageView {
        widthAnchor.constraint(equalTo: layout, constant: constaint).isActive = true
        return self
    }
    func setWidthAnchor(multiplier : CGFloat, layout : NSLayoutDimension) -> UIImageView {
           widthAnchor.constraint(equalTo: layout, multiplier: multiplier).isActive = true
           return self
    }
    
    func setHeightAnchor(constaint : CGFloat, layout : NSLayoutAnchor<NSLayoutDimension>) -> UIImageView {
        heightAnchor.constraint(equalTo: layout, constant: constaint).isActive = true
        return self
    }
    func setHeightAnchor(multiplier : CGFloat, layout : NSLayoutDimension) -> UIImageView {
           heightAnchor.constraint(equalTo: layout, multiplier: multiplier).isActive = true
           return self
    }
    
    func setHeight(height : CGFloat) -> UIImageView {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    func setContentMove(mode : UIImageView.ContentMode) -> UIImageView {
        self.contentMode = mode
        return self
    }
    
    func setBackground(color : UIColor) -> UIImageView {
        self.backgroundColor = color
        return self
    }
    
    func setFilter(filter : CALayerContentsFilter) -> UIImageView {
        self.layer.magnificationFilter = filter
        return self
    }
    
    func Corners(round : CGFloat) -> UIImageView {
        self.setCorners(corners: round)
        return self
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
