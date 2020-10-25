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
        img.setCorners(corners: 12,needMask: true)
        return img
    }()
    
    lazy private var devName : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Rustam Khakhuk"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    lazy private var devInfo : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Develop and design"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    lazy private var devContacts : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Contacts"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        
        return label
    }()
    
    lazy private var devEmail : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Email"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    lazy private var devEmailInfo : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "zed.null@icloud.com"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    lazy private var devTelegram : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "Telegram"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    lazy private var devTelegramInfo : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.text = "@Zed_Null"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Developer"
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(devIcon)
        view.addSubview(devName)
        view.addSubview(devInfo)
        view.addSubview(devContacts)
        view.addSubview(devEmail)
        view.addSubview(devEmailInfo)
        
        view.addSubview(devTelegram)
        view.addSubview(devTelegramInfo)

        devIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        devIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        
        devName.leftAnchor.constraint(equalTo: devIcon.rightAnchor, constant: 12).isActive = true
        devName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        devName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        
        devInfo.leftAnchor.constraint(equalTo: devIcon.rightAnchor, constant: 12).isActive = true
        devInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        devInfo.topAnchor.constraint(equalTo: devName.bottomAnchor, constant: 0).isActive = true
        
        devContacts.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        devContacts.topAnchor.constraint(equalTo: devIcon.bottomAnchor, constant: 24).isActive = true
        
        devEmail.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        devEmail.topAnchor.constraint(equalTo: devContacts.bottomAnchor, constant: 12).isActive = true
        
        devEmailInfo.leftAnchor.constraint(equalTo: devEmail.rightAnchor, constant: 24).isActive = true
        devEmailInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        devEmailInfo.topAnchor.constraint(equalTo: devContacts.bottomAnchor, constant: 12).isActive = true
        
        devTelegram.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        devTelegram.topAnchor.constraint(equalTo: devEmail.bottomAnchor, constant: 0).isActive = true
        
        devTelegramInfo.leftAnchor.constraint(equalTo: devTelegram.rightAnchor, constant: 24).isActive = true
        devTelegramInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        devTelegramInfo.topAnchor.constraint(equalTo: devEmail.bottomAnchor, constant: 0).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
