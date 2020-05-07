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
    weak var editor : Editor? = nil
    
    
    lazy private var preview : UIView = {
        let img = UIImageView(image: project!.getFrame(frame: 0, size: project!.projectSize))
        img.translatesAutoresizingMaskIntoConstraints = false

        img.layer.magnificationFilter = .nearest
        img.setCorners(corners: 16)
        img.contentMode = .scaleAspectFit
        img.backgroundColor = project?.backgroundColor
        
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        mainview.heightAnchor.constraint(equalTo: mainview.widthAnchor).isActive = true
        mainview.layer.magnificationFilter = .nearest
        mainview.layer.cornerRadius = 16

        mainview.addSubviewFullSize(view: img)
        
        return mainview
    }()
    
    lazy private var projectName : TextField = {
        let text = TextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 42).isActive = true
        text.filed.text = project!.projectName
        text.isUserInteractionEnabled = false
        text.setHelpText(help: "Project Name")
        text.filed.delegate = renameDelegate
        
        let bar = UIToolbar()
        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel))
        bar.items = [doneBtn,cancel]
        bar.sizeToFit()
        text.filed.inputAccessoryView = bar
        
        return text
    }()
    
    lazy private var renameDelegate : TextFieldDelegate = {
        return TextFieldDelegate(method: {[unowned self] in
            if(self.getProjects().contains($0.text!) && $0.text != self.project!.projectName) {
                self.projectName.error = "A project with this name already exists"
                self.doneBtn.isEnabled = false
            } else if ($0.text == "" || $0.text == self.project!.projectName){
                self.projectName.error = nil
                self.doneBtn.isEnabled = false
            } else {
                self.projectName.error = nil
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
        print("\(rect)")
        
        if view.frame.height - rect.height - 8 < projectName.frame.origin.y + projectName.frame.height {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y -= (self.projectName.frame.origin.y + self.projectName.frame.height) - (self.view.frame.height - rect.height) + 8
            })
        }
    }
    @objc func onHideKeyboard(notification : NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = 0
        })
        projectName.filed.text = project!.projectName
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func done() {
        project!.projectName = projectName.filed.text!
        projectName.isUserInteractionEnabled = false
        projectName.endEditing(true)
    }
    
    @objc func cancel() {
        projectName.endEditing(true)
        projectName.isUserInteractionEnabled = false
    }
    
    lazy private var projectBackground : TextField = {
        let text = TextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 42).isActive = true
        text.filed.text = "Background"
        text.filed.isUserInteractionEnabled = false
        
        return text
    }()
    
    lazy private var projectSize : TextField = {
        let text = TextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 42).isActive = true
        text.widthAnchor.constraint(equalToConstant: 164).isActive = true
        text.filed.text = "\(Int(project!.projectSize.width))x\(Int(project!.projectSize.height))"
        text.filed.textAlignment = .center
        text.filed.isUserInteractionEnabled = false
        
        return text
    }()
    
    lazy private var backgroundColor : ColorSelector = {
       let selector = ColorSelector()
        selector.color = project!.backgroundColor
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.widthAnchor.constraint(equalToConstant: 42).isActive = true
        selector.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        selector.delegate = {[unowned self] in
            let projectPallete = ProjectPallete()
            projectPallete.project = self.project
            projectPallete.startColor = selector.color
            projectPallete.selectDelegate = {color in
                selector.color = color
                self.project?.addAction(action: ["ToolID" : "\(Actions.backgroundChange.rawValue)", "last" : "\(UIColor.toHex(color: self.project!.backgroundColor))", "now" : "\(UIColor.toHex(color: color))" ])
                self.project?.backgroundColor = color
                self.editor?.updateEditor()
                self.preview.subviews[0].backgroundColor = color
            }
            
            self.show(projectPallete, sender: nil)
        }
        return selector
    }()
    
    lazy private var editNameButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "edit_icon"), frame: .zero,icScale: 0.5)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.corners = 12
        
        btn.delegate = {[unowned self] in
            self.projectName.isUserInteractionEnabled = true
            self.projectName.filed.becomeFirstResponder()
        }
        
        return btn
    }()
    
    lazy private var editSizeButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "edit_icon"), frame: .zero,icScale: 0.5)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.corners = 12
        btn.delegate = {[unowned self] in
            let resize = ProjectResizeController()
            resize.project = self.project
            resize.delegate = {[unowned self] in
                if $0 {
                    (self.preview.subviews[0] as! UIImageView).image = self.project!.getFrame(frame: 0, size: self.project!.projectSize)
                    self.editor?.resizeProject()
                    self.projectSize.filed.text = "\(Int(self.project!.projectSize.width))x\(Int(self.project!.projectSize.height))"
                }
            }
            
            resize.modalPresentationStyle = .pageSheet
            self.show(resize, sender: self)
        }
        
        return btn
    }()
    
    override func viewDidLoad() {
        view.addSubview(preview)
        view.addSubview(projectName)
        view.addSubview(projectBackground)
        view.addSubview(projectSize)
        view.addSubview(backgroundColor)
        view.addSubview(editNameButton)
        view.addSubview(editSizeButton)

        preview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        preview.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        
        projectName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        projectName.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 8).isActive = true
        projectName.rightAnchor.constraint(equalTo: editNameButton.leftAnchor, constant: -8).isActive = true

        projectBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        projectBackground.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 8).isActive = true
        projectBackground.rightAnchor.constraint(equalTo: backgroundColor.leftAnchor, constant: -8).isActive = true
        
        projectSize.topAnchor.constraint(equalTo: projectBackground.bottomAnchor, constant: 8).isActive = true
        projectSize.rightAnchor.constraint(equalTo: editSizeButton.leftAnchor, constant: -8).isActive = true
        
        backgroundColor.topAnchor.constraint(equalTo: projectBackground.topAnchor, constant: 0).isActive = true
        backgroundColor.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        editNameButton.topAnchor.constraint(equalTo: projectName.topAnchor, constant: 0).isActive = true
        editNameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        editSizeButton.topAnchor.constraint(equalTo: projectSize.topAnchor, constant: 0).isActive = true
        editSizeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        NotificationCenter.default.addObserver(self, selector: #selector(onShowKeyboard(notification:)), name:  UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHideKeyboard(notification:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        preview.backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 1 / ((view.frame.width - 32) / 8.0), orientation: .down))
        preview.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
    }
}
