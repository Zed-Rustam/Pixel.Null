//
//  GalleryCell.swift
//  new Testing
//
//  Created by Рустам Хахук on 07.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GalleryCell : UICollectionViewCell {
    var project : ProjectView
 
    override init(frame: CGRect) {
        project = ProjectView()
        super.init(frame: frame)
        project.frame = bounds
        
        contentView.frame = frame
        contentView.addSubview(project)
        contentView.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 0.5, offset: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 0.5)
    }
    
    public func setProject(proj : ProjectWork){
        project.setData(proj: proj,width: Double(self.frame.width))
        contentView.layer.rasterizationScale = UIScreen.main.scale
        contentView.layer.shouldRasterize = true
    }
    
    required init?(coder: NSCoder) {
        project = ProjectView()
        super.init(coder: coder)
    }
}

class GalleryTitleCell : UICollectionViewCell{
    var title : UILabel
    
    override init(frame: CGRect) {
        title = UILabel()
        super.init(frame : frame)
        contentView.addSubview(title)
    }
    
    required init?(coder: NSCoder) {
        title = UILabel()
        super.init(coder : coder)
    }
    
    func setTitle(title t : String){
        title.text = t
        title.textColor = UIColor(named: "enableColor")
        title.font = UIFont(name: "Rubik-Bold", size: 48)
        title.frame = contentView.bounds
    }
}
