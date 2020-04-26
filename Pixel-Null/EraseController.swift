//
//  EraseController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 26.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class EraseController : UIViewController {
    weak var navigation : UINavigationController? = nil
    lazy private var scroll : UIScrollView = {
        let scrl = UIScrollView()
        scrl.translatesAutoresizingMaskIntoConstraints = false
        
        scrl.addSubview(content)
        content.leftAnchor.constraint(equalTo: scrl.leftAnchor, constant: 12).isActive = true
        content.topAnchor.constraint(equalTo: scrl.topAnchor, constant: 12).isActive = true
        content.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true

        return scrl
    }()
    
    lazy private var content : UIStackView = {
        let stack = makeStack(orientation: .vertical, alignment: .fill, distribution: .fill).addViews(views: [
            UILabel()
                .setTextColor(color: ProjectStyle.uiEnableColor)
                .appendText(text: "Eraser", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: ProjectStyle.uiEnableColor),
            UILabel()
            .setTextColor(color: ProjectStyle.uiEnableColor)
            .appendText(text: """
                An eraser is a tool that erases pixels, replacing them with a transparent color. This tool works just like a pencil tool. You can change the property
            """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                
                .appendText(text: " Eraser Width ", fortt: UIFont(name: "Rubik-Bold", size: 16)!)
                
                .appendText(text: "to increase the erased area.", fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .setMaxWidth(width: view.frame.width - 24)
                .setBreakMode(mode: .byWordWrapping)
        ])
        
        return stack
    }()
    
    override func viewDidLoad() {
        view.addSubview(scroll)
        
        view.backgroundColor = ProjectStyle.uiBackgroundColor
        scroll.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scroll.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
           content.layoutIfNeeded()
           scroll.contentSize.height = content.frame.height + 64
       }
}

