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
    
    lazy var settingsButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 8,needMask: false)
        
        btn.setImage(#imageLiteral(resourceName: "settings_icon"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        
        btn.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        
        btn.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        btn.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 36, height: 36), cornerRadius: 8).cgPath
        
        return btn
    }()
    
    @objc func onPress() {
        frameControlDelegate?.openFrameControl(project: project)
    }
    
    
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
        settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        
        
        array.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        array.rightAnchor.constraint(equalTo: settingsButton.leftAnchor, constant: -8).isActive = true
        array.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        array.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
