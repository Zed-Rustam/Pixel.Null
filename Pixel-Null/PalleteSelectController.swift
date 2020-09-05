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
    
    lazy private var layout = UICollectionViewFlowLayout()

    
    lazy private var collection : SelectPaletteCollection = {
        let col = SelectPaletteCollection(layout: layout)
        col.translatesAutoresizingMaskIntoConstraints = false
        
        return col
    }()
    
    override func viewDidLoad() {
        view.setCorners(corners: 32)
        view.backgroundColor = getAppColor(color: .background)
        
        layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let itemSize = Int((view.frame.size.width - 48) / 3)
        layout.itemSize = CGSize(width: itemSize, height: itemSize + 24)
        layout.headerReferenceSize = CGSize(width: view.frame.size.width - 24, height: 72)
        
        view.addSubview(collection)
        collection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collection.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collection.mainController = self
    }
}
