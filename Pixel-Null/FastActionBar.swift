//
//  FastActionBar.swift
//  new Testing
//
//  Created by Рустам Хахук on 14.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FastActionBar : UIView {
    
    private var hide = true
    
    var isHide: Bool {
        get{
            return hide
        }
    }
    
    lazy private var bgView : UIView = {
       let view = UIView()
        view.backgroundColor = getAppColor(color: .background)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCorners(corners: 16)
        
        
        
        view.addSubview(stack)
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        stack.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -12).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true

        return view
    }()
    
    lazy private var stack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.heightAnchor.constraint(equalToConstant: 36).isActive = true
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    func updateButtons(btns : [UIView]){
        if btns.count == 0 {
            hide = true
            UIView.animate(withDuration: 0.2, animations: {
                self.frame.origin.y = 96
            })
        } else {
            if hide {
                stack.removeAllArrangedSubviews()
                btns.forEach({
                    self.stack.addArrangedSubview($0)
                })
                hide = false
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.frame.origin.y = 0
                })
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.frame.origin.y = 96
                },completion: {isEnd in
                    self.stack.removeAllArrangedSubviews()
                    btns.forEach({
                        self.stack.addArrangedSubview($0)
                    })
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        self.frame.origin.y = 0
                    })
                })
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 96).isActive = true

        addSubview(bgView)
        bgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bgView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bgView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        //setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
    }
    
    override func tintColorDidChange() {
        //setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
