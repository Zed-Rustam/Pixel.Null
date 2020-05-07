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

    lazy private var renameButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "edit_icon"), frame: .zero, icScale: 0.35)
        
        btn.delegate = {[unowned self] in
            self.palleteName.filed.isEnabled = true
            self.palleteName.filed.becomeFirstResponder()
            self.exitButton.isEnabled = false
        }
        
        btn.corners = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true

        return btn
    }()
    
    lazy private var palleteBar : UIView = {
       let mainview = UIView()
        //mainview.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor(named : "backgroundColor")
        bgView.setCorners(corners: 8)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
       
        mainview.addSubviewFullSize(view: bgView,paddings: (0,0,0,0))
        bgView.addSubviewFullSize(view: palleteName,paddings: (0,0,0,0))
        
        return mainview
    }()
    
    lazy private var palleteName : TextField = {
        let label = TextField()
        label.filed.font = UIFont(name: "Rubik-Bold", size: 20)
        label.filed.text = pallete.palleteName
        label.subviews[0].setCorners(corners: 8)
        label.filed.isEnabled = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        label.filed.delegate = nameDelegate
        
        let bar = UIToolbar()
        bar.items = [done,cancel]
        bar.sizeToFit()
        
        label.filed.inputAccessoryView = bar
        
        return label
    }()
    
    let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtn))
    let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelBtn))

    lazy private var palleteEditBap : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.widthAnchor.constraint(equalToConstant: 156).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.setCorners(corners: 12)
        bg.backgroundColor = UIColor(named : "backgroundColor")
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
        btn.setIconColor(color: getAppColor(color: .red))
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

    lazy private var nameDelegate : TextFieldDelegate = {
       let del = TextFieldDelegate(method: {[weak self] in
            if $0.text == "" {
                self!.done.isEnabled = false
                self!.palleteName.error = nil
            } else if self!.getProjects().contains($0.text!) && $0.text! != self!.pallete.palleteName {
                self!.palleteName.error = "A pallete with this name already exists"
                self!.done.isEnabled = false
            } else {
                self!.palleteName.error = nil
                self!.done.isEnabled = true
            }
        })
        
        return del
    }()
    
    var pallete : PalleteWorker!
    
    var delegate : () -> () = {}
    
    private func getProjects() -> [String] {
        do{
            let projs = try FileManager.default.contentsOfDirectory(at: PalleteWorker.getDocumentsDirectory(), includingPropertiesForKeys: nil)
                   
                   var names : [String] = []
                   
                   for i in 0..<projs.count  {
                       var name = projs[i].lastPathComponent
                        name.removeLast(8)
                       names.append(name)
                   }
                   
                    print(names)
                    return names
        } catch {
            return []
        }
    }

    @objc func doneBtn() {
        pallete.rename(newName: palleteName.filed.text!)
        palleteName.endEditing(true)
        self.exitButton.isEnabled = true
        self.palleteName.filed.isEnabled = false
    }
    
    @objc func cancelBtn(){
        palleteName.filed.text = pallete.palleteName
        palleteName.endEditing(true)
        self.exitButton.isEnabled = true
        self.palleteName.filed.isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        palleteEditBap.setShadow(color: UIColor(named : "shadowColor")!, radius: 4, opasity: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        colors.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "backgroundColor")

        view.addSubview(colors)
        view.addSubview(exitButton)
        view.addSubview(renameButton)
        view.addSubview(palleteBar)
        view.addSubview(palleteEditBap)

        colors.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        colors.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        colors.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        colors.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        palleteBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 6).isActive = true
        palleteBar.rightAnchor.constraint(equalTo: renameButton.leftAnchor, constant: -6).isActive = true
        palleteBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true

        exitButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -6).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        
        renameButton.rightAnchor.constraint(equalTo: exitButton.leftAnchor, constant: -6).isActive = true
        renameButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        
        palleteEditBap.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        palleteEditBap.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
