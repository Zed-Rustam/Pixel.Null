//
//  PalleteSelectController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 16.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PeletteSelectController : UIViewController {

    var selectDelegate : (Pallete,String) -> () = {palette,name in }
    
    lazy private var titleBg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = getAppColor(color: .background)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        
        view.addSubviewFullSize(view: titleLabel)
        
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.addSubviewFullSize(view: view)
        return mainview
    }()
    
    func setSelectPalette(palette : [String], name : String) {
        selectDelegate(Pallete(colors: palette), name)
    }
    
    lazy private var titleLabel : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Select palette", comment: "")
        label.font = UIFont(name: "Rubik-Bold", size: 24)
        label.textColor = getAppColor(color: .enable)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy private var collection : SelectPaletteCollection = {
        let col = SelectPaletteCollection()
        col.translatesAutoresizingMaskIntoConstraints = false
        
        return col
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        
        view.addSubview(collection)
        view.addSubview(titleBg)
        
        titleBg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        titleBg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        titleBg.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        titleBg.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        collection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collection.topAnchor.constraint(equalTo: titleBg.bottomAnchor, constant: -12).isActive = true
        collection.mainController = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collection.layoutIfNeeded()
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: (view.frame.width - 36) / 3, height: (view.frame.width - 36) / 3)
        
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 8
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collection.frame.width, height: 36)
        collection.reloadData()
    }
    override func viewWillLayoutSubviews() {
        titleBg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
    }
}
