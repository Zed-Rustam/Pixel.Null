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
    case enable = "enableColor"
    case disable = "disableColor"
    case shadow = "shadowColor"
    case select = "selectColor"
    case red = "redColor"
}
