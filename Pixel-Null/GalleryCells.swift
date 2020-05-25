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
    }
    
    public func setProject(proj : ProjectWork){
        project.project = proj
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
        title.layer.masksToBounds = false
        title.textAlignment = .justified
        super.init(frame : frame)
        contentView.layer.masksToBounds = false
        contentView.addSubview(title)
    }
    
    required init?(coder: NSCoder) {
        title = UILabel()
        super.init(coder : coder)
    }
    
    func setTitle(title t : String){
        title.text = t
        title.textColor = getAppColor(color: .enable)
        title.font = UIFont(name: "Rubik-Bold", size: 48)
        title.frame = contentView.bounds
    }
}
