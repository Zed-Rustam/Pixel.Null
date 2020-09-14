//
//  ImprtController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 13.09.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ImportController: UIViewController {
    
    weak var gallery: GalleryProjectDelegate? = nil
    
    weak var palettes: PalleteGalleryDelegate? = nil
    
    lazy private var importTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Import"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = getAppColor(color: .enable)
        
        lbl.font = UIFont.systemFont(ofSize: 32, weight: .black)
        lbl.heightAnchor.constraint(equalToConstant: 42).isActive = true
        return lbl
    }()

    lazy private var importBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true

        btn.setImage(#imageLiteral(resourceName: "import_icon"), for: .normal)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        btn.addTarget(self, action: #selector(onImport), for: .touchUpInside)
        return btn
    }()
    
    lazy private var filesTable: UITableView = {
        let tbl = UITableView(frame: .zero, style: .plain)
        tbl.rowHeight = 84
        tbl.register(FileCell.self, forCellReuseIdentifier: "file")
        tbl.dataSource = self
        
        tbl.contentInset.top = 24
        tbl.separatorStyle = .none
        tbl.backgroundColor = .clear
        tbl.allowsSelection = false
        
        tbl.translatesAutoresizingMaskIntoConstraints = false
        return tbl
    }()
        
    private var importedFiles: [ProjectFile] = []
        
    private var projects: [(String, Int)] {
        get{
            var array: [(String,Int)] = []
            
            for i in importedFiles {
                if i.name != nil {
                    array.append((i.name!, i.type == "Palettes" ? 1 : 0))
                }
            }
            
            do {
                let projs = try FileManager.default.contentsOfDirectory(at: GalleryControl.getDocumentsDirectory(), includingPropertiesForKeys: nil)
                for i in 0..<projs.count  {
                    let name = projs[i].lastPathComponent
                    if name.hasSuffix(".pnart") {
                        var realName = name
                        realName.removeLast(6)
                        array.append((realName, 0))
                    }
                }
            } catch {}
            
            do {
                let palettes = try FileManager.default.contentsOfDirectory(at: PalleteWorker.getDocumentsDirectory(), includingPropertiesForKeys: nil)
                for i in 0..<palettes.count  {
                    let name = palettes[i].lastPathComponent
                    if name.hasSuffix(".pnpalette") {
                        var realName = name
                        realName.removeLast(10)
                        array.append((realName, 1))
                    }
                }
            } catch {}
            
            return array
        }
    }
        
    @objc func onImport() {
        for i in 0..<importedFiles.count {
            importFile(index: i)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func renameFiles() {
        for i in 0..<importedFiles.count {
            let name = getFileName(file: importedFiles[i].url)
            importedFiles[i].name = getNewName(name: name, type: importedFiles[i].type == "Palette" ? 1 : 0)
        }
    }
    
    private func checkErrors() {
        for i in 0..<importedFiles.count {
            let img = getFilePreview(file: importedFiles[i].url)!
            
            if getFileType(file: importedFiles[i].url) == "Unknown" {
                importedFiles[i].error = "unknown file format"
            } else if img.size.width > 512 || img.size.height > 512 {
                importedFiles[i].error = "file is very big (max 512x512)"
            }
            
        }
    }
    
    private func getFileType(file: URL) -> String {
        let fullFile = file.lastPathComponent
        
        if fullFile.hasSuffix(".pnart") {
            return "Project"
        } else if fullFile.hasSuffix(".png") || fullFile.hasSuffix(".PNG") || fullFile.hasSuffix(".jpg") || fullFile.hasSuffix(".JPG") ||
                    fullFile.hasSuffix(".jpeg") || fullFile.hasSuffix(".JPEG") {
            return "Image"
        } else if fullFile.hasSuffix(".gif") || fullFile.hasSuffix(".GIF") {
            return "Gif"
        } else if fullFile.hasSuffix(".pnpalette") {
            return "Palette"
        }
        
        return "Unknown"
    }
    
    private func getFilePreview(file: URL) -> UIImage? {
        let fullFile = file.lastPathComponent

        if fullFile.hasSuffix(".pnart") {
            if file.startAccessingSecurityScopedResource() {
                let img =  UIImage(data: try! Data(contentsOf: file.appendingPathComponent("preview-icon.png")))!
                file.stopAccessingSecurityScopedResource()
                
                return img
            }
        } else if fullFile.hasSuffix(".pnpalette") {
            
            var palette: PalleteWorker? = nil

            if file.startAccessingSecurityScopedResource() {
                palette = PalleteWorker(fileUrl: file)
                file.stopAccessingSecurityScopedResource()
            }
            
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 16, height: 16))
            
            let img = renderer.image{context in
                for i in 0..<palette!.colors.count {
                    UIColor(hex : palette!.colors[i])!.setFill()
                    context.fill(CGRect(x: i % 16, y: i / 16, width: 1, height: 1))
                }
            }
            
            return img
        } else {
            if file.startAccessingSecurityScopedResource() {
                let img = UIImage(data: try! Data(contentsOf: file))!
                file.stopAccessingSecurityScopedResource()

                return img
            }
        }
        
        return nil
    }
    
    private func getFileName(file: URL) -> String {
        let fullFile = file.lastPathComponent
        
        if fullFile.hasSuffix(".pnart") {
            var name = fullFile
            name.removeLast(6)
            
            return name
        } else if fullFile.hasSuffix(".png") || fullFile.hasSuffix(".PNG") || fullFile.hasSuffix(".jpg") || fullFile.hasSuffix(".JPG") || fullFile.hasSuffix(".gif") || fullFile.hasSuffix(".GIF")  {
            var name = fullFile
            name.removeLast(4)
            
            return name
        } else if fullFile.hasSuffix(".jpeg") || fullFile.hasSuffix(".JPEG") {
            var name = fullFile
            name.removeLast(5)
            
            return name
        } else if fullFile.hasSuffix(".pnpalette") {
            var name = fullFile
            name.removeLast(10)
            
            return name
        }
        
        return ""
    }
    
    private func getNewName(name: String,type: Int) -> String {
        
        if !projects.contains(where: {proj in
            proj == (name, type)
        }) {
            return name
        }
        
        for i in 1... {
            if !projects.contains(where: {proj in
                proj == ("\(name)(\(i))",type)
            }) {
                return "\(name)(\(i))"
            }
        }
        
        return ""
    }
    
    private func importFile(index: Int) {
        let name = importedFiles[index].url.lastPathComponent
        
        if importedFiles[index].error != "" {
            if name.hasSuffix(".pnart") {
                if importedFiles[index].url.startAccessingSecurityScopedResource() {
                    try! FileManager.default.copyItem(at: importedFiles[index].url, to: GalleryControl.getDocumentsDirectory().appendingPathComponent("\(importedFiles[index].name!).pnart"))
                    
                    gallery?.projectAdded(name: "\(importedFiles[index].name!).pnart")
                    
                    importedFiles[index].url.stopAccessingSecurityScopedResource()
                }
            } else if name.hasSuffix(".png") || name.hasSuffix(".PNG") || name.hasSuffix(".jpg") || name.hasSuffix(".JPG") ||
                        name.hasSuffix(".jpeg") || name.hasSuffix(".JPEG") {
                if importedFiles[index].url.startAccessingSecurityScopedResource() {
                    
                    ProjectWork(projectName: "\(importedFiles[index].name!).pnart", image: getFilePreview(file: importedFiles[index].url)!).save()
                    gallery?.projectAdded(name: "\(importedFiles[index].name!).pnart")
                    
                    importedFiles[index].url.stopAccessingSecurityScopedResource()
                }
            } else if name.hasSuffix(".gif") || name.hasSuffix(".GIF") {
                if importedFiles[index].url.startAccessingSecurityScopedResource() {
                    
                    ProjectWork(projectName: "\(importedFiles[index].name!).pnart", gif: try! Data(contentsOf: importedFiles[index].url)).save()
                    gallery?.projectAdded(name: "\(importedFiles[index].name!).pnart")
                    
                    importedFiles[index].url.stopAccessingSecurityScopedResource()
                }
            } else if name.hasSuffix(".pnpalette") {
                if importedFiles[index].url.startAccessingSecurityScopedResource() {
                    
                    try! FileManager.default.copyItem(at: importedFiles[index].url, to: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(importedFiles[index].name!).pnpalette"))
                    
                    palettes?.palleteAdded(newPallete: PalleteWorker(fileUrl: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(importedFiles[index].name!).pnpalette")))
                    
                    importedFiles[index].url.stopAccessingSecurityScopedResource()
                }
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(importTitle)
        view.setCorners(corners: 32)
        
        importTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        importTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        
        view.addSubview(filesTable)
        
        filesTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        filesTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        filesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        filesTable.topAnchor.constraint(equalTo: importTitle.bottomAnchor,constant: 12).isActive = true
        
        view.addSubview(importBtn)
        
        importBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        importBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
    }
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        
        setupViews()
    }
    
    init(filesUrl : [URL]) {
        super.init(nibName: nil, bundle: nil)
        for i in filesUrl {
            importedFiles.append(ProjectFile(url: i, type: getFileType(file: i), isImport: true))
        }
        renameFiles()
        checkErrors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ImportController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importedFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "file") as! FileCell
        
        cell.setInfo(name: importedFiles[indexPath.item].name!, preview: getFilePreview(file: importedFiles[indexPath.item].url), type: importedFiles[indexPath.item].type,error: importedFiles[indexPath.item].error)
        
        return cell
    }
}


struct ProjectFile {
    var url: URL
    var name: String? = nil
    var type: String
    var isImport: Bool
    var error: String = ""
}
