//
//  ColorSelectModel.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 07.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

protocol ColorDelegate: class {
    func changeColor(newColor: UIColor, sender: ColorSelectorDelegate?)
}

protocol ColorSelectorDelegate: class {    
    func setColor(color: UIColor)
}
