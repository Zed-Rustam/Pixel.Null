//
//  PalleteCollection.swift
//  new Testing
//
//  Created by Рустам Хахук on 15.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalleteCollection : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GalleryDelegate {
    
    lazy private var collection : UICollectionView = {
        let col = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        col.register(PalleteCell.self, forCellWithReuseIdentifier: "Pallete")
        col.register(GalleryTitleCell.self, forCellWithReuseIdentifier: "Title")
        col.delegate = self
        col.dataSource = self
        col.backgroundColor = .clear
        col.contentInsetAdjustmentBehavior = .never
        col.translatesAutoresizingMaskIntoConstraints = false
        col.isUserInteractionEnabled = true
        //col.layer.shouldRasterize = true
        //col.layer.rasterizationScale = UIScreen.main.scale
        return col
    }()
    private var palletes : [Any] = []
    private var layout : GalleryLayout!
    
//    lazy private var addButton : CircleButton = {
//        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: .zero)
//        btn.delegate = {[weak self] in
//            let create = PalleteCreateController()
//            create.isModalInPresentation = true
//            create.delegate = self
//
//            self!.show(create, sender: self!)
//        }
//        btn.translatesAutoresizingMaskIntoConstraints = false
//
//
//        return btn
//    }()
    
    lazy private var addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        btn.imageView?.tintColor = getAppColor(color: .enable)
        
        btn.backgroundColor = getAppColor(color: .background)
        
        btn.setCorners(corners: 12)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        btn.addTarget(self, action: #selector(onAdd), for: .touchUpInside)
        return btn
    }()
    
    @objc func onAdd(){
        let create = PalleteCreateController()
        create.isModalInPresentation = true
        create.delegate = self
        show(create, sender: self)
    }
    
    func getItemHeight(indexItem: IndexPath) -> Double {
        if (palletes[indexItem.item] is PalleteWorker){
            return Double(Pallete.getKoef(count: (palletes[indexItem.item] as! PalleteWorker).colors.count))
        } else {
            return 0.0
        }
    }
    
    func getItemClass(indexItem: IndexPath) -> String {
        if (palletes[indexItem.item] is PalleteWorker){
            return "Project"
        } else {
            return "Title"
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return palletes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(palletes[indexPath.item] is String){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Title", for: indexPath) as! GalleryTitleCell
            cell.setTitle(title : palletes[indexPath.item] as! String)
            return cell
        } else if (palletes[indexPath.item] is PalleteWorker){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Pallete", for: indexPath) as! PalleteCell
            cell.setPallete(pallete: palletes[indexPath.item] as! PalleteWorker)
            cell.palleteView.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PalleteCell {
            cell.palleteView.delegate?.palleteOpen(item: palletes[indexPath.item] as! PalleteWorker)
        }
    }
    
    override func viewDidLoad() {
        palletes.append(NSLocalizedString("Palettes", comment: ""))
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
        
        palletes.append(NSLocalizedString("System", comment: ""))
        
        
        layout = GalleryLayout()
        layout.columnsCount = 3
        layout.bottomOffset = 72 + Double(UIApplication.shared.windows[0].safeAreaInsets.bottom / 2) + 4
        layout.delegate = self
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(collection)
        view.addSubview(addButton)
        
        collection.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        collection.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        collection.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        addButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collection.layoutSubviews()
        collection.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        addButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        addButton.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 36, height: 36), cornerRadius: 12).cgPath
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
           
           show(editor, sender: self)
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
            
        PalleteWorker.clone(original: "\(pallete.palleteName).pnpalette", clone: "\(pallete.palleteName)(\(index)).pnpalette")
        let proj = PalleteWorker(fileName: "\(pallete.palleteName)(\(index))")
            
        palletes.append(proj)
        
        collection.performBatchUpdates({
            collection.insertItems(at: [IndexPath(item: palletes.count - 1, section: 0)])
        },completion: nil)
    }
          
       func deletePallete(pallete : PalleteWorker) {
            pallete.delete()
            
            for1 : for i in 0..<palletes.count {
                if palletes[i] is PalleteWorker {
                    if (palletes[i] as! PalleteWorker).palleteName == pallete.palleteName {
                        
                        let cell = self.collection.cellForItem(at: IndexPath(item: i, section: 0)) as! PalleteCell
                        
                        self.palletes.remove(at: i)

                        UIView.animate(withDuration: 0.25, delay: 0, animations: {
                            cell.palleteView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                            cell.palleteView.alpha = 0
                        }, completion: {isEnd in
                            self.collection.performBatchUpdates({
                                self.collection.deleteItems(at: [IndexPath(item: i, section: 0)])
                            },completion: {isEnd in
                                cell.palleteView.transform = CGAffineTransform(scaleX: 1, y: 1)
                                cell.palleteView.alpha = 1
                            })
                            
                        })
                        break for1
                    }
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
        show(UIActivityViewController(activityItems: [pallete.getURL()], applicationActivities: nil), sender: self)
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

protocol PalleteGalleryDelegate : class{
    func palleteOpen(item : PalleteWorker)
    func clonePallete(pallete : PalleteWorker)
    func deletePallete(pallete : PalleteWorker)
    func palleteUpdate(item : Int)
    func palleteAdded(newPallete : PalleteWorker)
    func palleteShare(pallete : PalleteWorker)
}
