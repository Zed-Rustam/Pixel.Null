//
//  LayerSettings.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 05.09.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayerSettings: UIViewController {
    weak var project: ProjectWork? = nil
    weak var delegate: FrameControlUpdate? = nil
    
    lazy private var preview: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.layer.magnificationFilter = .nearest
        img.contentMode = .scaleAspectFit
        return img
    }()

    lazy private var previewBg: UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "background"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 128).isActive = true
        img.heightAnchor.constraint(equalToConstant: 128).isActive = true

        img.addSubviewFullSize(view: preview)
        
        img.layer.magnificationFilter = .nearest
        
        img.setCorners(corners: 12,needMask: true)
        return img
    }()
    
    
    lazy private var divider: UIView = {
        let view = UIView()
        view.setCorners(corners: 1,needMask: true)
        
        view.backgroundColor = getAppColor(color: .backgroundLight)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        return view
    }()
    
    lazy private var delayLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        lbl.textAlignment = .left
        lbl.textColor = getAppColor(color: .enable)
        lbl.font = UIFont.systemFont(ofSize: 24,weight: .bold)
        lbl.text = "Opasity"
        
        return lbl
    }()
    
    lazy private var delayField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        field.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.setCorners(corners: 8)
        
        field.textAlignment = .center
        field.textColor = getAppColor(color: .enable)
        field.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        field.keyboardType = .numberPad

        let bar = UIToolbar()
        bar.items = [done,cancel]
        bar.sizeToFit()

        field.inputAccessoryView = bar
        
        field.delegate = self
        
        return field
    }()
    
    func updateInfo() {
        delayField.text = "\(Int(project!.information.frames[project!.FrameSelected].layers[project!.LayerSelected].transparent * 100))"
        
        preview.image = project!.getLayer(frame: project!.FrameSelected, layer: project!.LayerSelected).withAlpha(CGFloat(project!.information.frames[project!.FrameSelected].layers[project!.LayerSelected].transparent))
        
        preview.backgroundColor = project!.backgroundColor
    }
    
    let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDone))
    
    let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onCancel))

    @objc func onDone(){
        let newAlpha = Int(delayField.text!)!
        
        project!.addAction(action: ["ToolID" : "\(Actions.changeLayerOpasity.rawValue)", "from" : "\(project!.information.frames[project!.FrameSelected].layers[project!.LayerSelected].transparent)", "to" : "\(CGFloat(newAlpha) / 100.0)", "frame" : "\(project!.FrameSelected)","layer" : "\(project!.LayerSelected)"])
        
        project!.setLayerOpasity(frame: project!.FrameSelected, layer: project!.LayerSelected, newOpasity: newAlpha)
        delegate?.updateLayerSettings(target: project!.LayerSelected)

        delayField.attributedPlaceholder = NSAttributedString(string: "\(project!.information.frames[project!.FrameSelected].delay)", attributes: [NSAttributedString.Key.foregroundColor : getAppColor(color: .disable)])
        delayField.text = "\(newAlpha)"

        preview.image = preview.image?.withAlpha(CGFloat(newAlpha) / 100.0)
        delayField.endEditing(true)
    }
    
    @objc func onCancel(){
        delayField.text = "\(Int(project!.information.frames[project!.FrameSelected].layers[project!.LayerSelected].transparent * 100))"
        delayField.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        view.addSubview(previewBg)
        view.addSubview(delayField)
        view.addSubview(delayLabel)
        view.addSubview(divider)
        
        previewBg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        previewBg.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        
        delayField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        delayField.topAnchor.constraint(equalTo: previewBg.bottomAnchor, constant: 12).isActive = true
        
        delayLabel.topAnchor.constraint(equalTo: previewBg.bottomAnchor,constant: 12).isActive = true
        delayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        delayLabel.rightAnchor.constraint(equalTo: delayField.leftAnchor, constant: -24).isActive = true
        
        divider.topAnchor.constraint(equalTo: delayLabel.bottomAnchor, constant: 24).isActive = true
        divider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36).isActive = true
        divider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -36).isActive = true
    }
    
}

extension LayerSettings: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        while (textField.text!.count > 3 || (textField.text!.count > 0 && Int(textField.text!) == nil)) {
            textField.text!.removeLast()
        }
        
        if textField.text != "" && Int(textField.text!)! > 100 {
            textField.text = "100"
        }
    
        if textField.text!.count == 0 {
            done.isEnabled = false
        } else {
            done.isEnabled = true
        }
        
        
    }
}
