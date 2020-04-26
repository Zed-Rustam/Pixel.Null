//
//  PalleteEditor.swift
//  new Testing
//
//  Created by Рустам Хахук on 16.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.

import UIKit

class PalleteEditor : UIViewController {
    
    lazy private var colors : PalleteCollectionV2 = {
        let clr = PalleteCollectionV2(colors: pallete.colors)
        clr.translatesAutoresizingMaskIntoConstraints = false
        
        return clr
    }()
    
    lazy private var exitButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero, icScale: 0.35)
        
        btn.delegate = {[unowned self] in
            self.pallete.colors = self.colors.palleteColors
            self.pallete.save()
            self.delegate()
            self.dismiss(animated: true, completion: nil)
        }
        btn.corners = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true

        return btn
    }()
    
    lazy private var palleteBar : UIView = {
       let mainview = UIView()
        mainview.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        let bgView = UIView()
        bgView.backgroundColor = ProjectStyle.uiBackgroundColor
        bgView.setCorners(corners: 8)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
       
        mainview.addSubviewFullSize(view: bgView,paddings: (0,0,0,0))
        bgView.addSubviewFullSize(view: palleteName,paddings: (12,-12,0,0))
        
        return mainview
    }()
    
    lazy private var palleteName : UILabel = {
        let label = UILabel().setTextColor(color: ProjectStyle.uiEnableColor).setFont(font: UIFont(name: "Rubik-Bold", size: 18)!).setText(text: "\(pallete.palleteName)")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        return label
    }()
    
    lazy private var palleteEditBap : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.widthAnchor.constraint(equalToConstant: 156).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        mainView.setShadow(color: ProjectStyle.uiShadowColor, radius: 4, opasity: 0.25)
        
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.setCorners(corners: 12)
        bg.backgroundColor = ProjectStyle.uiBackgroundColor
        mainView.addSubviewFullSize(view: bg)
        
        bg.addSubview(addButton)
        bg.addSubview(editButton)
        bg.addSubview(cloneButton)
        bg.addSubview(deleteButton)
        
        addButton.leftAnchor.constraint(equalTo: bg.leftAnchor, constant: 6).isActive = true
        addButton.topAnchor.constraint(equalTo: bg.topAnchor, constant: 3).isActive = true
        
        editButton.leftAnchor.constraint(equalTo: addButton.rightAnchor, constant: 0).isActive = true
        editButton.topAnchor.constraint(equalTo: bg.topAnchor, constant: 3).isActive = true
        
        cloneButton.leftAnchor.constraint(equalTo: editButton.rightAnchor, constant: 0).isActive = true
        cloneButton.topAnchor.constraint(equalTo: bg.topAnchor, constant: 3).isActive = true
        
        deleteButton.leftAnchor.constraint(equalTo: cloneButton.rightAnchor, constant: 0).isActive = true
        deleteButton.topAnchor.constraint(equalTo: bg.topAnchor, constant: 3).isActive = true

        return mainView
    }()
    
    lazy private var cloneButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "clone_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.colors.moving {
                self.colors.cloneSelectedColor()
            }
        }
        
        return btn
    }()
    
    lazy private var deleteButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "trash_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.setIconColor(color: ProjectStyle.uiRedColor)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.colors.moving {
                self.colors.deleteSelectedColor()
            }
        }
        
        return btn
    }()
    
    lazy private var addButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.colors.moving {
                let palleteSelector = ColorSelectorController()
                
                palleteSelector.delegate = {[unowned self] in
                    self.colors.addColor(color: $0)
                }
                
                self.show(palleteSelector, sender: self)
            }
        }
        
        return btn
    }()
    
    lazy private var editButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "edit_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.colors.moving {
                let palleteSelector = ColorSelectorController()
                palleteSelector.setColor(clr: self.colors.getSelectItemColor())
                
                palleteSelector.delegate = {[unowned self] in
                    self.colors.changeSelectedColor(color: $0)
                }
                
                self.show(palleteSelector, sender: self)
            }
        }
        
        return btn
    }()

    var pallete : PalleteWorker!
    
    var delegate : () -> () = {}
    
    override func viewDidLoad() {
        view.backgroundColor = ProjectStyle.uiBackgroundColor

        view.addSubview(colors)
        view.addSubview(exitButton)
        view.addSubview(palleteBar)
        view.addSubview(palleteEditBap)

        colors.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        colors.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        colors.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        colors.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        palleteBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 6).isActive = true
        palleteBar.rightAnchor.constraint(equalTo: exitButton.leftAnchor, constant: -6).isActive = true
        palleteBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
    
        exitButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -6).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        
        palleteEditBap.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -6).isActive = true
        palleteEditBap.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 6).isActive = true
    }
}
