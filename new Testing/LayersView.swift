//
//  LayersView.swift
//  new Testing
//
//  Created by Рустам Хахук on 26.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit


class LayersView : UIView {
    private unowned var project : ProjectWork
    lazy private var settingsButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "settings_icon"), frame: .zero)
        btn.corners = 8
        btn.delegate = {[weak self] in
            self!.project.savePreview(frame: self!.project.FrameSelected)
            self!.frameControlDelegate?.openFrameControl(project: self!.project)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
    private var array : LayerList
    weak var frameControlDelegate : Editor? = nil
    var list : LayerList{
        get{
            return array
        }
    }
    
    func setProject(proj : ProjectWork){
        project = proj
        array.setProject(proj : project)
    }
    
    init(frame : CGRect, proj : ProjectWork){
        project = proj
        
        array = LayerList(frame: .zero, proj: project)
        array.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame : frame)

        addSubview(array)
        
        addSubview(settingsButton)
        
        
        settingsButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        
        array.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        array.rightAnchor.constraint(equalTo: settingsButton.leftAnchor, constant: -8).isActive = true
        array.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        array.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        translatesAutoresizingMaskIntoConstraints = false
    }
    
    deinit {
        print("layerView is deiniting")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
