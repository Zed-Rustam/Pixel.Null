//
//  EditorSettingsController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 10.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class EditorSettingsController: UIViewController {
    lazy private var lastDelegate : UIGestureRecognizerDelegate? = nil
    
    lazy private var themeTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Editor", comment: "")
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont.systemFont(ofSize: 32, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    
    lazy private var toolsPosition: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Tools position", comment: "")
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    
    lazy private var toolBarBg: UIView = {
        let bg = UIView()
        bg.backgroundColor = getAppColor(color: .background)
        bg.setCorners(corners: 16)
        bg.translatesAutoresizingMaskIntoConstraints = false
        
        bg.addSubview(sliderView)
        
        sliderView.centerXAnchor.constraint(equalTo: bg.centerXAnchor, constant: 0).isActive = true
        sliderView.topAnchor.constraint(equalTo: bg.topAnchor, constant: 8).isActive = true

        bg.addSubviewFullSize(view: collection, paddings: (0,0,16,0))
        return bg
    }()
    
    lazy private var sliderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 42).isActive = true
        view.heightAnchor.constraint(equalToConstant: 4).isActive = true
        view.backgroundColor = getAppColor(color: .enable)
        view.setCorners(corners: 2)
        return view
    }()
    
    lazy private var collection : ToolBarRepositionCollection = {
        let col = ToolBarRepositionCollection()
        
        return col
    }()
    
    @objc func onBackPress() {
        navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Editor"
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(toolsPosition)
        view.addSubview(toolBarBg)

        toolsPosition.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        toolsPosition.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        toolsPosition.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        
        toolBarBg.topAnchor.constraint(equalTo: toolsPosition.bottomAnchor, constant: 12).isActive = true
        toolBarBg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        toolBarBg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        toolBarBg.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16).isActive = true
        
        collection.navigate = self.navigationController
    }
    
    override func viewDidLayoutSubviews() {
        toolBarBg.layoutIfNeeded()
        toolBarBg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
        toolBarBg.layer.shadowPath = UIBezierPath(roundedRect: toolBarBg.bounds, cornerRadius: 16).cgPath
    }
    
    override func viewDidDisappear(_ animated: Bool) {

        self.navigationController?.interactivePopGestureRecognizer?.reset()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("test")
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
}
