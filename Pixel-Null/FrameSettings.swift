//
//  FrameSettings.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 20.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FrameSettings : UIViewController {
    override func viewDidLoad() {
        preferredContentSize = CGSize(width: 256, height: 160)
        view.backgroundColor = getAppColor(color: .background)
    }
}
