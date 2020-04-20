//
//  GridView.swift
//  new Testing
//
//  Created by Рустам Хахук on 07.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GridView : UIView {
    override class var layerClass: AnyClass{return GridLayer.self}

var isVisible = true
    
    var gridSize : CGSize = .zero
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
            if let lay = layer as? GridLayer {
                //print("drawing... \(lay.startPos)")
                var points : [CGPoint] = []
                ctx.setShouldAntialias(false)

                ctx.translateBy(x: lay.startPos.x, y: lay.startPos.y)
                
                for x in 0...Int(gridSize.width) {
                    points.append(CGPoint(x: CGFloat(x) * lay.gridScale, y: 0))
                    points.append(CGPoint(x: CGFloat(x) * lay.gridScale, y: gridSize.height * lay.gridScale))
                }

                for y in 0...Int(gridSize.height) {
                    points.append(CGPoint(x: 0, y: CGFloat(y) * lay.gridScale))
                    points.append(CGPoint(x: gridSize.width * lay.gridScale, y: CGFloat(y) * lay.gridScale))
                }

                ctx.setStrokeColor(UIColor.white.withAlphaComponent(0.25).cgColor)
                ctx.setLineWidth(1)
                ctx.strokeLineSegments(between: points)
            }
        }
    
//    override func display(_ layer: CALayer) {
//        if let lay = layer.presentation() as? GridLayer {
//            print("testim")
//            lay.needsDisplay()
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
