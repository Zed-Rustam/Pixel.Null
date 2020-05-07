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
                .setTextColor(color: UIColor(named: "enableColor")!)
                .setBreakMode(mode: .byWordWrapping)
                .setMaxWidth(width: view.frame.width - 24)
                .appendText(text: "Editor\n", fortt: UIFont(name: "Rubik-Bold", size: 48)!)
                .appendText(text: "    An editor is a place where you create animations and images. Here is everything you need for drawing. The editor is divided into 3 parts:\n", fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: "        * Bar with layers and frames\n        * Toolbar\n        * Work area\n", fortt: UIFont(name: "Rubik-Bold", size: 16)!)
                .appendText(text: "Let's talk about each of them.\n\n", fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: "Frames and Layers bar\n", fortt: UIFont(name: "Rubik-Bold", size: 24)!)
                .appendText(text: "    This is the panel at the top of the screen. It displays all the frames and layers of the project. Frames are displayed on the first line, and layers on the second. Also, if you do not need to work with animation, then you can swipe up the panel to hide the line with frames and increase the workspace.\n", fortt: UIFont(name: "Rubik-Regular", size: 16)!)
        ])
        
        stack.addArrangedSubview(imgLFB)
        imgLFB.heightAnchor.constraint(equalTo: imgLFB.widthAnchor, multiplier: 356.0/1250.0).isActive = true

        stack.addArrangedSubview(
            UILabel().setTextColor(color:UIColor(named: "enableColor")!).appendText(text: "frames and layers bar\n\n", fortt: UIFont(name: "Rubik-Regular", size: 12)!)
        )
        
        stack.addViews(views: [
            UILabel()
                .setTextColor(color: UIColor(named: "enableColor")!)
                .setBreakMode(mode: .byWordWrapping)
                .setMaxWidth(width: view.frame.width - 24)
            .appendText(text:
                """
                
                    In addition, there are 2 buttons on the right side of this panel. The top one starts the animation in the editor to see the result obtained without having to exit the editor. Pressing this button again stops the animation. Clicking on the bottom button will open the frame and layer editor.

                """, fortt: UIFont(name: "Rubik-Regular", size: 16)!),
            frameEditor,

            UILabel()
                .setTextColor(color: UIColor(named: "enableColor")!)
                .appendText(text: "frames and layers editor", fortt: UIFont(name: "Rubik-Regular", size: 12)!),
            UILabel()
                .setTextColor(color: UIColor(named: "enableColor")!)
                .setBreakMode(mode: .byWordWrapping)
                .setMaxWidth(width: view.frame.width - 24)
                .appendText(text: """

                    In this menu you can add / delete / duplicate / move / hide / merge frames and layers. You can also change properties such as frame duration and layer transparency.\n\n
                """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: "Toolbar\n", fortt: UIFont(name: "Rubik-Bold", size: 24)!)
            .appendText(text: """
                This panel is at the bottom of the screen. It contains all the tools for working with the image. This panel is divided into 2 panels: the main one, in which the tools themselves are located, and the additional one, which appears if necessary if the tool has quick actions. At the same time, if some tool does not have quick actions, then the additional panel is hidden and does not occupy the workspace.\n
            """, fortt:  UIFont(name: "Rubik-Regular", size: 16)!),
            toolbarImg,
            UILabel()
            .setTextColor(color: UIColor(named: "enableColor")!)
            .appendText(text: "Toolbar\n", fortt: UIFont(name: "Rubik-Regular", size: 12)!),
            UILabel()
            .setTextColor(color: UIColor(named: "enableColor")!)
            .appendText(text: """
            
                If the tool has settings, then a long press on the tool will open the settings menu for this tool. In addition, you can swipe down the toolbar to leave only the top line of tools, while freeing up space for the working area. When Swipe up, the panel will open back. You can change the order of tools and adjust it for yourself in the application settings.
                Also on this panel is a button that opens the project settings. She looks like a gear. In the project settings, you can change such project properties as:
                 * Name
                 * Background color
                 * Project dimensions
            In addition to this, you can also rotate or mirror the project.\n\n
            """, fortt:  UIFont(name: "Rubik-Regular", size: 16)!)
            .appendText(text: "Work area\n", fortt: UIFont(name: "Rubik-Bold", size: 24)!)
            .appendText(text: """
                This is the area in which the selected frame is displayed. Here you can use the tools with your finger. Also, using gestures with two little boys, you can move and scale the canvas to your needs.
            """, fortt:  UIFont(name: "Rubik-Regular", size: 16)!)
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
