//
//  GradientTool.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 31.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GradientTool : DrawTool {
    var result: UIImage
    
    var original: UIImage
    
    var preview: UIImage {
        get{
            return UIImage.merge(images: [original,result])!
        }
    }
    
    var delegate: EditorDelegate
    
    private var startPoint : CGPoint = .zero
    private var endPoint : CGPoint = .zero
    
    var stepCount = 10
    var startColor : UIColor = .black
    var endColor : UIColor = .white

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
    
    func makeArray() -> [CGFloat] {
        var array : [CGFloat] = []
        let color = CIColor(color: startColor)
        
        array.append(color.red)
        array.append(color.green)
        array.append(color.blue)
        array.append(color.alpha)
        
        let color2 = CIColor(color: endColor)
        
        array.append(color2.red)
        array.append(color2.green)
        array.append(color2.blue)
        array.append(color2.alpha)
        return array
    }
    
    func drawing() {
        UIGraphicsBeginImageContextWithOptions(original.size, false, 1)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
                
        if stepCount == 0 {
        let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: makeArray(), locations: nil, count: 2)!
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation,.drawsAfterEndLocation])
            
            result = UIGraphicsGetImageFromCurrentImageContext()!
        } else {
            drawStepGradient(context: context)
            
            context.rotate(by: -getAngle(p1: startPoint, p2: endPoint))
            context.translateBy(x: -startPoint.x , y: -startPoint.y)
            result = UIGraphicsGetImageFromCurrentImageContext()!
        }
        
        result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        result = result.inner(image: delegate.selecion)
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
    }
    
    private func lenght(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
    }
    
    private func getAngle(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        let angle = atan2(p2.y - p1.y, p2.x - p1.x)
        
        return angle
    }
    
    private func drawStepGradient(context : CGContext){
        let oneStep = CGFloat(lenght(p1: startPoint, p2: endPoint)) / CGFloat(stepCount + 2)
        let radius = 10000
        
        context.translateBy(x: startPoint.x , y: startPoint.y)
        context.rotate(by: getAngle(p1: startPoint, p2: endPoint))

        context.setFillColor(UIColor.getColorInGradient(position: 0, colors: startColor,endColor).cgColor)
        context.fill(CGRect(x: -CGFloat(radius), y: -CGFloat(radius), width: CGFloat(radius), height: CGFloat(radius * 2)))
        
        
        for i in 0..<stepCount + 1 {
            context.setFillColor(UIColor.getColorInGradient(position: CGFloat(i) / CGFloat(stepCount + 2), colors: startColor,endColor).cgColor)
            
            context.setBlendMode(.clear)
            context.fill(CGRect(x: ceil(CGFloat(i) * oneStep) - 0.5, y: -CGFloat(radius), width: (ceil(CGFloat(i + 1) * oneStep) - ceil(CGFloat(i) * oneStep)), height: CGFloat(radius * 2)))
            context.setBlendMode(.normal)
             context.fill(CGRect(x: ceil(CGFloat(i) * oneStep) - 0.5, y: -CGFloat(radius), width: (ceil(CGFloat(i + 1) * oneStep) - ceil(CGFloat(i) * oneStep)), height: CGFloat(radius * 2)))
        }
        
        context.setFillColor(UIColor.getColorInGradient(position: 1, colors: startColor,endColor).cgColor)
        
        context.setBlendMode(.clear)
        context.fill(CGRect(x: ceil(CGFloat(stepCount + 1) * oneStep) - 0.5, y: -CGFloat(radius), width: CGFloat(radius), height: CGFloat(radius * 2)))
        
        context.setBlendMode(.normal)
        context.fill(CGRect(x: ceil(CGFloat(stepCount + 1) * oneStep) - 0.5, y: -CGFloat(radius), width: CGFloat(radius), height: CGFloat(radius * 2)))
    }

}
