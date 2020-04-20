//
//  FrameCollectionView.swift
//  new Testing
//
//  Created by Рустам Хахук on 10.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayersCollectionView : UIView {
    lazy var list : LayersCollection = {
        let ls = LayersCollection(frame: .zero, proj: project!)
        ls.selfView = self
        ls.translatesAutoresizingMaskIntoConstraints = false
        ls.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        return ls
    }()
    
    lazy var deleteButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "trash_icon"), frame: .zero)
        btn.corners = 6
        btn.setbgColor(color: ProjectStyle.uiRedColor)
        btn.setShadowColor(color: ProjectStyle.uiRedColor.withAlphaComponent(0.75))
        btn.setIconColor(color: .white)
        btn.delegate = {[weak self] in
            if self!.list.canMove {
                self!.project?.addAction(action: ["ToolID" : "\(Actions.layerDelete.rawValue)","frame" : "\(self!.project!.FrameSelected)", "layer" : "\(self!.project!.LayerSelected)"])
                
                try! self!.project?.getLayer(frame: self!.project!.FrameSelected, layer: self!.project!.LayerSelected).pngData()?.write(to: self!.project!.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(self!.project!.information.actionList.actions.count - 1).png"))
                
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
            if self!.list.canMove {
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
           if self!.list.canMove {
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
        self.addSubview(deleteButton)
        self.addSubview(cloneButton)
        self.addSubview(visibleButton)
        self.addSubview(addButton)

        list.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        list.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        list.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        cloneButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        cloneButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 0).isActive = true

        visibleButton.leftAnchor.constraint(equalTo: cloneButton.rightAnchor, constant: 8).isActive = true
        visibleButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 0).isActive = true

        deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        deleteButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 0).isActive = true
        addButton.leftAnchor.constraint(equalTo: visibleButton.rightAnchor, constant: 8).isActive = true
        addButton.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 0).isActive = true

        checkFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("frame Control deiniting")
        
    }
}
