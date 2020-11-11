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
    
    //for finger's gestures
    func action(location: CGPoint, gestureState: UIGestureRecognizer.State)
    
    //draw in result image
    func drawing()
            
    //saving action in project
    func saveAction()
}

protocol EditorDelegate {
    var selecion: UIImage? {get}
    var symmetry: CGPoint {get}
    var color : UIColor {get}
    var selectLayer : UIImage {get set}
    var actionLayer : UIImage {get set}
    var editorProject : ProjectWork {get}
    var editorDelegate: ToolsActionDelegate {get}
    func startDrawing()
    func endDrawing()
    func actionCancel()
}
