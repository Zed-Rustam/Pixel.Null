//
//  EraserTool.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 31.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class EraserTool: DrawTool {
    var result: UIImage
    
    var original: UIImage
    
    var preview: UIImage {
        get{
            return original.cut(image: result)
        }
    }
    
    var delegate: EditorDelegate
    
    var width : Int = 1
    
    private var points : [CGPoint] = []
    
    func action(location: CGPoint, gestureState: UIGestureRecognizer.State) {
        switch gestureState {
               case .began:
                   original = delegate.selectLayer
                   result = UIImage(size: original.size)!
                   
                   if !isLikeLast(point: fixPoint(point: location)) {
                       points.append(fixPoint(point: location))
                   }
                   break
               case .changed:
                   delegate.startDrawing()

                   if !isLikeLast(point: fixPoint(point: location)) {
                       points.append(fixPoint(point: location))
                       points.append(fixPoint(point: location))
                   }
                                      
                   drawing()
                   break
                   
               case .ended:
                    points.append(fixPoint(point: location))
                                      
                   drawing()
                   saveAction()
                   delegate.endDrawing()
                   
                   points.removeAll()
                   break
                   
               default:
                   delegate.actionCancel()
                   points.removeAll()
                   break
               }
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
        
        result = result.inner(image: delegate.selecion)
        delegate.actionLayer = preview
    }
    
    func saveAction() {
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
