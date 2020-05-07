//
//  TextFIeld.swift
//  new Testing
//
//  Created by Рустам Хахук on 12.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class TextField : UIView {
    
    private var bgView : UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor(named: "disableColor")!.withAlphaComponent(0.25)
        bg.layer.cornerRadius = 12
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()
    
    var filed : UITextField = {
        let f = UITextField()
        f.textColor = UIColor(named: "enableColor")!
        f.tintColor = UIColor(named: "enableColor")!
        f.font = UIFont(name: "Rubik-Medium", size: 22)
        f.text = "TextTest"
        f.translatesAutoresizingMaskIntoConstraints = false
        f.attributedPlaceholder =
            NSAttributedString(string: "Test", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "disableColor")!])
        return f
    }()
    
    private var errorText : UILabel = {
        let text = UILabel()

        text.text = "Error Text"
        text.font = UIFont(name: "Rubik-Medium", size: 11)
        text.textColor = UIColor(named: "redColor")
        text.alpha = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    private var isSmall = false
    
    var small : Bool {
        get{
            isSmall
        }
        set{
            if newValue{
                self.filed.frame = CGRect(x: 12, y: 4, width: frame.width - 24, height: frame.height - 8)
            } else {
                self.filed.frame = CGRect(x: 12, y: 10, width: frame.width - 24, height: frame.height - 20)
            }
            isSmall = newValue
        }
    }
    
    var error : String? {
        get{
            errorText.text
        }
        set{
            if(newValue != nil){
                errorText.text = newValue
                UIView.animate(withDuration: 0.2){
                    self.filed.frame.origin.y = 0
                    self.errorText.alpha = 1.0
                }
            } else if(errorText.text != ""){
                errorText.text = newValue
                UIView.animate(withDuration: 0.2){
                    self.filed.frame.origin.y = 6
                    self.errorText.alpha = 0.0
                }
            }
        }
    }
    
    var textSize : Int {
        get{
            0
        }
        set{
            filed.font = UIFont(name: "Rubik-Medium", size: CGFloat(newValue))
        }
    }
    
    func setHelpText(help : String) {
        filed.attributedPlaceholder =
            NSAttributedString(string: help, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "disableColor")!])
    }
    
    func setFIeldDelegate(delegate : UITextFieldDelegate){
        filed.delegate = delegate
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        self.addSubview(bgView)
        bgView.addSubview(filed)
        bgView.addSubview(errorText)
    }
    
    override func layoutSubviews() {
        bgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        bgView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        filed.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 12).isActive = true
        filed.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 6).isActive = true
        filed.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -12).isActive = true
        filed.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -6).isActive = true
        
        errorText.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 12).isActive = true
        errorText.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -12).isActive = true
        errorText.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 0).isActive = true
        errorText.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
