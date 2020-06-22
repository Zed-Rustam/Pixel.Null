//
//  PaletteCollectionModern.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 12.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PaletteCollectionModern : UICollectionView {
    var colors : [String]
    
    var palleteColors : [String] {
        get{
            return colors
        }
        set {
            colors = newValue
            reloadData()
        }
    }
    var moving : Bool = false
    
    private var layout = PalleteCollectionLayout(itemSize: 36, itemsSpacing: 0)
    
    private var selectedColor = 0

    init(colors clrs : [String]) {
        colors = clrs

        super.init(frame: .zero, collectionViewLayout:  layout)
        
        isPrefetchingEnabled = false

        register(PaletteCollectionCell.self, forCellWithReuseIdentifier: "Color")
        
        dataSource = self
        delegate = self
        
        backgroundColor = .clear
        
        dragDelegate = self
        dragInteractionEnabled = true
        allowsSelection = true
        isUserInteractionEnabled = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaletteCollectionModern : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "Color", for: indexPath) as! PaletteCollectionCell
        cell.setSelect(isSelect: indexPath.item == selectedColor, animate: false)
        cell.setColor(color: UIColor(hex: colors[indexPath.item])!)
        
        return cell
    }
}

extension PaletteCollectionModern : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? PaletteCollectionCell
        cell?.setSelect(isSelect: true, animate: true)
        selectedColor = indexPath.item
        self.bringSubviewToFront(cell!)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == selectedColor {
            self.bringSubviewToFront(cell)
        } else {
            self.sendSubviewToBack(cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? PaletteCollectionCell
        cell?.setSelect(isSelect: false, animate: true)
    }
}

extension PaletteCollectionModern : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        return [item]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let params = UIDragPreviewParameters()
        params.backgroundColor = .clear
        params.visiblePath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: cellForItem(at: indexPath)!.bounds.size), cornerRadius: 0)
        
        return params
    }
    
    
}

class PaletteCollectionCell : UICollectionViewCell {
    
    lazy private var bgColor : UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "background"))
        
        img.layer.magnificationFilter = .nearest
        
        img.addSubviewFullSize(view: colorView)
        
        return img
    }()
    
    lazy private var colorView : UIView = {
       let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviewFullSize(view: bgColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelect(isSelect : Bool, animate : Bool) {
        self.bgColor.layer.borderColor = getAppColor(color: .select).cgColor
        
        UIView.animate(withDuration: animate ? 0.2 : 0, animations: {
            self.bgColor.setCorners(corners: isSelect ? 9 : 0)
            self.bgColor.transform = CGAffineTransform(scaleX: isSelect ? 1.25 : 1, y: isSelect ? 1.25 : 1)
            self.bgColor.StrokeAnimate(duration: animate ? 0.2 : 0, width: isSelect ? 3 : 0)
            self.contentView.setShadow(color: .black, radius: 8, opasity: isSelect ? 0.2 : 0)
        })
    }
    
    func setColor(color : UIColor) {
        colorView.backgroundColor = color
    }
}

extension PaletteCollectionModern : PalleteCollectionDelegate {
    func cloneSelectedColor() {
        colors.insert(colors[selectedColor], at: selectedColor + 1)
        performBatchUpdates({
            insertItems(at: [IndexPath(item: selectedColor + 1, section: 0)])
        }, completion: nil)
    }
    
    func addColor(color: UIColor) {
        colors.insert(UIColor.toHex(color: color), at: selectedColor + 1)
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
                if isEnd {
                    (self.cellForItem(at: IndexPath(item: self.selectedColor, section: 0)) as! PaletteCollectionCell).setSelect(isSelect: true, animate: true)
                    self.selectItem(at: IndexPath(item: self.selectedColor, section: 0), animated: true, scrollPosition: .left)
                    self.bringSubviewToFront(self.cellForItem(at: IndexPath(item: self.selectedColor, section: 0))!)
                }
            })
        }
    }
    
    func changeSelectedColor(color: UIColor) {
        colors[selectedColor] = UIColor.toHex(color: color)
        performBatchUpdates({
            reloadItems(at: [IndexPath(item: selectedColor, section: 0)])
        }, completion: {isEnd in
            self.selectItem(at: IndexPath(item: self.selectedColor, section: 0), animated: false, scrollPosition: .left)
            self.bringSubviewToFront(self.cellForItem(at: IndexPath(item: self.selectedColor, section: 0))!)
        })
    }
    
    func getSelectItemColor() -> UIColor {
        return UIColor(hex: colors[selectedColor])!
    }
    
    
}
