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
 
    override init(frame: CGRect) {
        project = ProjectViewNew()
        super.init(frame: frame)
        
        contentView.addSubviewFullSize(view: project)
        contentView.isOpaque = true
        
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: project.bounds, cornerRadius: 16).cgPath
    }
    
    public func setProject(proj : ProjectWork){
        project.project = proj
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: project.bounds, cornerRadius: 16).cgPath
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
