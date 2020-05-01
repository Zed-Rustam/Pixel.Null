//
//  GradientController.swift
//  new Testing
//
//  Created by Рустам Хахук on 19.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GradientController : UIViewController {
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
                .appendText(text: "G", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(hex: "#8400B1FF")!)
                .appendText(text: "r", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(hex: "#9200B7FF")!)
                .appendText(text: "a", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(hex: "#A000BDFF")!)
                .appendText(text: "d", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(hex: "#AE00C3FF")!)
                .appendText(text: "i", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(hex: "#BC00C9FF")!)
                .appendText(text: "e", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(hex: "#CA00CFFF")!)
                .appendText(text: "n", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(hex: "#D800D5FF")!)
                .appendText(text: "t\n", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: UIColor(hex: "#E600DBFF")!),
            UILabel()
            .setTextColor(color: ProjectStyle.uiEnableColor)
            .appendText(text: """
                Gradient is a tool for drawing gradients (unexpectedly, right? :D).
                At the gradient you can choose the
            """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: " start color ", fortt: UIFont(name: "Rubik-Bold", size: 16)!)
                .appendText(text: "and", fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: " end color", fortt: UIFont(name: "Rubik-Bold", size: 16)!)
                .appendText(text: """
                .
                    In addition, you can set the
                """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: " step's count ", fortt: UIFont(name: "Rubik-Bold", size: 16)!)
                .appendText(text: """
                           for the gradient to make the gradient transition more pronounced. if the
                           """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: " step's count ", fortt: UIFont(name: "Rubik-Bold", size: 16)!)
                .appendText(text: """
                is equal to 0, then the gradient will be with the smoothest possible transition.\n
                """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .setMaxWidth(width: view.frame.width - 24)
                .setBreakMode(mode: .byWordWrapping),
            makeStack(orientation: .horizontal, alignment: .fill, distribution: .fillEqually).addViews(views: [
                makeStack(orientation: .vertical, alignment: .center, distribution: .fill).addViews(views: [
                    UIView().addFullSizeView(view:
                        UIImageView(image: #imageLiteral(resourceName: "gradient_x0"))
                        .setFilter(filter: .nearest)
                        .setSize(size: CGSize(width: 140, height: 210))
                        .Corners(round: 16)
                    )
                    .Shadow(clr: ProjectStyle.uiShadowColor, rad: 4, opas: 0.5)
                    .setViewSize(size: CGSize(width: 140, height: 210)),
                    UILabel()
                    .setTextColor(color: ProjectStyle.uiEnableColor)
                    .appendText(text: "Step's count x0", fortt: UIFont(name: "Rubik-Regular", size: 12)!)
                    ]),
                makeStack(orientation: .vertical, alignment: .center, distribution: .fill).addViews(views: [
                    UIView().addFullSizeView(view:
                        UIImageView(image: #imageLiteral(resourceName: "gradient_x8"))
                        .setFilter(filter: .nearest)
                        .setSize(size: CGSize(width: 140, height: 210))
                        .Corners(round: 16)
                    )
                        .Shadow(clr: ProjectStyle.uiShadowColor, rad: 4, opas: 0.5)
                        .setViewSize(size: CGSize(width: 140, height: 210)),
                    UILabel()
                        .setTextColor(color: ProjectStyle.uiEnableColor)
                        .appendText(text: "Step's count x8", fortt: UIFont(name: "Rubik-Regular", size: 12)!)
               ])
            ])
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
           scroll.contentSize.height = content.frame.height + 24
       }
}

