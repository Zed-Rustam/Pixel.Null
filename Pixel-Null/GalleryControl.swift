//
//  GalleryControl.swift
//  new Testing
//
//  Created by Рустам Хахук on 13.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreGraphics

class GalleryControl : UIViewController{
        
    var projects : [Any] = []
    
    lazy private var createButtonNew : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12, needMask: false, curveType: .continuous)
        btn.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        btn.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 36, height: 36), cornerRadius: 12).cgPath
        
        btn.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))!, for: .normal)
        btn.tintColor = getAppColor(color: .enable)
        
        btn.menu = {
            let createAction = UIAction(title: "New Project", image: UIImage(systemName: "doc")) {_ in
                let create = CreateDialogNew()
                create.delegate = self
                self.show(create, sender: nil)
                
                
//                let dialog = CreateDialogController()
//                dialog.delegate = self
//                dialog.setDefault()
//
//                switch UIDevice.current.userInterfaceIdiom {
//                    //если айфон, то просто показываем контроллер
//                case .phone:
//                    dialog.modalPresentationStyle = .pageSheet
//                    self.show(dialog, sender: self)
//                    //если айпад то немного химичим
//                case .pad:
//                    dialog.modalPresentationStyle = .popover
//
//                    if let popover = dialog.popoverPresentationController {
//                        popover.sourceView = self.createButtonNew
//                        popover.delegate = self
//                        popover.permittedArrowDirections = .any
//                    }
//                    self.show(dialog, sender: self)
//
//                default:
//                    break
//                }
            }
            
            let importAction = UIAction(title: "Import Project", image: UIImage(systemName: "arrow.down.doc")) {_ in
                let dialog = UIDocumentBrowserViewController(forOpeningFilesWithContentTypes: ["com.zed.null.project",String(kUTTypePNG),String(kUTTypeJPEG),String(kUTTypeGIF)])
                
                dialog.modalPresentationStyle = .pageSheet
                dialog.delegate = self
                dialog.allowsDocumentCreation = false
                dialog.allowsPickingMultipleItems = true
                
                self.show(dialog, sender: self)
            }
            
            
            let menu = UIMenu(title: "", image: nil, identifier: .none, options: .displayInline, children: [createAction,importAction])
            return menu
        }()
        
        btn.showsMenuAsPrimaryAction = true
        
        return btn
    }()
    
    lazy var gallery : UICollectionView =  {
        
        let layout = GalleryLayout()
               layout.bottomOffset = 72 + Double(UIApplication.shared.windows[0].safeAreaInsets.bottom / 2) + 4
               switch UIDevice.current.userInterfaceIdiom {
               case .phone:
                   layout.setData(columnsCount: 3, delegate: self)
               case .pad:
                   layout.setData(columnsCount: 6, delegate: self)
               default:
                   break
               }
        
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(GalleryCell.self, forCellWithReuseIdentifier: "Cell")
        collection.register(GalleryTitleCell.self, forCellWithReuseIdentifier: "Title")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.contentInsetAdjustmentBehavior = .never
        return collection
    }()
    
    func updateProjectView(proj : ProjectWork){
        for i in 0..<projects.count {
            if projects[i] is ProjectWork && (projects[i] as! ProjectWork).projectName == proj.projectName {
                gallery.reloadItems(at: [IndexPath(item: i, section: 0)])
                break
            }
        }
    }
        //создание файла
    func createProject(){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("Projects")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {}
        }
    }
        
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("Projects")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        gallery.reloadData()
        //gallery.setShadow(color: getAppColor(color: .shadow), radius: 32, opasity: 1)
        createButtonNew.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        createButtonNew.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 36, height: 36), cornerRadius: 12).cgPath

    }
    
    override func viewDidLoad() {
                
        createProject()
        
        print(GalleryControl.getDocumentsDirectory())
        
        let f = FileManager()
        do {
            let projs = try f.contentsOfDirectory(at: GalleryControl.getDocumentsDirectory(), includingPropertiesForKeys: nil)
            
            for i in 0..<projs.count  {
                let name = projs[i].lastPathComponent
                if name.hasSuffix(".pnart") {
                    projects.append(ProjectWork(fileName: name))
                }
            }
            
        } catch {}
                
        projects.insert(NSLocalizedString("Gallery", comment: ""), at: 0)
    
        
        self.view.addSubview(gallery)
        
        view.addSubview(createButtonNew)

        createButtonNew.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        createButtonNew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        gallery.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        gallery.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        gallery.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        gallery.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        self.view.backgroundColor = getAppColor(color: .background)
        //gallery.setShadow(color: getAppColor(color: .shadow), radius: 32, opasity: 1)
    }
}

extension GalleryControl : GalleryDelegate {
    func getItemClass(indexItem: IndexPath) -> String {
        if(projects[indexItem.item] is String){
            return "Title"
        } else if (projects[indexItem.item] is ProjectWork){
            return "Project"
        }
        return ""
     }
     
    func getItemHeight(indexItem: IndexPath) -> Double {
        if (projects[indexItem.item] is ProjectWork){
            var k = Double((projects[indexItem.item] as! ProjectWork).projectSize.height) / Double((projects[indexItem.item] as! ProjectWork).projectSize.width)
            if k > 1.5 {k = 1.5}
            if k < 0.75 {k = 0.75}
            return k
        } else {
            return 0.0
        }
    }
}

extension GalleryControl : GalleryProjectDelegate {
    func projectAdded(name: String) {
        let proj = ProjectWork(fileName: name)
        
        projects.append(proj)
        
        gallery.performBatchUpdates({
            gallery.insertItems(at: [IndexPath(item: projects.count - 1, section: 0)])
        },completion: nil)
    }
}

extension GalleryControl : ProjectActions {
    
    func projectExport(proj: ProjectWork) {
        let exp = ProjectExportController()
        exp.modalPresentationStyle = .formSheet
        exp.project = proj
        show(exp, sender: self)
    }
    
    func projectOpen(proj: ProjectWork) {
        let ed = Editor()
        ed.setProject(proj: proj)
        ed.gallery = self
        ed.modalPresentationStyle = .currentContext
        ed.modalTransitionStyle = .coverVertical
        show(ed, sender: self)
    }
    
    func projectDublicate(view: ProjectViewNew) {
        var index : Int = 1
        
        let projs = try! FileManager.default.contentsOfDirectory(at: GalleryControl.getDocumentsDirectory(), includingPropertiesForKeys: nil)
        
        ind : while true {
            for i in 0..<projs.count  {
                print("\(projs[i].lastPathComponent)   \(view.projectName)(\(index)).pnart")
                if projs[i].lastPathComponent == "\(view.projectName)(\(index)).pnart" {
                    index += 1
                    continue ind
                }
            }
            break
        }
        
        ProjectWork.clone(original: "\(view.projectName).pnart", clone: "\(view.projectName)(\(index)).pnart")
        
        let proj = ProjectWork(fileName: "\(view.projectName)(\(index)).pnart")
        
        projects.append(proj)
        
        gallery.performBatchUpdates({
            gallery.insertItems(at: [IndexPath(item: projects.count - 1, section: 0)])
        },completion: nil)
    }
    
    func projectDelete(view: ProjectViewNew, deletedName: String) {
        ProjectWork.deleteFile(fileName: deletedName)
        
        for1 : for i in 0..<projects.count {
            if projects[i] is ProjectWork {
                if (projects[i] as! ProjectWork).projectName == deletedName {
                    
                    let cell = self.gallery.cellForItem(at: IndexPath(item: i, section: 0)) as! GalleryCell
                    
                    self.projects.remove(at: i)

                    UIView.animate(withDuration: 0.25, delay: 0, animations: {
                        cell.project.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        cell.project.alpha = 0
                    }, completion: {isEnd in
                        self.gallery.performBatchUpdates({
                            self.gallery.deleteItems(at: [IndexPath(item: i, section: 0)])
                        },completion: {isEnd in
                            cell.project.transform = CGAffineTransform(scaleX: 1, y: 1)
                            cell.project.alpha = 1
                        })
                    })
                    
                    break for1
                }
            }
        }
    }
    
}

extension GalleryControl : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           projects.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if(projects[indexPath.item] is String){
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Title", for: indexPath) as! GalleryTitleCell
               cell.setTitle(title : projects[indexPath.item] as! String)
               return cell
           } else if (projects[indexPath.item] is ProjectWork){
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GalleryCell
               cell.setProject(proj: projects[indexPath.item] as! ProjectWork)
               cell.project.delegate = self
               return cell
           }
           return UICollectionViewCell()
       }
}

extension GalleryControl : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if projects[indexPath.item] is ProjectWork {
            self.projectOpen(proj: projects[indexPath.item] as! ProjectWork)
        }
    }
}

extension GalleryControl : UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        controller.dismiss(animated: true, completion: {
            let importMenu = ProjectImportController(filesUrl: documentURLs)
            importMenu.gallery = self
            self.show(importMenu, sender: nil)
        })
        print(documentURLs)
    }
}

extension GalleryControl : UIPopoverPresentationControllerDelegate {
    
}

protocol GalleryProjectDelegate : class{
    func projectAdded(name : String)
}

protocol GalleryDelegate : class{
    func getItemHeight(indexItem : IndexPath) -> Double
    func getItemClass(indexItem : IndexPath) -> String
}

protocol ProjectActions : class{
    func projectDublicate(view : ProjectViewNew)
    func projectDelete(view : ProjectViewNew, deletedName : String)
    func projectOpen(proj : ProjectWork)
    func projectExport(proj : ProjectWork)
}
