//
//  FrameList.swift
//  new Testing
//
//  Created by Рустам Хахук on 09.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FrameList : UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var tapgesture : UITapGestureRecognizer!
    weak var layers : LayerList? = nil
    weak var canvas : ProjectCanvas?
    var selectedCell : LayerCellNew? = nil
    weak var editor : Editor? = nil
    
    func changeSelect(newSelect: LayerCellNew) {
        let itemIndex = indexPath(for: newSelect)!.item
 
        canvas?.transformView.needToSave = false
        editor?.finishTransform()
        
        let itemNew = cellForItem(at: IndexPath(item: itemIndex, section: 0)) as! LayerCellNew
        
        selectedCell?.setSelect(isSelect: false, animate: true)
        
        let newCell = cellForItem(at: IndexPath(item: indexPath(for: itemNew)!.item, section: 0)) as! LayerCellNew
        newCell.setSelect(isSelect: true, animate: true)
        selectedCell = newCell
        
        project.savePreview(frame: project.FrameSelected)
        
        project.FrameSelected = indexPath(for: itemNew)!.item
        project.LayerSelected = 0
        
        layers?.updateFrame()
        canvas?.updateLayers()
    }
    
    func updatePositions() {
        
    }
    
    func setProject(proj : ProjectWork){
        project = proj
        reloadData()
    }
    
    private unowned var project : ProjectWork
    
    private var layout : ListLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        project.frameCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Frame", for: indexPath) as! LayerCellNew

        cell.setBackground(clr: UIColor(hex : project.information.bgColor)!)
        cell.setVisible(visible: true)
        
        DispatchQueue.global(qos: .userInteractive).async {
            let img = (indexPath.item == self.project.FrameSelected) ? self.project.getFrameFromLayers(frame : indexPath.item,size: CGSize(width: 36, height: 36)).flip(xFlip: self.project.isFlipX, yFlip: self.project.isFlipY) : self.project.getFrame(frame: indexPath.item, size: CGSize(width: 36, height: 36)).flip(xFlip: self.project.isFlipX, yFlip: self.project.isFlipY)
            //let img = self.project.getFrameFromLayers(frame : indexPath.item,size: CGSize(width: 36, height: 36))
            DispatchQueue.main.async {
                    cell.setImage(img: img)
            }
        }
        
        cell.setSelect(isSelect: (indexPath.item == project.FrameSelected) ? true : false, animate: false)
        if indexPath.item == project.FrameSelected {
            selectedCell = cell
        }
        return cell
    }
    
    init(frame : CGRect, proj : ProjectWork){
        project = proj
        layout = ListLayout()
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        tapgesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))

        register(LayerCellNew.self, forCellWithReuseIdentifier: "Frame")
        
        delegate = self
        dataSource = self
        isUserInteractionEnabled = true
        layer.masksToBounds = true
        backgroundColor = .clear
        self.isExclusiveTouch = false
        
        self.addGestureRecognizer(tapgesture)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    @objc func tap(sender : UITapGestureRecognizer){
        if sender.state == .ended {
            if let item = indexPathForItem(at: sender.location(in: sender.view)) {
                if item.item != project.FrameSelected {
                    changeSelect(newSelect: cellForItem(at: item) as! LayerCellNew)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
