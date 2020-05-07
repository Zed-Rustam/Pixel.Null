//
//  SymmetryController.swift
//  new Testing
//
//  Created by Рустам Хахук on 18.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SymmetryController : UIViewController {
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
                .appendText(text: "Symmetry\n", fortt: UIFont(name: "Rubik-Bold", size: 48)!),
            UILabel()
            .setTextColor(color: UIColor(named: "enableColor")!)
            .appendText(text: """
                Symmetry is a tool that helps you save time and draw symmetrical images. This tool has 2 types of symmetry: vertical and horizontal. Each of them can be moved around the canvas.\n
            """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .setMaxWidth(width: view.frame.width - 24)
                .setBreakMode(mode: .byWordWrapping),
            makeStack(orientation: .horizontal, alignment: .center, distribution: .fillEqually).addViews(views: [
                makeStack(orientation: .vertical, alignment: .center, distribution: .equalSpacing).addViews(views: [
                    symmetryOff,
                    UILabel()
                        .setTextColor(color: UIColor(named: "enableColor")!)
                        .setBreakMode(mode: .byWordWrapping)
                        .appendText(text: "Symmetry off\n", fortt: UIFont(name: "Rubik-Regular", size: 12)!),
                ]),
                makeStack(orientation: .vertical, alignment: .center, distribution: .equalSpacing).addViews(views: [
                    symmetryVertical,
                    UILabel()
                        .setTextColor(color: UIColor(named: "enableColor")!)
                        .setBreakMode(mode: .byWordWrapping)
                        .appendText(text: "Symmetry vertical\n", fortt: UIFont(name: "Rubik-Regular", size: 12)!),
                ])
            ]),
            makeStack(orientation: .horizontal, alignment: .center, distribution: .fillEqually).addViews(views: [
                makeStack(orientation: .vertical, alignment: .center, distribution: .fill).addViews(views: [
                    symmetryHorizontal,
                    UILabel()
                        .setTextColor(color: UIColor(named: "enableColor")!)
                        .setBreakMode(mode: .byWordWrapping)
                        .appendText(text: "Symmetry horizontal\n", fortt: UIFont(name: "Rubik-Regular", size: 12)!),
                ]),
                makeStack(orientation: .vertical, alignment: .center, distribution: .fill).addViews(views: [
                    symmetryAll,
                    UILabel()
                        .setTextColor(color: UIColor(named: "enableColor")!)
                        .setBreakMode(mode: .byWordWrapping)
                        .appendText(text: "Symmetry all on\n", fortt: UIFont(name: "Rubik-Regular", size: 12)!),
                ])
            ]),
            UILabel()
            .setTextColor(color: UIColor(named: "enableColor")!)
            .setMaxWidth(width: view.frame.width - 24)
            .setBreakMode(mode: .byWordWrapping)
            .appendText(text: """
                Symmetry works with all tools except
            """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
            .appendText(text: " Gradient ", fortt: UIFont(name: "Rubik-Bold", size: 16)!)
            .appendText(text: "and", fortt: UIFont(name: "Rubik-Regular", size: 16)!)
            .appendText(text: " Transform ", fortt: UIFont(name: "Rubik-Bold", size: 16)!)
            .appendText(text: "tools.", fortt: UIFont(name: "Rubik-Regular", size: 16)!),
        ])
        
        return stack
    }()
    
    lazy private var symmetryHorizontal : UIView = {
        return UIView()
        .addFullSizeView(view:
            UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "symmetry_horizontal")!.data))
                .setSize(size: CGSize(width: 132, height: 132))
                .setFilter(filter: .nearest)
                .Corners(round: 16)
            )
        .setViewSize(size: CGSize(width: 132, height: 132))
    }()

    lazy private var symmetryVertical : UIView = {
        return UIView()
        .addFullSizeView(view:
            UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "symmetry_vertical")!.data))
                .setSize(size: CGSize(width: 132, height: 132))
                .setFilter(filter: .nearest)
                .Corners(round: 16)
            )
        .setViewSize(size: CGSize(width: 132, height: 132))
    }()
    
    lazy private var symmetryOff : UIView = {
        return UIView()
        .addFullSizeView(view:
            UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "symmetry_off")!.data))
                .setSize(size: CGSize(width: 132, height: 132))
                .setFilter(filter: .nearest)
                .Corners(round: 16)
            )
        .setViewSize(size: CGSize(width: 132, height: 132))
    }()
    
    lazy private var symmetryAll : UIView = {
        return UIView()
        .addFullSizeView(view:
            UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "symmetry_all")!.data))
                .setSize(size: CGSize(width: 132, height: 132))
                .setFilter(filter: .nearest)
                .Corners(round: 16)
            )
        .setViewSize(size: CGSize(width: 132, height: 132))
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
        
        symmetryHorizontal.subviews[0].backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 1.0/16.5, orientation: .down))
        symmetryHorizontal.setShadow(color: UIColor(named : "shadowColor")!, radius: 8, opasity: 1)
        
        symmetryVertical.subviews[0].backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 1.0/16.5, orientation: .down))
        symmetryVertical.setShadow(color: UIColor(named : "shadowColor")!, radius: 8, opasity: 1)
        
        symmetryAll.subviews[0].backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 1.0/16.5, orientation: .down))
        symmetryAll.setShadow(color: UIColor(named : "shadowColor")!, radius: 8, opasity: 1)
        
        symmetryOff.subviews[0].backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 1.0/16.5, orientation: .down))
        symmetryOff.setShadow(color: UIColor(named : "shadowColor")!, radius: 8, opasity: 1)
    }
}
