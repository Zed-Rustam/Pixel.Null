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
    
    lazy private var titleBg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = getAppColor(color: .background)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        
        view.addSubviewFullSize(view: titleLabel)
        view.addSubview(importBtn)
        
        importBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        importBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true

        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.addSubviewFullSize(view: view)
        return mainview
    }()
    
    lazy private var titleLabel : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Import files", comment: "")
        label.font = UIFont(name: "Rubik-Bold", size: 24)
        label.textColor = getAppColor(color: .enable)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy private var importBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "import_icon"), frame: .zero,icScale: 0.33)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.setShadowColor(color: .clear)
        
        btn.delegate = {[unowned self] in
            self.importFiles()
            
            self.gallery?.gallery.reloadData()
            
            self.dismiss(animated: true, completion: nil)
        }
        
        return btn
    }()
    
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
        
        view.addSubview(titleBg)
        view.addSubview(collection)

        titleBg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        titleBg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        titleBg.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        titleBg.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        collection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        collection.topAnchor.constraint(equalTo: titleBg.bottomAnchor, constant: 12).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        titleBg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
    }
    
    func importFiles() {
        for i in urls {
            if i.lastPathComponent.hasSuffix(".png") || i.lastPathComponent.hasSuffix(".jpg") {
                var name = i.lastPathComponent
                name.removeLast(4)
                name += ".pnart"
                if i.startAccessingSecurityScopedResource() {
                    ProjectWork(projectName: name, image: UIImage(data: try! Data(contentsOf: i))!)
                    self.gallery!.projectAdded(name: name)
                    i.stopAccessingSecurityScopedResource()
                }
            }
        }
    }
}
