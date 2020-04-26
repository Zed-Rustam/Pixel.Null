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
        let ls = FramesCollection(frame: .zero, proj: project!)
        ls.selfView = self
        ls.translatesAutoresizingMaskIntoConstraints = false
        ls.heightAnchor.constraint(equalToConstant: 72).isActive = true
        return ls
    }()
    
    lazy var deleteButton : CircleButton = {
        let  btn = CircleButton(icon: #imageLiteral(resourceName: "trash_icon"), frame: .zero)
       btn.corners = 6
       btn.setbgColor(color: ProjectStyle.uiRedColor)
       btn.setShadowColor(color: ProjectStyle.uiRedColor.withAlphaComponent(0.75))
       btn.setIconColor(color: .white)
       
       btn.delegate = {[weak self] in
        if(self!.list.canMove && self!.project!.information.frames.count > 1) {
               let frameJson = String(data: try! JSONEncoder().encode(self!.project!.information.frames[self!.project!.FrameSelected]), encoding: .utf8)!
               
               self!.project?.addAction(action: ["ToolID" : "\(Actions.frameDelete.rawValue)", "frame" : "\(self!.project!.FrameSelected)", "lastID" : "\(self!.project!.information.frames[self!.project!.FrameSelected].frameID)", "frameStruct" : frameJson])
               
            try! FileManager.default.copyItem(at: self!.project!.getProjectDirectory().appendingPathComponent("frame-\(self!.project!.information.frames[self!.project!.FrameSelected].frameID)"), to: self!.project!.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(self!.project!.getNextActionID())"))
               
               self!.list.frameDelegate?.deleteFrame(frame: self!.project!.FrameSelected)
           }
       }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return btn
    }()
    lazy var cloneButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "clone_icon"), frame: .zero)
        
        btn.corners = 6
        btn.delegate = {[weak self] in
            if(self!.list.canMove) {
                self!.project?.addAction(action: ["ToolID" : "\(Actions.frameClone.rawValue)", "frame" : "\(self!.project!.FrameSelected)"])
                
                self!.list.frameDelegate?.cloneFrame(original: self!.project!.FrameSelected)
            }
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
    lazy var addButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: .zero)
        btn.corners = 8
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
    
    var delayField : TextField!
    var dublicateButton : CircleButton!
    weak var project : ProjectWork?
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("hey!")
         if textField.text != "" {
            var delay = Int(textField.text!) ?? -1
        
            if delay <= 0 {
                textField.text = ""
                return
            } else if delay > 9999 {
                delay = 9999
            }
            textField.text = String(delay)
            //self.project!.setFrameDelay(frame: self.project!.FrameSelected, delay: delay)
         }
    }
    
    
    @objc func doneSetDelay() {
        endEditing(true)
        if delayField.filed.text == "" {
            delayField.filed.text = String(project!.information.frames[project!.FrameSelected].delay)
        } else {
            project?.addAction(action: ["ToolID" : "\(Actions.changeFrameDelay.rawValue)","frame" : "\(project!.FrameSelected)", "from" : "\(project!.information.frames[project!.FrameSelected].delay)", "to" : delayField.filed.text!])
            
            project!.setFrameDelay(frame: project!.FrameSelected, delay: Int(delayField.filed.text!)!)
        }
        
    }
    
    @objc func cancelSetDelay() {
        endEditing(true)
        delayField.filed.text = String(project!.information.frames[project!.FrameSelected].delay)
    }
    
    init(proj : ProjectWork) {
        project = proj
        
        super.init(frame : .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        delayField = TextField(frame: CGRect(x: 12, y: 72, width: 80, height: 36))
        delayField.small = true
        delayField.setHelpText(help: "100")
        delayField.filed.textAlignment = .center
        delayField.filed.text = String(project!.information.frames[project!.FrameSelected].delay)
        delayField.setFIeldDelegate(delegate: self)
        delayField.filed.keyboardType = .numberPad
        
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneSetDelay))
        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelSetDelay))
        bar.items = [done,cancel]
        bar.sizeToFit()
        delayField.filed.inputAccessoryView = bar
        
        self.addSubview(list)
        self.addSubview(delayField)
        self.addSubview(deleteButton)
        self.addSubview(cloneButton)
        self.addSubview(addButton)

        list.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        list.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        list.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        deleteButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 0).isActive = true
        
        cloneButton.leftAnchor.constraint(equalTo: delayField.rightAnchor, constant: 8).isActive = true
        cloneButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 0).isActive = true
        
        addButton.leftAnchor.constraint(equalTo: cloneButton.rightAnchor, constant: 8).isActive = true
        addButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
