//
//  FrameCollectionView.swift
//  new Testing
//
//  Created by Рустам Хахук on 10.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayersCollectionView : UIView, UITextFieldDelegate {
    lazy var list : LayersTable = {
        let ls = LayersTable(project: project!,delegateFrame: nil)
        ls.translatesAutoresizingMaskIntoConstraints = false
        ls.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        return ls
    }()
    
    lazy private var layerText : UILabel = {
        let text = UILabel(frame: .zero)
        text.text = NSLocalizedString("Layers", comment: "")
        text.font = UIFont(name: "Rubik-Bold", size: 32)
        text.textColor = UIColor(named: "enableColor")
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return text
    }()
    
    
    lazy var addButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: CGRect(x: frame.width - 90, y: 0, width: 36, height: 36))
        btn.corners = 8
        btn.delegate = { [weak self] in
            self!.project!.addLayer(frame : self!.project!.FrameSelected, layerPlace: self!.project!.LayerSelected + 1)
            
            self!.project!.addAction(action: ["ToolID" : "\(Actions.layerAdd.rawValue)", "frame" : "\(self!.project!.FrameSelected)", "layer" : "\( self!.project!.LayerSelected + 1)"])
            
            if(self!.project!.layerCount >= 16) {
                self!.addButton.isEnabled = false
                //self!.cloneButton.isEnabled = false
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
            }
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
//

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
        
//        list.frameDelegate?.updateLayerSettings(target: project!.LayerSelected)
//        list.frameDelegate?.updateFrameSettings(target: project!.FrameSelected)
//        list.frameDelegate?.updatePreview()
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
            //cloneButton.isEnabled = false
        } else {
            addButton.isEnabled = true
            //cloneButton.isEnabled = true
        }
    }
    
    init(frame: CGRect,proj : ProjectWork) {
        project = proj
        
        super.init(frame : frame)
        
        self.addSubview(layerText)
        self.addSubview(list)
        self.addSubview(addButton)

        layerText.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        layerText.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        list.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        list.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        list.topAnchor.constraint(equalTo: layerText.bottomAnchor, constant: 0).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        addButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        addButton.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true

        checkFrame()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        list.layout.invalidateLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("frame Control deiniting")
        
    }
}
