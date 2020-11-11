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
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 36))
        
        text.rightViewMode = .always
        text.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 36))
        
        text.font = UIFont(name: UIFont.appBold, size: 16)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
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
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        lbl.text = ""
        return lbl
    }()
    
    lazy private var cancelButton : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "no"), for: .normal)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.setCorners(corners: 12)
        btn.backgroundColor = getAppColor(color: .background)
        btn.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.addTarget(self, action: #selector(onCancelPress), for: .touchUpInside)
        return btn
    }()
    
    lazy private var createButton : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "yes"), for: .normal)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.setCorners(corners: 12)
        btn.backgroundColor = getAppColor(color: .background)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.addTarget(self, action: #selector(onCancelPress), for: .touchUpInside)
        return btn
    }()
    
    @objc func onCancelPress() {
        pallete.delete()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onCreatePress() {
        pallete.colors = colors.palleteColors
        pallete.save()
        pallete.rename(newName : name.text!)
        delegate?.palleteAdded(newPallete : pallete)
        dismiss(animated: true, completion: nil)
    }
    
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
                self.colors.addColor(color: $0)
            }
            
            present(palleteSelector,animated: true,completion: nil)
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
        view.setCorners(corners: 24)
        
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

        createButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        createButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        
        cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true

        name.leftAnchor.constraint(equalTo: cancelButton.rightAnchor, constant: 12).isActive = true
        name.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -12).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true

        paletteEditBap.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        paletteEditBap.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        paletteEditBap.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.view.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        paletteEditBap.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        paletteEditBap.layer.shadowPath = UIBezierPath(roundedRect: paletteEditBap.bounds, cornerRadius: 12).cgPath
        
        cancelButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        cancelButton.layer.shadowPath = UIBezierPath(roundedRect: cancelButton.bounds, cornerRadius: 12).cgPath
        
        createButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        createButton.layer.shadowPath = UIBezierPath(roundedRect: createButton.bounds, cornerRadius: 12).cgPath
    }
    override func viewDidAppear(_ animated: Bool) {
        colors.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}
