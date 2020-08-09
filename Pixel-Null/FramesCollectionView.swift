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
        ls.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        return ls
    }()
    
    weak var parentController : UIViewController? = nil
    
    lazy private var frameText : UILabel = {
           let text = UILabel(frame: .zero)
           text.text = NSLocalizedString("Frames", comment: "")
           text.font = UIFont(name: "Rubik-Bold", size: 32)
           text.textColor = UIColor(named: "enableColor")
           text.translatesAutoresizingMaskIntoConstraints = false
           text.heightAnchor.constraint(equalToConstant: 36).isActive = true
           return text
       }()
 
//    lazy var addButton : CircleButton = {
//        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: .zero)
//        btn.corners = 6
//        btn.delegate = { [weak self] in
//            self!.project!.insertFrame(at: self!.project!.FrameSelected + 1)
//            self!.project!.addAction(action: ["ToolID" : "\(Actions.frameAdd.rawValue)", "frame" : "\(self!.project!.FrameSelected + 1)"])
//
//            if(self!.project!.frameCount >= 128) {
//                self!.addButton.isEnabled = false
//            }
//
//            self!.list.frameDelegate!.addFrame(at: self!.project!.FrameSelected + 1)
//        }
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
//        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
//
//        return btn
//    }()
    
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
    
    lazy var settingsButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "project_settings_icon"), frame: .zero)
        btn.corners = 6
        btn.delegate = { [unowned self] in
            let frameSettings = FrameSettings()
            frameSettings.modalPresentationStyle = .popover
            
            if let popover = frameSettings.popoverPresentationController {
                popover.sourceView = self
                popover.sourceRect = btn.frame
                popover.delegate = self
                popover.permittedArrowDirections = .any
                self.parentController?.present(frameSettings, animated: true, completion: nil)
            }
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
    
    var dublicateButton : CircleButton!
    weak var project : ProjectWork?
    
    
    @objc func onPress() {
        project!.insertFrame(at: project!.FrameSelected + 1)
        project!.addAction(action: ["ToolID" : "\(Actions.frameAdd.rawValue)", "frame" : "\(project!.FrameSelected + 1)"])

        if(project!.frameCount >= 128) {
            addButton.isEnabled = false
        }

        list.frameDelegate!.addFrame(at: project!.FrameSelected + 1)
    }
    
    init(proj : ProjectWork) {
        project = proj
        
        super.init(frame : .zero)
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(frameText)
        self.addSubview(list)
        self.addSubview(addButton)
        self.addSubview(settingsButton)

        frameText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        frameText.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true

        list.topAnchor.constraint(equalTo: frameText.bottomAnchor, constant: 6).isActive = true
        list.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        list.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true

        addButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        addButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        settingsButton.rightAnchor.constraint(equalTo: addButton.leftAnchor, constant: -6).isActive = true
        settingsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        
        //delayField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        //delayField.topAnchor.constraint(equalTo: list.bottomAnchor, constant: 6).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FramesCollectionView : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
