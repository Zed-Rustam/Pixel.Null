//
//  ThemeController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 15.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

func getAppColor(color : Theme) -> UIColor{
        return UIColor(named: color.rawValue)!
}

enum Theme : String {
    case background = "backgroundColor"
    case backgroundLight = "backgroundLightColor"
    case content = "ContentColor"
    case enable = "enableColor"
    case disable = "disableColor"
    
    case shadow = "shadowColor"
    
    case select = "selectColor"
    case red = "redColor"
}

extension UIColor {
    static var appDisable : UIColor {
        get{
            return UIColor(named: "disableColor")!
        }
    }
    
    static var appBackground : UIColor {
        get{
            return UIColor(named: "backgroundColor")!
        }
    }
    
    static var appEnable : UIColor {
        get{
            return UIColor(named: "enableColor")!
        }
    }
    
    static var appSelect : UIColor {
        get{
            return UIColor(named: "selectColor")!
        }
    }
    
    static var appShadow : UIColor {
        get{
            return UIColor(named: "shadowColor")!
        }
    }
    
    static var appTextDisable : UIColor {
        get{
            return UIColor(named: "textDisableColor")!
        }
    }
    
    static var appRed : UIColor {
        get{
            return UIColor(named: "redColor")!
        }
    }
}
