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
        let navig = NavigationView(ics:[#imageLiteral(resourceName: "gallery_icon"),#imageLiteral(resourceName: "pallete_icon"),#imageLiteral(resourceName: "book_icon"),#imageLiteral(resourceName: "settings_icon")])
        navig.translatesAutoresizingMaskIntoConstraints = false
        
        if UIApplication.shared.windows[0].safeAreaInsets.bottom / 2 > 0 {
            navig.setNavigationCorners(top: 16, bottom: 36)
            navig.bottomOffset = 16
        } else {
            navig.setNavigationCorners(top: 16, bottom: 16)
        }
        navig.listener = self
        navig.select = 0
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
        //self.view.addSubview(controllers[4].view)
        
        controllers[0].view.isHidden = false
        controllers[1].view.isHidden = true
        controllers[2].view.isHidden = true
        controllers[3].view.isHidden = true
        //controllers[4].view.isHidden = true

        self.view.addSubview(nav)
       }
    
    override func viewDidLayoutSubviews() {
        nav.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        nav.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
        nav.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
        nav.heightAnchor.constraint(equalToConstant: 64 + CGFloat(UIApplication.shared.windows[0].safeAreaInsets.bottom / 2)).isActive = true
        
        let edges = UIEdgeInsets(top: 0, left: 0, bottom: nav.frame.height - CGFloat(UIApplication.shared.windows[0].safeAreaInsets.bottom / 2) , right: 0)
        
        controllers.forEach({
            $0.additionalSafeAreaInsets = edges
        })
    }
}

extension MainViewController : NavigationProtocol {
    
    func onSelectChange(select: Int, lastSelect: Int) {
        self.controllers[select].view.transform = CGAffineTransform(translationX: 0, y: -100)
        self.controllers[select].view.isHidden = false
        self.controllers[select].view.alpha = 0

        self.controllers[lastSelect].view.isHidden = false
        self.controllers[lastSelect].view.alpha = 1
        self.controllers[lastSelect].view.transform = CGAffineTransform(translationX: 0, y: 0)


        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.controllers[lastSelect].view.transform = CGAffineTransform(translationX: 0, y: 100)
            self.controllers[lastSelect].view.alpha = 0
            
            self.controllers[select].view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.controllers[select].view.alpha = 1

        },completion: {isEnd in
            if lastSelect != self.nav.select {
                self.controllers[lastSelect].view.alpha = 1
                self.controllers[lastSelect].view.transform = CGAffineTransform(translationX: 0, y: 0)
                self.controllers[lastSelect].view.isHidden = true
            }
        })
    }
}
