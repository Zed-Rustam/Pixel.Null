//
//  PalletesDialog.swift
//  new Testing
//
//  Created by Рустам Хахук on 12.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalletesDialog: UIView {

    lazy private var palleteTitle : UILabel = {
        let label = UILabel()
        
        label.textColor = ProjectStyle.uiEnableColor
        label.textAlignment = .left
        label.font = UIFont(name:  "Rubik-Medium", size: 18)
        label.text = "Default Pallete"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return label
    }()
    
    lazy private var palleteSelect : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "pallete_collection_item"), frame: .zero)
        btn.setShadowColor(color: .clear)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return btn
    }()
    
    lazy private var PalleteBar : UIView = {
        let mainview = UIView()
        
        let subview = UIView()
        subview.setCorners(corners: 12)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = ProjectStyle.uiBackgroundColor
        
        mainview.addSubview(subview)
        mainview.addSubview(palleteTitle)
        mainview.addSubview(palleteSelect)
        
        subview.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 0).isActive = true
        subview.rightAnchor.constraint(equalTo: mainview.rightAnchor, constant: 0).isActive = true
        subview.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true
        subview.bottomAnchor.constraint(equalTo: mainview.bottomAnchor, constant: 0).isActive = true

        palleteSelect.centerYAnchor.constraint(equalTo: mainview.centerYAnchor, constant: 0).isActive = true
        palleteSelect.rightAnchor.constraint(equalTo: mainview.rightAnchor, constant: -4).isActive = true
        
        palleteTitle.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 8).isActive = true
        palleteTitle.rightAnchor.constraint(equalTo: palleteSelect.leftAnchor, constant: -8).isActive = true
        palleteTitle.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true
        
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        mainview.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        return mainview
    }()
    
    
    init() {
        super.init(frame: .zero)

        addSubview(PalleteBar)
        
        PalleteBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        PalleteBar.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        PalleteBar.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
