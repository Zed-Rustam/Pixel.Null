//
//  FileCell.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 13.09.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {
    lazy private var previewBg: UIImageView = {
        let bg = UIImageView()
        
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.widthAnchor.constraint(equalToConstant: 72).isActive = true
        bg.heightAnchor.constraint(equalToConstant: 72).isActive = true

        bg.layer.magnificationFilter = .nearest
        
        bg.image = #imageLiteral(resourceName: "background")
        
        bg.setCorners(corners: 12, needMask: true, curveType: .continuous)
        
        bg.addSubviewFullSize(view: imagePreview)
        return bg
    }()
    
    lazy private var imagePreview: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.layer.magnificationFilter = .nearest
        img.contentMode = .scaleAspectFill
        
        return img
    }()
    
    lazy private var projectName: UILabel = {
        let title = UILabel()
        title.textColor = getAppColor(color: .enable)
        title.font = UIFont(name: UIFont.appBold, size: 20)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        title.adjustsFontSizeToFitWidth = true
        
        return title
    }()
    
    lazy private var fileInfo: UILabel = {
        let title = UILabel()
        title.textColor = getAppColor(color: .disable)
        title.font = UIFont(name: UIFont.appMedium, size: 12)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        return title
    }()
    
    lazy private var error: UILabel = {
        let title = UILabel()
        title.textColor = getAppColor(color: .red)
        title.font = UIFont(name: UIFont.appMedium, size: 12)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        return title
    }()
    
    private func setupViews() {
        contentView.addSubview(previewBg)
        previewBg.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        previewBg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        contentView.addSubview(projectName)
        projectName.leftAnchor.constraint(equalTo: previewBg.rightAnchor, constant: 6).isActive = true
        projectName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        projectName.topAnchor.constraint(equalTo: previewBg.topAnchor).isActive = true
        
        contentView.addSubview(fileInfo)
        fileInfo.leftAnchor.constraint(equalTo: previewBg.rightAnchor, constant: 6).isActive = true
        fileInfo.topAnchor.constraint(equalTo: projectName.bottomAnchor).isActive = true
        
        contentView.addSubview(error)
        error.leftAnchor.constraint(equalTo: previewBg.rightAnchor, constant: 6).isActive = true
        error.topAnchor.constraint(equalTo: fileInfo.bottomAnchor).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        backgroundColor = .clear
    }
    
    func setInfo(name: String, preview: UIImage?, type: String,error: String) {
        projectName.text = name
        imagePreview.image = preview
        fileInfo.text = type
        self.error.text = error
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
