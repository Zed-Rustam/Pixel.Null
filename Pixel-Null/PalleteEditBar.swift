//
//  PalleteEditBar.swift
//  new Testing
//
//  Created by Рустам Хахук on 18.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalleteEditBar : UIView {
    lazy private var bg : UIView = {
        let bgView = UIView()
        bgView.backgroundColor = ProjectStyle.uiBackgroundColor
        bgView.layer.cornerRadius = 16
        bgView.layer.masksToBounds = true
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        return bgView
    }()
    
    lazy private var addColor : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.delegate = {[weak self] in
            if !self!.list!.isMove {
                self!.colorPicker.setColor(clr: .clear)
                self!.colorPicker.delegate = {[weak self] in
                    self!.delegate?.addColor(color: 0, newValue: UIColor.toHex(color: $0))
                }
                self!.controller?.show(self!.colorPicker, sender: nil)
            }
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        return btn
    }()
    
    lazy private var cloneColor : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "clone_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.delegate = {[weak self] in
            if !self!.list!.isMove {
                self!.delegate?.cloneColor(color: self!.list!.select)
            }
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        return btn
    }()
    
    lazy private var editColor : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "edit_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.delegate = {[weak self] in
            if !self!.list!.isMove {
                self!.colorPicker.setColor(clr: UIColor(hex: self!.pallete!.colorPallete.colors[self!.list!.select])!)
                self!.colorPicker.delegate = {[weak self] in
                    self!.delegate?.changeColor(color: self!.list!.select, newValue: UIColor.toHex(color: $0))
                }
                self!.controller?.show(self!.colorPicker, sender: nil)
            }
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        return btn
    }()
    lazy private var deleteColor : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "trash_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.setIconColor(color: ProjectStyle.uiRedColor)
        
        btn.delegate = {[weak self] in
            if !self!.list!.isMove {
                self!.delegate?.deleteColor(color: self!.list!.select)
            }
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        return btn
    }()
    private var colorPicker = ColorSelectorController()
    
    weak var pallete : PalleteWorker? = nil
    weak var delegate : PalleteEditorDelegate? = nil
    weak var controller : UIViewController? = nil
    weak var list : GridCollection? = nil
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(bg)
        
        setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        
        bg.addSubview(addColor)
        bg.addSubview(cloneColor)
        bg.addSubview(editColor)
        bg.addSubview(deleteColor)
        
        bg.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bg.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        bg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        addColor.leftAnchor.constraint(equalTo: bg.leftAnchor, constant: 6).isActive = true
        addColor.topAnchor.constraint(equalTo: bg.topAnchor, constant: 6).isActive = true
        
        cloneColor.leftAnchor.constraint(equalTo: addColor.rightAnchor, constant: 0).isActive = true
        cloneColor.topAnchor.constraint(equalTo: bg.topAnchor, constant: 6).isActive = true
        
        editColor.leftAnchor.constraint(equalTo: cloneColor.rightAnchor, constant: 0).isActive = true
        editColor.topAnchor.constraint(equalTo: bg.topAnchor, constant: 6).isActive = true
        
        deleteColor.leftAnchor.constraint(equalTo: editColor.rightAnchor, constant: 0).isActive = true
        deleteColor.topAnchor.constraint(equalTo: bg.topAnchor, constant: 6).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
