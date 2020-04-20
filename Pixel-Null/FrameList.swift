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
    var selectedCell : FrameCell? = nil
    
    func changeSelect(newSelect: FrameCell) {
        selectedCell?.setSelect(isSelect: false, animate: true)
        
        let newCell = cellForItem(at: IndexPath(item: indexPath(for: newSelect)!.item, section: 0)) as! FrameCell
        newCell.setSelect(isSelect: true, animate: true)
        selectedCell = newCell
        
        project.savePreview(frame: project.FrameSelected)
        
        project.FrameSelected = indexPath(for: newSelect)!.item
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Frame", for: indexPath) as! FrameCell
        print("here 1")

        cell.preview?.bgColor = UIColor(hex : project.information.bgColor)!
        DispatchQueue.global(qos: .userInteractive).async {
            let img = (indexPath.item == self.project.FrameSelected) ? self.project.getFrameFromLayers(frame : indexPath.item,size: CGSize(width: 36, height: 36)) : self.project.getFrame(frame: indexPath.item, size: CGSize(width: 36, height: 36))
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

        register(FrameCell.self, forCellWithReuseIdentifier: "Frame")
        
        delegate = self
        dataSource = self
        isUserInteractionEnabled = true
        layer.masksToBounds = true
        backgroundColor = .clear
        self.isExclusiveTouch = false
        
        self.addGestureRecognizer(tapgesture)
    }
    
    @objc func tap(sender : UITapGestureRecognizer){
        if sender.state == .ended {
            if let item = indexPathForItem(at: sender.location(in: sender.view)) {
                if item.item != project.FrameSelected {
                    changeSelect(newSelect: cellForItem(at: item) as! FrameCell)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FrameCell : UICollectionViewCell, UIGestureRecognizerDelegate {
    var preview : FramePreview?
    private var select = false
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func setSelect(isSelect : Bool, animate : Bool){
           select = isSelect
           if select {
               self.StrokeAnimate(duration: animate ? 0.25 : 0,width: 2)
           } else {
               self.StrokeAnimate(duration: animate ? 0.25 : 0,width: 0)
           }
       }
    
    override init(frame: CGRect) {
        preview = FramePreview(frame: CGRect(origin: .zero, size: frame.size), image: UIImage())
        super.init(frame: frame)
        
        layer.borderColor = ProjectStyle.uiSelectColor.cgColor
        layer.masksToBounds = false
        layer.cornerRadius = 8
        
        addSubview(preview!)

    }
    
    func setImage(img : UIImage){
        preview?.image = img
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
