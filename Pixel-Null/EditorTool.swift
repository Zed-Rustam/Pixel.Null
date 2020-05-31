//
//  EditorTool.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 30.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

protocol DrawTool {
    //drawing image
    var result: UIImage {get}
    
    //original layer in start drawing
    var original: UIImage {get}
    
    //preview for showing result
    var preview: UIImage {get}
    
    //Editor delegate
    var delegate: EditorDelegate {get set}
    
    //need for set start original image
    func startDrawing(layer : UIImage)
    
    //for finger's gestures
    func action(location: CGPoint, gestureState: UIGestureRecognizer.State)
    
    //draw in result image
    func drawing()
    
    func endDrawing()
    
    //saving action in project
    func saveAction(to: ProjectWork)
}

protocol EditorDelegate {
    var selecion: UIImage? {get}
    var symmetry: CGPoint {get}
    var color : UIColor {get}
}

class PencilTool: DrawTool {
    
    var preview: UIImage {
        get{
            return UIImage.merge(images: [result,original])!
        }
    }
    
    var result: UIImage
    
    var original: UIImage
    
    var delegate: EditorDelegate
    
    var width : Int = 1
    
    private var points : [CGPoint] = []
    
    init(editorDelegate: EditorDelegate) {
        delegate = editorDelegate
        result = UIImage()
        original = UIImage()
    }
    
    func action(location: CGPoint, gestureState: UIGestureRecognizer.State) {
        switch gestureState {
        case .began:
            if !isLikeLast(point: fixPoint(point: location)) {
                points.append(fixPoint(point: location))
            }
            break
        case .changed:
            if !isLikeLast(point: fixPoint(point: location)) {
                points.append(fixPoint(point: location))
                points.append(fixPoint(point: location))
            }
            
            drawing()
            break
            
        case .ended:
            if !isLikeLast(point: fixPoint(point: location)) {
                points.append(fixPoint(point: location))
            }
            
            drawing()
            break
            
        default:
            result = original
            break
        }
    }
    
    func startDrawing(layer: UIImage) {
        original = layer
        result = layer
    }
    
    func drawing() {
        UIGraphicsBeginImageContextWithOptions(original.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(UIColor.black.cgColor)
        context.setShouldAntialias(false)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(CGFloat(normalise(radius: Double(width))))
        
        context.addLines(between: points)
        result = UIGraphicsGetImageFromCurrentImageContext()!
        
        if delegate.symmetry.x != 0 {
            context.clear(CGRect(origin: .zero ,size: original.size))
            context.translateBy(x: original.size.width, y: 0)
            context.scaleBy(x: -1, y: 1)
            
            result.draw(in: CGRect(x: (original.size.width / 2.0 - delegate.symmetry.x) * 2, y: 0, width: original.size.width, height: original.size.height))
            result = UIImage.merge(images: [result, UIImage(cgImage: context.makeImage()!)])!
            
            context.scaleBy(x: -1, y: 1)
            context.translateBy(x:  -original.size.width, y: 0)
        }
        
        if delegate.symmetry.y != 0 {
            context.clear(CGRect(origin: .zero ,size: original.size))
            context.translateBy(x: 0, y: original.size.height)
            context.scaleBy(x: 1, y: -1)
            
            result.draw(in: CGRect(x: 0, y: (original.size.height / 2.0 - delegate.symmetry.y) * 2, width: original.size.width, height: original.size.height))
            result = UIImage.merge(images: [result, UIImage(cgImage: context.makeImage()!)])!

            
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -original.size.height)
        }
        
        UIGraphicsEndImageContext()
        
        result = result.inner(image: delegate.selecion).withTintColor(delegate.color)
    }
    
    func endDrawing() {
        points.removeAll()
        original = UIImage()
        result = UIImage()
    }
    
    func saveAction(to project: ProjectWork) {
        //save in main file information about action
        project.addAction(action :["ToolID" : "\(Actions.drawing.rawValue)", "frame" : "\(project.FrameSelected)", "layer" : "\(project.LayerSelected)"])

        //save result image as layer
        try! UIImage.merge(images: [preview.flip(xFlip: project.isFlipX, yFlip: project.isFlipY)])!.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(project.information.frames[project.FrameSelected].frameID)").appendingPathComponent("layer-\(project.information.frames[project.FrameSelected].layers[project.LayerSelected].layerID).png"))
        
        //save original image as last action's state
        try! original.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID())-was.png"))

        //save result image as total action's state
        try! project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID()).png"))
    }
    
    private func normalise(radius: Double) -> Double {
        if radius <= 2 {
            return sqrt(radius)
        }
        
        let realRad = sqrt(2) / 2.0 * radius
        if realRad - floor(realRad) >= 0.5 {
            return sqrt(2 * pow(floor(realRad), 2))
        } else {
            return sqrt(2 * pow(floor(realRad) - 0.5, 2))
        }
    }
    
    private func fixPoint(point: CGPoint) -> CGPoint {
        if width % 2 == 1 {
            return point.offset(x: 0.5, y: 0.5)
        }
        return point
    }
    
    private func isLikeLast(point : CGPoint) -> Bool {
        return points.last == point
    }
}
