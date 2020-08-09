//
//  ProjectWorker.swift
//  new Testing
//
//  Created by Рустам Хахук on 06.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import ImageIO
import MobileCoreServices
import UIKit
import Compression

class ProjectWork{
    private var name : String
    private var projectInfo : ProjectInfo!
    private var selectedLayer : Int
    private var selectedFrame: Int
    
    var LayerSelected : Int {
        get{
            return selectedLayer
        }
        set {
            selectedLayer = newValue
        }
    }
    
    var FrameSelected : Int {
        get{
            return selectedFrame
        }
        set {
            
            selectedFrame = newValue
        }
    }

    var backgroundColor : UIColor {
        get{
            return UIColor(hex: projectInfo.bgColor)!
        } set {
            projectInfo.bgColor = UIColor.toHex(color: newValue)
        }
    }
    
    var projectSize : CGSize {
        get{
            return CGSize(width: projectInfo.width, height: projectInfo.height)
        }
        set{
            projectInfo.width = Int(newValue.width)
            projectInfo.height = Int(newValue.height)
        }
    }
    
    var animationDelay : Int {
        get{
            var sum = 0
            for i in projectInfo.frames {
                sum += i.delay
            }
            return sum
        }
    }
    
    var projectName : String {
        get{
            return name
        }
        set {
            rename(newname: newValue)
            name = newValue
        }
    }
    
    var userProjectName : String {
        get{
            var userName = name
            userName.removeLast(6)
            
            return userName
        }
    }
    
    var layerCount : Int {
        get{
            return projectInfo.frames[FrameSelected].layers.count
        }
    }
    
    var frameCount : Int {
        get{
            return projectInfo.frames.count
        }
    }
    
    var isFlipX : Bool {
        get{
            return projectInfo.flipX
        }
        set{
            projectInfo.flipX = newValue
        }
    }
    
    var isFlipY : Bool {
        get{
            return projectInfo.flipY
        }
        set{
            projectInfo.flipY = newValue
        }
    }
    
    var information : ProjectInfo {
        get{
            return projectInfo
        }
    }
    
    private func rename(newname : String){
        do{
            try FileManager.default.moveItem(at: getProjectDirectory(), to: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Projects").appendingPathComponent(newname))
       } catch{
           print(error.localizedDescription)
       }
    }
    
    var projectPallete : [String] {
        get{
            return projectInfo.pallete.colors
        }
        set{
            projectInfo.pallete.colors = newValue
        }
    }
    
    init(ProjectName projName : String, ProjectSize projSize : CGSize, bgColor : UIColor){
        
        let img = UIImage(size: projSize)!
        
        name = projName
        selectedLayer = 0
        selectedFrame = 0
                
        projectInfo = ProjectInfo(version: 0, width: Int(projSize.width), height: Int(projSize.height), bgColor: UIColor.toHex(color: bgColor),frames:  [ProjectFrame(frameID: 0, delay: 100, layers: [ProjectLayer(layerID: 0, visible: true, locked: false, transparent: 1.0)])], actionList: ActionList(actions: [], lastActiveAction: -1, maxCount: 64), pallete: try! JSONDecoder().decode(Pallete.self, from: NSDataAsset(name: "Default pallete")!.data), flipX: false, flipY: false, rotate: 0)
             
        let folder = ProjectWork.getDocumentsDirectory().appendingPathComponent(name)
        do {
            try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: folder.appendingPathComponent("frames").path, withIntermediateDirectories: true, attributes: nil)

            try FileManager.default.createDirectory(atPath: folder.appendingPathComponent("frames").appendingPathComponent("frame-0").path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: folder.appendingPathComponent("actions").path, withIntermediateDirectories: true, attributes: nil)

            try img.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-0").appendingPathComponent("layer-0.png"))
            try img.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-0").appendingPathComponent("preview.png"))
            
            try! scalePreview(preview: img, size: generateIconSize()).pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-0").appendingPathComponent("preview-icon.png"))
            
            try UIImage(size: img.size)!.pngData()!.write(to: getProjectDirectory().appendingPathComponent("selection.png"))
            
            try UIImage(size: img.size)!.pngData()!.write(to: getProjectDirectory().appendingPathComponent("copy.png"))

            let data = try JSONEncoder().encode(projectInfo)
            
            try String(data: data, encoding: .utf8)!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("main.txt"), atomically: true, encoding: .utf8)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    init(fileName : String) {
        selectedLayer = 0
        selectedFrame = 0
        
        name = fileName
        do{
            projectInfo = try JSONDecoder().decode(ProjectInfo.self, from: try Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("main.txt")))
        } catch {}
    }
    
    init(fileUrl : URL) {
        selectedLayer = 0
        selectedFrame = 0
        
        name = fileUrl.lastPathComponent
        do{
            projectInfo = try JSONDecoder().decode(ProjectInfo.self, from: try Data(contentsOf: fileUrl))
        } catch {}
    }
    
    init(projectName : String, image : UIImage) {
        name = projectName
        
        selectedLayer = 0
        selectedFrame = 0
        
        let resultImage = UIImage(cgImage: image.cgImage!)
        
        projectInfo = ProjectInfo(version: 0, width: Int(resultImage.size.width), height: Int(resultImage.size.height), bgColor: "#00000000", frames: [ProjectFrame(frameID: 0, delay: 100, layers: [ProjectLayer(layerID: 0, visible: true, locked: false, transparent: 1)])], actionList: ActionList(actions: [], lastActiveAction: -1, maxCount: 64), pallete: try! JSONDecoder().decode(Pallete.self, from: NSDataAsset(name: "Default pallete")!.data), flipX: false, flipY: false, rotate: 0)
        
        let folder = ProjectWork.getDocumentsDirectory().appendingPathComponent(name)
        do {
            try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: folder.appendingPathComponent("frames").path, withIntermediateDirectories: true, attributes: nil)

            try FileManager.default.createDirectory(atPath: folder.appendingPathComponent("frames").appendingPathComponent("frame-0").path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: folder.appendingPathComponent("actions").path, withIntermediateDirectories: true, attributes: nil)

            try resultImage.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-0").appendingPathComponent("layer-0.png"))
            try resultImage.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-0").appendingPathComponent("preview.png"))
            
            try! scalePreview(preview: resultImage, size: generateIconSize()).pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-0").appendingPathComponent("preview-icon.png"))
            
            try UIImage(size: resultImage.size)!.pngData()!.write(to: getProjectDirectory().appendingPathComponent("selection.png"))
            
            try UIImage(size: resultImage.size)!.pngData()!.write(to: getProjectDirectory().appendingPathComponent("copy.png"))

            let data = try JSONEncoder().encode(projectInfo)
            
            try String(data: data, encoding: .utf8)!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("main.txt"), atomically: true, encoding: .utf8)
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getProjectDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("Projects").appendingPathComponent(name)
    }

    func save(){
        do {
            let data = try JSONEncoder().encode(projectInfo)
            try String(data: data, encoding: .utf8)!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("main.txt"), atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadCopyImage() -> UIImage {
        let img = UIImage(data: try! Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("copy.png")))!
        return img
    }
   
    func addLayer(frame : Int, layerPlace : Int){
        let layer = UIImage(size: projectSize)!
        var layerID : Int = 0
        
        out : for i in 0..<64 {
            for t in 0..<projectInfo.frames[frame].layers.count {
                if i == projectInfo.frames[frame].layers[t].layerID {
                    continue out
                }
            }
            layerID = i
            break
        }
        
        do{
            try layer.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[frame].frameID)").appendingPathComponent("layer-\(layerID).png"))
            
        } catch{
            print("hey check error : \(error.localizedDescription)")
        }

        projectInfo.frames[frame].layers.insert(ProjectLayer(layerID: layerID, visible: true, locked: false, transparent: 1.0), at: layerPlace)
    }

    func renameLayer(frame: Int, layer: Int, newName: String){
        projectInfo.frames[frame].layers[layer].name = newName
    }
    
    func replaceLayer(frame : Int, from : Int, to : Int){
        let layer = projectInfo.frames[frame].layers.remove(at: from)
        projectInfo.frames[frame].layers.insert(layer, at: to)
    }
    
    func getLayer(frame : Int,layer : Int) -> UIImage{
        return ProjectWork.loadImage(projectName: name, frameID: projectInfo.frames[frame].frameID, layerID: projectInfo.frames[frame].layers[layer].layerID)!
    }
    
    private func loadAction(actionNum : Int) -> UIImage{
        let img = UIImage(data: try! Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: actionNum)).png")))!
        return img
    }

    private func loadActionMerge(actionNum : Int, imageNum : Int) -> UIImage{
        let img = UIImage(data: try! Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("actions").appendingPathComponent("action-\(imageNum == 1 ? "first" : "second")-\(getActionID(action: actionNum)).png")))!
        return img
    }
    
    private func loadActionSelect(actionNum : Int) -> UIImage{
        let img = UIImage(data: try! Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("actions").appendingPathComponent("action-select-\(getActionID(action: actionNum)).png")))!
        return img
    }
    
    private func loadImagefromUrl(url : URL) -> UIImage {
        return try! UIImage(data: Data(contentsOf: url))!
    }
    
    func loadSelection() -> UIImage{
        let img = UIImage(data: try! Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("selection.png")))!
        return img
    }
    
    private func loadActionWas(actionNum : Int) -> UIImage{
        let img = UIImage(data: try! Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: actionNum))-was.png")))!
        return img
    }
    
    private func loadActionSelectWas(actionNum : Int) -> UIImage{
        let img = UIImage(data: try! Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("actions").appendingPathComponent("action-select-\(getActionID(action: actionNum))-was.png")))!
        return img
    }
    
    private func loadActionMiniature(actionNum : Int,size : CGSize) -> UIImage{
        let img = UIImage.miniature(imageAt: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: actionNum)).png"), to: size, scale: UIScreen.main.scale)
        
        return img
    }
    
    private func loadActionMiniatureWas(actionNum : Int,size : CGSize) -> UIImage{
        let img = UIImage.miniature(imageAt: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: actionNum))-was.png"), to: size, scale: UIScreen.main.scale)
        
        return img
    }
    
    func getSmallLayer(frame : Int,layer : Int, size : CGSize) -> UIImage{
        print("    getting layer : frameID : \(projectInfo.frames[frame].frameID) layerID : \(projectInfo.frames[frame].layers[layer].layerID)")
    let img = UIImage.miniature(imageAt: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[frame].frameID)").appendingPathComponent("layer-\(projectInfo.frames[frame].layers[layer].layerID).png").absoluteURL, to: size, scale: UIScreen.main.scale).withAlpha(CGFloat(projectInfo.frames[frame].layers[layer].transparent))

    return img
    }
    
    func deleteLayer(frame : Int, layer : Int) {
           try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[frame].frameID)").appendingPathComponent("layer-\(projectInfo.frames[frame].layers[layer].layerID).png"))
           
           projectInfo.frames[frame].layers.remove(at: layer)
       }
       
    func cloneLayer(frame : Int, layer : Int) {
        let img = ProjectWork.loadImage(projectName: name, frameID: projectInfo.frames[frame].frameID, layerID: projectInfo.frames[frame].layers[layer].layerID)!
        
        var layerID : Int = 0
        
        out : for i in 0..<64 {
            for t in 0..<projectInfo.frames[frame].layers.count {
                if i == projectInfo.frames[frame].layers[t].layerID {
                    continue out
                }
            }
            layerID = i
            break
        }
        
        do{
            try img.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[frame].frameID)").appendingPathComponent("layer-\(layerID).png"))
            
        } catch{
            print("hey check error : \(error.localizedDescription)")
        }
        
        // print()
        projectInfo.frames[frame].layers.insert(ProjectLayer(layerID: layerID, visible: projectInfo.frames[frame].layers[layer].visible, locked: projectInfo.frames[frame].layers[layer].locked, transparent: projectInfo.frames[frame].layers[layer].transparent), at: layer + 1)
    }
       
    func changeLayerVisible(layer : Int,isVisible : Bool){
           projectInfo.frames[FrameSelected].layers[layer].visible = isVisible
       }
       
    func layerVisible(layer : Int) -> Bool {
        return projectInfo.frames[FrameSelected].layers[layer].visible
    }
    
    func addFrame(){
           let frame = UIImage(size: projectSize)!
           var frameID : Int = 0
           
           out : for i in 0..<128 {
               for t in 0..<projectInfo.frames.count {
                   if i == projectInfo.frames[t].frameID {
                       continue out
                   }
               }
               frameID = i
               break
           }
           
           do{
                try FileManager.default.createDirectory(atPath: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-\(frameID)").path, withIntermediateDirectories: true, attributes: nil)

                try frame.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-\(frameID)").appendingPathComponent("layer-0.png"))
               
                try frame.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-\(frameID)").appendingPathComponent("preview.png"))
               
           } catch{}
           
           projectInfo.frames.append(ProjectFrame(frameID: frameID, delay: 100, layers: [ProjectLayer(layerID: 0, visible: true, locked: false, transparent: 1.0)]))
       }

    func insertFrame(at : Int){
           let frame = UIImage(size: projectSize)!
           var frameID : Int = 0
           
           out : for i in 0..<128 {
               for t in 0..<projectInfo.frames.count {
                   if i == projectInfo.frames[t].frameID {
                       continue out
                   }
               }
               frameID = i
               break
           }
           
           do{
                try FileManager.default.createDirectory(atPath: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-\(frameID)").path, withIntermediateDirectories: true, attributes: nil)

                try frame.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-\(frameID)").appendingPathComponent("layer-0.png"))
               
                try frame.pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-\(frameID)").appendingPathComponent("preview.png"))
               
           } catch{}
           
        projectInfo.frames.insert(ProjectFrame(frameID: frameID, delay: 100, layers: [ProjectLayer(layerID: 0, visible: true, locked: false, transparent: 1.0)]), at: at)
        
    }

    func replaceFrame(from : Int, to : Int){
        let frame = projectInfo.frames.remove(at: from)
                projectInfo.frames.insert(frame, at: to)
    }
       
    func getFrame(frame : Int, size : CGSize) -> UIImage{
        let img = UIImage.miniature(imageAt: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[frame].frameID)").appendingPathComponent("preview.png").absoluteURL, to: size, scale: UIScreen.main.scale)
        return img
    }
    
    func getFrameWithBackground(frame : Int) -> UIImage {
        return UIImage.merge(images: [UIImage(size: projectSize,bgColor: UIColor(hex: projectInfo.bgColor)!)!,getFrame(frame: frame, size: projectSize)])!
    }
    
    func generateSpriteList(scale : CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: projectSize.width * scale * CGFloat(frameCount), height: projectSize.height * scale))
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .none
        UIColor(hex: projectInfo.bgColor)!.setFill()
        context.fill(CGRect(origin: .zero, size: CGSize(width: projectSize.width * scale * CGFloat(frameCount), height: projectSize.height * scale)))
        
        for i in 0..<frameCount {
            getFrame(frame: i, size: projectSize).flip(xFlip: isFlipX, yFlip: isFlipY).scale(scaleFactor: scale).draw(at: CGPoint(x: Int(projectSize.width * scale) * i, y: 0))
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func getFrameFromLayers(frame : Int, size : CGSize) -> UIImage{
        var imgs : [UIImage] = []
        //print("  start getting Frame :")
        for i in 0..<projectInfo.frames[frame].layers.count {
            imgs.append(getSmallLayer(frame: frame, layer: (projectInfo.frames[frame].layers.count - i - 1),size: size).withAlpha(projectInfo.frames[frame].layers[projectInfo.frames[frame].layers.count - i - 1].visible ? CGFloat(projectInfo.frames[frame].layers[projectInfo.frames[frame].layers.count - i - 1].transparent) : 0))
        }
        //print("  end getting Frame")

        return UIImage.merge(images: imgs)!
    }
    
    func setFrameDelay(frame : Int, delay : Int){
        projectInfo.frames[frame].delay = delay
    }
    
    func deleteFrame(frame : Int) {
        try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[frame].frameID)"))
        projectInfo.frames.remove(at: frame)
    }
    
    func mergeLayers(frame : Int, layer : Int) {
        try! UIImage.merge(images: [getLayer(frame: frame, layer: layer + 1).withAlpha(projectInfo.frames[frame].layers[layer + 1].visible ? CGFloat(projectInfo.frames[frame].layers[layer + 1].transparent) : 0),getLayer(frame: frame, layer: layer).withAlpha(projectInfo.frames[frame].layers[layer].visible ? CGFloat(projectInfo.frames[frame].layers[layer].transparent) : 0)])!.pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[frame].frameID)").appendingPathComponent("layer-\(projectInfo.frames[frame].layers[layer].layerID).png"))
        
        projectInfo.frames[frame].layers[layer].transparent = 1
        deleteLayer(frame: frame, layer: layer + 1)
    }
    
    func cloneFrame(frame : Int) {
        var frameID : Int = 0
        
        out : for i in 0..<1280 {
            for t in 0..<projectInfo.frames.count {
                if i == projectInfo.frames[t].frameID {
                    continue out
                }
            }
            frameID = i
            break
        }
        
        print("clone frameID : \(frameID)")
        
        savePreview(frame: frame)
        
        try! FileManager.default.copyItem(at: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[frame].frameID)"), to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(frameID)"))

        var newFrame : ProjectFrame = projectInfo.frames[frame]
        newFrame.frameID = frameID
        projectInfo.frames.insert(newFrame, at: frame + 1)
    }
    
    func savePreview(frame : Int){
        try! getFrameFromLayers(frame: frame, size: projectSize).pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[frame].frameID)").appendingPathComponent("preview.png"))
        
        if projectInfo.frames[frame].frameID == 0 {
            try! scalePreview(preview: getFrameFromLayers(frame: frame, size: projectSize) , size: generateIconSize()).flip(xFlip: isFlipX, yFlip: isFlipY).pngData()!.write(to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(name).appendingPathComponent("preview-icon.png"))
        }
    }
    
    private func scalePreview(preview : UIImage, size : CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .none
        context.setFillColor(UIColor(hex: projectInfo.bgColor)!.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        preview.draw(in: CGRect(origin: .zero, size: size))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    private func generateIconSize() -> CGSize {
        if projectSize.width > projectSize.height {
            return CGSize(width: 512, height: 512 * (projectSize.height / projectSize.width))
        } else {
            return CGSize(width: 512 * (projectSize.width / projectSize.height), height: 512)
        }
    }
    
    func setLayerOpasity(frame : Int, layer : Int, newOpasity : Int) {
        projectInfo.frames[frame].layers[layer].transparent = Float(newOpasity) / 100.0
    }
    
    static func clone(original : String, clone : String){
        do{
            try FileManager.default.createDirectory(atPath: ProjectWork.getDocumentsDirectory().appendingPathComponent(clone).path, withIntermediateDirectories: true, attributes: nil)
            
            let filesPath = try FileManager.default.contentsOfDirectory(at: ProjectWork.getDocumentsDirectory().appendingPathComponent(original), includingPropertiesForKeys: nil, options: .includesDirectoriesPostOrder)
            
            for i in 0..<filesPath.count {
                try FileManager.default.copyItem(at: filesPath[i], to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(clone).appendingPathComponent(filesPath[i].lastPathComponent))
            }
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = URL(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])!
        return paths.appendingPathComponent("Projects")
    }
    
    static func getDocumentsDirectoryWithFile() -> URL {
        let paths = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        return paths.appendingPathComponent("Projects")
    }
        
    static func loadImage(projectName : String,frameID : Int, layerID : Int) -> UIImage? {
        do{
            let img = UIImage(data: try Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("frames").appendingPathComponent("frame-\(frameID)").appendingPathComponent("layer-\(layerID).png")))
            
            return img
        } catch {}
        
        return nil
    }
    
    static func loadImage(projectName : String,frameID : Int, layerID : Int, scale : CGFloat) -> UIImage? {
        do{
            let img = UIImage(data: try Data(contentsOf: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(projectName).appendingPathComponent("frames").appendingPathComponent("frame-\(frameID)").appendingPathComponent("layer-\(layerID).png")), scale: scale)
            return img
        } catch {}
        
        return nil
    }
    
    static func deleteFile(fileName : String){
        do{
            try FileManager.default.removeItem(atPath: ProjectWork.getDocumentsDirectory().appendingPathComponent(fileName).path)
        }catch{}
    }
    
    func unDo(delegate : FrameControlDelegate){
        if projectInfo.actionList.lastActiveAction >= 0 {
            switch Actions.init(rawValue: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["ToolID"]!)!)! {
            case .drawing:
                try! loadActionWas(actionNum: projectInfo.actionList.lastActiveAction).pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].frameID)").appendingPathComponent("layer-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!].layerID).png"))
                
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
                    
                    savePreview(frame: FrameSelected)

                    let lastSelect = FrameSelected
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    LayerSelected = 0
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.updateFrame(frame: FrameSelected)
                }
                
                if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! {
                    let lastSelect = LayerSelected
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                    delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                } else {
                    delegate.updateLayer(layer: LayerSelected)
                }
                
            case .layerAdd:
                deleteLayer(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!, layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!)

                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
                  
                    savePreview(frame: FrameSelected)
                    
                    let lastSelect = FrameSelected
                   FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    LayerSelected = 0
                   delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.deleteLayer(layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!)
                }
                if LayerSelected == Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! {
                   LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! - 1
                    delegate.updateLayer(layer: LayerSelected)
                } else if LayerSelected > Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!  {
                        LayerSelected -= 1
                }
                

            
            case .frameAdd:
                deleteFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!)

                delegate.deleteFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!)
                
                if FrameSelected >= Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
            
                    LayerSelected = 0
                    FrameSelected -= 1
                    
                    delegate.updateFrame(frame: FrameSelected)
                    delegate.updateLayers()
                }
                
            case .frameReplace:
                
                if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)!  < FrameSelected && Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)! >= FrameSelected {
                    FrameSelected -= 1
                } else if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)!  > FrameSelected && Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)! <= FrameSelected {
                    FrameSelected += 1
                } else if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)! == FrameSelected {
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)!
                }
                
                replaceFrame(from: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)!, to: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)!)
                
                delegate.replaceFrame(from: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)!, to: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)!)
                
            case .layerReplace:
                replaceLayer(frame : Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! ,from: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)!, to: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)!)
                
                if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)!  < LayerSelected && Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)! >= LayerSelected {
                       LayerSelected -= 1
                   } else if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)!  > LayerSelected && Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)! <= LayerSelected {
                       LayerSelected += 1
                   } else if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)! == LayerSelected {
                       LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)!
                   }
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
                    let lastSelect = FrameSelected
                    
                    savePreview(frame: FrameSelected)
                    
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.replaceLayer(from: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["to"]!)!, to: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)!)
                    delegate.updateFrame(frame: FrameSelected)
                }
                
            case .layerClone:
                
                deleteLayer(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!, layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! + 1)
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
                    let lastSelect = FrameSelected
                    
                    savePreview(frame: FrameSelected)
                    
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!

                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                    delegate.updateLayers()
                } else {
                    delegate.deleteLayer(layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! + 1)

                    if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! + 1 {
                        let lastselect = LayerSelected
                        
                        LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                        
                        if lastselect > LayerSelected {
                            delegate.updateLayerSelect(lastLayer: lastselect - 1, newLayer: LayerSelected)
                        } else if(lastselect < LayerSelected){
                            delegate.updateLayerSelect(lastLayer: lastselect, newLayer: LayerSelected)
                        }
                    } else {
                        LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                        delegate.updateLayer(layer: LayerSelected)
                    }
                    
                    delegate.updateFrame(frame: FrameSelected)
                }
                
            case .frameClone:
                deleteFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! + 1)
                delegate.deleteFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! + 1)

                if FrameSelected == Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! + 1 {
                    FrameSelected -= 1
                    LayerSelected = 0
                    delegate.updateFrame(frame: FrameSelected)
                    delegate.updateLayers()
                } else if (FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)){
                    let lastselect = FrameSelected
                    
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    LayerSelected = 0
                    
                    if lastselect > FrameSelected {
                        savePreview(frame: lastselect - 1)
                        delegate.updateFrameSelect(lastFrame: lastselect - 1, newFrame: FrameSelected)
                    } else if(lastselect < FrameSelected){
                        savePreview(frame: lastselect)
                        delegate.updateFrameSelect(lastFrame: lastselect, newFrame: FrameSelected)
                    }
                    
                }
                
            //MARK: Layer delete

                
            case .layerDelete:
                addLayer(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!, layerPlace: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!)
                
                projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!].transparent = Float(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["transparent"]!)!

                projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!].visible = Bool(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["wasVisible"]!)!

                
                try! loadAction(actionNum: projectInfo.actionList.lastActiveAction).pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].frameID)").appendingPathComponent("layer-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!].layerID).png"))
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
                    let lastSelect = FrameSelected
                    
                    savePreview(frame: FrameSelected)
                    
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                    
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    let lastSelect = LayerSelected
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                    
                    delegate.addLayer(layer: LayerSelected)
                    if lastSelect < LayerSelected {
                        delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                    } else{
                        delegate.updateLayerSelect(lastLayer: lastSelect + 1, newLayer: LayerSelected)
                    }
                    delegate.updateFrame(frame: FrameSelected)
                }
                
            //MARK: Frame delete

                
            case .frameDelete:
                let frame : ProjectFrame = try! JSONDecoder().decode(ProjectFrame.self, from: projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frameStruct"]!.data(using: .utf8)!)
                
                projectInfo.frames.insert(frame, at: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!)
                
                print("now frameID : \(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].frameID) and last : \(Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["lastID"]!)!)")
                
                try! FileManager.default.copyItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.lastActiveAction))"), to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["lastID"]!)!)"))
                
                let lastSelect = FrameSelected
                FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                
                delegate.addFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!)

                LayerSelected = 0

                if lastSelect < FrameSelected {
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.updateFrameSelect(lastFrame: lastSelect + 1, newFrame: FrameSelected)
                }
                delegate.updateLayers()
               
            //MARK: Layers visible change

                
            case .layerVisibleChange:
                projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!].visible.toggle()
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
                    
                    savePreview(frame: FrameSelected)

                    let lastSelect = FrameSelected
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.updateFrame(frame: FrameSelected)
                }
                
                if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! {
                    let lastSelect = LayerSelected
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                    delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                } else {
                    delegate.updateLayer(layer: LayerSelected)
                }
                
            //MARK: Selection change

                
            case .selectionChange:
                delegate.updateSelection(select: loadActionWas(actionNum: projectInfo.actionList.lastActiveAction),isSelected: Bool(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["wasSelected"]!)!)
            
            //MARK: Frames delay change

                
            case .changeFrameDelay:
                setFrameDelay(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!, delay: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)!)
                
            //MARK: Transform
                
            case .transform:
                try! loadActionWas(actionNum: projectInfo.actionList.lastActiveAction).pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].frameID)").appendingPathComponent("layer-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!].layerID).png"))
                try! loadActionSelectWas(actionNum: projectInfo.actionList.lastActiveAction).pngData()?.write(to: getProjectDirectory().appendingPathComponent("selection.png"))
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
                    
                    savePreview(frame: FrameSelected)

                    let lastSelect = FrameSelected
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    LayerSelected = 0
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.updateFrame(frame: FrameSelected)
                }
                
                if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! {
                    let lastSelect = LayerSelected
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                    delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                } else {
                    delegate.updateLayer(layer: LayerSelected)
                }
                
            //MARK: Background change

        
            case .backgroundChange:
                projectInfo.bgColor = projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["last"]!
                delegate.updateEditor()
            case .resizeProject:
                try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("frames"))
                try! FileManager.default.copyItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.lastActiveAction))-was"), to: getProjectDirectory().appendingPathComponent("frames"))
                projectSize = CGSize(width: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["lastSizeX"]!)!, height: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["lastSizeY"]!)!)
                
                try! loadImagefromUrl(url: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.lastActiveAction))-selection-was.png")).pngData()?.write(to: getProjectDirectory().appendingPathComponent("selection.png"))

                
                (delegate as! Editor).resizeProject()
                
            //MARK: Layers opacity change

                
            case .changeLayerOpasity:
                setLayerOpasity(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!, layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!, newOpasity: Int(Float(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["from"]!)! * 100))
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
                    
                    savePreview(frame: FrameSelected)

                    let lastSelect = FrameSelected
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    LayerSelected = 0
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.updateFrame(frame: FrameSelected)
                }
                
                if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! {
                    let lastSelect = LayerSelected
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                    delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                } else {
                    delegate.updateLayer(layer: LayerSelected)
                }
                
            //MARK: Layers merge

                    
            case .mergeLayers:
                
                try! loadActionMerge(actionNum: projectInfo.actionList.lastActiveAction, imageNum: 1).pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].frameID)").appendingPathComponent("layer-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!].layerID).png"))

                addLayer(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!, layerPlace: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! + 1)
                
                try! loadActionMerge(actionNum: projectInfo.actionList.lastActiveAction, imageNum: 2).pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].frameID)").appendingPathComponent("layer-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! + 1].layerID).png"))

                projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!].transparent = Float(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["firstLayerOpasity"]!)!
                
                projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!].visible = Bool(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["isFirstLayerVisible"]!)!
                
                projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! + 1].transparent = Float(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["secondLayerOpasity"]!)!
                
                projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)! + 1].visible = Bool(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["isSecondLayerVisible"]!)!
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)! {
                    let lastSelect = FrameSelected
                    
                    savePreview(frame: FrameSelected)
                    
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["frame"]!)!
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                    
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    let lastSelect = LayerSelected
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction]["layer"]!)!
                    
                    delegate.addLayer(layer: LayerSelected)
                    if lastSelect < LayerSelected {
                        delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                    } else{
                        delegate.updateLayerSelect(lastLayer: lastSelect + 1, newLayer: LayerSelected)
                    }
                }
                break
                
            case .projectFlipX:
                self.isFlipX.toggle()
                (delegate as! Editor).resizeProject()
                    
            case .projectFlipY:
                self.isFlipY.toggle()
                (delegate as! Editor).resizeProject()
                
            default:
                break
            }
            
            delegate.updateCanvas()
            
            projectInfo.actionList.lastActiveAction -= 1
            save()
        }
    }
    
    //MARK: ReDo
    
    
    func reDo(delegate : FrameControlDelegate){
        if projectInfo.actionList.lastActiveAction < projectInfo.actionList.actions.count - 1 {
            switch Actions.init(rawValue: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["ToolID"]!)!)! {
            //MARK: Drawing Action
                
                
            case .drawing:
                try! loadAction(actionNum: projectInfo.actionList.lastActiveAction + 1).pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!].frameID)").appendingPathComponent("layer-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!].layerID).png"))
               
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    
                    savePreview(frame: FrameSelected)
                    
                    let lastSelect = FrameSelected
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                    if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! {
                        LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!
                    }
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.updateFrame(frame: FrameSelected)
                    
                    if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! {
                        let lastSelect = LayerSelected
                        LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!
                        delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                    } else {
                        delegate.updateLayer(layer: LayerSelected)
                    }
                }
            //MARK: Add layer
                
                
            case .layerAdd:
                addLayer(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!, layerPlace:  Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!)

                    if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    
                    savePreview(frame: FrameSelected)

                   let lastSelect = FrameSelected
                   FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                   delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                    
                    if LayerSelected != 0 {
                        LayerSelected = 0
                        delegate.updateLayer(layer: LayerSelected)
                    }
                }
                
                delegate.addLayer(layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!)
            
            //MARK: Add frame
                
                
            case .frameAdd:
                addFrame()
                delegate.addFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!)
                
            //MARK: Replace frame
                
                
            case .frameReplace:
                if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)!  < FrameSelected && Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)! >= FrameSelected {
                       FrameSelected -= 1
                   } else if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)!  > FrameSelected && Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)! <= FrameSelected {
                       FrameSelected += 1
                   } else if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)! == FrameSelected {
                       FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)!
                   }
                
                
                replaceFrame(from: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)!, to: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)!)
                delegate.replaceFrame(from: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)!, to: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)!)
            
            //MARK: Replace layer
                
                
            case .layerReplace:
                replaceLayer(frame : Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!,from: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)!, to: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)!)
                                
                 if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)!  < LayerSelected && Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)! >= LayerSelected {
                      LayerSelected -= 1
                  } else if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)!  > LayerSelected && Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)! <= LayerSelected {
                      LayerSelected += 1
                  } else if Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)! == LayerSelected {
                      LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)!
                  }
                           
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    let lastSelect = FrameSelected
                       
                    savePreview(frame: FrameSelected)
                    
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                       
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.replaceLayer(from: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["from"]!)!, to: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)!)
                    delegate.updateFrame(frame: FrameSelected)
                }
                
            //MARK: Clone layer
                
                
            case .layerClone:
                cloneLayer(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!, layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!)

                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    let lastSelect = FrameSelected
                       
                    savePreview(frame: FrameSelected)
                    
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!

                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                    delegate.updateLayers()
                } else {
                    let lastSelect = LayerSelected
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!
                    
                    delegate.addLayer(layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! + 1)
                    
                    if lastSelect < LayerSelected {
                        delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                    } else {
                        delegate.updateLayerSelect(lastLayer: lastSelect + 1, newLayer: LayerSelected)
                    }
                    delegate.updateFrame(frame: FrameSelected)
                }
                
            //MARK: Clone frame
                
                
            case .frameClone:
                cloneFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!)
                delegate.addFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! + 1)

                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    let lastSelect = FrameSelected

                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                    LayerSelected = 0
                    
                    if lastSelect < FrameSelected {
                        savePreview(frame: lastSelect)
                        delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                    } else {
                        savePreview(frame: lastSelect + 1)
                        delegate.updateFrameSelect(lastFrame: lastSelect + 1, newFrame: FrameSelected)
                    }
                }
                
            //MARK: Delete layer
                
                
            case .layerDelete:
                deleteLayer(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!, layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!)
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    let lastSelect = FrameSelected
                    
                    savePreview(frame: FrameSelected)
                    
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                    LayerSelected = 0
                    
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.deleteLayer(layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!)
                    delegate.updateFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!)
                    
                    if LayerSelected == Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! {
                        LayerSelected -= 1
                        if LayerSelected < 0 {
                            LayerSelected = 0
                        }
                        
                        delegate.updateLayer(layer: LayerSelected)
                    } else if LayerSelected > Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! {
                        LayerSelected -= 1
                    }
                }
                
            //MARK: Delete frame
                
                
            case .frameDelete:
                deleteFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!)
                delegate.deleteFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!)
                
                if FrameSelected == Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    FrameSelected -= 1
                    LayerSelected = 0
                    if FrameSelected < 0 {
                        FrameSelected = 0
                    }
                    
                    delegate.updateFrame(frame: FrameSelected)
                    delegate.updateLayers()
                } else if FrameSelected > Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    FrameSelected -= 1
                }
                
                
                //MARK: Layer visible change
                
                
                case .layerVisibleChange:
                projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!].visible.toggle()
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    
                    savePreview(frame: FrameSelected)

                    let lastSelect = FrameSelected
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.updateFrame(frame: FrameSelected)
                }
                
                if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! {
                    let lastSelect = LayerSelected
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!
                    delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                } else {
                    delegate.updateLayer(layer: LayerSelected)
                }
                
            //MARK: Change selection
              
                
            case .selectionChange:
                delegate.updateSelection(select: loadAction(actionNum: projectInfo.actionList.lastActiveAction + 1), isSelected: Bool(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["nowSelected"]!)!)
                
            //MARK: Change frame delay
              
                
            case .changeFrameDelay:
                setFrameDelay(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!, delay: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)!)
           
            //MARK: Transform
                
                
            case .transform:
                 try! loadAction(actionNum: projectInfo.actionList.lastActiveAction + 1).pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!].frameID)").appendingPathComponent("layer-\(projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!].layerID).png"))
                 try! loadActionSelect(actionNum: projectInfo.actionList.lastActiveAction + 1).pngData()?.write(to: getProjectDirectory().appendingPathComponent("selection.png"))
                 
                 if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                     
                     savePreview(frame: FrameSelected)
                     
                     let lastSelect = FrameSelected
                     FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                     if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! {
                         LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!
                     }
                     delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                 } else {
                     delegate.updateFrame(frame: FrameSelected)
                     
                     if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! {
                         let lastSelect = LayerSelected
                         LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!
                         delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                     } else {
                         delegate.updateLayer(layer: LayerSelected)
                     }
                 }
                
            //MARK: Change background
                
                
            case .backgroundChange:
                projectInfo.bgColor = projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["now"]!
                delegate.updateEditor()
               
            //MARK: Project resize
                
                
            case .resizeProject:
                try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("frames"))
                try! FileManager.default.copyItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.lastActiveAction + 1))"), to: getProjectDirectory().appendingPathComponent("frames"))
                
                projectSize = CGSize(width: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["newSizeX"]!)!, height: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["newSizeY"]!)!)
                try! loadImagefromUrl(url: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.lastActiveAction + 1))-selection.png")).pngData()?.write(to: getProjectDirectory().appendingPathComponent("selection.png"))
                
                (delegate as! Editor).resizeProject()
                
            //MARK: Change layer opasity

                
            case .changeLayerOpasity:
                setLayerOpasity(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!, layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!, newOpasity: Int(Float(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["to"]!)! * 100))
                
                 if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                     
                     savePreview(frame: FrameSelected)
                     
                     let lastSelect = FrameSelected
                     FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                     if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! {
                         LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!
                     }
                     delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                 } else {
                     delegate.updateFrame(frame: FrameSelected)
                     
                     if LayerSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! {
                         let lastSelect = LayerSelected
                         LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!
                         delegate.updateLayerSelect(lastLayer: lastSelect, newLayer: LayerSelected)
                     } else {
                         delegate.updateLayer(layer: LayerSelected)
                     }
                 }
                
            //MARK: Layers merge

                
            case .mergeLayers:
                mergeLayers(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!, layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!)
                
                projectInfo.frames[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!].layers[Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!].visible = true
                
                if FrameSelected != Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)! {
                    let lastSelect = FrameSelected
                    
                    savePreview(frame: FrameSelected)
                    
                    FrameSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!
                    LayerSelected = 0
                    
                    delegate.updateFrameSelect(lastFrame: lastSelect, newFrame: FrameSelected)
                } else {
                    delegate.deleteLayer(layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)! + 1)
                    delegate.updateLayer(layer: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!)

                    delegate.updateFrame(frame: Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["frame"]!)!)
                    
                    LayerSelected = Int(projectInfo.actionList.actions[projectInfo.actionList.lastActiveAction + 1]["layer"]!)!
                        
                    delegate.updateLayer(layer: LayerSelected)
                }
                
            case .projectFlipX:
                self.isFlipX.toggle()
                (delegate as! Editor).resizeProject()
                
            case .projectFlipY:
                self.isFlipY.toggle()
                (delegate as! Editor).resizeProject()
                
            default:
                break
            }
            
            delegate.updateCanvas()
            projectInfo.actionList.lastActiveAction += 1
            save()
        }
    }
    
    func addAction(action : [String : String]){
        var mutableAction = action
        if projectInfo.actionList.lastActiveAction < projectInfo.actionList.actions.count - 1 {
            for _ in projectInfo.actionList.lastActiveAction + 1..<projectInfo.actionList.actions.count {
                removeActionLast()
            }
        }
        if projectInfo.actionList.actions.count == projectInfo.actionList.maxCount {
            removeActionFirst()
            projectInfo.actionList.lastActiveAction -= 1
        }
        if projectInfo.actionList.actions.count > 0 {
            mutableAction["ActionID"] = "\((getActionID(action: projectInfo.actionList.actions.count - 1) + 1) % projectInfo.actionList.maxCount)"
        } else {
            mutableAction["ActionID"] = "\(0)"
        }
        projectInfo.actionList.actions.append(mutableAction)
        projectInfo.actionList.lastActiveAction += 1
        save()
        var actionIDs : [Int] = []
        for i in 0..<projectInfo.actionList.actions.count {
            actionIDs.append(getActionID(action: i))
        }
        print("\(actionIDs) : \(projectInfo.actionList.lastActiveAction)")
    }
    
    private func removeActionLast(){
        switch Actions(rawValue : Int(projectInfo.actionList.actions[projectInfo.actionList.actions.count - 1]["ToolID"]!)!)! {
        case .drawing, .selectionChange:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1)).png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1))-was.png"))
        case .layerDelete:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1)).png"))
        case .frameDelete:
           try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1))"))
        case .transform:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1)).png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1))-was.png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-select-\(getActionID(action: projectInfo.actionList.actions.count - 1)).png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-select-\(getActionID(action: projectInfo.actionList.actions.count - 1))-was.png"))
        case .resizeProject:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1))"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1))-was"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1))-selection.png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: projectInfo.actionList.actions.count - 1))-selection-was.png"))
        case .mergeLayers:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-first-\(getActionID(action: projectInfo.actionList.actions.count - 1)).png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-second-\(getActionID(action: projectInfo.actionList.actions.count - 1)).png"))
        default:
            break
        }
        projectInfo.actionList.actions.removeLast()
        save()
    }
    
    private func removeActionFirst(){
        switch Actions(rawValue : Int(projectInfo.actionList.actions[0]["ToolID"]!)!)! {
        case .drawing, .selectionChange:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0)).png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0))-was.png"))
        case .layerDelete:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0)).png"))
        case .frameDelete:
           try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0))"))
        case .transform:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0)).png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0))-was.png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-select-\(getActionID(action: 0)).png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-select-\(getActionID(action: 0))-was.png"))
        case .resizeProject:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0))"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0))-was"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0))-selection.png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getActionID(action: 0))-selection-was.png"))
        case .mergeLayers:
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-first-\(getActionID(action: 0)).png"))
            try! FileManager.default.removeItem(at: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-second-\(getActionID(action: 0)).png"))
        default:
            break
        }
        projectInfo.actionList.actions.removeFirst()
        save()
    }
    
    func getActionID(action : Int) -> Int{
        return Int(projectInfo.actionList.actions[action]["ActionID"]!)!
    }
    
    func getNextActionID() -> Int {
        if projectInfo.actionList.actions.count > 0 {
            return (Int(projectInfo.actionList.actions[projectInfo.actionList.actions.count - 1]["ActionID"]!)!) % projectInfo.actionList.maxCount
        } else {
            return 0
        }
    }
    
    func resize(newSize : CGSize, scale : Bool, alignment : ProjectAlignment){
        if newSize == projectSize { return }
        
        addAction(action: ["ToolID" : "\(Actions.resizeProject.rawValue)", "lastSizeX" : "\(Int(projectSize.width))", "lastSizeY" : "\(Int(projectSize.height))", "newSizeX" : "\(Int(newSize.width))","newSizeY" : "\(Int(newSize.height))"])
        
        try! FileManager.default.copyItem(at: getProjectDirectory().appendingPathComponent("frames"), to: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getNextActionID())-was"))
        
        for f in 0..<projectInfo.frames.count {
            for l in 0..<projectInfo.frames[f].layers.count {
                try! resizeImage(image: getLayer(frame: f, layer: l), newSize: newSize, scale: scale, alignment: alignment).pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[f].frameID)").appendingPathComponent("layer-\(projectInfo.frames[f].layers[l].layerID).png"))
            }
            try! resizeImage(image: getFrame(frame: f, size: projectSize), newSize: newSize, scale: scale, alignment: alignment).pngData()?.write(to: getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(projectInfo.frames[f].frameID)").appendingPathComponent("preview.png"))
        }
        
        try! loadSelection().pngData()?.write(to: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getNextActionID())-selection-was.png"))

        try! resizeImage(image: loadSelection(), newSize: newSize, scale: scale, alignment: alignment).pngData()?.write(to: getProjectDirectory().appendingPathComponent("selection.png"))
        
        try! loadSelection().pngData()?.write(to: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getNextActionID())-selection.png"))

        try! FileManager.default.copyItem(at: getProjectDirectory().appendingPathComponent("frames"), to: getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(getNextActionID())"))
        
        projectSize = newSize
    }
    
    func resizeImage(image : UIImage, newSize : CGSize, scale : Bool, alignment : ProjectAlignment) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
        context.interpolationQuality = .none
        
        if scale {
            image.draw(in: CGRect(origin: .zero, size: newSize))
        } else {
            switch alignment {
            case .up_left:
                image.draw(at: .zero)
            case .up:
                let offset = CGPoint(x: (newSize.width - image.size.width) / 2, y: 0)
                image.draw(at: offset)
            case .up_right:
                let offset = CGPoint(x: (newSize.width - image.size.width), y: 0)
                image.draw(at: offset)
            case .right:
                let offset = CGPoint(x: (newSize.width - image.size.width), y: (newSize.height - image.size.height) / 2)
                image.draw(at: offset)
            case .down_right:
                let offset = CGPoint(x: (newSize.width - image.size.width), y: (newSize.height - image.size.height))
                image.draw(at: offset)
            case .down:
                let offset = CGPoint(x: (newSize.width - image.size.width) / 2, y: (newSize.height - image.size.height))
                image.draw(at: offset)
            case .down_left:
                let offset = CGPoint(x: 0, y: (newSize.height - image.size.height))
                image.draw(at: offset)
            case .left:
                let offset = CGPoint(x: 0, y: (newSize.height - image.size.height) / 2)
                image.draw(at: offset)
            case .center:
                let offset = CGPoint(x: (newSize.width - image.size.width) / 2, y: (newSize.height - image.size.height) / 2)
                image.draw(at: offset)
            }
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func generateGif(scale : CGFloat) {
        let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]  as CFDictionary
        let resData : CFMutableData = CFDataCreateMutable(nil, .zero)

        if let destination = CGImageDestinationCreateWithURL(getProjectDirectory().appendingPathComponent("\(userProjectName).gif") as CFURL, kUTTypeGIF, projectInfo.frames.count, nil) {
            CGImageDestinationSetProperties(destination, fileProperties)
            for image in 0..<projectInfo.frames.count {
                let frameImg = getFrameWithBackground(frame: image).scale(scaleFactor: scale).flip(xFlip: isFlipX, yFlip: isFlipY).cgImage!
                
                let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFDelayTime as String): CGFloat(projectInfo.frames[image].delay) / 1000.0, kCGImagePropertyHasAlpha : true, kCGImagePropertyGIFImageColorMap : false]] as CFDictionary
            
                CGImageDestinationAddImage(destination, frameImg, frameProperties)
            }
            
            if !CGImageDestinationFinalize(destination) {
               print("Failed to finalize the image destination")
            }
        }
        
        CGImageSourceCreateWithData(resData, nil)
    }
        
    func generateGroupOfImages(scale : CGFloat) {
        print("start starting")
        try! FileManager.default.createDirectory(at: getProjectDirectory().appendingPathComponent("\(userProjectName)"), withIntermediateDirectories: true, attributes: nil)
        for i in 0..<frameCount {
            try! getFrameWithBackground(frame: i).scale(scaleFactor: scale).flip(xFlip: isFlipX, yFlip: isFlipY).pngData()?.write(to: getProjectDirectory().appendingPathComponent("\(userProjectName)").appendingPathComponent("\(i).png"))
        }
    }
}

struct ProjectInfo : Codable {
    var version : Int
    var width : Int
    var height : Int
    var bgColor : String
    var frames : [ProjectFrame]
    var actionList : ActionList
    var pallete : Pallete
    var flipX : Bool
    var flipY : Bool
    var rotate : Int
}

struct ProjectFrame : Codable {
    var frameID : Int
    var delay : Int
    var layers : [ProjectLayer]
}

struct ProjectLayer : Codable {
    var layerID : Int
    var visible : Bool
    var locked : Bool
    var transparent : Float
    var name: String?
}

struct ActionList : Codable {
    var actions : [[String : String]] = []
    var lastActiveAction : Int = -1
    var maxCount = 8
}

enum Actions : Int {
    case drawing = 0 //done
    case layerReplace = 2 //done
    case frameReplace = 3 //done
    case layerDelete = 4 //done
    case frameDelete = 5 //done
    case layerAdd = 6 //done
    case frameAdd = 7 //done
    case layerClone = 8 //done
    case frameClone = 9 //done
    case layerVisibleChange = 10 //done
    case selectionChange = 11 //done
    case changeFrameDelay = 12 //done
    case transform = 13 //done
    case backgroundChange = 14//done
    case resizeProject = 15//done
    case changeLayerOpasity = 16//done
    case mergeLayers = 17//done
    case projectFlipX = 18//done
    case projectFlipY = 19//done
    case renameLayer = 20//done
}

