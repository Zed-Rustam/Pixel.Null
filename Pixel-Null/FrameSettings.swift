//
//  FrameSettings.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 20.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FrameSettings : UIViewController {
    weak var project: ProjectWork? = nil
    
    lazy private var framePreview: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 196).isActive = true
        img.heightAnchor.constraint(equalToConstant: 196).isActive = true
        
        img.backgroundColor = getAppColor(color: .disable)
        img.layer.magnificationFilter = .nearest
        img.contentMode = .scaleAspectFit
        
        img.setCorners(corners: 12,needMask: true)
        return img
    }()
    
    lazy private var bg: UIView = {
        let view = UIView()
        view.setCorners(corners: 12,needMask: true)
        
        view.backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 8 / 196, orientation: .down))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 196).isActive = true
        view.heightAnchor.constraint(equalToConstant: 196).isActive = true
        view.layer.magnificationFilter = .nearest
        
        view.addSubview(framePreview)
        framePreview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        framePreview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        return view
    }()
    
    lazy private var actionsBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(UIImage(systemName: "ellipsis",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), for: .normal)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 8)
        
        btn.showsMenuAsPrimaryAction = true
        btn.menu = UIMenu(title: "", image: nil, identifier: .none, children: [
            UIAction(title: "Set for all frames", image: nil, identifier: nil, discoverabilityTitle: nil, handler: {action in
                              
                let newDelay = Int(self.delayField.text!) ?? self.project!.information.frames[self.project!.FrameSelected].delay >= 10 ? Int(self.delayField.text!) ?? self.project!.information.frames[self.project!.FrameSelected].delay : 10

                var delays: String = ""
                
                for i in self.project!.information.frames {
                    delays += "\(i.delay) "
                }
                delays.removeLast()
                
                self.project!.addAction(action: ["ToolID" : "\(Actions.allFramesDelayChenge.rawValue)", "newDelay" : "\(newDelay)", "oldDelays" : "\(delays)"])
                self.project!.changeDelayForAllFrames(delay: newDelay)
                self.delayField.text = "\(newDelay)"

            })
        ])
        
        return btn
    }()
    
    lazy private var delayLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        lbl.textAlignment = .left
        lbl.textColor = getAppColor(color: .enable)
        lbl.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
        lbl.text = "Delay"
        
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
    
    let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDone))
    
    let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onCancel))

    @objc func onDone(){
        let newDelay = Int(delayField.text!)! >= 10 ? delayField.text! : "10"
        project!.addAction(action: ["ToolID" : "\(Actions.changeFrameDelay.rawValue)", "from" : "\(project!.information.frames[project!.FrameSelected].delay)", "to" : "\(newDelay)", "frame" : "\(project!.FrameSelected)"])
        project!.setFrameDelay(frame: project!.FrameSelected, delay: Int(newDelay)!)
        
        delayField.attributedPlaceholder = NSAttributedString(string: "\(project!.information.frames[project!.FrameSelected].delay)", attributes: [NSAttributedString.Key.foregroundColor : getAppColor(color: .disable)])
        delayField.text = newDelay
        
        delayField.endEditing(true)
    }
    
    @objc func onCancel(){
        delayField.text = "\(project!.information.frames[project!.FrameSelected].delay)"
        delayField.endEditing(true)
    }
    
    override func viewDidLoad() {
        preferredContentSize = CGSize(width: 220, height: 268)
        view.backgroundColor = getAppColor(color: .background)

        view.addSubview(bg)
        view.addSubview(actionsBtn)
        view.addSubview(delayField)
        view.addSubview(delayLabel)
        
        bg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        bg.bottomAnchor.constraint(equalTo: actionsBtn.topAnchor, constant: -12).isActive = true
        
        actionsBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        actionsBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        delayField.rightAnchor.constraint(equalTo: actionsBtn.leftAnchor, constant: -12).isActive = true
        delayField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        
        delayLabel.bottomAnchor.constraint(equalTo: delayField.bottomAnchor).isActive = true
        delayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        delayLabel.rightAnchor.constraint(equalTo: delayField.leftAnchor, constant: -12).isActive = true
    }
    
    
    override func viewDidLayoutSubviews() {
        actionsBtn.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        actionsBtn.layer.shadowPath = UIBezierPath(roundedRect: actionsBtn.bounds, cornerRadius: 8).cgPath
    }
    
    func setInfo(project: ProjectWork){
        framePreview.backgroundColor = project.backgroundColor
        framePreview.image = project.getFrame(frame: project.FrameSelected, size: project.projectSize)
        delayField.text = "\(project.information.frames[project.FrameSelected].delay)"
        delayField.attributedPlaceholder = NSAttributedString(string: "\(project.information.frames[project.FrameSelected].delay)", attributes: [NSAttributedString.Key.foregroundColor : getAppColor(color: .disable)])

        
        self.project = project
    }
}


extension FrameSettings: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        while (textField.text!.count > 4 || (textField.text!.count > 0 && Int(textField.text!) == nil)) {
            textField.text!.removeLast()
        }
        
        if textField.text!.count == 0 {
            done.isEnabled = false
        } else {
            done.isEnabled = true
        }
        
        
    }
}
