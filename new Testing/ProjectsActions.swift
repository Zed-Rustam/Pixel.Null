//
//  ProjectsActions.swift
//  new Testing
//
//  Created by Рустам Хахук on 09.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

protocol FastActionsListener {
    func didTouch(num : Int)
}

class FastActionsView: UIView {
    var items : [ UIImageView] = []
    var background : UIView = UIView()
    var spacing : Int = 12
    var listener : FastActionsListener? = nil
        
    init(x : Int,y : Int, iconsSize : Int,listener lis : FastActionsListener?, icons : UIImage...){
        listener = lis
        for i in 0..<icons.count {
            items.append(UIImageView(image: icons[i]))
            items.last!.image!.withRenderingMode(.alwaysTemplate)
            items.last!.tintColor = ProjectStyle.uiEnableColor
            items.last!.frame = CGRect(x:Int(Double(iconsSize * i) + Double(Double(spacing) * 1.5) + Double(i * spacing * 1)), y: spacing, width: iconsSize, height: iconsSize)
        }
        background.frame = CGRect(x: 0, y: 0, width: icons.count * iconsSize + (icons.count + 2) * spacing, height: spacing * 2 + iconsSize)
        background.backgroundColor = ProjectStyle.uiBackgroundColor
        background.layer.cornerRadius = CGFloat((iconsSize + spacing * 2) / 2)

        super.init(frame : CGRect(x: x, y: y, width: icons.count * iconsSize + (icons.count + 2) * spacing, height: spacing * 2 + iconsSize))
        addSubview(background)
        
        for item in items {
            addSubview(item)
        }
        
        layer.shadowColor = ProjectStyle.uiShadowColor.cgColor
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder : coder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        listener!.didTouch(num: 1)
    }
}
