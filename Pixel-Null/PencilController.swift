//
//  PencilController.swift
//  new Testing
//
//  Created by Рустам Хахук on 13.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PencilController : UIViewController {
    lazy private var scroll : UIScrollView = {
       let scr = UIScrollView()
        scr.translatesAutoresizingMaskIntoConstraints = false
        
        scr.addSubview(stack)
        stack.leftAnchor.constraint(equalTo: scr.leftAnchor, constant: 12).isActive = true
//        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        stack.topAnchor.constraint(equalTo: scr.topAnchor, constant: 12).isActive = true
        
        return scr
    }()
    
    lazy private var stack : UIStackView = {
            makeStack(orientation: .vertical, alignment: .fill, distribution: .fill).addViews(views: [
                pencilTitle,
                text1,
                makeStack(orientation: .horizontal, alignment: .fill, distribution: .fillEqually).addViews(views: [
                    makeStack(orientation: .vertical, alignment: .center).addViews(views: [
                        UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "pixel_perfect_off")!.data))
                            .Corners(round: 10)
                            .setSize(size: CGSize(width: 120, height: 160))
                            .setBackground(color: UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1.0/20.0, orientation: .down)))
                            .setFilter(filter: .nearest),
                        UILabel()
                            .setText(text: "pixel perfect off")
                            .setTextColor(color: ProjectStyle.uiEnableColor)
                            .setFont(font: UIFont(name:  "Rubik-Regular", size: 12)!)
                    ]),
                makeStack(orientation: .vertical, alignment: .center).addViews(views: [
                    UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "pixel_perfect_on")!.data))
                        .Corners(round: 10)
                        .setSize(size: CGSize(width: 120, height: 160))
                        .setBackground(color: UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1.0/20.0, orientation: .down)))
                        .setFilter(filter: .nearest),
                    UILabel()
                        .setText(text: "pixel perfect on")
                        .setTextColor(color: ProjectStyle.uiEnableColor)
                        .setFont(font: UIFont(name:  "Rubik-Regular", size: 12)!)
                ])
                ]),
                text2,
                makeStack(orientation: .horizontal, alignment: .fill, distribution: .fillEqually).addViews(views: [
                    makeStack(orientation: .vertical, alignment: .center).addViews(views: [
                        UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "smoothing_x0")!.data)!)
                            .Corners(round: 10)
                            .setSize(size: CGSize(width: 120, height: 160))
                            .setBackground(color: UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1.0/20.0, orientation: .down)))
                            .setFilter(filter: .nearest),
                        UILabel()
                            .setText(text: "smoothing x0")
                            .setTextColor(color: ProjectStyle.uiEnableColor)
                            .setFont(font: UIFont(name:  "Rubik-Regular", size: 12)!)
                    ]),
                makeStack(orientation: .vertical, alignment: .center).addViews(views: [
                    UIImageView(image: UIImage.gifImageWithData(NSDataAsset(name: "smoothing_x24")!.data))
                        .Corners(round: 10)
                        .setSize(size: CGSize(width: 120, height: 160))
                        .setBackground(color: UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1.0/20.0, orientation: .down)))
                        .setFilter(filter: .nearest),
                    UILabel()
                        .setText(text: "smoothing x24")
                        .setTextColor(color: ProjectStyle.uiEnableColor)
                        .setFont(font: UIFont(name:  "Rubik-Regular", size: 12)!)
                ])
                ]),
                text3,
            ])
    }()
    
    lazy private var pencilTitle : UILabel = {
        let label = UILabel()
        label.text = "Pencil"
        label.textColor = ProjectStyle.uiEnableColor
        label.font = UIFont(name:  "Rubik-Bold", size: 48)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var text1 : UILabel = {
        let label = UILabel()
        label.textColor = ProjectStyle.uiEnableColor
        label.font = UIFont(name:  "Rubik-Regular", size: 18)
        
        label.textAlignment = .justified
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        
        let bold : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont(name:  "Rubik-Bold", size: 16) as Any]
        let normal : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont(name:  "Rubik-Regular", size: 16) as Any]
        
        let attributedString = NSMutableAttributedString(string:"""
            A pencil is a tool designed to draw curved lines by hand. You can draw lines of different widths and colors by changing the
        """, attributes:normal)
        
        attributedString.append(NSMutableAttributedString(string:" Pencil Color ", attributes:bold ))
        attributedString.append(NSMutableAttributedString(string:"and", attributes:normal))
        attributedString.append(NSMutableAttributedString(string:" Pencil Width ", attributes:bold ))
        attributedString.append( NSMutableAttributedString(string:
            """
            properties.
                The pencil also has a
            """, attributes:normal))
        attributedString.append(NSMutableAttributedString(string:" Pixel Perfect ", attributes:bold ))
        attributedString.append( NSMutableAttributedString(string:"""
         mode in which the lines are straightened in width, removing errors by hand.

        """, attributes:normal))
        label.attributedText = attributedString
        
        label.preferredMaxLayoutWidth = self.view.frame.width - 24

        
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()
    
    lazy private var text2 : UILabel = {
        let label = UILabel()
        
        
        let bold : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont(name:  "Rubik-Bold", size: 16) as Any]
        let normal : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont(name:  "Rubik-Regular", size: 16) as Any]
               
        let attributedString = NSMutableAttributedString(string:
            """

                You can also set the
            """, attributes:normal)
        
        
        attributedString.append(NSMutableAttributedString(string:" Smoothing ", attributes:bold))
        attributedString.append(NSMutableAttributedString(string:"property to make your lines smoother. But at the same time your line will be slightly behind your finger.\n", attributes:normal))

        label.textColor = ProjectStyle.uiEnableColor
        label.font = UIFont(name:  "Rubik-Regular", size: 16)
        
        label.textAlignment = .justified
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        label.attributedText = attributedString
        
        label.preferredMaxLayoutWidth = self.view.frame.width - 24

        
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()
    
    lazy private var text3 : UILabel = {
        let label = UILabel()
        
        
        let bold : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont(name:  "Rubik-Bold", size: 16) as Any]
        let normal : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont(name:  "Rubik-Regular", size: 16) as Any]
               
        let attributedString = NSMutableAttributedString(string:
            """

                Using the pencil tool, you can draw curved lines, a stroke, and just draw like a brush.

            """, attributes:normal)
        
        label.textColor = ProjectStyle.uiEnableColor
        label.font = UIFont(name:  "Rubik-Regular", size: 16)
        
        label.textAlignment = .justified
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        label.attributedText = attributedString
        
        label.preferredMaxLayoutWidth = self.view.frame.width - 24

        
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()
    
    lazy private var perfectPixelOff : UIImageView = {
        let img = UIImageView()

        if let asset = NSDataAsset(name: "pixel_perfect_off") {
            img.image = UIImage.gifImageWithData( asset.data)
        }
        
        img.contentMode = .scaleAspectFit
        img.layer.magnificationFilter = .nearest
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 160).isActive = true
        img.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        img.backgroundColor = UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1.0/20.0, orientation: .down))
        
        img.setCorners(corners: 10)
        return img
    }()

    
    lazy private var perfectPixelOn : UIImageView = {
        let img = UIImageView()

        if let asset = NSDataAsset(name: "pixel_perfect_on") {
            img.image = UIImage.gifImageWithData( asset.data)
        }
        
        img.contentMode = .scaleAspectFit
        img.layer.magnificationFilter = .nearest
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 160).isActive = true
        img.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        img.backgroundColor = UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1.0/20.0, orientation: .down))
        
        img.setCorners(corners: 10)
        return img
    }()

    
    
    override func viewDidLoad() {
        view.addSubview(scroll)
        
        scroll.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scroll.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        view.backgroundColor = ProjectStyle.uiBackgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        stack.layoutIfNeeded()
        scroll.contentSize.height = stack.frame.height + 64
        print(stack.frame.height)
    }
}
