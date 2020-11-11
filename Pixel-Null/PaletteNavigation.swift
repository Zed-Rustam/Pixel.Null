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
                
        let option = UINavigationBarAppearance()
        option.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        option.backgroundColor = getAppColor(color: .background).withAlphaComponent(0.75)
        
        option.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: UIFont.appBlack, size: 42)!, NSAttributedString.Key.foregroundColor: getAppColor(color: .enable)]
        option.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: UIFont.appBlack, size: 20)!, NSAttributedString.Key.foregroundColor: getAppColor(color: .enable)]
        
        navigationBar.standardAppearance = option

        let palettes = PalleteCollection()
        
        pushViewController(palettes, animated: true)
    }
}
