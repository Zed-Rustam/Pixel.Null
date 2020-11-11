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
        navigationBar.tintColor = getAppColor(color: .enable)
        
        let option = UINavigationBarAppearance()
        option.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        option.backgroundColor = getAppColor(color: .background).withAlphaComponent(0.75)
        
        option.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: UIFont.appBlack, size: 42)!, NSAttributedString.Key.foregroundColor: getAppColor(color: .enable)]
        option.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: UIFont.appBlack, size: 20)!, NSAttributedString.Key.foregroundColor: getAppColor(color: .enable)]
        navigationBar.standardAppearance = option
        
        pushViewController(selection, animated: false)
    }
}
