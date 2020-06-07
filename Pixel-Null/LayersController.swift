//
//  LayersController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 02.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayersController : UIViewController {
    lazy private var table : LayersTable = {
        let tb = LayersTable()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    override func viewDidLoad() {
        view.addSubview(table)
        table.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        table.heightAnchor.constraint(equalToConstant: 300).isActive = true
        table.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        table.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
        view.backgroundColor = getAppColor(color: .background)
    }
}
