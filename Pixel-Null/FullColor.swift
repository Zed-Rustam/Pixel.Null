//
//  FullColor.swift
//  new Testing
//
//  Created by Рустам Хахук on 18.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FullColor : UIViewController {
    private var colorView : UIView!
    private var blur : UIVisualEffectView!
    private var info : UILabel!
    private var color : UIColor!
    
    func setColor(color clr : UIColor){
        color = clr
    }
    
    override func viewDidLoad() {
        self.preferredContentSize.height = self.preferredContentSize.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        colorView = UIView(frame: view.bounds)
        colorView.backgroundColor = color
        
        view.backgroundColor = UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1 / (view.frame.width / 8), orientation: .down))
        
        view.addSubview(colorView)
    }
}
