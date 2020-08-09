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
    
    func setSelectPalette(palette : [String], name : String) {
        selectDelegate(Pallete(colors: palette), name)
    }
    
    lazy private var collection : SelectPaletteCollection = {
        let col = SelectPaletteCollection()
        col.translatesAutoresizingMaskIntoConstraints = false
        
        
        return col
    }()
    
    override func viewDidLoad() {
        view.setCorners(corners: 32)
        view.backgroundColor = getAppColor(color: .background)
        
        view.addSubview(collection)
        collection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collection.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collection.mainController = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collection.layoutIfNeeded()
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: (view.frame.width - 36) / 3, height: (view.frame.width - 36) / 3)
        
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 8
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collection.frame.width, height: 36)
        collection.reloadData()
    }
}
