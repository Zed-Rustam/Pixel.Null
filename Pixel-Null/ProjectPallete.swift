//
//  ProjectPallete.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 24.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectPallete : UIViewController {
    var project : ProjectWork? = nil
    
    lazy private var palleteBar : UIView = {
       let mainview = UIView()
        mainview.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        mainview.translatesAutoresizingMaskIntoConstraints = false
        
        
        let bgView = UIView()
        bgView.backgroundColor = ProjectStyle.uiBackgroundColor
        bgView.setCorners(corners: 8)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        mainview.addSubview(selectBtn)
        selectBtn.rightAnchor.constraint(equalTo: mainview.rightAnchor, constant: 0).isActive = true
        selectBtn.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true
        
        mainview.addSubview(bgView)
        bgView.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 0).isActive = true
        bgView.rightAnchor.constraint(equalTo: selectBtn.leftAnchor, constant: -6).isActive = true
        bgView.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: mainview.bottomAnchor, constant: 0).isActive = true

        let openPalletesBtn = CircleButton(icon: #imageLiteral(resourceName: "pallete_collection_item"), frame: .zero)
        openPalletesBtn.translatesAutoresizingMaskIntoConstraints = false
        openPalletesBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        openPalletesBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        openPalletesBtn.setShadowColor(color: .clear)
        
        bgView.addSubview(openPalletesBtn)
        openPalletesBtn.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 3).isActive = true
        openPalletesBtn.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 3).isActive = true
        
        bgView.addSubview(palleteName)
        palleteName.leftAnchor.constraint(equalTo: openPalletesBtn.rightAnchor, constant: 3).isActive = true
        palleteName.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -12).isActive = true
        palleteName.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 0).isActive = true
        
        return mainview
    }()
    
    lazy private var palleteName : UILabel = {
        let label = UILabel().setTextColor(color: ProjectStyle.uiEnableColor).setFont(font: UIFont(name: "Rubik-Bold", size: 18)!).setText(text: "Project's Pallete")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        return label
    }()
    
    lazy private var selectBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero, icScale: 0.33)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.corners = 8
        
        return btn
    }()
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        //print("activate")
        view.addSubview(palleteBar)
        palleteBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        palleteBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        palleteBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        palleteBar.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        view.backgroundColor = ProjectStyle.uiBackgroundColor
    }
}
