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
                .setTextColor(color: ProjectStyle.uiEnableColor)
                .setBreakMode(mode: .byWordWrapping)
                .setMaxWidth(width: view.frame.width - 24)
                .appendText(text: "Editor\n", fortt: UIFont(name: "Rubik-Bold", size: 48)!)
                .appendText(text: "    The editor is the place where you create your pictures and animations. Here is everything you need to work with pictures. It is divided into several parts:\n", fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: "        * Bar with layers and frames\n        * Tool bar\n        * working area\n", fortt: UIFont(name: "Rubik-Bold", size: 16)!)
                .appendText(text: "    let's talk about each item separately.\n\n", fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: "Frames and Layers bar\n", fortt: UIFont(name: "Rubik-Bold", size: 24)!)
                .appendText(text: "    This panel is at the top of the screen. It displays all the frames and layers of the project. The list of frames is displayed in the first line, and the list of layers of the selected frame in the second line. (You can read about layers and frames in the Training menu in the Layers, Frames section)\n", fortt: UIFont(name: "Rubik-Regular", size: 16)!)
        ])
        
        stack.addArrangedSubview(imgLFB)
        imgLFB.heightAnchor.constraint(equalTo: imgLFB.widthAnchor, multiplier: 356.0/1250.0).isActive = true

        stack.addArrangedSubview(
            UILabel().setTextColor(color: ProjectStyle.uiEnableColor).appendText(text: "frames and layers bar", fortt: UIFont(name: "Rubik-Regular", size: 12)!)
        )
        
        stack.addViews(views: [
            UILabel()
                .setTextColor(color: ProjectStyle.uiEnableColor)
                .setBreakMode(mode: .byWordWrapping)
                .setMaxWidth(width: view.frame.width - 24)
            .appendText(text:
                """

                    Also, if you want to paint a picture and will not use frames, then you can swipe up the bar and the line with frames will disappear, and the workspace will increase.
                    In addition, the bar on the right has 2 buttons. The top one starts the animation with the help of which you can see your animation in the workspace. Pressing the button again stops the animation. And the bottom button opens the frames and layers editor.

                """, fortt: UIFont(name: "Rubik-Regular", size: 16)!),
            UIView().addFullSizeView(view:
                UIImageView(image: #imageLiteral(resourceName: "frame_editor"))
                    .setContentMove(mode: .scaleAspectFit)
                    .setSize(size: CGSize(width: 200, height: 200 * 2.1653))
                    .Corners(round: 8)
            )
                .Shadow(clr: ProjectStyle.uiShadowColor, rad: 4, opas: 0.25)
                .setViewSize(size: CGSize(width: 200, height: 200 * 2.1653)),

            UILabel()
                .setTextColor(color: ProjectStyle.uiEnableColor)
                .appendText(text: "frames and layers editor", fortt: UIFont(name: "Rubik-Regular", size: 10)!),
            UILabel()
                .setTextColor(color: ProjectStyle.uiEnableColor)
                .setBreakMode(mode: .byWordWrapping)
                .setMaxWidth(width: view.frame.width - 24)
                .appendText(text: """

                    In this menu you can add / delete / move / clone frames and layers. You can also change properties such as frame duration and layer transparency.\n\n
                """, fortt: UIFont(name: "Rubik-Regular", size: 16)!)
                .appendText(text: "Tool Bar\n", fortt: UIFont(name: "Rubik-Bold", size: 24)!)
            .appendText(text: """
                This bar is located at the bottom of the screen. There are all the necessary tools for drawing. This bar is also divided into 2 parts.
                The main part is the place where all the tools and controls for drawing are located.
                The second part is an additional bar that appears when the selected tool has any additional actions. For example, the Symmetry tool has actions such as Turn vertical symmetry on, turn horizontal symmetry on, and center all symmetry. This bar appears and disappears on its own depending on the selected instrument.\n
            """, fortt:  UIFont(name: "Rubik-Regular", size: 16)!),
            UIView().addFullSizeView(view:
                UIImageView(image: #imageLiteral(resourceName: "tool_bar"))
                    .setContentMove(mode: .scaleAspectFit)
                    .setSize(size: CGSize(width: 300, height: 300 * 0.4))
                    .Corners(round: 8)
            )
                .Shadow(clr: ProjectStyle.uiShadowColor, rad: 4, opas: 0.25)
                .setViewSize(size: CGSize(width: 300, height: 300 * 0.4)),
            UILabel()
            .setTextColor(color: ProjectStyle.uiEnableColor)
            .appendText(text: "Tool bar", fortt: UIFont(name: "Rubik-Regular", size: 10)!),
        ])
        
        
        //imgLFB.widthAnchor.constraint(equalToConstant: self.view.frame.width - 24).isActive = true
        //imgLFB.heightAnchor.constraint(equalTo: imgLFB.widthAnchor, multiplier: 400.0 / 1250.0).isActive = true

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
        
        mainView.setShadow(color: ProjectStyle.uiShadowColor, radius: 4, opasity: 0.25)
        return mainView
    }()
    
    override func viewDidLoad() {
        view.addSubview(scroll)
        scroll.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scroll.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        //scroll.contentSize.height = content.frame.height + 6400

        view.backgroundColor = ProjectStyle.uiBackgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        content.layoutIfNeeded()
        scroll.contentSize.height = content.frame.height + 64 + 12
        print(content.frame.height)
    }
}
