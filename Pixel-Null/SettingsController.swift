//
//  SettingsController.swift
//  new Testing
//
//  Created by Рустам Хахук on 11.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SettingsController : UINavigationController {
    
    override func viewDidLoad() {
        
        navigationBar.prefersLargeTitles = true
        setNavigationBarHidden(true, animated: true)

        view.backgroundColor = getAppColor(color: .background)
        let main = MainSettingsMenu()
        main.navigation = self
        pushViewController(main, animated: true)
    }
    
}
