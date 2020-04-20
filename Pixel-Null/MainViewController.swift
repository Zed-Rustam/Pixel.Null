//
//  ViewController.swift
//  new Testing
//
//  Created by Рустам Хахук on 31.12.2019.
//  Copyright © 2019 Zed Null. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var controllers : [UIViewController] = []
    lazy var nav : NavigationView = {
        let navig = NavigationView(ics:[#imageLiteral(resourceName: "book_icon"),#imageLiteral(resourceName: "news_icon"),#imageLiteral(resourceName: "gallery_icon"),#imageLiteral(resourceName: "pallete_icon"),#imageLiteral(resourceName: "settings_icon")])
        navig.translatesAutoresizingMaskIntoConstraints = false
        
        if UIApplication.shared.windows[0].safeAreaInsets.bottom / 2 > 0 {
            navig.setNavigationCorners(top: 16, bottom: 36)
            navig.bottomOffset = 16
        } else {
            navig.setNavigationCorners(top: 16, bottom: 16)
        }
        navig.listener = self
        navig.select = 2
        return navig
    }()
    
    override var prefersHomeIndicatorAutoHidden : Bool{
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setControllers(menus : UIViewController...){
        controllers.removeAll()
        controllers = menus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ProjectStyle.uiBackgroundColor

        self.view.addSubview(controllers[0].view)
        self.view.addSubview(controllers[1].view)
        self.view.addSubview(controllers[2].view)
        self.view.addSubview(controllers[3].view)
        self.view.addSubview(controllers[4].view)
        
        controllers[0].view.isHidden = true
        controllers[1].view.isHidden = true
        controllers[2].view.isHidden = false
        controllers[3].view.isHidden = true
        controllers[4].view.isHidden = true

        self.view.addSubview(nav)
       }
    
    override func viewDidLayoutSubviews() {
        nav.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        nav.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
        nav.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
        nav.heightAnchor.constraint(equalToConstant: 64 + CGFloat(UIApplication.shared.windows[0].safeAreaInsets.bottom / 2)).isActive = true
    }
}

extension MainViewController : NavigationProtocol {
    
    func onSelectChange(select: Int, lastSelect: Int) {
        self.controllers[lastSelect].view.isHidden = true
        self.controllers[select].view.isHidden = false
    }
}
