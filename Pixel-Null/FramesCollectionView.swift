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
    
    lazy var settingsButton : UIButton = {
        let btn = UIButton()
        btn.setCorners(corners: 8)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setImage(#imageLiteral(resourceName: "project_settings_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.addTarget(self, action: #selector(onSettings), for: .touchUpInside)
        
        btn.backgroundColor = getAppColor(color: .background)
        return btn
    }()
    
    @objc func onSettings(){
        let frameSettings = FrameSettings()
        frameSettings.modalPresentationStyle = .popover
        frameSettings.setInfo(project: self.project!)
        
        if let popover = frameSettings.popoverPresentationController {
            popover.sourceView = self
            popover.sourceRect = settingsButton.frame
            popover.delegate = self
            popover.permittedArrowDirections = .any
            self.parentController?.present(frameSettings, animated: true, completion: nil)
        }
    }
    
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
        
        settingsButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        settingsButton.layer.shadowPath = UIBezierPath(roundedRect: settingsButton.bounds, cornerRadius: 8).cgPath
    }
    
    override func tintColorDidChange() {
        list.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        
        settingsButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        settingsButton.layer.shadowPath = UIBezierPath(roundedRect: settingsButton.bounds, cornerRadius: 8).cgPath
        
        addButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        addButton.layer.shadowPath = UIBezierPath(roundedRect: settingsButton.bounds, cornerRadius: 8).cgPath
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
