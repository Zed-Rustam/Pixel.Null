//
//  GridLayer.swift
//  new Testing
//
//  Created by Рустам Хахук on 07.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GridLayer : CALayer {
    @NSManaged var gridScale : CGFloat
    @NSManaged var startPos : CGPoint
    
    override init() {
        super.init()
    }
    override init(layer: Any) {
        super.init(layer: layer)
        if let lay = layer as? GridLayer {
            self.gridScale = lay.gridScale
            self.startPos = lay.startPos
        }
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        switch key {
        case "startPos":
            return true
        case "gridScale":
            return true
        default:
            return super.needsDisplay(forKey: key)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
