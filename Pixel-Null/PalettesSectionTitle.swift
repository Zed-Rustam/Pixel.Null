//
//  PalettesSectionTitle.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 18.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalettesSectionTitle: UICollectionReusableView {
    lazy private var title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = getAppColor(color: .enable)
        lbl.font = UIFont(name: UIFont.appBlack, size: 24)
        lbl.textAlignment = .left
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewFullSize(view: title,paddings: (0,0,24,0))
    }
    
    func setText(text: String){
        title.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
