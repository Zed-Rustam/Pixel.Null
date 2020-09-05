//
//  ProjectImportController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 14.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectImportController: UIViewController {
    private var urls : [URL] = []
    weak var gallery : GalleryControl? = nil
    weak var palettes : PalleteCollection? = nil

    lazy private var titleLabel : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Import files", comment: "")
        label.font = UIFont.systemFont(ofSize: 24,weight: .black)
        label.textColor = getAppColor(color: .enable)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return label
    }()
    
    lazy private var importBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "import_icon"), for: .normal)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.addTarget(self, action: #selector(onImport), for: .touchUpInside)
        return btn
    }()
    
    @objc func onImport() {
        importFiles()
        gallery?.gallery.reloadData()
        palettes?.collection.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    lazy private var collection: ImportCollectionView = {
        let collect = ImportCollectionView(files: urls)
        collect.translatesAutoresizingMaskIntoConstraints = false
        
        return collect
    }()
    
    init(filesUrl : [URL]) {
        super.init(nibName: nil, bundle: nil)
        urls = filesUrl
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        view.setCorners(corners: 32)
        
        view.addSubview(titleLabel)
        view.addSubview(importBtn)
        view.addSubview(collection)

        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        
        importBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        importBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true

        collection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        collection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func importFiles() {
        for i in urls {
            print(urls)
            if i.lastPathComponent.hasSuffix(".png") || i.lastPathComponent.hasSuffix(".jpg") || i.lastPathComponent.hasSuffix(".PNG") || i.lastPathComponent.hasSuffix(".JPG") {
                var name = i.lastPathComponent
                name.removeLast(4)
                name += ".pnart"
                if i.startAccessingSecurityScopedResource() {
                    ProjectWork(projectName: name, image: UIImage(data: try! Data(contentsOf: i))!).save()
                    self.gallery!.projectAdded(name: name)
                    i.stopAccessingSecurityScopedResource()
                }
            } else if i.lastPathComponent.hasSuffix(".jpeg") || i.lastPathComponent.hasSuffix(".JPEG") {
                var name = i.lastPathComponent
                name.removeLast(5)
                name += ".pnart"
                if i.startAccessingSecurityScopedResource() {
                    ProjectWork(projectName: name, image: UIImage(data: try! Data(contentsOf: i))!).save()
                    self.gallery!.projectAdded(name: name)
                    i.stopAccessingSecurityScopedResource()
                }
            } else if i.lastPathComponent.hasSuffix(".pnart") {
                var name = i.lastPathComponent
                name.removeLast(6)
                let f = FileManager.default
                
                if i.startAccessingSecurityScopedResource() {
                    try! f.copyItem(at: i, to: ProjectWork.getDocumentsDirectoryWithFile().appendingPathComponent(i.lastPathComponent))

                    i.stopAccessingSecurityScopedResource()
                }
                
                self.gallery?.projectAdded(name: i.lastPathComponent)
                
            } else if i.lastPathComponent.hasSuffix(".pnpalette") {
                print("yes")
                var name = i.lastPathComponent
                name.removeLast(10)
                
                let pal = PalleteWorker(name: name, colors: PalleteWorker(fileUrl: i).colors,isSave: true)
                self.palettes?.palleteAdded(newPallete: pal)
            }
        }
    }
}
