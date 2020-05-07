//
//  FillController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 26.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FillController : UIViewController {
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
                .appendText(text: "Fill", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(named : "enableColor")!),
            UILabel()
            .setTextColor(color: UIColor(named : "enableColor")!)
            .appendText(text: """
                Fill is a tool that fills an area of ​​one color with another. You choose the place where to start filling and the area to fill.

            """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .setMaxWidth(width: view.frame.width - 24)
                .setBreakMode(mode: .byWordWrapping),
                makeStack(orientation: .vertical, alignment: .center, distribution: .fill).addViews(views: [
                   imageFill,
                    UILabel()
                    .setTextColor(color: UIColor(named : "enableColor")!)
                    .appendText(text: "fill sample", fortt: UIFont(name: "Rubik-Regular", size: 12)!)
                ])
        ])
        
        return stack
    }()
    
    lazy private var imageFill : UIView = {
        return  UIView().addFullSizeView(view:
                   UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "fill_tool")!.data))
                   .setFilter(filter: .nearest)
                   .setSize(size: CGSize(width: 210, height: 210))
                   .Corners(round: 16)
               )
               .setViewSize(size: CGSize(width: 210, height: 210))
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
        
            imageFill.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
            imageFill.subviews[0].backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 1.0/26.25, orientation: .down))
       }
}

