//
//  SegmentSelector.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 30.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SegmentSelector : UIView {
    
    var select : Int {
        get{
           return selectedIndex
        }
        set{
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.images[self.selectedIndex].tintColor = UIColor(named: "enableColor")
                self.images[self.selectedIndex].transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
            
            selectedIndex = newValue
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.images[self.selectedIndex].tintColor = UIColor(named: "selectColor")
                self.images[self.selectedIndex].transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)

            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.selectBg.frame.origin.x = CGFloat((self.selectedIndex) * 36)
            }, completion: nil)
        }
    }
    
    var selectDelegate : (Int) -> () = {sel in}
    
    lazy private var gesture : UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        
        return gest
    }()
    
    private var images : [UIImageView] = []
    
    lazy private var bg : UIView = {
       let bgview = UIView()
        bgview.translatesAutoresizingMaskIntoConstraints = false
        bgview.backgroundColor = UIColor(named: "disableColor")!.withAlphaComponent(0.25)
        bgview.layer.masksToBounds = false
        bgview.layer.cornerRadius = 12
        
        bgview.addSubview(selectBg)
        selectBg.frame.origin = .zero
        
        bgview.addSubview(imageStack)
        imageStack.leftAnchor.constraint(equalTo: bgview.leftAnchor, constant: 0).isActive = true
        imageStack.rightAnchor.constraint(equalTo: bgview.rightAnchor, constant: 0).isActive = true
        imageStack.topAnchor.constraint(equalTo: bgview.topAnchor, constant: 0).isActive = true
        imageStack.bottomAnchor.constraint(equalTo: bgview.bottomAnchor, constant: 0).isActive = true
        
       
        
        return bgview
    }()
    
    lazy private var selectBg : UIView = {
        let mainView = UIView()

       let v = UIView()
        v.frame.size = CGSize(width: 36, height: 36)
        
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 12
            
        v.backgroundColor = UIColor(named: "backgroundColor")
        
               
               
        mainView.addSubview(v)
        v.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        v.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        v.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        v.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        
        return mainView
    }()
    
    lazy private var imageStack : UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.distribution = .fillEqually
        
        for i in images {
            stack.addArrangedSubview(i)
        }
        
        return stack
    }()
    
    private var selectedIndex = 0
    
    @objc func onTap(sender : UITapGestureRecognizer) {
        if sender.state == .ended && Int(sender.location(in: self).x / 36.0) != selectedIndex{
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.images[self.selectedIndex].tintColor = UIColor(named: "enableColor")
                self.images[self.selectedIndex].transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
            
            selectedIndex = Int(sender.location(in: self).x / 36.0)
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.images[self.selectedIndex].tintColor = UIColor(named: "selectColor")
                self.images[self.selectedIndex].transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)

            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.selectBg.frame.origin.x = CGFloat((self.selectedIndex) * 36)
            }, completion: nil)
            
            selectDelegate(selectedIndex)
        }
    }
    
    init(imgs : [UIImage]){
        super.init(frame: .zero)
        
        for i in imgs {
            let imgview = UIImageView(image: i.withRenderingMode(.alwaysTemplate))
            imgview.contentMode = .scaleAspectFit
            imgview.translatesAutoresizingMaskIntoConstraints = false
            imgview.heightAnchor.constraint(equalToConstant: 20).isActive = true
            imgview.tintColor = UIColor(named: "enableColor")
            imgview.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            images.append(imgview)
        }
        select = 0
        
        addSubview(bg)
        bg.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bg.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        bg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 36).isActive = true
        widthAnchor.constraint(equalToConstant: CGFloat(36 * images.count)).isActive = true
        
        addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        selectBg.setShadow(color: UIColor(named: "shadowColor")!, radius: 4, opasity: 1)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

