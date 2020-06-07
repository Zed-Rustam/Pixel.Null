//
//  LayerCell.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 02.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayerTableCell : UITableViewCell {
    
    lazy private var preview : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img.heightAnchor.constraint(equalToConstant: 36).isActive = true
        img.setCorners(corners: 6)
        img.layer.magnificationFilter = .nearest
        img.image = #imageLiteral(resourceName: "background")
        return img
    }()
    
    lazy private var layerName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont(name: "Rubik-Medium", size: 16)
        label.text = "New Label"
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var bg : UIView = {
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = getAppColor(color: .background)
        bg.layer.cornerRadius = 6
        
        bg.addSubview(preview)
        preview.leftAnchor.constraint(equalTo: bg.leftAnchor, constant: 0).isActive = true
        preview.topAnchor.constraint(equalTo: bg.topAnchor, constant: 0).isActive = true
        
        bg.addSubview(layerName)
        layerName.leftAnchor.constraint(equalTo: preview.rightAnchor, constant: 6).isActive = true
        layerName.rightAnchor.constraint(equalTo: bg.rightAnchor, constant: -6).isActive = true
        layerName.topAnchor.constraint(equalTo: bg.topAnchor, constant: 0).isActive = true
        layerName.bottomAnchor.constraint(equalTo: bg.bottomAnchor, constant: 0).isActive = true

        return bg
    }()
    
    lazy private var deletebtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "trash_icon"), frame: .zero)
        btn.corners = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setbgColor(color: getAppColor(color: .red))
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviewFullSize(view: bg,paddings: (12,-12,3,-3))
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        print("is select ? \(selected)")
        self.preview.layer.borderColor = getAppColor(color: .select).cgColor
        
        self.layerName.textColor = getAppColor(color: selected ? .select : .enable)
        self.preview.layer.borderWidth = selected ? 3 : 0
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        print("some some")
    }
}
