//
//  GalleryCell.swift
//  new Testing
//
//  Created by Рустам Хахук on 07.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GalleryCell : UICollectionViewCell {
    var project : ProjectViewNew
 
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont(name: "Rubik-Bold", size: 10)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return label
    }()
    
    
    override init(frame: CGRect) {
        project = ProjectViewNew()
        super.init(frame: frame)
        
        contentView.addSubviewFullSize(view: project,paddings: (0,0,0,-24))

        contentView.addSubview(titleLabel)

        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true

        contentView.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: project.bounds, cornerRadius: 12).cgPath
    }
    
    override func layoutSubviews() {
        contentView.layoutIfNeeded()
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: project.bounds, cornerRadius: 12).cgPath
    }
    
    public func setProject(proj : ProjectWork){
        project.project = proj
        titleLabel.text = project.projectName
        
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: project.bounds, cornerRadius: 12).cgPath
    }
    
    required init?(coder: NSCoder) {
        project = ProjectViewNew()
        super.init(coder: coder)
    }
}

class GalleryTitleCell : UICollectionViewCell{
    var title : UILabel
    
    override init(frame: CGRect) {
        title = UILabel()
        title.textAlignment = .justified
        super.init(frame : frame)
        contentView.addSubview(title)
    }
    
    required init?(coder: NSCoder) {
        title = UILabel()
        super.init(coder : coder)
    }
    
    func setTitle(title t : String){
        title.text = t
        title.textColor = getAppColor(color: .enable)
        title.font = UIFont(name: "Rubik-Bold", size: 42)
        title.frame = contentView.bounds
    }
}
