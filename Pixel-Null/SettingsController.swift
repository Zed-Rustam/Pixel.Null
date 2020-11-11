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
        
        let option = UINavigationBarAppearance()
        option.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: UIFont.appBlack, size: 42)!, NSAttributedString.Key.foregroundColor: getAppColor(color: .enable)]
        option.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: UIFont.appBlack, size: 20)!, NSAttributedString.Key.foregroundColor: getAppColor(color: .enable)]
        navigationBar.standardAppearance = option
        
        navigationBar.tintColor = getAppColor(color: .enable)
        
        setNavigationBarHidden(true, animated: true)

        view.backgroundColor = getAppColor(color: .background)
        let main = MainSettingsMenu()
        main.navigation = self
        pushViewController(main, animated: true)
    }
    
}
