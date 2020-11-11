//
//  PalleteEditor.swift
//  new Testing
//
//  Created by Рустам Хахук on 16.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.

import UIKit

class PalleteEditor : UIViewController {
    
    lazy private var colors : PaletteCollectionModern = {
        let clr = PaletteCollectionModern(colors: pallete.colors)
        clr.translatesAutoresizingMaskIntoConstraints = false
        
        return clr
    }()
    
    lazy private var exitButton : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "yes"), for: .normal)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.backgroundColor = getAppColor(color: .background)
        
        btn.addTarget(self, action: #selector(onCreate), for: .touchUpInside)
        
        btn.setCorners(corners: 12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
    
    lazy private var errorText: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        lbl.textColor = getAppColor(color: .red)
        
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        lbl.text = ""
        return lbl
    }()
    
    lazy private var palleteName : UITextField = {
        let label = UITextField()
        label.font = UIFont(name: UIFont.appBold, size: 16)
        
        label.text = pallete.palleteName
        label.setCorners(corners: 12)
        label.textColor = getAppColor(color: .enable)
        label.isEnabled = true
        label.backgroundColor = getAppColor(color: .backgroundLight)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        label.delegate = nameDelegate
        
        let leftView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        label.leftViewMode = .always
        label.leftView = leftView
        
        let bar = UIToolbar()
        bar.items = [done,cancel]
        bar.sizeToFit()
        
        label.inputAccessoryView = bar
        
        return label
    }()
    
    let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtn))
    let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelBtn))

    lazy private var palleteEditBap : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.heightAnchor.constraint(equalToConstant: 42 + UIApplication.shared.windows[0].safeAreaInsets.bottom).isActive = true
        
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.setCorners(corners: 12)
        bg.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        bg.backgroundColor = getAppColor(color: .background)
        mainView.addSubviewFullSize(view: bg)
        
        bg.addSubview(addBtn)
        bg.addSubview(editBtn)
        bg.addSubview(cloneBtn)
        bg.addSubview(deleteBtn)
        
        addBtn.leftAnchor.constraint(equalTo: bg.leftAnchor, constant: 6).isActive = true
        addBtn.topAnchor.constraint(equalTo: bg.topAnchor, constant: 3).isActive = true
        
        editBtn.leftAnchor.constraint(equalTo: addBtn.rightAnchor, constant: 0).isActive = true
        editBtn.topAnchor.constraint(equalTo: bg.topAnchor, constant: 3).isActive = true
        
        cloneBtn.leftAnchor.constraint(equalTo: editBtn.rightAnchor, constant: 0).isActive = true
        cloneBtn.topAnchor.constraint(equalTo: bg.topAnchor, constant: 3).isActive = true
        
        deleteBtn.leftAnchor.constraint(equalTo: cloneBtn.rightAnchor, constant: 0).isActive = true
        deleteBtn.topAnchor.constraint(equalTo: bg.topAnchor, constant: 3).isActive = true

        return mainView
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
        if !colors.moving {
            colors.cloneSelectedColor()
        }
    }
    
    lazy private var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "trash_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .red)
        btn.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        return btn
    }()
    
    @objc func onDelete() {
        if !colors.moving {
            colors.deleteSelectedColor()
        }
    }
    
    lazy private var addBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "add_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.addTarget(self, action: #selector(onAdd), for: .touchUpInside)
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        return btn
    }()
    
    @objc func onAdd() {
        if !colors.moving {
            let palleteSelector = ColorDialogController()
            palleteSelector.delegate = {[unowned self] in
                if !self.colors.moving {
                    self.colors.addColor(color: $0)
                }
            }
            
            present(palleteSelector, animated: true, completion: nil)
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
        if !colors.moving {
            let palleteSelector = ColorDialogController()
            palleteSelector.setStartColor(clr: colors.getSelectItemColor())
            
            palleteSelector.delegate = {[unowned self] in
                self.colors.changeSelectedColor(color: $0)
            }
            present(palleteSelector, animated: true, completion: nil)
        }
    }

    lazy private var nameDelegate : TextFieldDelegate = {
       let del = TextFieldDelegate(method: {[unowned self] in
            if $0.text == "" {
                self.exitButton.isEnabled = false
                self.done.isEnabled = false
                self.exitButton.imageView?.tintColor = getAppColor(color: .disable)
                self.errorText.text = ""
            } else if self.getProjects().contains("\($0.text!).pnpalette") && $0.text! != self.pallete.palleteName {
                self.errorText.text = "A pallete with this name already exists"
                self.exitButton.isEnabled = false
                self.exitButton.imageView?.tintColor = getAppColor(color: .disable)
                self.done.isEnabled = false
            } else {
                self.errorText.text = ""
                self.exitButton.isEnabled = true
                self.exitButton.imageView?.tintColor = getAppColor(color: .enable)
                self.done.isEnabled = true
            }
        })
        
        return del
    }()
    
    var pallete : PalleteWorker!
    
    var delegate : () -> () = {}
    
    
    @objc func onCreate() {
        pallete.rename(newName: palleteName.text!)
        pallete.colors = colors.palleteColors
        pallete.save()
        delegate()
        dismiss(animated: true, completion: nil)
    }
    
    private func getProjects() -> [String] {
        do{
            let projs = try FileManager.default.contentsOfDirectory(at: PalleteWorker.getDocumentsDirectory(), includingPropertiesForKeys: nil)
                   
                   var names : [String] = []
                   
                   for i in 0..<projs.count  {
                       let name = projs[i].lastPathComponent
                       names.append(name)
                   }
                   
                    print(names)
                    return names
        } catch {
            return []
        }
    }

    @objc func doneBtn() {
        palleteName.endEditing(true)
        self.exitButton.isEnabled = true
        exitButton.imageView?.tintColor = getAppColor(color: .enable)
    }
    
    @objc func cancelBtn(){
        palleteName.text = pallete.palleteName
        palleteName.endEditing(true)
        self.exitButton.isEnabled = true
        errorText.text = ""
        exitButton.imageView?.tintColor = getAppColor(color: .enable)
    }
    
    override func viewDidLayoutSubviews() {
        palleteEditBap.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        palleteEditBap.layer.shadowPath = UIBezierPath(roundedRect: palleteEditBap.bounds, cornerRadius: 12).cgPath
        
        exitButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        exitButton.layer.shadowPath = UIBezierPath(roundedRect: exitButton.bounds, cornerRadius: 12).cgPath
    }
    
    override func viewDidAppear(_ animated: Bool) {
        colors.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        view.setCorners(corners: 24)
        
        view.addSubview(colors)
        view.addSubview(exitButton)
        view.addSubview(palleteName)
        view.addSubview(errorText)
        view.addSubview(palleteEditBap)
        
        colors.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        colors.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        colors.topAnchor.constraint(equalTo: palleteName.bottomAnchor, constant: 24).isActive = true
        colors.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        palleteName.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        palleteName.rightAnchor.constraint(equalTo: exitButton.leftAnchor, constant: -12).isActive = true
        palleteName.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true

        errorText.leftAnchor.constraint(equalTo: palleteName.leftAnchor,constant: 12).isActive = true
        errorText.rightAnchor.constraint(equalTo: palleteName.rightAnchor).isActive = true
        errorText.topAnchor.constraint(equalTo: palleteName.bottomAnchor).isActive = true

        exitButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        
        palleteEditBap.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        palleteEditBap.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
       
        palleteEditBap.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}
