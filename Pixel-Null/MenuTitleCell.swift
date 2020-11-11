//
//  MenuTitleCell.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 30.10.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class MenuTitleCell: UITableViewCell {
    lazy var Title: UILabel = {
        let lbl = UILabel()
        
        lbl.textColor = getAppColor(color: .enable)
        lbl.font = UIFont(name: UIFont.appBlack, size: 28)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviewFullSize(view: Title,paddings: (16,-16,0,0))
        contentView.backgroundColor = .clear
        
        let bg = UIView()
        bg.backgroundColor = getAppColor(color: .disable).withAlphaComponent(0.25)
        bg.setCorners(corners: 12,curveType: .continuous)
        
        selectedBackgroundView = bg
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
