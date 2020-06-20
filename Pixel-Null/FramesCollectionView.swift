//
//  FrameCollectionView.swift
//  new Testing
//
//  Created by Рустам Хахук on 10.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FramesCollectionView : UIView, UITextFieldDelegate {
    lazy var list : FramesCollection = {
        let ls = FramesCollection(proj: project!)
        //ls.selfView = self
        ls.translatesAutoresizingMaskIntoConstraints = false
        ls.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return ls
    }()
    
    lazy private var frameText : UILabel = {
           let text = UILabel(frame: .zero)
           text.text = NSLocalizedString("Frames", comment: "")
           text.font = UIFont(name: "Rubik-Bold", size: 32)
           text.textColor = UIColor(named: "enableColor")
           text.translatesAutoresizingMaskIntoConstraints = false
           text.heightAnchor.constraint(equalToConstant: 36).isActive = true
           return text
       }()
 
    lazy var addButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: .zero)
        btn.corners = 6
        btn.delegate = { [weak self] in
            self!.project!.insertFrame(at: self!.project!.FrameSelected + 1)
            self!.project!.addAction(action: ["ToolID" : "\(Actions.frameAdd.rawValue)", "frame" : "\(self!.project!.FrameSelected + 1)"])
            
            if(self!.project!.frameCount >= 128) {
                self!.addButton.isEnabled = false
            }
            
            self!.list.frameDelegate!.addFrame(at: self!.project!.FrameSelected + 1)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
    
    lazy var settingsButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "project_settings_icon"), frame: .zero)
        btn.corners = 6
        btn.delegate = { [weak self] in
            
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
    
//    lazy var delayField : TextField = {
//        let field = TextField(frame: .zero)
//        field.translatesAutoresizingMaskIntoConstraints = false
//        field.small = true
//        field.setHelpText(help: "100")
//        field.filed.textAlignment = .center
//        field.filed.text = String(project!.information.frames[project!.FrameSelected].delay)
//        field.setFIeldDelegate(delegate: self)
//        field.filed.keyboardType = .numberPad
//
//        let bar = UIToolbar()
//        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneSetDelay))
//        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelSetDelay))
//        bar.items = [done,cancel]
//        bar.sizeToFit()
//        field.filed.inputAccessoryView = bar
//
//        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
//        field.widthAnchor.constraint(equalToConstant: 72).isActive = true
//
//        return field
//    }()
    
    var dublicateButton : CircleButton!
    weak var project : ProjectWork?
    
    
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        print("hey!")
//         if textField.text != "" {
//            var delay = Int(textField.text!) ?? -1
//
//            if delay <= 0 {
//                textField.text = ""
//                return
//            } else if delay > 9999 {
//                delay = 9999
//            }
//            textField.text = String(delay)
//            //self.project!.setFrameDelay(frame: self.project!.FrameSelected, delay: delay)
//         }
//    }
    
    
//    @objc func doneSetDelay() {
//        endEditing(true)
//        if delayField.filed.text == "" {
//            delayField.filed.text = String(project!.information.frames[project!.FrameSelected].delay)
//        } else {
//            project?.addAction(action: ["ToolID" : "\(Actions.changeFrameDelay.rawValue)","frame" : "\(project!.FrameSelected)", "from" : "\(project!.information.frames[project!.FrameSelected].delay)", "to" : delayField.filed.text!])
//
//            project!.setFrameDelay(frame: project!.FrameSelected, delay: Int(delayField.filed.text!)!)
//        }
//
//    }
    
//    @objc func cancelSetDelay() {
//        endEditing(true)
//        delayField.filed.text = String(project!.information.frames[project!.FrameSelected].delay)
//    }
    
    init(proj : ProjectWork) {
        project = proj
        
        super.init(frame : .zero)
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(frameText)
        self.addSubview(list)
        //self.addSubview(delayField)
        self.addSubview(addButton)
        self.addSubview(settingsButton)

        frameText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        frameText.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true

        list.topAnchor.constraint(equalTo: frameText.bottomAnchor, constant: 6).isActive = true
        list.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        list.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true

        addButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        addButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        settingsButton.rightAnchor.constraint(equalTo: addButton.leftAnchor, constant: -6).isActive = true
        settingsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        //delayField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        //delayField.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 6).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
