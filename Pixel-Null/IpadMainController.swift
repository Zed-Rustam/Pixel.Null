//
//  IpadMainController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 30.10.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class IpadMainController: UISplitViewController {
    let gallery = GalleryNavigation()
    let palettes = PaletteNavigation()
    let settings = SettingsController()

    var controllers: [UIViewController] = []

    let navigation = IpadMainNavigation()
    override func viewDidLoad() {
                
        gallery.controller.mainController = self
        
        navigation.controller.delegate = self
        
        controllers = [gallery, palettes, settings]
        
        self.viewControllers.append(navigation)
        self.viewControllers.append(gallery)
        self.viewControllers.append(palettes)

        self.preferredPrimaryColumnWidth = 320

        view.backgroundColor = getAppColor(color: .disable)
        
    }
}

extension IpadMainController: NavigationProtocol {
    func onSelectChange(select: Int, lastSelect: Int) {
        self.showDetailViewController(controllers[select], sender: nil)
    }
}
