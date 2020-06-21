//
//  LayerstableCell.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 16.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayersTableCell : UICollectionViewCell {
    
    private var isUpdateImageMode : Bool = false
    
    lazy private var background : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = getAppColor(color: .background)
        
        view.addSubview(previewBackground)
        previewBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        previewBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
        view.setCorners(corners: 6)
        
        view.addSubview(layerName)
        layerName.leftAnchor.constraint(equalTo: previewBackground.rightAnchor, constant: 6).isActive = true
        layerName.topAnchor.constraint(equalTo: previewBackground.topAnchor, constant: 0).isActive = true
        return view
    }()
    
    lazy private var previewBackground : UIView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 36).isActive = true
        view.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addSubviewFullSize(view: previewImageBack)
        return view
    }()
    
    lazy private var previewImage : UIImageView = {
        let image = UIImageView()
        image.layer.magnificationFilter = .nearest
        image.setCorners(corners: 6)
        
        image.addSubviewFullSize(view: unvisibleImage)
        return image
    }()
    
    lazy private var unvisibleImage : UIImageView = {
        let image = UIImageView()
        image.setCorners(corners: 6)
        image.image = #imageLiteral(resourceName: "unvisible_icon").withRenderingMode(.alwaysOriginal)
        image.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return image
    }()
    
    lazy private var previewImageBack : UIImageView = {
        let image = UIImageView()
        image.layer.magnificationFilter = .nearest
        image.image = #imageLiteral(resourceName: "background")
        image.setCorners(corners: 6)
        
        image.addSubviewFullSize(view: previewImage)
        
        return image
    }()
    
    lazy private var layerName : UILabel = {
        let label = UILabel()
        label.text = "New layer"
        label.font = UIFont(name: "Rubik-Medium", size: 16)
        label.textColor = getAppColor(color: .enable)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviewFullSize(view: background)
    }
        
    func setSelected(isSelect : Bool, anim : Bool) {
        self.layerName.textColor = isSelect ? getAppColor(color: .select) : getAppColor(color: .enable)
    }
    
    func setPreview(image : UIImage) {
        previewImage.image = image
    }
    
    func setBgColor(color : UIColor) {
        previewImage.backgroundColor = color
    }
    
    func setVisible(isVisible : Bool, animate : Bool) {
        UIView.animate(withDuration: animate ? 0.2 : 0, animations: {
            self.unvisibleImage.alpha = isVisible ? 0 : 1
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
