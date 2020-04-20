//
//  Training.swift
//  new Testing
//
//  Created by Рустам Хахук on 13.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class TrainingController : UINavigationController {
    
    override func viewDidLoad() {
        let training = TrainingMain()
        training.navigation = self
        navigationBar.isHidden = true
        
        pushViewController(training, animated: true)
    }
}
