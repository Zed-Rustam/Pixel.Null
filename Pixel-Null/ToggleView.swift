//
//  ToggleView.swift
//  new Testing
//
//  Created by Рустам Хахук on 02.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ToggleView : UIView {
    private var check = false
    
    var isCheck : Bool {
        get{
            return check
        }
        set{
            check = newValue
            checkChange()
        }
    }
    var delegate : (Bool)->() = {isCheck in}
    
    lazy private var selectorView : UIView = {
        var mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        var innerView = UIView()
        innerView.setCorners(corners: 12)

        mainView.addSubview(innerView)
        
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        innerView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        innerView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        innerView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        innerView.backgroundColor = getAppColor(color: .enable)
        
        mainView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return mainView
    }()
    
    lazy private var bgView : UIView = {
        let view = UIView()
        view.setCorners(corners: 6)
        view.backgroundColor =  getAppColor(color: .backgroundLight)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy private var tapGesture : UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        return gest
    }()
    
    @objc private func onTap(sender : UITapGestureRecognizer) {
        check.toggle()
        checkChange()
        delegate(check)
    }
    
    func checkChange(){
        layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.bgView.backgroundColor = self.check ? getAppColor(color: .enable) : getAppColor(color: .backgroundLight)
            self.selectorView.frame.origin.x = self.check ? self.frame.width - self.selectorView.frame.width : 0
        })
    }
    
    init(){
        super.init(frame : .zero)
        addGestureRecognizer(tapGesture)
        addSubview(bgView)
        addSubview(selectorView)
        
        bgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bgView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bgView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        
        selectorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        selectorView.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 48).isActive = true
        heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectorView.frame.origin.x = self.check ? self.frame.width - self.selectorView.frame.width : 0
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

