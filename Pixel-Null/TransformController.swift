//
//  TransformController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 06.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit


class TransformController : UIViewController {
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
                .setTextColor(color: UIColor(named : "enableColor")!)
                .appendText(text: "Transform", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(named : "enableColor")!),
            UILabel()
            .setTextColor(color: UIColor(named : "enableColor")!)
            .appendText(text: """
                it is a tool with which you can transform whole layers or selected parts of layers. Using the transformation tool, you can:
                * Move region
                * Spin area
                * Scale area
                * Mirror vertically and horizontally
            If you have selected any area using the selection tool, then when choosing a transformation tool, you will work with the selected area. Otherwise, the entire layer will be selected.
            """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .setMaxWidth(width: view.frame.width - 24)
                .setBreakMode(mode: .byWordWrapping)
        ])
        
        return stack
    }()
    
    override func viewDidLoad() {
        view.addSubview(scroll)
        
        view.backgroundColor = UIColor(named : "backgroundColor")!
        scroll.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scroll.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
           content.layoutIfNeeded()
           scroll.contentSize.height = content.frame.height + 24
       }
}


