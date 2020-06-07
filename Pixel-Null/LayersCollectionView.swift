//
//  FrameCollectionView.swift
//  new Testing
//
//  Created by Рустам Хахук on 10.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayersCollectionView : UIView, UITextFieldDelegate {
    lazy var list : LayersCollection = {
        let ls = LayersCollection(proj: project!)
        //ls.selfView = self
        ls.translatesAutoresizingMaskIntoConstraints = false
        ls.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        return ls
    }()
    
    lazy var deleteButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "trash_icon"), frame: .zero)
        btn.corners = 6
        btn.setbgColor(color: getAppColor(color: .red))
        btn.setShadowColor(color: getAppColor(color: .red).withAlphaComponent(0.75))
        btn.setIconColor(color: .white)
        btn.delegate = {[weak self] in
            if (!self!.list.moving && self!.project!.information.frames[self!.project!.FrameSelected].layers.count > 1) {
                self!.project?.addAction(action: ["ToolID" : "\(Actions.layerDelete.rawValue)","frame" : "\(self!.project!.FrameSelected)", "layer" : "\(self!.project!.LayerSelected)", "wasVisible" : "\(self!.project!.information.frames[self!.project!.FrameSelected].layers[self!.project!.LayerSelected].visible)", "transparent" : "\(self!.project!.information.frames[self!.project!.FrameSelected].layers[self!.project!.LayerSelected].transparent)"])
                
                try! self!.project?.getLayer(frame: self!.project!.FrameSelected, layer: self!.project!.LayerSelected).pngData()?.write(to: self!.project!.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(self!.project!.getNextActionID()).png"))
                
                self!.list.frameDelegate?.deleteLayer(frame: self!.project!.FrameSelected, layer: self!.project!.LayerSelected)
                
                if(self!.project!.layerCount < 16) {
                    self!.addButton.isEnabled = true
                    self!.cloneButton.isEnabled = true
                }
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
            if !self!.list.moving {
                self!.project?.addAction(action: ["ToolID" : "\(Actions.layerClone.rawValue)", "frame" : "\(self!.project!.FrameSelected)", "layer" : "\(self!.project!.LayerSelected)"])
                
                self!.list.frameDelegate?.cloneLayer(frame: self!.project!.FrameSelected, original: self!.project!.LayerSelected)
                
                if(self!.project!.layerCount >= 16) {
                    self!.addButton.isEnabled = false
                    self!.cloneButton.isEnabled = false
                }
            }
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return btn
    }()
    
    lazy var visibleButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "visible_button_icon"), frame: .zero)
       btn.corners = 6
       btn.delegate = {[weak self] in
           if !self!.list.moving {
               self!.list.frameDelegate?.changeLayerVisible(frame: self!.project!.FrameSelected, layer: self!.project!.LayerSelected)
               self!.project!.addAction(action: ["ToolID" : "\(Actions.layerVisibleChange.rawValue)", "frame" : "\(self!.project!.FrameSelected)", "layer" : "\(self!.project!.LayerSelected)"])
           }
       }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return btn
    }()
    
    lazy var addButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: CGRect(x: frame.width - 90, y: 0, width: 36, height: 36))
        btn.corners = 8
        btn.delegate = { [weak self] in
            self!.project!.addLayer(frame : self!.project!.FrameSelected, layerPlace: self!.project!.LayerSelected + 1)
            
            self!.project!.addAction(action: ["ToolID" : "\(Actions.layerAdd.rawValue)", "frame" : "\(self!.project!.FrameSelected)", "layer" : "\( self!.project!.LayerSelected + 1)"])
            
            if(self!.project!.layerCount >= 16) {
                self!.addButton.isEnabled = false
                self!.cloneButton.isEnabled = false
            }
            
            self!.list.frameDelegate?.addLayer(frame: self!.project!.FrameSelected, layer: self!.project!.LayerSelected + 1)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
               
        return btn
    }()

    lazy var mergeButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "layers_merge_icon"), frame: CGRect(x: frame.width - 90, y: 0, width: 36, height: 36))
        btn.corners = 8
        btn.delegate = { [unowned self] in
            //self!.project!.addLayer(frame : self!.project!.FrameSelected, layerPlace: self!.project!.LayerSelected + 1)
            if self.project!.layerCount > 1 && self.project!.LayerSelected != self.project!.layerCount - 1 {
                self.project!.addAction(action: ["ToolID" : "\(Actions.mergeLayers.rawValue)",
                    "frame" : "\(self.project!.FrameSelected)",
                    "layer" : "\( self.project!.LayerSelected)",
                    "firstLayerOpasity" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[self.project!.LayerSelected].transparent)",
                    "secondLayerOpasity" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[self.project!.LayerSelected + 1].transparent)",
                    "isFirstLayerVisible" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[self.project!.LayerSelected].visible)",
                    "isSecondLayerVisible" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[self.project!.LayerSelected + 1].visible)",
                ])
                
                try! self.project!.getLayer(frame: self.project!.FrameSelected, layer: self.project!.LayerSelected).pngData()?.write(to: self.project!.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-first-\(self.project!.getNextActionID()).png"))
                try! self.project!.getLayer(frame: self.project!.FrameSelected, layer: self.project!.LayerSelected + 1).pngData()?.write(to: self.project!.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-second-\(self.project!.getNextActionID()).png"))

                self.project!.mergeLayers(frame: self.project!.FrameSelected, layer: self.project!.LayerSelected)
                self.list.frameDelegate?.margeLayers(frame: self.project!.FrameSelected, layer: self.project!.LayerSelected)
                self.transparentField.filed.text = "100"
            }
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
               
        return btn
    }()
    
    lazy var transparentField : TextField = {
        let text = TextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.widthAnchor.constraint(equalToConstant: 72).isActive = true
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        text.setHelpText(help: "100")
        text.filed.text = "\(Int(project!.information.frames[project!.FrameSelected].layers[project!.LayerSelected].transparent * 100))"
        
        text.filed.textAlignment = .center
        text.filed.keyboardType = .numberPad

        text.filed.delegate = self
        let bar = UIToolbar()
        bar.items = [done,cancel]
        bar.sizeToFit()
        text.filed.inputAccessoryView = bar
        return text
    }()
    
    let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
    let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
    
    @objc func doneAction() {
        project?.addAction(action: ["ToolID" : "\(Actions.changeLayerOpasity.rawValue)","frame" : "\(project!.FrameSelected)","layer" : "\(project!.LayerSelected)", "from" : "\(project!.information.frames[project!.FrameSelected].layers[project!.LayerSelected].transparent)", "to" : "\(Float(transparentField.filed.text!)! / 100.0)"])
        
        project?.setLayerOpasity(frame: project!.FrameSelected, layer: project!.LayerSelected, newOpasity: Int(transparentField.filed.text!)!)
        transparentField.endEditing(true)
        
        list.frameDelegate?.updateLayerSettings(target: project!.LayerSelected)
        list.frameDelegate?.updateFrameSettings(target: project!.FrameSelected)
        list.frameDelegate?.updatePreview()
    }
    
    @objc func cancelAction() {
        transparentField.filed.text = "\(Int(project!.information.frames[project!.FrameSelected].layers[project!.LayerSelected].transparent * 100))"
        transparentField.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
         if textField.text != "" {
            var delay = Int(textField.text!) ?? -1
        
            if delay <= 0 {
                textField.text = ""
                return
            } else if delay > 100 {
                delay = 100
            }
            textField.text = String(delay)
            //self.project!.setFrameDelay(frame: self.project!.FrameSelected, delay: delay)
         }
    }
    
    weak var project : ProjectWork?
    
    func checkFrame(){
        if(project!.layerCount >= 16) {
            addButton.isEnabled = false
            cloneButton.isEnabled = false
        } else {
            addButton.isEnabled = true
            cloneButton.isEnabled = true
        }
    }
    
    init(frame: CGRect,proj : ProjectWork) {
        project = proj
        
        super.init(frame : frame)
        self.addSubview(list)
        self.addSubview(transparentField)
        self.addSubview(deleteButton)
        self.addSubview(cloneButton)
        self.addSubview(visibleButton)
        self.addSubview(addButton)
        self.addSubview(mergeButton)

        list.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        list.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        list.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        transparentField.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        transparentField.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 12).isActive = true
        
        cloneButton.leftAnchor.constraint(equalTo: transparentField.rightAnchor, constant: 6).isActive = true
        cloneButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 12).isActive = true

        visibleButton.leftAnchor.constraint(equalTo: cloneButton.rightAnchor, constant: 6).isActive = true
        visibleButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 12).isActive = true

        deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        deleteButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 12).isActive = true
       
        addButton.leftAnchor.constraint(equalTo: visibleButton.rightAnchor, constant: 6).isActive = true
        addButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 12).isActive = true
        
        mergeButton.leftAnchor.constraint(equalTo: addButton.rightAnchor, constant: 6).isActive = true
        mergeButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 12).isActive = true

        checkFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("frame Control deiniting")
        
    }
}
