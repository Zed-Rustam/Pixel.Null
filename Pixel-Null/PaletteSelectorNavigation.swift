//
//  PaletteSelectorNavigation.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 26.09.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PaletteSelectorNavigation: UINavigationController {
    var selection = PeletteSelectController()

    override func viewDidLoad() {
        view.setCorners(corners: 24, needMask: true)
        
        navigationBar.prefersLargeTitles = true
        
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 42, weight: .heavy)]
        
        let option = UINavigationBarAppearance()
        option.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        option.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 42, weight: .heavy)]
        navigationBar.standardAppearance = option
        
        pushViewController(selection, animated: false)
    }
}
