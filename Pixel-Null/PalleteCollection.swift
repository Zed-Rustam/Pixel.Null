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
        
        return col
    }()
    private var palletes : [Any] = []
    private var layout : GalleryLayout!
    
    lazy private var addButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "add_icon"), frame: .zero)
        btn.delegate = {[weak self] in
            let create = PalleteCreateController()
            create.isModalInPresentation = true
            create.delegate = self
            
            self!.show(create, sender: self!)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        
        return btn
    }()
    
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
    
    override func viewDidLoad() {
        palletes.append(NSLocalizedString("Palettes", comment: ""))
        let f = FileManager()
        do {
            let projs = try f.contentsOfDirectory(at: PalleteWorker.getDocumentsDirectory(), includingPropertiesForKeys: nil)
            
            for i in 0..<projs.count  {
                var name : String = projs[i].lastPathComponent
                name.removeLast(8)
                palletes.append(PalleteWorker(fileName: name))
            }
        } catch {}
        
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
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21).isActive = true
    }
}

extension PalleteCollection : PalleteGalleryDelegate {
       func palleteOpen(item: ColorPallete) {
            let editor = PalleteEditor()
            editor.isModalInPresentation = true
            editor.pallete = item.pallete
            editor.delegate = {[unowned self] in
                self.collection.reloadData()
            }
           
           show(editor, sender: self)
       }
          
       func clonePallete(pallete : PalleteWorker) {
              
       }
          
       func deletePallete(pallete : PalleteWorker) {
            pallete.delete()
            
            for1 : for i in 0..<palletes.count {
                if palletes[i] is PalleteWorker {
                    if (palletes[i] as! PalleteWorker).palleteName == pallete.palleteName {
                        
                        let cell = self.collection.cellForItem(at: IndexPath(item: i, section: 0)) as! PalleteCell
                        
                        self.palletes.remove(at: i)

                        UIView.animate(withDuration: 0.25, delay: 1, animations: {
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
    var palleteView : ColorPallete!
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    override func layoutSubviews() {
        contentView.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 0.5)
    }
    
    func setPallete(pallete : PalleteWorker){
        palleteView?.removeFromSuperview()
        
        palleteView = ColorPallete(width: self.frame.width, pallete: pallete)
        contentView.addSubview(palleteView)
        contentView.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PalleteGalleryDelegate : class{
    func palleteOpen(item : ColorPallete)
    func clonePallete(pallete : PalleteWorker)
    func deletePallete(pallete : PalleteWorker)
    func palleteUpdate(item : Int)
    func palleteAdded(newPallete : PalleteWorker)
    func palleteShare(pallete : PalleteWorker)
}
