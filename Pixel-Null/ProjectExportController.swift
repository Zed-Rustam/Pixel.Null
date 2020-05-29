//
//  ProjectExportController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 23.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectExportController: UIViewController {
    weak var project: ProjectWork? = nil
    
    lazy private var titleBg: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = getAppColor(color: .background)
        view.layer.cornerRadius = 8
        
        view.addSubviewFullSize(view: titleText, paddings: (42,-42,0,0))
        view.addSubview(exitBtn)
        view.addSubview(appendBtn)

        exitBtn.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        exitBtn.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        appendBtn.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        appendBtn.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        return view
    }()
    
    lazy private var exitBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "cancel_icon"), frame: .zero, icScale: 0.33)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.corners = 8
        btn.setShadowColor(color: .clear)
        
        btn.delegate = {[unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
        
        return btn
    }()
    
    lazy private var appendBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "share_icon"), frame: .zero, icScale: 0.4)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.corners = 8
        btn.setShadowColor(color: .clear)
        
        btn.delegate = {[unowned self] in
            switch self.exportSelector.select {
            case 0:
                self.present(UIActivityViewController(activityItems: [self.project!.getProjectDirectory()], applicationActivities: nil), animated: true, completion: nil)
            case 1:
                
                let activity = UIActivityViewController(activityItems: [self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName).png")], applicationActivities: nil)
                activity.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                        try? FileManager.default.removeItem(at: self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName).png"))
                    print("deleted")
                }
                
                try! self.project!.getFrameWithBackground(frame: 0).scale(scaleFactor: CGFloat(self.scale)).flip(xFlip: self.project!.isFlipX, yFlip: self.project!.isFlipY).pngData()?.write(to: self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName).png"))
                
                self.present(activity, animated: true, completion: nil)
            case 2:
                let activity = UIActivityViewController(activityItems: [self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName).gif")], applicationActivities: nil)
                activity.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                        try? FileManager.default.removeItem(at: self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName).gif"))
                    print("deleted")
                }
                
                self.project!.generateGif(scale: CGFloat(self.scale))
                self.present(activity, animated: true, completion: nil)

            case 3:
                self.project?.generateGroupOfImages(scale: CGFloat(self.scale))
                
                let activity = UIActivityViewController(activityItems: [self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName)")], applicationActivities: nil)
                activity.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                        try? FileManager.default.removeItem(at: self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName)"))
                        print("deleted")
                }
                
                self.present(activity, animated: true, completion: nil)
                
            case 4:
                let activity = UIActivityViewController(activityItems: [self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName).png")], applicationActivities: nil)
                activity.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                        try? FileManager.default.removeItem(at: self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName).png"))
                    print("deleted")
                }
                
                try! self.project!.generateSpriteList(scale: CGFloat(self.scale)).pngData()!.write(to: self.project!.getProjectDirectory().appendingPathComponent("\(self.project!.userProjectName).png"))
                
                self.present(activity, animated: true, completion: nil)
                
                
            default:
                break
            }
        }
        
        return btn
    }()
    
    lazy private var titleText: UILabel = {
        let text = UILabel()
        text.text = "Export project"
        text.font = UIFont(name: "Rubik-Bold", size: 24)
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = getAppColor(color: .enable)
        return text
    }()
    
    lazy private var image: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "background")
        img.contentMode = .scaleAspectFill
        img.layer.magnificationFilter = .nearest
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setCorners(corners: 12)
                
        if project!.projectSize.width > project!.projectSize.height {
            img.widthAnchor.constraint(equalToConstant: 108).isActive = true
            img.heightAnchor.constraint(equalTo: img.widthAnchor, multiplier: max(0.25,project!.projectSize.height / project!.projectSize.width)).isActive = true
        } else {
            img.heightAnchor.constraint(equalToConstant: 108).isActive = true
            img.widthAnchor.constraint(equalTo: img.heightAnchor, multiplier: max(0.25,project!.projectSize.width / project!.projectSize.height)).isActive = true
        }
        
        img.addSubviewFullSize(view: resultImage)
        
        return img
    }()
    
    lazy private var resultImage : UIImageView = {
        let img = UIImageView()
        
        img.image = project?.getFrameWithBackground(frame: 0).flip(xFlip: project!.isFlipX, yFlip: project!.isFlipY)
        img.contentMode = .scaleAspectFill
        img.layer.magnificationFilter = .nearest
        
        return img
    }()
    
    lazy private var projectName: UILabel = {
        let text = UILabel()
        text.text = project?.userProjectName
        
        text.font = UIFont(name: "Rubik-Bold", size: 20)
        text.textAlignment = .left
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = getAppColor(color: .enable)
        text.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return text
    }()
    
    lazy private var exportInfo: UILabel = {
        let text = UILabel()
        text.text = "Will export like a project file"
           
        text.font = UIFont(name: "Rubik-Medium", size: 12)
        text.textAlignment = .left
        text.adjustsFontSizeToFitWidth = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = getAppColor(color: .enable)
        text.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return text
    }()
    
    lazy private var sizeInfo: UILabel = {
        let text = UILabel()
        text.text = ""
           
        text.font = UIFont(name: "Rubik-Medium", size: 12)
        text.textAlignment = .left
        text.adjustsFontSizeToFitWidth = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = getAppColor(color: .enable)
        text.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return text
    }()
    
    lazy private var filesSizeInfo: UILabel = {
        let text = UILabel()
        text.text = ""
           
        text.font = UIFont(name: "Rubik-Medium", size: 12)
        text.textAlignment = .right
        text.adjustsFontSizeToFitWidth = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = getAppColor(color: .enable)
        text.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return text
    }()
    
    lazy private var scaleTitle: UILabel = {
        let text = UILabel()
        text.text = "Scale"
        text.font = UIFont(name: "Rubik-Medium", size: 16)
        text.textAlignment = .left
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = getAppColor(color: .enable)
        text.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return text
    }()
    
    lazy private var scaleSelector: SegmentSelector = {
        var segment : SegmentSelector
        segment = SegmentSelector(imgs: [#imageLiteral(resourceName: "scale_1x_icon"),#imageLiteral(resourceName: "scale_2x_icon"),#imageLiteral(resourceName: "scale_4x_icon"),#imageLiteral(resourceName: "scale_8x_icon"),#imageLiteral(resourceName: "scale_16x_icon")])
        
        if project!.projectSize.width == 512 || project!.projectSize.height == 512 {
            segment = SegmentSelector(imgs: [#imageLiteral(resourceName: "scale_1x_icon"),#imageLiteral(resourceName: "scale_2x_icon")])
        } else if project!.projectSize.width < 512 && project!.projectSize.width >= 256 || project!.projectSize.height < 512 && project!.projectSize.height >= 256 {
            segment = SegmentSelector(imgs: [#imageLiteral(resourceName: "scale_1x_icon"),#imageLiteral(resourceName: "scale_2x_icon"),#imageLiteral(resourceName: "scale_4x_icon")])
        } else if project!.projectSize.width < 256 && project!.projectSize.width >= 128 || project!.projectSize.height < 256 && project!.projectSize.height >= 128 {
            segment = SegmentSelector(imgs: [#imageLiteral(resourceName: "scale_1x_icon"),#imageLiteral(resourceName: "scale_2x_icon"),#imageLiteral(resourceName: "scale_4x_icon"),#imageLiteral(resourceName: "scale_8x_icon")])
        }
        
        
        segment.select = 0
        
        segment.selectDelegate = {[unowned self] select in
            switch self.exportSelector.select {
            case 0:
                self.filesSizeInfo.text = ""
                self.sizeInfo.text = ""
            case 1, 2:
                self.filesSizeInfo.text = "1 file : \(Int(self.project!.projectSize.width * CGFloat(self.scale)))x\(Int(self.project!.projectSize.height * CGFloat(self.scale)))"
                self.sizeInfo.text = "file(s) size"
            case 3:
                self.filesSizeInfo.text = "\(self.project!.frameCount) file\(self.project!.frameCount > 1 ? "s" : "") : \(Int(self.project!.projectSize.width * CGFloat(self.scale)))x\(Int(self.project!.projectSize.height * CGFloat(self.scale)))"
                self.sizeInfo.text = "file(s) size"
            case 4:
                self.filesSizeInfo.text = "1 file : \(Int(self.project!.projectSize.width * CGFloat(self.scale)) * self.project!.frameCount)x\(Int(self.project!.projectSize.height * CGFloat(self.scale)))"
                self.sizeInfo.text = "file(s) size"
            default:
                break
            }
        }
    
        return segment
    }()
    
    lazy private var exportTitle: UILabel = {
        let text = UILabel()
        text.text = "Export type"
        text.font = UIFont(name: "Rubik-Medium", size: 16)
        text.textAlignment = .left
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = getAppColor(color: .enable)
        text.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return text
    }()
    
    lazy private var exportSelector: SegmentSelector = {
        let segment : SegmentSelector
        segment = SegmentSelector(imgs: [#imageLiteral(resourceName: "export_as_project_icon"),#imageLiteral(resourceName: "export_as_image_icon"),#imageLiteral(resourceName: "export_as_animation_icon"),#imageLiteral(resourceName: "export_as_images_icon"),#imageLiteral(resourceName: "export_as_images_sheet_icon")])
        segment.select = 0
        
        segment.selectDelegate = {[unowned self] select in
            switch select {
            case 0:
                self.exportInfo.text = "Will export like a project file"
                self.filesSizeInfo.text = ""
                self.sizeInfo.text = ""
            case 1:
                self.exportInfo.text = "Will export like an image"
                self.filesSizeInfo.text = "1 file : \(Int(self.project!.projectSize.width * CGFloat(self.scale)))x\(Int(self.project!.projectSize.height * CGFloat(self.scale)))"
                self.sizeInfo.text = "file(s) size"
            case 2:
                self.exportInfo.text = "Will export like an animation"
                self.filesSizeInfo.text = "1 file : \(Int(self.project!.projectSize.width * CGFloat(self.scale)))x\(Int(self.project!.projectSize.height * CGFloat(self.scale)))"
                self.sizeInfo.text = "file(s) size"
            case 3:
                self.exportInfo.text = "Will export like a group of images"
                self.filesSizeInfo.text = "\(self.project!.frameCount) file\(self.project!.frameCount > 1 ? "s" : "") : \(Int(self.project!.projectSize.width * CGFloat(self.scale)))x\(Int(self.project!.projectSize.height * CGFloat(self.scale)))"
                self.sizeInfo.text = "file(s) size"
            case 4:
                self.exportInfo.text = "Will export like a sprite list"
                self.filesSizeInfo.text = "1 file : \(Int(self.project!.projectSize.width * CGFloat(self.scale)) * self.project!.frameCount)x\(Int(self.project!.projectSize.height * CGFloat(self.scale)))"
                self.sizeInfo.text = "file(s) size"
            default:
                break
            }
        }
        
        return segment
    }()
    
    private var scale : Int {
        get{
            switch scaleSelector.select {
            case 0:
                return 1
            case 1:
                return 2
            case 2:
                return 4
            case 3:
                return 8
            case 4:
                return 16
            default:
                return 1
            }
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        view.addSubview(titleBg)
        view.addSubview(image)
        view.addSubview(projectName)
        view.addSubview(exportInfo)
        view.addSubview(sizeInfo)
        view.addSubview(filesSizeInfo)


        view.addSubview(scaleTitle)
        view.addSubview(scaleSelector)
        
        view.addSubview(exportTitle)
        view.addSubview(exportSelector)
        
        titleBg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        titleBg.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        titleBg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        titleBg.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        image.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 62).isActive = true
        image.centerYAnchor.constraint(equalTo: titleBg.bottomAnchor, constant: 62).isActive = true
        
        projectName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 124).isActive = true
        projectName.topAnchor.constraint(equalTo: titleBg.bottomAnchor, constant: 8).isActive = true
        projectName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        exportInfo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 124).isActive = true
        exportInfo.topAnchor.constraint(equalTo: projectName.bottomAnchor, constant: 4).isActive = true
        exportInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        sizeInfo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 124).isActive = true
        sizeInfo.topAnchor.constraint(equalTo: exportInfo.bottomAnchor, constant: 4).isActive = true
        sizeInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        filesSizeInfo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 124).isActive = true
        filesSizeInfo.topAnchor.constraint(equalTo: exportInfo.bottomAnchor, constant: 4).isActive = true
        filesSizeInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        exportTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        exportTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        exportTitle.topAnchor.constraint(equalTo: titleBg.bottomAnchor, constant: 124).isActive = true

        exportSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        exportSelector.topAnchor.constraint(equalTo: exportTitle.bottomAnchor, constant: 0).isActive = true
        
        scaleTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        scaleTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        scaleTitle.topAnchor.constraint(equalTo: exportSelector.bottomAnchor, constant: 4).isActive = true

        scaleSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        scaleSelector.topAnchor.constraint(equalTo: scaleTitle.bottomAnchor, constant: 0).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        titleBg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
    }
}
