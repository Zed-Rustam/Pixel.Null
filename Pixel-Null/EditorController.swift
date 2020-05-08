//
//  EditorController.swift
//  new Testing
//
//  Created by Рустам Хахук on 13.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class EditorController : UIViewController {
    weak var navigation : UINavigationController? = nil
    
    lazy private var scroll : UIScrollView = {
        let scr = UIScrollView()
        scr.translatesAutoresizingMaskIntoConstraints = false
        
        scr.addSubview(content)
        content.leftAnchor.constraint(equalTo: scr.leftAnchor, constant: 12).isActive = true
        content.widthAnchor.constraint(equalToConstant: self.view.frame.width - 24).isActive = true
        content.topAnchor.constraint(equalTo: scr.topAnchor, constant: 12).isActive = true

        return scr
    }()
    
    lazy private var content : UIStackView = {
        let stack = makeStack(orientation: .vertical, alignment: .center, distribution: .fill).addViews(views: [
            UILabel()
                .setTextColor(color: getAppColor(color: .enable))
                .setBreakMode(mode: .byWordWrapping)
                .setMaxWidth(width: view.frame.width - 24)
                .appendText(text: "\(NSLocalizedString("Editor", comment: ""))\n", fortt: UIFont(name: "Rubik-Bold", size: 48)!)
                .appendText(text: NSLocalizedString("Editor text 1", comment: ""), fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: NSLocalizedString("Editor text 2", comment: ""), fortt: UIFont(name: "Rubik-Bold", size: 16)!)
                .appendText(text: NSLocalizedString("Editor text 3", comment: ""), fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: NSLocalizedString("Editor text 4", comment: ""), fortt: UIFont(name: "Rubik-Bold", size: 24)!)
                .appendText(text: NSLocalizedString("Editor text 5", comment: ""), fortt: UIFont(name: "Rubik-Regular", size: 16)!)
        ])
        
        stack.addArrangedSubview(imgLFB)
        imgLFB.heightAnchor.constraint(equalTo: imgLFB.widthAnchor, multiplier: 356.0/1250.0).isActive = true

        stack.addArrangedSubview(
            UILabel().setTextColor(color:UIColor(named: "enableColor")!).appendText(text: NSLocalizedString("Editor text 4", comment: ""), fortt: UIFont(name: "Rubik-Regular", size: 12)!)
        )
        
        stack.addViews(views: [
            UILabel()
                .setTextColor(color: UIColor(named: "enableColor")!)
                .setBreakMode(mode: .byWordWrapping)
                .setMaxWidth(width: view.frame.width - 24)
            .appendText(text: NSLocalizedString("Editor text 6", comment: ""), fortt: UIFont(name: "Rubik-Regular", size: 16)!),
            frameEditor,

            UILabel()
                .setTextColor(color: UIColor(named: "enableColor")!)
                .appendText(text: NSLocalizedString("Editor text 7", comment: ""), fortt: UIFont(name: "Rubik-Regular", size: 12)!),
            UILabel()
                .setTextColor(color: UIColor(named: "enableColor")!)
                .setBreakMode(mode: .byWordWrapping)
                .setMaxWidth(width: view.frame.width - 24)
                .appendText(text: NSLocalizedString("Editor text 8", comment: ""), fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                
            .appendText(text: NSLocalizedString("Editor text 9", comment: ""), fortt: UIFont(name: "Rubik-Bold", size: 24)!)
            .appendText(text: NSLocalizedString("Editor text 10", comment: ""), fortt:  UIFont(name: "Rubik-Regular", size: 16)!),
            toolbarImg,
            UILabel()
            .setTextColor(color: UIColor(named: "enableColor")!)
            .appendText(text: NSLocalizedString("Editor text 9", comment: ""), fortt: UIFont(name: "Rubik-Regular", size: 12)!),
            UILabel()
            .setTextColor(color: UIColor(named: "enableColor")!)
            .appendText(text: NSLocalizedString("Editor text 11", comment: ""), fortt:  UIFont(name: "Rubik-Regular", size: 16)!)
            .appendText(text: NSLocalizedString("Editor text 12", comment: ""), fortt: UIFont(name: "Rubik-Bold", size: 24)!)
            .appendText(text: NSLocalizedString("Editor text 13", comment: ""), fortt:  UIFont(name: "Rubik-Regular", size: 16)!)
            .setBreakMode(mode: .byWordWrapping)
            .setMaxWidth(width: view.frame.width - 24)
        ])
        
        return stack
    }()
    
    lazy private var imgLFB : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImageView(image: #imageLiteral(resourceName: "frames_layers_bar_light"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setCorners(corners: 8)
        
        mainView.addSubview(img)
        img.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        img.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        img.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        img.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        
        return mainView
    }()
    
    lazy private var toolbarImg : UIView = {
       return UIView().addFullSizeView(view:
           UIImageView(image: #imageLiteral(resourceName: "tool_bar"))
               .setContentMove(mode: .scaleAspectFit)
               .setSize(size: CGSize(width: 300, height: 300 * 0.4))
               .Corners(round: 8)
       )
           .Shadow(clr: getAppColor(color: .shadow), rad: 4, opas: 0.25)
           .setViewSize(size: CGSize(width: 300, height: 300 * 0.4))
    }()
    
    lazy private var frameEditor : UIView = {
       return UIView().addFullSizeView(view:
           UIImageView(image: #imageLiteral(resourceName: "frame_editor"))
               .setContentMove(mode: .scaleAspectFit)
               .setSize(size: CGSize(width: 200, height: 200 * 1.066))
               .Corners(round: 8)
       )
           .Shadow(clr: getAppColor(color: .shadow), rad: 4, opas: 0.25)
           .setViewSize(size: CGSize(width: 200, height: 200 * 1.066))
    }()
    
    override func viewDidLoad() {
        view.addSubview(scroll)
        scroll.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scroll.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    override func viewDidLayoutSubviews() {
        content.layoutIfNeeded()
        scroll.contentSize.height = content.frame.height + 24
        print(content.frame.height)
        
        imgLFB.setShadow(color: UIColor(named: "shadowColor")!, radius: 4, opasity: 1)
        toolbarImg.setShadow(color: UIColor(named: "shadowColor")!, radius: 4, opasity: 1)
        frameEditor.setShadow(color: UIColor(named: "shadowColor")!, radius: 4, opasity: 1)

    }
}
