//
//  ShapeTool.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 31.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ShapeTool: DrawTool {
    var result: UIImage
    
    var original: UIImage
    
    var preview: UIImage {
        get{
            return UIImage.merge(images: [original,result])!
        }
    }
    
    var delegate: EditorDelegate
    
    var startPoint : CGPoint
    var endPoint : CGPoint
    
    var isFixed = false
    var squareType : SquareType = .rectangle

    enum SquareType {
        case rectangle
        case oval
        case line
    }
    
    func action(location: CGPoint, gestureState: UIGestureRecognizer.State) {
        switch gestureState {
        case .began:
            original = delegate.selectLayer
            result = UIImage(size: original.size)!
            startPoint = location.offset(x: 0.5, y: 0.5)
            break
        case .changed:
            delegate.startDrawing()
            endPoint = location.offset(x: 0.5, y: 0.5)
            drawing()
            break
            
        case .ended:
            endPoint = location.offset(x: 0.5, y: 0.5)
            drawing()
            saveAction()
            delegate.endDrawing()
            break
            
        default:
            delegate.actionCancel()
            break
        }
    }
    
    func drawing() {
        if isFixed {
            let width = endPoint.x - startPoint.x
            let height = endPoint.y - startPoint.y
            
            let finalSize = max(abs(width),abs(height))
            
            endPoint = CGPoint(x: startPoint.x + finalSize * (width / abs(width)), y: startPoint.y + finalSize * (height / abs(height)))
        }
        
        UIGraphicsBeginImageContextWithOptions(original.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(1)
        
        switch squareType {
        case .rectangle:
            context.addRect(CGRect(x: min(startPoint.x,endPoint.x), y: min(startPoint.y,endPoint.y), width: abs(endPoint.x - startPoint.x), height: abs(endPoint.y - startPoint.y)))
            
        case .oval:
            context.addEllipse(in: CGRect(x: min(startPoint.x,endPoint.x), y: min(startPoint.y,endPoint.y), width: abs(endPoint.x - startPoint.x), height: abs(endPoint.y - startPoint.y)))
            
        case .line:
            context.addLines(between: [startPoint,endPoint])
        }
        context.strokePath()
        
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
        delegate.actionLayer = preview
    }
    
    func saveAction() {
        //save in main file information about action
        delegate.editorProject.addAction(action :["ToolID" : "\(Actions.drawing.rawValue)", "frame" : "\(delegate.editorProject.FrameSelected)", "layer" : "\(delegate.editorProject.LayerSelected)"])

        //save result image as layer
        try! UIImage.merge(images: [preview.flip(xFlip: delegate.editorProject.isFlipX, yFlip: delegate.editorProject.isFlipY)])!.pngData()?.write(to: delegate.editorProject.getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(delegate.editorProject.information.frames[delegate.editorProject.FrameSelected].frameID)").appendingPathComponent("layer-\(delegate.editorProject.information.frames[delegate.editorProject.FrameSelected].layers[delegate.editorProject.LayerSelected].layerID).png"))
        
        //save original image as last action's state
        try! original.flip(xFlip: delegate.editorProject.isFlipX, yFlip: delegate.editorProject.isFlipY).pngData()?.write(to: delegate.editorProject.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(delegate.editorProject.getNextActionID())-was.png"))

        //save result image as total action's state
        try! delegate.editorProject.getLayer(frame: delegate.editorProject.FrameSelected, layer: delegate.editorProject.LayerSelected).pngData()?.write(to: delegate.editorProject.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(delegate.editorProject.getNextActionID()).png"))
    }
    
    init(editorDelegate: EditorDelegate) {
        delegate = editorDelegate
        result = UIImage()
        original = UIImage()
        startPoint = .zero
        endPoint = .zero
    }
    
}
