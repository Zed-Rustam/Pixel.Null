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
    
    lazy private var addButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 8,needMask: false)
        
        btn.setImage(UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration.init(weight: .semibold)), for: .normal)
        
        btn.imageView?.tintColor = getAppColor(color: .enable)
        
        btn.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        
        btn.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        btn.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 36, height: 36), cornerRadius: 8).cgPath
        
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
    
    @objc func onPress() {
        project!.addLayer(frame : project!.FrameSelected, layerPlace: project!.LayerSelected + 1)
        
        project!.addAction(action: ["ToolID" : "\(Actions.layerAdd.rawValue)", "frame" : "\(project!.FrameSelected)", "layer" : "\( project!.LayerSelected + 1)"])
        
        if(project!.layerCount >= 16) {
            addButton.isEnabled = false
            //self!.cloneButton.isEnabled = false
        }
        
        list.frameDelegate?.addLayer(frame: project!.FrameSelected, layer: project!.LayerSelected + 1)
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
         }
    }
    
    weak var project : ProjectWork?
    
    func checkFrame(){
        if(project!.layerCount >= 16) {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
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
