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
        text.font = UIFont.systemFont(ofSize: 32, weight: .black)
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
    
    func unpdateAddButton(){
        if(project!.layerCount >= 16) {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
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
        addButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        addButton.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 36, height: 36), cornerRadius: 8).cgPath
    }
    
    override func tintColorDidChange() {
        addButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        addButton.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 36, height: 36), cornerRadius: 8).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("frame Control deiniting")
        
    }
}
