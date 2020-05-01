//
//  SelectorSettings.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 01.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SelectorSettings : UIViewController {
    
    weak var delegate : ToolSettingsDelegate? = nil
    lazy private var selectorTitle : UILabel = {
        let text = UILabel()
        text.textColor = ProjectStyle.uiEnableColor
        text.text = "Selector"
        text.font = UIFont(name: "Rubik-Bold", size: 24)
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return text
    }()
    
    lazy private var appendBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setShadowColor(color: .clear)

        btn.delegate = {[unowned self] in
            self.delegate?.setSelectionSettings(mode: self.startMode)
            self.dismiss(animated: true, completion: nil)
        }
        return btn
    }()
    
    lazy private var cancelBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "cancel_icon"), frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setShadowColor(color: .clear)
        
        btn.delegate = {[unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
        
        return btn
    }()
    
    lazy private var titleBg : UIView = {
       let mainBg = UIView()
        mainBg.translatesAutoresizingMaskIntoConstraints = false
        mainBg.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = ProjectStyle.uiBackgroundColor
        bg.setCorners(corners: 12)
        
        mainBg.addSubviewFullSize(view: bg)
        
        bg.addSubview(cancelBtn)
        bg.addSubview(appendBtn)
        bg.addSubview(selectorTitle)

        cancelBtn.leftAnchor.constraint(equalTo: bg.leftAnchor, constant: 6).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: bg.topAnchor, constant: 6).isActive = true
        
        appendBtn.rightAnchor.constraint(equalTo: bg.rightAnchor, constant: -6).isActive = true
        appendBtn.topAnchor.constraint(equalTo: bg.topAnchor, constant: 6).isActive = true

        selectorTitle.leftAnchor.constraint(equalTo: cancelBtn.rightAnchor, constant: 6).isActive = true
        selectorTitle.rightAnchor.constraint(equalTo: appendBtn.leftAnchor, constant: -6).isActive = true
        selectorTitle.topAnchor.constraint(equalTo: bg.topAnchor, constant: 0).isActive = true
        
        mainBg.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return mainBg
    }()
    
    lazy private var modeSelector : SegmentSelector = {
        let selector = SegmentSelector(imgs: [#imageLiteral(resourceName: "custom_shape_selector_icon"),#imageLiteral(resourceName: "rectangle_icon"),#imageLiteral(resourceName: "circle_icon"),#imageLiteral(resourceName: "selection_magic_tool_icon")])
        selector.selectDelegate = {[unowned self] in
            self.startMode = $0
        }
        return selector
    }()
    
    lazy private var modeText : UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = ProjectStyle.uiEnableColor
        text.text = "Selector Mode"
        text.font = UIFont(name: "Rubik-Medium", size: 20)
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return text
    }()
    
    var startMode : Int = 0
    
    func setDefault(mode : Selection.SelectionType) {
        startMode = mode.rawValue
    }
    
    override func viewDidLoad() {
        view.addSubview(titleBg)
        view.addSubview(modeText)
        view.addSubview(modeSelector)

        titleBg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        titleBg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        titleBg.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        
        modeText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        modeText.topAnchor.constraint(equalTo: titleBg.bottomAnchor, constant: 12).isActive = true
        
        modeSelector.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        modeSelector.topAnchor.constraint(equalTo: titleBg.bottomAnchor, constant: 12).isActive = true
        
        view.backgroundColor = ProjectStyle.uiBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modeSelector.select = startMode
    }
}
