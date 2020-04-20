//
//  SummetryView.swift
//  new Testing
//
//  Created by Рустам Хахук on 16.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SymmetryView : UIView {
    var startX : CGFloat = 10
    var startY : CGFloat = 10
    var offset : CGPoint = .zero
    var scale : CGFloat = 1
    var isHorizontal = true
    var isVertical = true
    
    weak var project : ProjectWork!
    
    override init(frame : CGRect){
        super.init(frame : frame)
        isOpaque = false
        isUserInteractionEnabled = true
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        //print("some draw")
        ctx.clear(self.bounds)
        ctx.setStrokeColor(ProjectStyle.uiEnableColor.cgColor)
        ctx.setLineWidth(1)
        if isVertical {
            ctx.addLines(between: [CGPoint(x: offset.x + startX * scale, y: offset.y - 16),CGPoint(x: offset.x + startX * scale, y: offset.y + project.projectSize.height * scale + 16)])
        }
        if isHorizontal {
            ctx.addLines(between: [CGPoint(x: offset.x - 16, y: offset.y + startY * scale),CGPoint(x: offset.x + project.projectSize.width * scale + 16, y: offset.y + startY * scale)])
        }
        ctx.strokePath()
        
        ctx.setFillColor(ProjectStyle.uiEnableColor.cgColor)
        if isVertical {
            ctx.addEllipse(in: CGRect(x: offset.x + startX * scale - 16, y: offset.y - 32 - 16, width: 32, height: 32))
            ctx.addEllipse(in: CGRect(x: offset.x + startX * scale - 16, y: offset.y + project.projectSize.height * scale + 16, width: 32, height: 32))
        }
        if isHorizontal {
            ctx.addEllipse(in: CGRect(x: offset.x - 32 - 16, y: offset.y + startY * scale - 16, width: 32, height: 32))
            ctx.addEllipse(in: CGRect(x: offset.x + project.projectSize.width * scale + 16, y: offset.y + startY * scale - 16, width: 32, height: 32))
        }
        ctx.fillPath()
        
    }
    
    override func draw(_ rect: CGRect) {
        print("some draw")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
