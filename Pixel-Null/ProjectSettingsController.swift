//
//  ProjectSettingsController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 02.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectSettingsController : UIViewController {
    weak var project : ProjectWork? = nil
    weak var delegate : ToolsActionDelegate? = nil

    lazy private var preview : UIView = {
        let img = UIImageView(image: project!.getFrame(frame: 0, size: project!.projectSize).flip(xFlip: project!.isFlipX, yFlip: project!.isFlipY))
        
        img.translatesAutoresizingMaskIntoConstraints = false

        img.layer.magnificationFilter = .nearest
        img.setCorners(corners: 12,needMask: true)
        img.contentMode = .scaleAspectFit
        img.backgroundColor = project?.backgroundColor
        
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        
        mainview.layer.magnificationFilter = .nearest
        mainview.layer.cornerRadius = 16

        mainview.addSubviewFullSize(view: img)
        
        return mainview
    }()
    
    lazy private var nameField : UITextField = {
       let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        text.backgroundColor = getAppColor(color: .backgroundLight)
        text.textColor = getAppColor(color: .enable)
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        text.isUserInteractionEnabled = false
        text.attributedPlaceholder = NSAttributedString(string: "Project name",attributes: [NSAttributedString.Key.foregroundColor: getAppColor(color: .disable)])

        text.leftViewMode = .always
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        text.rightViewMode = .always
        text.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        text.setCorners(corners: 12)
        
        let bar = UIToolbar()
        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel))
        bar.items = [doneBtn,cancel]
        bar.sizeToFit()
        
        text.inputAccessoryView = bar
        
        text.text = project!.projectName
        text.text?.removeLast(6)
                
        return text
    }()
    
    lazy private var backgroundField : UITextField = {
       let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        text.backgroundColor = getAppColor(color: .backgroundLight)
        text.textColor = getAppColor(color: .enable)
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        text.isUserInteractionEnabled = false
        text.text = "Background"

        text.leftViewMode = .always
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        text.rightViewMode = .always
        text.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        text.setCorners(corners: 12)
        return text
    }()
    
    lazy private var sizeField : UITextField = {
       let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        text.widthAnchor.constraint(equalToConstant: 164).isActive = true

        text.backgroundColor = getAppColor(color: .backgroundLight)
        text.textColor = getAppColor(color: .enable)
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        text.isUserInteractionEnabled = false

        text.text = "\(Int(project!.projectSize.width))x\(Int(project!.projectSize.height))"
        text.textAlignment = .center
        
        text.leftViewMode = .always
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        text.rightViewMode = .always
        text.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        text.setCorners(corners: 12)
        return text
    }()
    
    lazy private var renameDelegate : TextFieldDelegate = {
        return TextFieldDelegate(method: {[unowned self] in
            if(self.getProjects().contains("\($0.text!).pnart") && "\($0.text!).pnart" != self.project!.projectName) {
                //self.projectName.error = "A project with this name already exists"
                self.doneBtn.isEnabled = false
            } else if ($0.text == "" || "\($0.text!).pnart" == self.project!.projectName){
               // self.projectName.error = nil
                self.doneBtn.isEnabled = false
            } else {
                //self.projectName.error = nil
                self.doneBtn.isEnabled = true
            }
            
        })
    }()
    
    private func getProjects() -> [String] {
        do{
            let projs = try FileManager.default.contentsOfDirectory(at: ProjectWork.getDocumentsDirectory(), includingPropertiesForKeys: nil)
                   
                   var names : [String] = []
                   
                   for i in 0..<projs.count  {
                       let name = projs[i].lastPathComponent
                       names.append(name)
                   }
                   
                   return names
        } catch {
            return []
        }
    }

    let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
    
    @objc func onShowKeyboard(notification : NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        if view.frame.height - rect.height - 8 < nameField.frame.origin.y + nameField.frame.height && nameField.isFirstResponder {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y -= (self.nameField.frame.origin.y + self.nameField.frame.height) - (self.view.frame.height - rect.height) + 8
            })
        }
    }
    
    @objc func onHideKeyboard(notification : NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = 0
        })
        nameField.text = project!.projectName
        nameField.text?.removeLast(6)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc func done() {
        project!.projectName = "\(nameField.text!).pnart"
        nameField.isUserInteractionEnabled = false
        nameField.endEditing(true)
    }
    
    @objc func cancel() {
        nameField.endEditing(true)
        nameField.isUserInteractionEnabled = false
    }
        
    lazy private var backgroundColor : ColorSelector = {
       let selector = ColorSelector()
        selector.color = project!.backgroundColor
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.widthAnchor.constraint(equalToConstant: 36).isActive = true
        selector.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        selector.delegate = {[unowned self] in
            let projectPallete = ProjectPallete()
            projectPallete.project = self.project
            projectPallete.startColor = selector.color
            projectPallete.selectDelegate = {color in
                selector.color = color
                self.project?.addAction(action: ["ToolID" : "\(Actions.backgroundChange.rawValue)", "last" : "\(UIColor.toHex(color: self.project!.backgroundColor))", "now" : "\(UIColor.toHex(color: color))" ])
                self.project?.backgroundColor = color
                self.delegate?.projectSettingsChange()
                self.preview.subviews[0].backgroundColor = color
            }
            
            self.show(projectPallete, sender: nil)
        }
        return selector
    }()
    
    lazy private var NameButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setCorners(corners: 12)
        btn.backgroundColor = getAppColor(color: .background)
        
        btn.setImage(#imageLiteral(resourceName: "edit_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .enable)
        
        btn.addTarget(self, action: #selector(onEditName), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func onEditName() {
        nameField.isUserInteractionEnabled = true
        nameField.becomeFirstResponder()
    }
    
    lazy private var SizeButton : UIButton = {
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "edit_icon"), for: .normal)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setCorners(corners: 12)
        btn.backgroundColor = getAppColor(color: .background)
        btn.addTarget(self, action: #selector(onResizePress), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func onResizePress() {
        let resize = ProjectResizeController()
        resize.project = self.project
        resize.delegate = {[unowned self] in
            if $0 {
                (self.preview.subviews[0] as! UIImageView).image = self.project!.getFrame(frame: 0, size: self.project!.projectSize)
                self.delegate?.resizeProject()

                self.sizeField.text = "\(Int(self.project!.projectSize.width))x\(Int(self.project!.projectSize.height))"
            }
        }
        
        switch UIDevice.current.userInterfaceIdiom {
            //если айфон, то просто показываем контроллер
        case .phone:
            resize.modalPresentationStyle = .pageSheet
            //если айпад то немного химичим
        case .pad:
            resize.modalPresentationStyle = .currentContext
        default:
            break
        }
        
        self.show(resize, sender: self)
    }
    
    lazy private var flipXBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "flip_horizontal_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.addTarget(self, action: #selector(flipX), for: .touchUpInside)
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        return btn
    }()
    
    @objc func flipX() {
        project?.addAction(action: ["ToolID" : "\(Actions.projectFlipX.rawValue)"])
        project?.isFlipX.toggle()
        (preview.subviews[0] as! UIImageView).image = project!.getFrame(frame: 0, size: project!.projectSize).flip(xFlip: project!.information.flipX, yFlip: project!.information.flipY)
        delegate?.projectSettingsChange()

    }
    
    lazy private var flipYBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "flip_vertical_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.addTarget(self, action: #selector(flipY), for: .touchUpInside)
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        return btn
    }()
    
    @objc func flipY() {
        project?.addAction(action: ["ToolID" : "\(Actions.projectFlipY.rawValue)"])
        project?.isFlipY.toggle()
        
        (preview.subviews[0] as! UIImageView).image = project!.getFrame(frame: 0, size: project!.projectSize).flip(xFlip: project!.information.flipX, yFlip: project!.information.flipY)
        delegate?.projectSettingsChange()
    }

    override func viewDidLoad() {
        view.addSubview(preview)
        view.addSubview(nameField)
        view.addSubview(backgroundField)
        view.addSubview(sizeField)
        view.addSubview(backgroundColor)
        view.addSubview(NameButton)
        view.addSubview(SizeButton)
        view.addSubview(flipXBtn)
        view.addSubview(flipYBtn)
        
        view.setCorners(corners: 24)

        preview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        preview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        preview.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        preview.heightAnchor.constraint(equalTo: preview.widthAnchor, constant: 0).isActive = true
        
        nameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        nameField.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 12).isActive = true
        nameField.rightAnchor.constraint(equalTo: NameButton.leftAnchor, constant: -12).isActive = true

        backgroundField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backgroundField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 12).isActive = true
        backgroundField.rightAnchor.constraint(equalTo: backgroundColor.leftAnchor, constant: -12).isActive = true
        
        sizeField.topAnchor.constraint(equalTo: backgroundField.bottomAnchor, constant: 12).isActive = true
        sizeField.rightAnchor.constraint(equalTo: SizeButton.leftAnchor, constant: -12).isActive = true
        
        backgroundColor.topAnchor.constraint(equalTo: backgroundField.topAnchor, constant: 0).isActive = true
        backgroundColor.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        NameButton.topAnchor.constraint(equalTo: nameField.topAnchor, constant: 0).isActive = true
        NameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        SizeButton.topAnchor.constraint(equalTo: sizeField.topAnchor, constant: 0).isActive = true
        SizeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        flipYBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        flipYBtn.topAnchor.constraint(equalTo: SizeButton.bottomAnchor, constant: 12).isActive = true
        
        flipXBtn.rightAnchor.constraint(equalTo: flipYBtn.leftAnchor, constant: -12).isActive = true
        flipXBtn.topAnchor.constraint(equalTo: SizeButton.bottomAnchor, constant: 12).isActive = true

        view.backgroundColor = getAppColor(color: .background)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onShowKeyboard(notification:)), name:  UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHideKeyboard(notification:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        preview.backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 1 / ((view.frame.width - 32) / 8.0), orientation: .down))
        preview.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
        preview.layer.shadowPath = UIBezierPath(roundedRect: preview.bounds, cornerRadius: 12).cgPath
        
        NameButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        NameButton.layer.shadowPath = UIBezierPath(roundedRect: NameButton.bounds, cornerRadius: 12).cgPath
        
        SizeButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        SizeButton.layer.shadowPath = UIBezierPath(roundedRect: NameButton.bounds, cornerRadius: 12).cgPath
        
        flipXBtn.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        flipXBtn.layer.shadowPath = UIBezierPath(roundedRect: flipXBtn.bounds, cornerRadius: 12).cgPath
        
        flipYBtn.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        flipYBtn.layer.shadowPath = UIBezierPath(roundedRect: flipYBtn.bounds, cornerRadius: 12).cgPath
    }
}
