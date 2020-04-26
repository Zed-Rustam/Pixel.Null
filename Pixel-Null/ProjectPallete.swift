//
//  ProjectPallete.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 24.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectPallete : UIViewController {
    weak var project : ProjectWork? = nil
    
    var startColor : UIColor? = nil
    
    var selectDelegate : (UIColor) -> () = {color in}
    
    lazy private var palleteBar : UIView = {
       let mainview = UIView()
        mainview.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        mainview.translatesAutoresizingMaskIntoConstraints = false
        
        
        let bgView = UIView()
        bgView.backgroundColor = ProjectStyle.uiBackgroundColor
        bgView.setCorners(corners: 8)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        mainview.addSubview(selectBtn)
        selectBtn.rightAnchor.constraint(equalTo: mainview.rightAnchor, constant: 0).isActive = true
        selectBtn.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true
        
        mainview.addSubview(bgView)
        bgView.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 0).isActive = true
        bgView.rightAnchor.constraint(equalTo: selectBtn.leftAnchor, constant: -6).isActive = true
        bgView.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: mainview.bottomAnchor, constant: 0).isActive = true

        let openPalletesBtn = CircleButton(icon: #imageLiteral(resourceName: "pallete_collection_item"), frame: .zero)
        openPalletesBtn.translatesAutoresizingMaskIntoConstraints = false
        openPalletesBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        openPalletesBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        openPalletesBtn.setShadowColor(color: .clear)
        
        bgView.addSubview(openPalletesBtn)
        openPalletesBtn.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 3).isActive = true
        openPalletesBtn.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 3).isActive = true
        
        bgView.addSubview(palleteName)
        palleteName.leftAnchor.constraint(equalTo: openPalletesBtn.rightAnchor, constant: 3).isActive = true
        palleteName.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -12).isActive = true
        palleteName.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 0).isActive = true
        
        return mainview
    }()
    
    lazy private var palleteName : UILabel = {
        let label = UILabel().setTextColor(color: ProjectStyle.uiEnableColor).setFont(font: UIFont(name: "Rubik-Bold", size: 18)!).setText(text: "Project's Pallete")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        return label
    }()
    
    lazy private var selectBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero, icScale: 0.33)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.corners = 8
        btn.delegate = {[unowned self] in
            self.selectDelegate(self.color.color)
            self.project!.projectPallete = self.collection.palleteColors
            
            self.dismiss(animated: true, completion: nil)
        }
        
        return btn
    }()
    
    lazy private var collection : PalleteCollectionV2 = {
        let colors = PalleteCollectionV2(colors : project!.information.pallete.colors)
        
        return colors
    }()
    
    lazy private var selectedColor : UIView = {
        let main = UIView()
        main.translatesAutoresizingMaskIntoConstraints = false
        main.heightAnchor.constraint(equalToConstant: 42).isActive = true
        main.widthAnchor.constraint(equalToConstant: 84).isActive = true
        main.setShadow(color: ProjectStyle.uiShadowColor, radius: 4, opasity: 0.25)
        
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = ProjectStyle.uiBackgroundColor
        bg.setCorners(corners: 12)
        
        main.addSubview(bg)
        bg.leftAnchor.constraint(equalTo: main.leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: main.rightAnchor, constant: 0).isActive = true
        bg.bottomAnchor.constraint(equalTo: main.bottomAnchor, constant: 0).isActive = true
        bg.topAnchor.constraint(equalTo: main.topAnchor, constant: 0).isActive = true

        bg.addSubview(color)
        bg.addSubview(saveButton)
        
        color.centerYAnchor.constraint(equalTo: bg.centerYAnchor, constant: 0).isActive = true
        color.leftAnchor.constraint(equalTo: bg.leftAnchor, constant: 3).isActive = true
        
        saveButton.centerYAnchor.constraint(equalTo: bg.centerYAnchor, constant: 0).isActive = true
        saveButton.leftAnchor.constraint(equalTo: color.rightAnchor, constant: 6).isActive = true

        return main
    }()
    
    lazy private var color : ColorSelector = {
        let clr = ColorSelector()
        clr.translatesAutoresizingMaskIntoConstraints = false
        clr.widthAnchor.constraint(equalToConstant: 36).isActive = true
        clr.heightAnchor.constraint(equalToConstant: 36).isActive = true
        clr.color = startColor ?? .clear
        
        clr.delegate = {[unowned self] in
            if !self.collection.moving {
                let palleteSelect = ColorSelectorController()
                palleteSelect.modalPresentationStyle = .pageSheet
                palleteSelect.setColor(clr: clr.color)
                palleteSelect.delegate = {color in
                    clr.color = color
                }
                
                self.show(palleteSelect, sender: self)
            }
        }
        return clr
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
            if !self.collection.moving {
                self.collection.cloneSelectedColor()
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
            if !self.collection.moving {
                self.collection.deleteSelectedColor()
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
            if !self.collection.moving {
                let palleteSelector = ColorSelectorController()
                
                palleteSelector.delegate = {[unowned self] in
                    self.collection.addColor(color: $0)
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
            if !self.collection.moving {
                let palleteSelector = ColorSelectorController()
                palleteSelector.setColor(clr: self.collection.getSelectItemColor())
                
                palleteSelector.delegate = {[unowned self] in
                    self.collection.changeSelectedColor(color: $0)
                }
                
                self.show(palleteSelector, sender: self)
            }
        }
        
        return btn
    }()

    lazy private var saveButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "save_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.collection.moving {
                self.collection.addColor(color: self.color.color)
            }
        }
        
        return btn
    }()

    override func viewDidLoad() {
        view.addSubview(collection)
        view.addSubview(palleteBar)
        view.addSubview(selectedColor)
        view.addSubview(palleteEditBap)

        collection.colorDelegate = {[unowned self] in
            self.color.color = $0
        }
        
        
        palleteBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        palleteBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        palleteBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        palleteBar.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        collection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        collection.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        selectedColor.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        selectedColor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6).isActive = true

        palleteEditBap.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        palleteEditBap.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6).isActive = true

        view.backgroundColor = ProjectStyle.uiBackgroundColor
    }
}
