//
//  EditorLayer.swift
//  new Testing
//
//  Created by Рустам Хахук on 08.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class EditorLayer : CALayer {
    @NSManaged var offset : CGPoint
    @NSManaged var scale : CGFloat
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        if let lay = layer as? EditorLayer {
            self.offset = lay.offset
            self.scale = lay.scale
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        switch key {
        case "offset":
            return true
        case "scale":
            return true
        default:
            return super.needsDisplay(forKey: key)
        }
    }
}
