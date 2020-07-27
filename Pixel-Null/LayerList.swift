//
//  LayerList.swift
//  new Testing
//
//  Created by Рустам Хахук on 29.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit
import AudioToolbox

class LayerList : UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    private var tapgesture : UITapGestureRecognizer!
    weak var canvas : ProjectCanvas?
    weak var list : FrameList?
    weak var editor : Editor?

    var selectedCell : LayerCellNew? = nil
    
    func changeSelect(newSelect: LayerCellNew) {
        
        canvas?.transformView.needToSave = true
        editor?.finishTransform()
        
        selectedCell?.setSelect(isSelect: false, animate: true)
        
        let newCell = cellForItem(at: IndexPath(item: indexPath(for: newSelect)!.item, section: 0)) as! LayerCellNew
        newCell.setSelect(isSelect: true, animate: true)
        selectedCell = newCell
        
        project.LayerSelected = indexPath(for: newSelect)!.item
        canvas?.updateLayers()
    }
//
//    func changeVisible(item: LayerCellNew) {
//        let itemIndex = indexPath(for: item)!.item
//        canvas?.transformView.needToSave = true
//        editor?.finishTransform()
//
//        let reloadItem = self.cellForItem(at: IndexPath(item: itemIndex, section: 0)) as! LayerCellNew
//
//        reloadItem.setVisible(isVisible: !reloadItem.preview!.isVisible)
//
//        project.changeLayerVisible(layer: indexPath(for: reloadItem)!.item, isVisible: !project.layerVisible(layer: indexPath(for: reloadItem)!.item))
//
//        canvas?.updateLayers()
//        project.addAction(action: ["ToolID" : "\(Actions.layerVisibleChange.rawValue)", "frame" : "\(project.FrameSelected)", "layer" : "\(indexPath(for: reloadItem)!.item)"])
//
//        (list?.cellForItem(at: IndexPath(item: project.FrameSelected, section: 0)) as? FrameCell)?.preview?.image = canvas?.getPreview()
//        //list?.reloadData()
//    }
//
    func updatePositions() {
        
    }
    
    func updateFrame(){
        selectedCell?.setSelect(isSelect: false, animate: false)
        selectedCell = nil
        reloadData()
    }
    
    
    func setProject(proj : ProjectWork){
        project = proj
        reloadData()
    }
    
    private unowned var project : ProjectWork
    
    private var layout : ListLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        project.layerCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Layer", for: indexPath) as! LayerCellNew
        
        cell.setImage(img: nil)
        cell.setBackground(clr: UIColor(hex : project.information.bgColor)!)
        
        DispatchQueue.global(qos: .userInteractive).async {
            let img = self.project.getSmallLayer(frame : self.project.FrameSelected,layer: indexPath.item,size : CGSize(width: 36, height: 36)).flip(xFlip: self.project.isFlipX, yFlip: self.project.isFlipY)
            DispatchQueue.main.async {
                cell.setImage(img: img)
            }
        }
        
        cell.setVisible(visible: project.layerVisible(layer: indexPath.item))
        
        cell.setSelect(isSelect: (indexPath.item == project.LayerSelected) ? true : false, animate: false)
        if indexPath.item == project.LayerSelected {
            print("was selected cell")
            selectedCell = cell
        }
        return cell
    }
    
    init(frame : CGRect, proj : ProjectWork){
        project = proj
        layout = ListLayout()
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        tapgesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        
        register(LayerCellNew.self, forCellWithReuseIdentifier: "Layer")
        
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
                if item.item != project.LayerSelected {
                    changeSelect(newSelect: cellForItem(at: item) as! LayerCellNew)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class LayerCell : UICollectionViewCell, UIGestureRecognizerDelegate {
//    var preview : FramePreview?
//    private var select = false
//
//    func setVisible(visible : Bool){
//        preview!.setVisible(isVisible: visible, anim: false)
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
//    func setSelect(isSelect : Bool, animate : Bool){
//        select = isSelect
//        if select {
//            self.StrokeAnimate(duration: animate ? 0.25 : 0.0,width: 2)
//        } else {
//            self.StrokeAnimate(duration: animate ? 0.25 : 0.0,width: 0)
//        }
//    }
//
//    override init(frame: CGRect) {
//        preview = FramePreview(frame: CGRect(origin: .zero, size: frame.size), image: UIImage())
//        super.init(frame: frame)
//
//        layer.borderColor = getAppColor(color: .select).cgColor
//        layer.masksToBounds = false
//        layer.cornerRadius = 8
//
//        addSubview(preview!)
//
//    }
//
//    func setImage(img : UIImage){
//        preview?.image = img
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class LayerCellNew: UICollectionViewCell {
    private var select = false
    
    lazy private var preview : UIImageView = {
        let img = UIImageView()
        img.layer.magnificationFilter = .nearest
        img.contentMode = .scaleAspectFit
        
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        img.addSubviewFullSize(view: visibleView)
        return img
    }()
    
    lazy private var visibleView : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "unvisible_icon")
        img.tintColor = .white
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return img
    }()
    
    func setVisible(visible : Bool){
        visibleView.isHidden = visible
    }
    
    lazy private var previewBg : UIImageView = {
        let img = UIImageView()
        img.layer.magnificationFilter = .nearest
        img.contentMode = .scaleAspectFit
        img.image = #imageLiteral(resourceName: "background")
        
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        img.addSubviewFullSize(view: preview)
        
        img.setCorners(corners: 8, needMask: true, curveType: .continuous)
        return img
    }()
    
    lazy private var selectBg : UIView = {
       let view = UIView()
        view.setCorners(corners: 11)
        view.backgroundColor = getAppColor(color: .select)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 42).isActive = true
        view.heightAnchor.constraint(equalToConstant: 42).isActive = true
        return view
    }()
    
    func setSelect(isSelect : Bool, animate : Bool){
        select = isSelect
        UIView.animate(withDuration: animate ? 0.2 : 0, animations: {
            self.selectBg.transform = CGAffineTransform(scaleX: isSelect ? 1 : 0.75, y: isSelect ? 1 : 0.75)
        })
    }
    
    func setImage(img : UIImage?){
        preview.image = img
    }
    
    func setBackground(clr : UIColor) {
        preview.backgroundColor = clr
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectBg)
        selectBg.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        selectBg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(previewBg)
        previewBg.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        previewBg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 3, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 3, y: 3, width: 36, height: 36), cornerRadius: 8).cgPath
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ListLayout : UICollectionViewLayout {
    private var attributes : [UICollectionViewLayoutAttributes] = []
    private var contentWidth = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: Int(contentWidth), height: Int(collectionView!.bounds.height))
    }
    
    override func prepare() {
        attributes.removeAll()
        for item in 0..<collectionView!.numberOfItems(inSection: 0){
            let index = IndexPath(item: item, section: 0)
            let frame = CGRect(x: 8 + item * 42, y: 0, width: 42, height: 42)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = frame
            attributes.append(attribute)
        }
        contentWidth = 42 * collectionView!.numberOfItems(inSection: 0) + 8
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttributes : [UICollectionViewLayoutAttributes] = []
        for attribute in attributes{
            if attribute.frame.intersects(rect){
                visibleAttributes.append(attribute)
            }
        }
        return visibleAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.item]
    }
}

