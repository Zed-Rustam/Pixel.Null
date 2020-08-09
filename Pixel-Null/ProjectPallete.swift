//
//  ProjectPallete.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 24.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectPallete: UIViewController {
    weak var project: ProjectWork? = nil
    
    var startColor: UIColor? = nil
    
    var selectDelegate: (UIColor) -> () = {color in}
    
    lazy private var toolBar: UIView = {
        let view = UIView()
        view.backgroundColor = getAppColor(color: .background)
        view.setCorners(corners: 12)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addButton)
        view.addSubview(editButton)
        view.addSubview(cloneButton)
        view.addSubview(deleteButton)
        view.addSubview(color)
        view.addSubview(saveButton)
        
        color.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        color.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        saveButton.leftAnchor.constraint(equalTo: color.rightAnchor, constant: 6).isActive = true
        
        addButton.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: 0).isActive = true
        addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        
        editButton.rightAnchor.constraint(equalTo: cloneButton.leftAnchor, constant: 0).isActive = true
        editButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        
        cloneButton.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: 0).isActive = true
        cloneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        
        deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        deleteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true

        return view
    }()
    
    lazy private var selectBtn: UIButton = {
        let openPalletesBtn = UIButton()
        openPalletesBtn.translatesAutoresizingMaskIntoConstraints = false
        openPalletesBtn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        openPalletesBtn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        openPalletesBtn.setImage(#imageLiteral(resourceName: "pallete_collection_item").withRenderingMode(.alwaysTemplate), for: .normal)
        openPalletesBtn.imageView?.tintColor = getAppColor(color: .enable)
        openPalletesBtn.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        openPalletesBtn.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        
        return openPalletesBtn
    }()
    
    lazy private var palleteName: UILabel = {
        let label = UILabel().setTextColor(color: getAppColor(color: .enable)).setFont(font: UIFont(name: "Rubik-Bold", size: 32)!).setText(text: "Palette")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        return label
    }()
    
    lazy private var collection: PaletteCollectionModern = {
        let colors = PaletteCollectionModern(colors : project!.information.pallete.colors)
        colors.translatesAutoresizingMaskIntoConstraints = false
        
        colors.replaceColorsDelegate = {
            self.project!.projectPallete = self.collection.palleteColors
        }
        
        return colors
    }()
    
    lazy private var color: ColorSelector = {
        let clr = ColorSelector()
        clr.translatesAutoresizingMaskIntoConstraints = false
        clr.widthAnchor.constraint(equalToConstant: 36).isActive = true
        clr.heightAnchor.constraint(equalToConstant: 36).isActive = true
        clr.color = startColor ?? .clear
        
        clr.delegate = {[unowned self] in
            if !self.collection.moving {
                let palleteSelect = ColorDialogController()
                palleteSelect.modalPresentationStyle = .formSheet
                palleteSelect.setStartColor(clr: clr.color)
                palleteSelect.delegate = {color in
                    clr.color = color
                    self.selectDelegate(self.color.color)
                }
                
                self.show(palleteSelect, sender: self)
            }
        }
        return clr
    }()
    
    lazy private var cloneButton: CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "clone_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.collection.moving {
                self.collection.cloneSelectedColor()
                self.project!.projectPallete = self.collection.palleteColors
            }
        }
        
        return btn
    }()
    
    lazy private var deleteButton: CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "trash_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.setIconColor(color: UIColor(named: "redColor")!)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.collection.moving {
                self.collection.deleteSelectedColor()
                self.project!.projectPallete = self.collection.palleteColors
            }
        }
        
        return btn
    }()
    
    lazy private var addButton: CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.collection.moving {
                let palleteSelector = ColorDialogController()
                palleteSelector.modalPresentationStyle = .formSheet
                palleteSelector.delegate = {[unowned self] in
                    self.collection.addColor(color: $0)
                    self.project!.projectPallete = self.collection.palleteColors
                }
                
                self.show(palleteSelector, sender: self)
            }
        }
        
        return btn
    }()
    
    lazy private var editButton: CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "edit_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.collection.moving {
                let palleteSelector = ColorDialogController()
                palleteSelector.modalPresentationStyle = .formSheet
                palleteSelector.setStartColor(clr: self.collection.getSelectItemColor())
                
                palleteSelector.delegate = {[unowned self] in
                    self.collection.changeSelectedColor(color: $0)
                    self.project!.projectPallete = self.collection.palleteColors
                }
                
                self.show(palleteSelector, sender: self)
            }
        }
        
        return btn
    }()

    lazy private var saveButton: CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "save_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.delegate = {[unowned self] in
            if !self.collection.moving {
                self.collection.addColor(color: self.color.color)
                self.project!.projectPallete = self.collection.palleteColors
            }
        }
        
        return btn
    }()
    
    @objc func onPress() {
        let selector = PeletteSelectController()
        selector.modalPresentationStyle = .formSheet
        selector.selectDelegate = {[unowned self] palette,name in
            self.collection.palleteColors = palette.colors
            self.collection.reloadData()
            self.project!.projectPallete = self.collection.palleteColors
        }
        self.show(selector, sender: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        toolBar.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        toolBar.layer.shadowPath = UIBezierPath(roundedRect: toolBar.bounds, cornerRadius: 12).cgPath
    }

    override func viewDidLoad() {
        view.setCorners(corners: 32)
        
        view.addSubview(collection)
        view.addSubview(palleteName)
        view.addSubview(selectBtn)
        view.addSubview(toolBar)
        
        toolBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        toolBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: UIApplication.shared.windows[0].safeAreaInsets.bottom + 48).isActive = true
        
        
        collection.colorDelegate = {[unowned self] in
            self.color.color = $0
            self.selectDelegate(self.color.color)
        }
        
        palleteName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        palleteName.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        
        selectBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        selectBtn.centerYAnchor.constraint(equalTo: palleteName.centerYAnchor, constant: 0).isActive = true

        collection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collection.topAnchor.constraint(equalTo: palleteName.bottomAnchor, constant: 12).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        collection.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
}
