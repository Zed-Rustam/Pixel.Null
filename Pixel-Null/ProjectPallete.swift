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
        
        view.addSubview(addBtn)
        view.addSubview(editBtn)
        view.addSubview(cloneBtn)
        view.addSubview(deleteBtn)
        view.addSubview(color)
        view.addSubview(saveBtn)
        
        color.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        color.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
        
        saveBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        saveBtn.leftAnchor.constraint(equalTo: color.rightAnchor, constant: 6).isActive = true
        
        addBtn.rightAnchor.constraint(equalTo: editBtn.leftAnchor, constant: 0).isActive = true
        addBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        
        editBtn.rightAnchor.constraint(equalTo: cloneBtn.leftAnchor, constant: 0).isActive = true
        editBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        
        cloneBtn.rightAnchor.constraint(equalTo: deleteBtn.leftAnchor, constant: 0).isActive = true
        cloneBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        
        deleteBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        deleteBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true

        return view
    }()
    
    lazy private var selectBtn: UIButton = {
        let openPalletesBtn = UIButton()
        openPalletesBtn.translatesAutoresizingMaskIntoConstraints = false
        openPalletesBtn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        openPalletesBtn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        openPalletesBtn.setImage(#imageLiteral(resourceName: "Palette").withRenderingMode(.alwaysTemplate), for: .normal)
        openPalletesBtn.imageView?.tintColor = getAppColor(color: .enable)
        openPalletesBtn.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        openPalletesBtn.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        
        return openPalletesBtn
    }()
    
    lazy private var palleteName: UILabel = {
        let label = UILabel().setTextColor(color: getAppColor(color: .enable)).setFont(font: UIFont.systemFont(ofSize: 32, weight: .black)).setText(text: "Palette")
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
    
    lazy private var cloneBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "clone_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.addTarget(self, action: #selector(onClone), for: .touchUpInside)
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        return btn
    }()
    
    @objc func onClone() {
        if !collection.moving {
            collection.cloneSelectedColor()
            project!.projectPallete = collection.palleteColors
        }
    }
    
    lazy private var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "trash_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .red)
        btn.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        return btn
    }()
    
    @objc func onDelete() {
        if !collection.moving {
            collection.deleteSelectedColor()
            project!.projectPallete = collection.palleteColors
        }
    }
    
    lazy private var addBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "center_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.addTarget(self, action: #selector(onAdd), for: .touchUpInside)
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        return btn
    }()
    
    @objc func onAdd() {
        if !collection.moving {
            let palleteSelector = ColorDialogController()
            palleteSelector.modalPresentationStyle = .formSheet
            palleteSelector.delegate = {[unowned self] in
                self.collection.addColor(color: $0)
                self.project!.projectPallete = self.collection.palleteColors
            }
            
            show(palleteSelector, sender: self)
        }
    }
    
    lazy private var editBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "edit_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.addTarget(self, action: #selector(onEdit), for: .touchUpInside)
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        return btn
    }()
    
    @objc func onEdit() {
        if !collection.moving {
            let palleteSelector = ColorDialogController()
            palleteSelector.modalPresentationStyle = .formSheet
            palleteSelector.setStartColor(clr: collection.getSelectItemColor())
            
            palleteSelector.delegate = {[unowned self] in
                self.collection.changeSelectedColor(color: $0)
                self.project!.projectPallete = self.collection.palleteColors
            }
            
            show(palleteSelector, sender: self)
        }
    }
    
    lazy private var saveBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "save_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.addTarget(self, action: #selector(onSave), for: .touchUpInside)
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        return btn
    }()
    
    @objc func onSave() {
        if !collection.moving {
            collection.addColor(color: color.color)
            project!.projectPallete = collection.palleteColors
        }
    }

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
