//
//  AboutDeveloperController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 12.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class AboutDeveloperController : UIViewController {
    lazy private var devIcon : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 96).isActive = true
        img.heightAnchor.constraint(equalToConstant: 96).isActive = true
        img.image = #imageLiteral(resourceName: "im")
        img.contentMode = .scaleAspectFill
        img.setCorners(corners: 16)
        return img
    }()
    
    lazy private var devName : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Rustam Khakhuk"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont(name: "Rubik-Bold", size: 24)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    lazy private var devInfo : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Develop and design"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont(name: "Rubik-Medium", size: 16)
        
        return label
    }()
    
    lazy private var devContacts : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Contacts"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont(name: "Rubik-Bold", size: 24)
        
        return label
    }()

    lazy private var devEmail : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Email"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont(name: "Rubik-Medium", size: 16)
        
        return label
    }()
    
    lazy private var devEmailInfo : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "zed.null@icloud.com"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont(name: "Rubik-Medium", size: 16)
        
        return label
    }()
    
    lazy private var devTelegram : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Telegram"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont(name: "Rubik-Medium", size: 16)
        
        return label
    }()
    
    lazy private var devTelegramInfo : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "@Zed_Null"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont(name: "Rubik-Medium", size: 16)
        
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        
        view.addSubview(devIcon)
        view.addSubview(devName)
        view.addSubview(devInfo)
        view.addSubview(devContacts)
        view.addSubview(devEmail)
        view.addSubview(devEmailInfo)
        
        view.addSubview(devTelegram)
        view.addSubview(devTelegramInfo)

        devIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        devIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        
        devName.leftAnchor.constraint(equalTo: devIcon.rightAnchor, constant: 12).isActive = true
        devName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        devName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        
        devInfo.leftAnchor.constraint(equalTo: devIcon.rightAnchor, constant: 24).isActive = true
        devInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        devInfo.topAnchor.constraint(equalTo: devName.bottomAnchor, constant: 0).isActive = true
        
        devContacts.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        devContacts.topAnchor.constraint(equalTo: devIcon.bottomAnchor, constant: 12).isActive = true
        
        devEmail.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        devEmail.topAnchor.constraint(equalTo: devContacts.bottomAnchor, constant: 0).isActive = true
        
        devEmailInfo.leftAnchor.constraint(equalTo: devEmail.rightAnchor, constant: 12).isActive = true
        devEmailInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        devEmailInfo.topAnchor.constraint(equalTo: devContacts.bottomAnchor, constant: 0).isActive = true
        
        devTelegram.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        devTelegram.topAnchor.constraint(equalTo: devEmail.bottomAnchor, constant: 0).isActive = true
        
        devTelegramInfo.leftAnchor.constraint(equalTo: devTelegram.rightAnchor, constant: 12).isActive = true
        devTelegramInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        devTelegramInfo.topAnchor.constraint(equalTo: devEmail.bottomAnchor, constant: 0).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.devIcon.transform = CGAffineTransform(translationX: 0, y: 50)
        self.devIcon.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.devIcon.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        UIView.animate(withDuration: 0.25, delay: 0.1, animations: {
            self.devIcon.alpha = 1
        })
        
        self.devName.transform = CGAffineTransform(translationX: 0, y: 50)
        self.devName.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.devName.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        UIView.animate(withDuration: 0.25, delay: 0.1, animations: {
            self.devName.alpha = 1
        })
        
        self.devInfo.transform = CGAffineTransform(translationX: 0, y: 50)
        self.devInfo.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.devInfo.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        UIView.animate(withDuration: 0.25, delay: 0.2, animations: {
            self.devInfo.alpha = 1
        })
        
        self.devContacts.transform = CGAffineTransform(translationX: 0, y: 50)
        self.devContacts.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.devContacts.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        UIView.animate(withDuration: 0.25, delay: 0.3, animations: {
            self.devContacts.alpha = 1
        })
        
        self.devEmailInfo.transform = CGAffineTransform(translationX: 0, y: 50)
        self.devEmailInfo.alpha = 0
        
        self.devEmail.transform = CGAffineTransform(translationX: 0, y: 50)
        self.devEmail.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.devEmailInfo.transform = CGAffineTransform(translationX: 0, y: 0)
            self.devEmail.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        UIView.animate(withDuration: 0.25, delay: 0.4, animations: {
            self.devEmailInfo.alpha = 1
            self.devEmail.alpha = 1
        })
        
        self.devTelegramInfo.transform = CGAffineTransform(translationX: 0, y: 50)
        self.devTelegramInfo.alpha = 0
        self.devTelegram.transform = CGAffineTransform(translationX: 0, y: 50)
        self.devTelegram.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.devTelegramInfo.transform = CGAffineTransform(translationX: 0, y: 0)
            self.devTelegram.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        UIView.animate(withDuration: 0.25, delay: 0.5, animations: {
            self.devTelegramInfo.alpha = 1
            self.devTelegram.alpha = 1
        })
        
        
    }
}
