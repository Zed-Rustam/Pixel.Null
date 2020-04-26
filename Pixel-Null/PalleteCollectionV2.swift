//
//  PalleteCollectionV2.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 25.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalleteCollectionV2 : UICollectionView {
    
    private var colors : [String]

    private var layout = PalleteCollectionLayout()
    
    private var selectedColor = 0
    
    private var isMoving = false
    private var moveCell : PalleteColorCell? = nil
    
    func setEnableMoving(enable : Bool) {
        if enable && gestureRecognizers == nil || !gestureRecognizers!.contains(moveGesture) {
            addGestureRecognizer(moveGesture)
        } else if !enable {
            removeGestureRecognizer(moveGesture)
        }
    }
    
    var moving : Bool {
        get{
            return isMoving
        }
    }
    
    var palleteColors : [String] {
        get{
            return colors
        }
    }
    
    var colorDelegate : (UIColor) -> () = {color in}
    
    lazy private var moveGesture : UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(sender:)))
        gesture.minimumPressDuration = 0.25
        
        return gesture
    }()

    init(colors clrs: [String]) {
        colors = clrs
        
        super.init(frame: .zero, collectionViewLayout: layout)
                
        register(PalleteColorCell.self, forCellWithReuseIdentifier: "Color")
        dataSource = self
        delegate = self
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = false
        
        addGestureRecognizer(moveGesture)
    }
    
    @objc func onLongPress(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let cell = indexPathForItem(at: sender.location(in: self)) {
                beginInteractiveMovementForItem(at: cell)
                moveCell = cellForItem(at: cell) as? PalleteColorCell
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.moveCell!.contentView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                })
                
                isMoving = true
            }
            
        case .changed:
            updateInteractiveMovementTargetPosition(sender.location(in: self))
            
        case .ended:
            performBatchUpdates({
                endInteractiveMovement()
            }, completion: {isEnd in
                UIView.animate(withDuration: 0.25, animations: {
                    self.moveCell!.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                },completion: {isEnd in
                    self.isMoving = false
                    self.moveCell = nil
                })
            })
            
        case .cancelled:
            performBatchUpdates({
                cancelInteractiveMovement()
            }, completion: {isEnd in
                UIView.animate(withDuration: 0.25, animations: {
                    self.moveCell!.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                },completion: {isEnd in
                    self.isMoving = false
                    self.moveCell = nil
                })
            })
 
            
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PalleteCollectionV2 : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isMoving && moveCell != nil{
            return moveCell!
        }
        
        let cell = dequeueReusableCell(withReuseIdentifier: "Color", for: indexPath) as! PalleteColorCell
        cell.color = UIColor(hex: colors[indexPath.item])!
        cell.setVisible(visible: selectedColor == indexPath.item ? true : false, withAnim: false)
        
        return cell
    }
}

extension PalleteCollectionV2 : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedColor != indexPath.item {
            let cell = cellForItem(at: IndexPath(item: selectedColor, section: 0)) as? PalleteColorCell
            cell?.setVisible(visible: false, withAnim: true)
            
            selectedColor = indexPath.item
            
            let cellnew = cellForItem(at: indexPath) as! PalleteColorCell
            cellnew.setVisible(visible: true, withAnim: true)
        }
        
        colorDelegate(UIColor(hex: colors[selectedColor])!)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        colors.insert(colors.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
        
        if sourceIndexPath.item == selectedColor {
            selectedColor = destinationIndexPath.item
        } else if selectedColor > sourceIndexPath.item && selectedColor <= destinationIndexPath.item {
            selectedColor -= 1
        } else if selectedColor < sourceIndexPath.item && selectedColor >= destinationIndexPath.item {
            selectedColor += 1
        }
    }
}

extension PalleteCollectionV2 : PalleteCollectionDelegate {
    
    func addColor(color : UIColor) {
        colors.insert(UIColor.toHex(color: color), at: selectedColor + 1)
        performBatchUpdates({
            insertItems(at: [IndexPath(item: selectedColor + 1, section: 0)])
        }, completion: nil)
    }
    
    func cloneSelectedColor() {
        colors.insert(colors[selectedColor], at: selectedColor + 1)
        performBatchUpdates({
            insertItems(at: [IndexPath(item: selectedColor + 1, section: 0)])
        }, completion: nil)
    }
    
    func deleteSelectedColor() {
        if colors.count > 1 {
            colors.remove(at: selectedColor)
            
            performBatchUpdates({
                deleteItems(at: [IndexPath(item: selectedColor, section: 0)])
                if self.selectedColor >= self.colors.count {
                    self.selectedColor = self.colors.count - 1
                }
            }, completion: {isEnd in
                (self.cellForItem(at: IndexPath(item: self.selectedColor, section: 0)) as! PalleteColorCell).setVisible(visible: true)
            })
        }
    }
    
    func changeSelectedColor(color: UIColor) {
        colors[selectedColor] = UIColor.toHex(color: color)
        performBatchUpdates({
            reloadItems(at: [IndexPath(item: selectedColor, section: 0)])
        }, completion: nil)
    }
    
    func getSelectItemColor() -> UIColor {
        return UIColor(hex: colors[selectedColor])!
    }
}

class PalleteCollectionLayout : UICollectionViewLayout {
    //size of item
    private var itemSize : CGFloat = 44
    
    var topOffset : CGFloat = 60
    var bottomOffset : CGFloat = 60

    //attributes of items
    private var attributes : [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    private var contentSize : CGSize = .zero
    
    init(itemSize size : CGFloat = 44, itemsSpacing : CGFloat = 4) {
        itemSize = size
        super.init()
    }
    
    override func prepare() {
        layout()
    }
    
    //calculate items attributes
    private func layout() {
        //clear all attributes
        attributes.removeAll()
        //count items of one row
        let rowCount = floor((collectionView!.bounds.width) / (itemSize))
        //offset for centerize items
        let offset = (collectionView!.bounds.width - itemSize * rowCount) / 2.0
        
        //set attributes
        for item in 0..<collectionView!.numberOfItems(inSection: 0) {
            let itemAttribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            let itemFrame : CGRect = CGRect(origin: CGPoint(x: offset + itemSize * CGFloat(item % Int(rowCount)),y: topOffset + (floor(CGFloat(item) / rowCount)) * itemSize),
                                            size: CGSize(width: itemSize, height: itemSize))
            
            itemAttribute.frame = itemFrame
            
            attributes.append(itemAttribute)
        }
        
        contentSize = CGSize(width: collectionView!.bounds.width,
                             height: topOffset + ceil(CGFloat(collectionView!.numberOfItems(inSection: 0)) / rowCount) * itemSize + bottomOffset)
    }
    
    //get visible attributes
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PalleteColorCell : UICollectionViewCell {
    //color setter and getter
    var color : UIColor {
        get{
            return colorView.subviews[0].backgroundColor!
        }
        set{
            colorView.subviews[0].backgroundColor = newValue
        }
    }
    //color view
    lazy private var colorView : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        mainView.isOpaque = true
        
        mainView.setCorners(corners: 12)
        mainView.backgroundColor = UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 0.25, orientation: .down))
        mainView.layer.magnificationFilter = .nearest
        
        mainView.tintColor = .clear
        
        let color = UIView()
        color.backgroundColor = .clear
        color.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(color)
        color.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        color.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        color.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        color.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        
        return mainView
    }()
    
    lazy private var selectStroke : UIView = {
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.backgroundColor = .clear
        mainview.setShadow(color: ProjectStyle.uiSelectColor, radius: 4, opasity: 0.25)
        
        mainview.widthAnchor.constraint(equalToConstant: 44).isActive = true
        mainview.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let stroke = UIView()
        stroke.layer.borderColor = ProjectStyle.uiSelectColor.cgColor
        stroke.layer.borderWidth = 3
        stroke.setCorners(corners: 18)
        stroke.translatesAutoresizingMaskIntoConstraints = false
        stroke.backgroundColor = .clear
        stroke.widthAnchor.constraint(equalToConstant: 44).isActive = true
        stroke.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        mainview.addSubview(stroke)
        stroke.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 0).isActive = true
        stroke.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true

        return mainview
    }()
    
    //show and hide select scroke
    func setVisible(visible : Bool, withAnim : Bool = true) {
        UIView.animate(withDuration: withAnim ? 0.25 : 0.0, animations: {
            self.selectStroke.alpha = visible ? 1 : 0
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        contentView.addSubview(selectStroke)
        
        colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        
        selectStroke.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        selectStroke.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        setVisible(visible: false, withAnim: false)
        
        contentView.setShadow(color: ProjectStyle.uiShadowColor, radius: 4, opasity: 0.5)
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//protocol for working with collection
protocol PalleteCollectionDelegate : class {
    func cloneSelectedColor()
    func addColor(color : UIColor)
    func deleteSelectedColor()
    func changeSelectedColor(color : UIColor)
    func getSelectItemColor() -> UIColor
}
