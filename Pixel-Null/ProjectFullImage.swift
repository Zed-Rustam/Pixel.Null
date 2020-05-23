//
//  ProjectFullImage.swift
//  new Testing
//
//  Created by Рустам Хахук on 10.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit
class ProjectFullImage : UIViewController {
    private var proj : ProjectWork!
    private var timer = CADisplayLink()
    private var animationTime : Int = 0
    private var nowFrameIndex : Int = 0
    
    private var project : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.magnificationFilter = CALayerContentsFilter.nearest
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var background : UIImageView = {
        let bg = UIImageView(image: #imageLiteral(resourceName: "background"))
        bg.contentMode = .scaleAspectFill
        bg.layer.magnificationFilter = CALayerContentsFilter.nearest
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()

    func setProject(proj : ProjectWork){
        timer = CADisplayLink(target: self, selector: #selector(setFrame(link:)))
        timer.add(to: .main, forMode: .common)
        
        self.proj = proj
        project.image = proj.getFrame(frame: 0, size: proj.projectSize)
        
        project.backgroundColor = proj.backgroundColor
    }
    
    @objc func setFrame(link : CADisplayLink) {
        animationTime += Int(link.duration * 1000)
        if animationTime >= proj.animationDelay {
            animationTime = animationTime % proj.animationDelay
        }
        
        var nowTime = 0
        for i in 0..<proj.information.frames.count {
            nowTime += proj.information.frames[i].delay
            if nowTime >= animationTime && nowTime - proj.information.frames[i].delay < animationTime && i != nowFrameIndex {
                nowFrameIndex = i
                project.image = proj.getFrame(frame: i, size: proj.projectSize)
                break
            } else if nowTime >= animationTime {
                break
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        let minwidth = 64.0
        let minheight = 48.0
        
        let k = project.image!.size.height / project.image!.size.width

        if(k > 1){
           preferredContentSize = CGSize(width: height / k, height: height)
        } else {
            preferredContentSize = CGSize(width: width, height: width * k)
        }
        if(preferredContentSize.width < CGFloat(minwidth)) {
            preferredContentSize = CGSize(width: CGFloat(minwidth), height: preferredContentSize.height)
        }
        if(preferredContentSize.height < CGFloat(minheight)) {
            preferredContentSize = CGSize(width: preferredContentSize.width, height: CGFloat(minheight))
        }
        
        self.view.addSubview(background)
        self.view.addSubview(project)
    }
    
    override func viewDidLayoutSubviews() {
        project.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -1).isActive = true
        project.topAnchor.constraint(equalTo: view.topAnchor, constant: -1).isActive = true
        project.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 1).isActive = true
        project.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true

        background.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -1).isActive = true
        background.topAnchor.constraint(equalTo: view.topAnchor, constant: -1).isActive = true
        background.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 1).isActive = true
        background.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true
    }
}

