//
//  TitleView.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 27.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class TitleView : UIView {
    
    var text : String {
        get{
            return title.text!
        }
        set{
            title.text = newValue
        }
    }
    
    var font : UIFont {
        get{
            return title.font
        }
        set{
            title.font = newValue
        }
    }
    
    var textAlignment : NSTextAlignment {
        get{
            return title.textAlignment
        }
        set{
            title.textAlignment = newValue
        }
    }
    
    lazy private var bgView : UIView = {
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = getAppColor(color: .background)
        bg.setCorners(corners: 8)
        
        bg.addSubviewFullSize(view: title)
        return bg
    }()
    
    lazy private var title : UILabel = {
       let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.font = UIFont(name: "Rubik-Bold", size: 20)
        text.textColor = getAppColor(color: .enable)
        return text
    }()
    
    init(text : String){
        super.init(frame: .zero)
        addSubviewFullSize(view: bgView)
        setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 0.25)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func tintColorDidChange() {
        setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 0.25)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
