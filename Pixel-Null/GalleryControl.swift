//
//  GalleryControl.swift
//  new Testing
//
//  Created by Рустам Хахук on 13.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GalleryControl : UIViewController{
    
    var projects : [Any] = []
   
    
    lazy var gallery : UICollectionView =  {
        
        let layout = GalleryLayout()
               layout.bottomOffset = 72 + Double(UIApplication.shared.windows[0].safeAreaInsets.bottom / 2) + 4
               switch UIDevice.current.userInterfaceIdiom {
               case .phone:
                   layout.setData(columnsCount: 3, delegate: self)
               case .pad:
                   layout.setData(columnsCount: 3, delegate: self)
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
    
    var createButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
        
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("Projects")
    }
    
    override func viewDidLoad() {
        
        createProject()
        
        let f = FileManager()
        do {
            let projs = try f.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil)
            
            for i in 0..<projs.count  {
                let name = projs[i].lastPathComponent
                projects.append(ProjectWork(fileName: name))
            }
            
        } catch {}
                
        projects.insert(NSLocalizedString("Gallery", comment: ""), at: 0)
    
        
        self.view.addSubview(gallery)
        
        
        
        createButton.delegate = {[weak self] in
            let dialog = CreateDialogController()
            dialog.delegate = self
            dialog.setDefault()
            
            
            switch UIDevice.current.userInterfaceIdiom {
                //если айфон, то просто показываем контроллер
            case .phone:
                dialog.modalPresentationStyle = .pageSheet
                self!.show(dialog, sender: self!)
                //если айпад то немного химичим
            case .pad:
                dialog.modalPresentationStyle = .popover
                
                if let popover = dialog.popoverPresentationController {
                    popover.sourceView = self!.createButton
                    popover.permittedArrowDirections = .any
                }
                self!.show(dialog, sender: self!)

            default:
                break
            }
        }
        
        view.addSubview(createButton)
        
        createButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        createButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        createButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21).isActive = true
               
        gallery.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        gallery.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        gallery.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        gallery.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")
    }
}

extension GalleryControl : UIPopoverPresentationControllerDelegate {
    
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
    func projectOpen(proj: ProjectWork) {
        //переделять что бы каждый раз не создавалось новое окно, а менялись данные в окне
        let ed = Editor()
        ed.setProject(proj: proj)
        ed.gallery = self
        ed.modalPresentationStyle = .currentContext
        ed.modalTransitionStyle = .coverVertical
        self.show(ed, sender: nil)
        
    }
        //var editor = Editor()
    
    func projectRename(view: ProjectView, newName: String) {
        
    }
    
    func projectDublicate(view: ProjectView) {
        var index : Int = 1
        
        let projs = try! FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil)
        
        ind : while true {
            for i in 0..<projs.count  {
                if projs[i].lastPathComponent == "\(view.projectName)(\(index))" {
                    index += 1
                    continue ind
                }
            }
            break
        }
        
        ProjectWork.clone(original: view.projectName, clone: "\(view.projectName)(\(index))")
        
        let proj = ProjectWork(fileName: "\(view.projectName)(\(index))")
        
        projects.append(proj)
        
        gallery.performBatchUpdates({
            gallery.insertItems(at: [IndexPath(item: projects.count - 1, section: 0)])
        },completion: nil)
    }
    
    func projectDelete(view: ProjectView, deletedName: String) {
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
               cell.project.superController = self
               return cell
           }
           return UICollectionViewCell()
       }
}

extension GalleryControl : UICollectionViewDelegate {
    
}

protocol GalleryProjectDelegate : class{
    func projectAdded(name : String)
}

protocol GalleryDelegate : class{
    func getItemHeight(indexItem : IndexPath) -> Double
    func getItemClass(indexItem : IndexPath) -> String
}

protocol ProjectActions : class{
    func projectRename(view : ProjectView, newName : String)
    func projectDublicate(view : ProjectView)
    func projectDelete(view : ProjectView, deletedName : String)
    func projectOpen(proj : ProjectWork)
}
