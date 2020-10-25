//
//  GalleryNavigation.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 18.09.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GalleryNavigation: UINavigationController {
    weak var parentController: UIViewController? = nil
    override func viewDidLoad() {
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 42, weight: .heavy)]
        
        let option = UINavigationBarAppearance()
        option.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        option.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 42, weight: .heavy)]
        navigationBar.standardAppearance = option
        
        let control = GalleryControl()
        control.parentController = parentController
        pushViewController(control, animated: false)
    }
}
