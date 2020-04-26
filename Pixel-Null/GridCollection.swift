//
//  GridCollection.swift
//  new Testing
//
//  Created by Рустам Хахук on 16.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GridCollection : UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    var title = UILabel()
    private var layout : GridLayout!
    private var pallete : PalleteWorker!
    private var tapGesture : UITapGestureRecognizer!
    private var longPressGesture : UILongPressGestureRecognizer!
    private var moveIndex : IndexPath? = nil
    var select : Int = 0
    var isMove : Bool = false
    
    private var moveCell : Color? = nil
    private var moveIndexCell : ColorCell? = nil

    //weak var delegateEditor : PalleteEditorDelegate? = nil
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pallete.colors.count
    }
    
    func addViewInTop(view : UIView) {
        self.addSubview(view)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Color", for: indexPath) as! ColorCell
        cell.color.setColor(color: UIColor(hex : pallete.colorPallete.colors[indexPath.item])!)
        
        if select == indexPath.item {
            cell.color.setSelect(isSelect: true, anim: false)
        } else {
            cell.color.setSelect(isSelect: false, anim: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    init(frame : CGRect, pallete p : PalleteWorker){
        pallete = p
        layout = GridLayout()
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(ColorCell.self, forCellWithReuseIdentifier: "Color")
        delegate = self
        dataSource = self
        layer.masksToBounds = true
        backgroundColor = .clear
        
        isUserInteractionEnabled = true
        addSubview(title)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        addGestureRecognizer(tapGesture)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLong(sender:)))
        longPressGesture.minimumPressDuration = 0.25
        addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onTap(sender : UITapGestureRecognizer){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        if let item = indexPathForItem(at: sender.location(in: self)) {
            setNewSelect(newSelect: item.item)
        }
    }
    
    @objc func onLong(sender : UILongPressGestureRecognizer){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        switch sender.state {
        case .began:
            if let item = indexPathForItem(at: sender.location(in: self)) {
                beginInteractiveMovementForItem(at: item)
                isMove = true
                moveIndex = item
                let cell = cellForItem(at: item) as! ColorCell
                cell.color.alpha = 0
                
                moveIndexCell = cell
                
                moveCell = Color(frame: CGRect(x: 0, y: 0, width: 36, height: 36), color: UIColor(hex : pallete.colorPallete.colors[item.item])!)
                moveCell?.setSelect(isSelect: item.item == select, anim: false)
                moveCell?.center = cell.center
                
                moveCell?.setColor(color: UIColor(hex : pallete.colorPallete.colors[item.item])!)
                addSubview(moveCell!)
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.moveCell?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                })
            }
        case .changed:
            updateInteractiveMovementTargetPosition(sender.location(in: self))
            UIView.animate(withDuration: 0.2, animations: {
                self.moveCell?.center = sender.location(in: self)
            })
            
        case .ended:
            if moveIndex != nil {
                performBatchUpdates({
                    endInteractiveMovement()
                }, completion: {isEnd in
                    let cell = (self.cellForItem(at: self.moveIndex!) as? ColorCell)
                    cell?.color.alpha = 0
                    UIView.animate(withDuration: 0.2, animations: {
                        self.moveCell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.moveCell?.center = (self.cellForItem(at: self.moveIndex!) as! ColorCell).center
                    }, completion: {isEnd in
                        self.isMove = false
                        self.moveCell?.removeFromSuperview()
                        self.moveCell = nil
                        self.moveIndexCell?.color.alpha = 1
                        (self.cellForItem(at: self.moveIndex!) as! ColorCell).color.alpha = 1
                        
                    })
                })
            }
        default:
            break
        }
    }
    
    override func updateInteractiveMovementTargetPosition(_ targetPosition: CGPoint) {
        super.updateInteractiveMovementTargetPosition(targetPosition)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        
        if originalIndexPath.item != proposedIndexPath.item {
            moveIndex = proposedIndexPath
        }
        
        return proposedIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if sourceIndexPath.item  < select && destinationIndexPath.item >= select {
            select -= 1
        } else if sourceIndexPath.item  > select && destinationIndexPath.item <= select {
            select += 1
        } else if sourceIndexPath.item == select {
            select = destinationIndexPath.item
        }
    }
    
    func setNewSelect(newSelect : Int){
        let last = IndexPath(item: select, section: 0)
        let new = IndexPath(item: newSelect, section: 0)
        
        var cell = cellForItem(at: last) as? ColorCell
        cell?.color.setSelect(isSelect: false, anim: true)
        
        cell = cellForItem(at: new) as? ColorCell
        cell?.color.setSelect(isSelect: true, anim: true)
        
        select = newSelect
    }
}

class GridLayout : UICollectionViewLayout {
    private var attributes : [UICollectionViewLayoutAttributes] = []
    private var contentHeight = 0
    private var spacing : Int = 6
    private var offsetWidth : Int = 12
    private var offsetBottom : Int = 0
    private var offsetTop : Int = 64

    private var itemSize : Int = 36
    
    var contentWidth : Int {
        return Int(collectionView!.bounds.width)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        attributes.removeAll()
        
        var columnsCount = ((Int(collectionView!.bounds.width) - offsetWidth * 2) / (itemSize))
        print(columnsCount)
        
        spacing = ((Int(collectionView!.bounds.width) - offsetWidth * 2) - (itemSize * columnsCount)) / (columnsCount - 1)
        
        if spacing < 8 {
            columnsCount -= 1
            spacing = ((Int(collectionView!.bounds.width) - offsetWidth * 2) - (itemSize * columnsCount)) / (columnsCount - 1)
        }
        
        print("spacing : \(spacing)")
        
        attributes.removeAll()
        
        for item in 0..<collectionView!.numberOfItems(inSection: 0){
            let index = IndexPath(item: item, section: 0)
            let frame = CGRect(x: offsetWidth + (itemSize + spacing) * (item % columnsCount) - spacing / 2, y: offsetTop + (itemSize + spacing) * (item / columnsCount) - spacing / 2, width: itemSize + spacing, height: itemSize + spacing)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = frame
            attributes.append(attribute)
        }
        contentHeight = (collectionView!.numberOfItems(inSection: 0) / columnsCount) * (itemSize + spacing) + offsetTop  + (collectionView!.numberOfItems(inSection: 0) % columnsCount != 0 ? (itemSize + spacing) : 0) + offsetBottom + 48 + 12
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
    
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        return attributes[indexPath.item]
    }
}

class Color : UIView {
    private var bg : UIImageView!
    private var colorView : UIView!

    init(frame: CGRect, color : UIColor) {
        super.init(frame: frame)
        
        bg = UIImageView(frame: self.bounds)
        bg.image = ProjectStyle.bgImage!
        bg.contentMode = .scaleAspectFit
        bg.layer.magnificationFilter = .nearest
        
        colorView = UIView(frame: self.bounds)
        
        setCorners(corners: 8)
        
        addSubview(bg)
        addSubview(colorView)
    }
    
    func setSelect(isSelect : Bool, anim : Bool){
        let duration = anim ? 0.2 : 0
        if isSelect {
            UIView.animate(withDuration: duration, animations: {
                self.layer.cornerRadius = 18
            })
        } else {
            UIView.animate(withDuration: duration, animations: {
                self.layer.cornerRadius = 8
            })
        }
    }
    
    func setColor(color : UIColor){
        colorView.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColorCell : UICollectionViewCell {
    var color : Color!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        color = Color(frame: CGRect(x: (frame.width - 36) / 2, y: (frame.height - 36) / 2, width: 36, height: 36), color: UIColor.clear)
        
        contentView.addSubview(color)
        contentView.isUserInteractionEnabled = true
        
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
    
        contentView.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
