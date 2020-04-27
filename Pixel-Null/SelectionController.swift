//
//  SelectionController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 26.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit


class SelectionController : UIViewController {
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
                .appendText(text: "Selection", fortt: UIFont(name: "Rubik-Bold", size: 48)!, textClr: ProjectStyle.uiEnableColor),
            UILabel()
            .setTextColor(color: ProjectStyle.uiEnableColor)
            .appendText(text: """
                Selection is a tool with which you can select a region on the canvas, which will be active for other tools. This means that the tools will not draw outside the selection. in addition, you can also delete / clear / expand / copy / cut the selection.

            """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .setMaxWidth(width: view.frame.width - 24)
                .setBreakMode(mode: .byWordWrapping),
                makeStack(orientation: .vertical, alignment: .center, distribution: .fill).addViews(views: [
                    UIView().addFullSizeView(view:
                        UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "selection_tool")!.data))
                        .setFilter(filter: .nearest)
                            .setBackground(color: UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1.0/26.25, orientation: .down)))
                        .setSize(size: CGSize(width: 210, height: 210))
                        .Corners(round: 16)
                    )
                    .Shadow(clr: ProjectStyle.uiShadowColor, rad: 4, opas: 0.5)
                    .setViewSize(size: CGSize(width: 210, height: 210)),
                    UILabel()
                    .setTextColor(color: ProjectStyle.uiEnableColor)
                    .appendText(text: "selection sample", fortt: UIFont(name: "Rubik-Regular", size: 12)!)
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
           scroll.contentSize.height = content.frame.height + 12
       }
}

