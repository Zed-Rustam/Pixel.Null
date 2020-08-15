//
//  PalleteCreateController.swift
//  new Testing
//
//  Created by Рустам Хахук on 20.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalleteCreateController : UIViewController {
    lazy private var colors : PaletteCollectionModern = {
        let clrs = PaletteCollectionModern(colors: pallete.colorPallete.colors)
        clrs.translatesAutoresizingMaskIntoConstraints = false

        return clrs
    }()
    
    lazy private var name : UITextField = {
        let text = UITextField(frame: .zero)
        text.text = pallete.palleteName
        text.delegate = nameDelegate
        text.attributedPlaceholder = NSAttributedString(string: "Palette Name", attributes: [NSAttributedString.Key.foregroundColor : getAppColor(color: .disable)])
        
        text.backgroundColor = getAppColor(color: .backgroundLight)
        text.setCorners(corners: 12)
        
        
        text.leftViewMode = .always
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 42))
        
        text.rightViewMode = .always
        text.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 42))
        
        text.font = UIFont(name: "Rubik-Medium", size: 18)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtn))
        bar.items = [done]
        bar.sizeToFit()
        text.inputAccessoryView = bar
        
        return text
    }()
    
    @objc func doneBtn() {
        view.endEditing(true)
    }
    
    lazy private var errorText: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        lbl.textColor = getAppColor(color: .red)
        lbl.font = UIFont(name: "Rubik-Medium", size: 10)
        lbl.text = ""
        return lbl
    }()
    
    lazy private var createButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero, icScale: 0.35)
        btn.delegate = {[unowned self] in
            self.pallete.colors = self.colors.palleteColors
            self.pallete.save()
            self.pallete.rename(newName : self.name.text!)
            self.delegate?.palleteAdded(newPallete : self.pallete)
            self.dismiss(animated: true, completion: nil)
        }
        
        btn.corners = 12
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
        btn.corners = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        return btn
    }()
    
    lazy private var paletteEditBap : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.heightAnchor.constraint(equalToConstant: 42 + UIApplication.shared.windows[0].safeAreaInsets.bottom).isActive = true
        
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.setCorners(corners: 12)
        bg.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
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
                let palleteSelector = ColorDialogController()
                
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
                let palleteSelector = ColorDialogController()
                palleteSelector.setStartColor(clr: self.colors.getSelectItemColor())
                
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
            if !getProjects().contains("\(NSLocalizedString("New palette", comment: "")) \(i).pnpalette") { return "\(NSLocalizedString("New palette", comment: "")) \(i)" }
        }
        return ""
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
    
    override func viewDidLoad() {
        pallete = PalleteWorker(name: getPalleteName(), colors: ["#00000000"])
        
        nameDelegate = TextFieldDelegate(method: {[unowned self] in
            if $0.text == "" {
                self.createButton.isEnabled = false
                self.errorText.text = ""
            } else if self.getProjects().contains("\($0.text!).pnpalette") && "\($0.text!)" != self.pallete.palleteName {
                self.errorText.text = NSLocalizedString("Palette exist error", comment: "")
                self.createButton.isEnabled = false
            } else {
                errorText.text = ""
                self.createButton.isEnabled = true
            }
        })
        
        view.backgroundColor = getAppColor(color: .background)
        view.setCorners(corners: 32)
        
        view.addSubview(colors)
        view.addSubview(name)
        view.addSubview(errorText)
        view.addSubview(createButton)
        view.addSubview(cancelButton)
        view.addSubview(paletteEditBap)

        colors.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        colors.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        colors.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 24).isActive = true
        colors.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        
        errorText.leftAnchor.constraint(equalTo: name.leftAnchor).isActive = true
        errorText.rightAnchor.constraint(equalTo: name.rightAnchor).isActive = true
        errorText.topAnchor.constraint(equalTo: name.bottomAnchor).isActive = true

        createButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        createButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        
        cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true

        name.leftAnchor.constraint(equalTo: cancelButton.rightAnchor, constant: 12).isActive = true
        name.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -12).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true

        paletteEditBap.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        paletteEditBap.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        paletteEditBap.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.view.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        paletteEditBap.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        paletteEditBap.layer.shadowPath = UIBezierPath(roundedRect: paletteEditBap.bounds, cornerRadius: 12).cgPath
    }
    override func viewDidAppear(_ animated: Bool) {
        colors.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}
