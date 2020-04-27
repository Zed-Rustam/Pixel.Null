//
//  PalleteCreateController.swift
//  new Testing
//
//  Created by Рустам Хахук on 20.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalleteCreateController : UIViewController {
    lazy private var colors : PalleteCollectionV2 = {
        let clrs = PalleteCollectionV2(colors: pallete.colorPallete.colors)
        
        (clrs.collectionViewLayout as! PalleteCollectionLayout).topOffset = 60
        return clrs
    }()
    
    lazy private var name : TextField = {
        let text = TextField(frame: .zero)
        text.filed.text = pallete.palleteName
        text.filed.delegate = nameDelegate
        text.setHelpText(help: "Pallete Name")
        text.filed.font = UIFont(name: "Rubik-Medium", size: 18)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtn))
        bar.items = [done]
        bar.sizeToFit()
        text.filed.inputAccessoryView = bar
        
        return text
    }()
    
    lazy private var nameBg : UIView = {
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        
        bg.addSubviewFullSize(view: name)
        bg.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        bg.backgroundColor = ProjectStyle.uiBackgroundColor
        return bg
    }()
    
    @objc func doneBtn() {
        view.endEditing(true)
    }
    
    lazy private var createButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero, icScale: 0.35)
        btn.delegate = {[unowned self] in
            self.pallete.colors = self.colors.palleteColors
            self.pallete.save()
            self.pallete.rename(newName : self.name.filed.text!)
            self.delegate?.palleteAdded(newPallete : self.pallete)
            self.dismiss(animated: true, completion: nil)
        }
        
        btn.corners = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true

        return btn
    }()
    
    lazy private var cancelButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "cancel_icon"), frame: .zero,icScale: 0.35)
        btn.delegate = {[weak self] in
            self!.pallete.delete()
            self!.dismiss(animated: true, completion: nil)
        }
        btn.corners = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        return btn
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

    private var pallete : PalleteWorker!
    
    private var nameDelegate : TextFieldDelegate!
    
    weak var delegate : PalleteGalleryDelegate? = nil
    
    private func getPalleteName() -> String{
        for i in 0... {
            if !getProjects().contains("New Pallete \(i)") { return "New Pallete \(i)" }
        }
        return ""
    }
    
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
    
    override func viewDidLoad() {
        pallete = PalleteWorker(name: getPalleteName(), colors: ["#00000000"])
        
        nameDelegate = TextFieldDelegate(method: {[weak self] in
            if $0.text == "" {
                self!.createButton.isEnabled = false
                self!.name.error = nil
            } else if self!.getProjects().contains($0.text!) && $0.text! != self!.pallete.palleteName {
                self!.name.error = "A pallete with this name already exists"
                self!.createButton.isEnabled = false
            } else {
                self!.name.error = nil
                self!.createButton.isEnabled = true
            }
        })
        
        self.view.backgroundColor = ProjectStyle.uiBackgroundColor
        
        self.view.addSubview(colors)
        self.view.addSubview(nameBg)
        self.view.addSubview(createButton)
        self.view.addSubview(cancelButton)
        self.view.addSubview(palleteEditBap)

        colors.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        colors.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        colors.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        colors.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        createButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -6).isActive = true
        createButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        
        cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 6).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true

        nameBg.leftAnchor.constraint(equalTo: cancelButton.rightAnchor, constant: 6).isActive = true
        nameBg.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -6).isActive = true
        nameBg.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true

        palleteEditBap.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -6).isActive = true
        palleteEditBap.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6).isActive = true
        
        self.view.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}
