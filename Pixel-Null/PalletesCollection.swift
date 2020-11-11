//
//  PalleteCollection.swift
//  new Testing
//
//  Created by Рустам Хахук on 15.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalleteCollection : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy private var mainTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = getAppColor(color: .enable)
        lbl.text = "Palettes"
        lbl.font = UIFont.systemFont(ofSize: 42, weight: .black)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return lbl
    }()
    
    lazy var collection : UICollectionView = {
        let col = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        col.register(PaletteGroup.self, forCellWithReuseIdentifier: "Pallete")
        col.register(PalettesSectionTitle.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Title")

        col.delegate = self
        col.dataSource = self
        col.backgroundColor = .clear
        
        col.translatesAutoresizingMaskIntoConstraints = false
        col.isUserInteractionEnabled = true
        
        col.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        return col
    }()
    private var palletes : [PalleteWorker] = []
    private var layout: UICollectionViewFlowLayout!
    
    lazy private var addButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: nil)
        
        btn.tintColor = getAppColor(color: .enable)
        
        btn.menu = UIMenu(title: "", image: nil, children: [
            UIAction(title: "New palette", image: UIImage(systemName: "doc"),handler: {_ in
                let create = PalleteCreateController()
                create.isModalInPresentation = true
                create.delegate = self
                self.present(create, animated: true, completion: nil)
            }),
            UIAction(title: "Import palette", image: UIImage(systemName: "arrow.down.doc"), handler: {_ in
                let dialog = UIDocumentBrowserViewController(forOpening: [.init(importedAs: "com.zed.null.palette")])
                
                
                dialog.modalPresentationStyle = .pageSheet
                dialog.delegate = self
                dialog.allowsDocumentCreation = false
                dialog.allowsPickingMultipleItems = true
                
                self.present(dialog, animated: true, completion: nil)
            })
        ])
        
        return btn
    }()
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return palletes.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Pallete", for: indexPath) as! PaletteGroup
            cell.setPalette(newPal: palletes[indexPath.item])
            cell.delegate = self
            cell.isSystem = false
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Pallete", for: indexPath) as! PaletteGroup
            cell.setPalette(newPal: PalleteWorker(name:"Default pallete", colors: try! JSONDecoder().decode(Pallete.self, from: NSDataAsset(name:"Default pallete")!.data).colors, isSave: false))
            cell.delegate = self
            cell.isSystem = true
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let title = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Title", for: indexPath) as! PalettesSectionTitle
        
        title.setText(text: indexPath.section == 0 ? "User's" : "System")
        return title
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.palleteOpen(item: palletes[indexPath.item])
    }
    
    override func viewDidLoad() {
        
        navigationItem.title = "Palettes"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = addButton
        
        let f = FileManager()
        do {
            let projs = try f.contentsOfDirectory(at: PalleteWorker.getDocumentsDirectory(), includingPropertiesForKeys: nil)
            
            for i in 0..<projs.count  {
                var name : String = projs[i].lastPathComponent
                if name.hasSuffix(".pnpalette") {
                    name.removeLast(10)
                    palletes.append(PalleteWorker(fileName: name))
                }
            }
        } catch {}
        
        layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let itemSize = Int((view.frame.size.width - 48) / 3)
        layout.itemSize = CGSize(width: itemSize, height: itemSize + 24)
        layout.headerReferenceSize = CGSize(width: view.frame.size.width - 24, height: 72)
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(collection)
        
        collection.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        collection.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        collection.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collection.layoutSubviews()
        collection.reloadData()
    }
}

extension PalleteCollection : PalleteGalleryDelegate {
       func palleteOpen(item: PalleteWorker) {
            let editor = PalleteEditor()
            editor.isModalInPresentation = true
            editor.pallete = item
            editor.delegate = {[unowned self] in
                self.collection.reloadData()
            }
        
            present(editor, animated: true, completion: nil)
        }
          
       func clonePallete(pallete : PalleteWorker) {
            var index : Int = 1
            
        let projs = try! FileManager.default.contentsOfDirectory(at: PalleteWorker.getDocumentsDirectory(), includingPropertiesForKeys: nil)
            
            ind : while true {
                for i in 0..<projs.count  {
                    print("\(projs[i].lastPathComponent)   \(pallete.palleteName)(\(index)).pnpalette")
                    if projs[i].lastPathComponent == "\(pallete.palleteName)(\(index)).pnpalette" {
                        index += 1
                        continue ind
                    }
                }
                break
            }
            
        PalleteWorker(name: "\(pallete.palleteName)(\(index))", colors: pallete.colors).save()
        
        let proj = PalleteWorker(fileName: "\(pallete.palleteName)(\(index))")
            
        palletes.append(proj)
        
        collection.performBatchUpdates({
            collection.insertItems(at: [IndexPath(item: palletes.count - 1, section: 0)])
        },completion: nil)
    }
          
       func deletePallete(pallete : PalleteWorker) {
            pallete.delete()
            
            for1 : for i in 0..<palletes.count {
                if palletes[i].palleteName == pallete.palleteName {
                    
                    self.palletes.remove(at: i)

                    self.collection.performBatchUpdates({
                        self.collection.deleteItems(at: [IndexPath(item: i, section: 0)])
                    },completion: nil)
                    
                    break for1
                }
            }
       }
        
       func palleteUpdate(item: Int) {
           collection.reloadData()
       }
    
    func palleteAdded(newPallete : PalleteWorker) {
        palletes.append(newPallete)
        collection.reloadData()
    }
    func palleteShare(pallete : PalleteWorker){
        present(UIActivityViewController(activityItems: [pallete.getURL()], applicationActivities: nil), animated: true, completion: nil)
    }
}

class PalleteCell : UICollectionViewCell {
   // var palleteView : ColorsPaletteNew!
    
    lazy var palleteView : ColorsPaletteNew = {
        let pallete = ColorsPaletteNew()
        
        return pallete
    }()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        contentView.addSubviewFullSize(view: palleteView)
        //contentView.isUserInteractionEnabled = true
    }
    
    func setPallete(pallete : PalleteWorker){
        palleteView.setPallete(newPallete: pallete, width: Int(contentView.frame.width))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PalleteCollection : UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        controller.dismiss(animated: true, completion: {
            let importMenu = ImportController(filesUrl: documentURLs)
            importMenu.palettes = self
            
            self.present(importMenu, animated: true, completion: nil)
        })
        print(documentURLs)
    }
}

protocol PalleteGalleryDelegate : class{
    func palleteOpen(item : PalleteWorker)
    func clonePallete(pallete : PalleteWorker)
    func deletePallete(pallete : PalleteWorker)
    func palleteUpdate(item : Int)
    func palleteAdded(newPallete : PalleteWorker)
    func palleteShare(pallete : PalleteWorker)
}
