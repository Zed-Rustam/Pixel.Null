//
//  PaletteNavigation.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 18.09.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PaletteNavigation: UINavigationController {
    override func viewDidLoad() {
        navigationBar.prefersLargeTitles = true
        
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 42, weight: .heavy)]
        
        let option = UINavigationBarAppearance()
        option.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        option.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 42, weight: .heavy)]
        navigationBar.standardAppearance = option
        
        let palettes = PalleteCollection()
        
        pushViewController(palettes, animated: true)
    }
}
