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
    
    private var newNames: [String] = []
    
    private var layout : UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .vertical
        
        return l
    }()
    
    init(files : [URL]) {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        urls = files
        
        register(ImportCollectionCell.self, forCellWithReuseIdentifier: "file")
        //delegate = self
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
        cell.delegate = self
        cell.setUrl(url: urls[indexPath.item])
        
        return cell
    }
}


extension ImportCollectionView: ImportDelegate {
    func setFileName(name: String) {
        newNames.append(name)
    }
    
    func isNameExist(name: String) -> Bool {
        let f = FileManager()
        var projects: [String] = []
        do {
            let projs = try f.contentsOfDirectory(at: GalleryControl.getDocumentsDirectory(), includingPropertiesForKeys: nil)
            
            for i in 0..<projs.count  {
                var name = projs[i].lastPathComponent
                
                if name.hasSuffix(".pnart") {
                    name.removeLast(6)
                    projects.append(name)
                }
            }
            
        } catch {}
        
        return projects.contains(name) || newNames.contains(name)
    }
}

class ImportCollectionCell : UICollectionViewCell {
    
    var delegate: ImportDelegate? = nil
    
    func makeImage(pallete: PalleteWorker) -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 16, height: 16))
        
        let img = renderer.image{context in
            for i in 0..<pallete.colors.count {
                UIColor(hex : pallete.colors[i])!.setFill()
                context.fill(CGRect(x: i % 16, y: i / 16, width: 1, height: 1))
            }
        }
        
        return img
    }
    
    func setUrl(url : URL) {
        fileName.text = url.lastPathComponent
        
        if url.lastPathComponent.hasSuffix(".pnart") {
            fileType.textColor = getAppColor(color: .enable)
            fileType.text = "Project"
            var name = url.lastPathComponent
            name.removeLast(6)
            
            if delegate!.isNameExist(name: name) {
                var index: Int = 1
                while(delegate!.isNameExist(name: "\(name)(\(index))")) {
                    index += 1
                }
                converttext.text = "will be renamed to \(name)(\(index))"
                delegate!.setFileName(name: "\(name)(\(index))")
            } else {
                converttext.text = ""
                delegate!.setFileName(name: name)
            }
            
            if url.startAccessingSecurityScopedResource() {
                fileImage.image = UIImage(data: try! Data(contentsOf: url.appendingPathComponent("preview-icon.png")))
                url.stopAccessingSecurityScopedResource()
            }
        } else if url.lastPathComponent.hasSuffix(".pnpalette") {
            fileType.textColor = getAppColor(color: .enable)
            fileType.text = "Palette"
            converttext.text = ""
            
            fileImage.image = makeImage(pallete: PalleteWorker(fileUrl: url))

        } else if url.lastPathComponent.hasSuffix(".gif") {
            fileType.textColor = getAppColor(color: .enable)
            fileType.text = "Gif"
            
            converttext.text = "will be converted to project"
            
            if url.startAccessingSecurityScopedResource() {
                fileImage.image = UIImage(data: try! Data(contentsOf: url))
                url.stopAccessingSecurityScopedResource()
            }
        } else if url.lastPathComponent.hasSuffix(".png") || url.lastPathComponent.hasSuffix(".jpeg") || url.lastPathComponent.hasSuffix(".jpg") || url.lastPathComponent.hasSuffix(".PNG") || url.lastPathComponent.hasSuffix(".JPEG") {
            var img = UIImage()
            
            if url.startAccessingSecurityScopedResource() {
                img = UIImage(data: try! Data(contentsOf: url))!
                url.stopAccessingSecurityScopedResource()
            }
            let isBig = img.size.width > 512 || img.size.height > 512
            
            imageBg.alpha = isBig ? 0.5 : 1
            
            fileName.textColor = isBig ? getAppColor(color: .disable) : getAppColor(color: .enable)
            
            fileType.textColor = isBig ? getAppColor(color: .disable) : getAppColor(color: .enable)
            fileType.text = "Image"
            
            converttext.text = isBig ? "will be ignored" : "will be converted to project"
            converttext.textColor = isBig ? getAppColor(color: .disable) : getAppColor(color: .enable)

            errortext.text = isBig ? "image size is so big(max 512x512)" : ""
            errortext.textColor = getAppColor(color: .red)
            
            fileImage.image = img
        } else {
            fileType.textColor = getAppColor(color: .disable)
            fileType.text = "Unknown file"
            converttext.text = "will be ignored"
        }
    }
    
    lazy private var imageBg : UIView = {
        let bg = UIView()
        bg.widthAnchor.constraint(equalToConstant: 72).isActive = true
        bg.backgroundColor = getAppColor(color: .disable)
        bg.setCorners(corners: 12,needMask: true)
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
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy private var fileType : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont.systemFont(ofSize: 16,weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy private var fileName : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont.systemFont(ofSize: 10,weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy private var converttext : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont.systemFont(ofSize: 10,weight: .bold)
        label.text = "will be convert to project"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy private var errortext : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.font = UIFont.systemFont(ofSize: 10,weight: .bold)
        //label.text = "will be convert to project"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageBg)
        contentView.addSubview(fileType)
        contentView.addSubview(fileName)
        contentView.addSubview(converttext)
        contentView.addSubview(errortext)
        
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
        
        converttext.leftAnchor.constraint(equalTo: imageBg.rightAnchor, constant: 6).isActive = true
        converttext.topAnchor.constraint(equalTo: fileName.bottomAnchor, constant: 3).isActive = true
        converttext.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        converttext.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        errortext.leftAnchor.constraint(equalTo: imageBg.rightAnchor, constant: 6).isActive = true
        errortext.topAnchor.constraint(equalTo: converttext.bottomAnchor, constant: 3).isActive = true
        errortext.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        errortext.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageBg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol ImportDelegate: class {
    func isNameExist(name: String) -> Bool
    func setFileName(name: String)
}
