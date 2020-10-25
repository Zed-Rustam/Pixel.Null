//
//  ThemeSelect.swift
//  new Testing
//
//  Created by Рустам Хахук on 12.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ThemeSelect: UIViewController {
    
    lazy private var useSystemTheme : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Use system theme", comment: "")
        label.textColor = getAppColor(color: .enable)
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 36).isActive = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.baselineAdjustment = .alignCenters
        return label
    }()
    
    lazy private var bgThemeSelect : UIView = {
        let mainView = UIView()
        mainView.backgroundColor = getAppColor(color: .disable).withAlphaComponent(0.5)
        mainView.setCorners(corners: 24)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        mainView.widthAnchor.constraint(equalToConstant: 132).isActive = true
        
        mainView.addSubview(lightTheme)
        mainView.addSubview(darkTheme)
        mainView.addSubview(selectStroke)

        lightTheme.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 12).isActive = true
        lightTheme.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12).isActive = true
        
        selectStroke.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 6).isActive = true
        selectStroke.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 6).isActive = true
        
        darkTheme.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -12).isActive = true
        darkTheme.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12).isActive = true
        
        return mainView
    }()
    
    lazy private var lightTheme : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 48).isActive = true
        img.heightAnchor.constraint(equalToConstant: 48).isActive = true
        img.setCorners(corners: 12, needMask: true)
        
        img.image = #imageLiteral(resourceName: "theme_icon_light")
        return img
    }()
    
    lazy private var darkTheme : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 48).isActive = true
        img.heightAnchor.constraint(equalToConstant: 48).isActive = true
        img.setCorners(corners: 12, needMask: true)
        
        img.image = #imageLiteral(resourceName: "theme_icon_dark")
        return img
    }()
    
    lazy private var selectStroke : UIView = {
        let stroke = UIView()
        stroke.translatesAutoresizingMaskIntoConstraints = false
        stroke.widthAnchor.constraint(equalToConstant: 60).isActive = true
        stroke.heightAnchor.constraint(equalToConstant: 60).isActive = true
        stroke.backgroundColor = .clear
        stroke.setCorners(corners: 18)
        stroke.layer.borderColor = getAppColor(color: .select).cgColor
        stroke.layer.borderWidth = 3
        
        return stroke
    }()
    
    lazy private var toggle : ToggleView = {
        let tog = ToggleView()
        
        tog.delegate = {[unowned self] in
            self.isThemeChange = true
            
            print(self.traitCollection.userInterfaceStyle.rawValue)

            if !$0 {
                    self.bgThemeSelect.transform = CGAffineTransform(translationX: 0, y: 50)
                    self.bgThemeSelect.alpha = 0
                    
                    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        self.bgThemeSelect.transform = CGAffineTransform(translationX: 0, y: 0)
                    }, completion: nil)
                     UIView.animate(withDuration: 0.25, animations: {
                         self.bgThemeSelect.alpha = 1
                     })
                } else {
                    self.bgThemeSelect.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.bgThemeSelect.alpha = 1
                    
                    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        self.bgThemeSelect.transform = CGAffineTransform(translationX: 0, y: 50)
                    }, completion: nil)
                     UIView.animate(withDuration: 0.25, animations: {
                         self.bgThemeSelect.alpha = 0
                     })
                 }
                
                self.isThemeChange = false
            //}
            
            self.view.window?.overrideUserInterfaceStyle = $0 ? .unspecified : self.traitCollection.userInterfaceStyle
            
            self.selectTheme(theme: self.traitCollection.userInterfaceStyle.rawValue)
            UserDefaults.standard.set($0 ? 0 : self.traitCollection.userInterfaceStyle.rawValue, forKey: "themeMode")
        }
        return tog
    }()
    
    private var isThemeChange : Bool = false
    
    lazy private var tapgesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
    
    @objc func onTap(sender : UITapGestureRecognizer) {
        if lightTheme.bounds.contains(sender.location(in: lightTheme)) {
            UserDefaults.standard.set(1, forKey: "themeMode")
            self.view.window?.overrideUserInterfaceStyle = .light
            selectTheme(theme: 1)

        } else if darkTheme.bounds.contains(sender.location(in: darkTheme)) {
            UserDefaults.standard.set(2, forKey: "themeMode")
            selectTheme(theme: 2)
            self.view.window?.overrideUserInterfaceStyle = .dark

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = getAppColor(color: .background)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Theme"
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(useSystemTheme)
        view.addSubview(toggle)
        view.addSubview(bgThemeSelect)
        view.isUserInteractionEnabled = true
        
        useSystemTheme.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        useSystemTheme.rightAnchor.constraint(equalTo: toggle.leftAnchor, constant: -12).isActive = true
        useSystemTheme.centerYAnchor.constraint(equalTo: toggle.centerYAnchor, constant: 0).isActive = true
        
        toggle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        toggle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        
        bgThemeSelect.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        bgThemeSelect.topAnchor.constraint(equalTo: useSystemTheme.bottomAnchor, constant: 12).isActive = true
        
        switch UserDefaults.standard.integer(forKey: "themeMode") {
        case 1:
            toggle.isCheck = false
            bgThemeSelect.alpha = 1
        case 2:
            toggle.isCheck = false
            bgThemeSelect.alpha = 1
        default:
            toggle.isCheck = true
            bgThemeSelect.alpha = 0
        }
                
        self.selectTheme(theme: self.traitCollection.userInterfaceStyle.rawValue)
        view.addGestureRecognizer(tapgesture)
    }
    
    func selectTheme(theme : Int) {
        if theme == 1 {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.selectStroke.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.selectStroke.transform = CGAffineTransform(translationX: 60, y: 0)
            }, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        toggle.checkChange()
        print(self.traitCollection.userInterfaceStyle.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
}
