//
//  ImportCollectionView.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 14.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ImportCollectionView : UICollectionView {
    private var urls : [URL] = []
    private var layout : UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .vertical
        
        return l
    }()
    
    init(files : [URL]) {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        urls = files
        
        register(ImportCollectionCell.self, forCellWithReuseIdentifier: "file")
        delegate = self
        dataSource = self
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = CGSize(width: self.frame.width, height: 72)
    }
}

extension ImportCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "file", for: indexPath) as! ImportCollectionCell
        cell.setUrl(url: urls[indexPath.item])
        
        return cell
    }
}

extension ImportCollectionView : UICollectionViewDelegate {
    
}

class ImportCollectionCell : UICollectionViewCell {
    func setUrl(url : URL) {
        fileName.text = url.lastPathComponent
        
        if url.lastPathComponent.hasSuffix(".pnart") {
            fileType.textColor = getAppColor(color: .enable)
            fileType.text = "Project"
        } else if url.lastPathComponent.hasSuffix(".pnpalette") {
            fileType.textColor = getAppColor(color: .enable)
            fileType.text = "Palette"
        } else if url.lastPathComponent.hasSuffix(".gif") {
            fileType.textColor = getAppColor(color: .enable)
            fileType.text = "Gif"
        } else if url.lastPathComponent.hasSuffix(".png") || url.lastPathComponent.hasSuffix(".jpeg") {
            fileType.textColor = getAppColor(color: .enable)
            fileType.text = "Image"
        } else {
            fileType.textColor = getAppColor(color: .disable)
            fileType.text = "Unknown file"
        }
    }
    
    lazy private var imageBg : UIView = {
        let bg = UIView()
        bg.widthAnchor.constraint(equalToConstant: 72).isActive = true
        bg.backgroundColor = getAppColor(color: .disable)
        bg.setCorners(corners: 8)
        bg.addSubviewFullSize(view: fileImage)
        
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.widthAnchor.constraint(equalToConstant: 72).isActive = true
        mainview.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        mainview.addSubviewFullSize(view: bg)
        
        return mainview
    }()
    
    lazy private var fileImage : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 72).isActive = true
        img.heightAnchor.constraint(equalToConstant: 72).isActive = true
        img.layer.magnificationFilter = .nearest
        img.image = #imageLiteral(resourceName: "background")
        
        return img
    }()
    
    lazy private var fileType : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont(name: "Rubik-Bold", size: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy private var fileName : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont(name: "Rubik-Medium", size: 12)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageBg)
        contentView.addSubview(fileType)
        contentView.addSubview(fileName)

        imageBg.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        imageBg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        fileType.leftAnchor.constraint(equalTo: imageBg.rightAnchor, constant: 6).isActive = true
        fileType.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        fileType.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        fileType.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        fileName.leftAnchor.constraint(equalTo: imageBg.rightAnchor, constant: 6).isActive = true
        fileName.topAnchor.constraint(equalTo: fileType.bottomAnchor, constant: 3).isActive = true
        fileName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        fileName.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageBg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
