//
//  TransformController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 06.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit


class ShapeController : UIViewController {
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
                .setTextColor(color: UIColor(named: "enableColor")!)
                .appendText(text: "Shape", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(named: "enableColor")!),
            UILabel()
            .setTextColor(color: UIColor(named: "enableColor")!)
            .appendText(text: """
                Shape it is a tool with which you can draw different geometric shapes such as line / rectangle / ellipse, etc.
                In addition, the shape tool has a correct shape mode, in which the correct shapes will be drawn (for example, instead of a rectangle, you will always get a square, and instead of an ellipse, a circle)
            """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .setMaxWidth(width: view.frame.width - 24)
                .setBreakMode(mode: .byWordWrapping)
        ])
        
        return stack
    }()
    
    override func viewDidLoad() {
        view.addSubview(scroll)
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
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


