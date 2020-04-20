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
    private var project : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.magnificationFilter = CALayerContentsFilter.nearest
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private var background : UIImageView = {
        let bg = UIImageView(image: ProjectStyle.bgImage!)
        bg.contentMode = .scaleAspectFill
        bg.layer.magnificationFilter = CALayerContentsFilter.nearest
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()

    func setProject(proj : ProjectWork){
        self.proj = proj
        project.image = proj.getFrame(frame: 0, size: proj.projectSize)
        
        DispatchQueue.global().async {
            let img = UIImage.animatedImageWithSource(proj.createGif())
            
            DispatchQueue.main.async {
                self.project.image = img
                self.project.startAnimating()
            }
        }
        project.backgroundColor = proj.backgroundColor
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

