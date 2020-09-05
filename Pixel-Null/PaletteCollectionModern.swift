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
    
    var replaceColorsDelegate: () -> () = {}
    
    var palleteColors : [String] {
        get {
            return colors
        }
        set {
            colors = newValue
            selectedColor = 0
            reloadData()
        }
    }
    
    lazy private var moveGesture: UILongPressGestureRecognizer = {
        let gest = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(sender:)))
        gest.minimumPressDuration = 0.35
        
        
        return gest
    }()
    
    func disableDragAndDrop(){
        removeGestureRecognizer(moveGesture)
    }
    
    private var moveCell : PaletteCollectionCell? = nil

    var moving : Bool = false
    private var isFinish : Bool = false
    
    private var layout = PalleteCollectionLayout(itemSize: 28, itemsSpacing: 0)
    
    var colorDelegate : (UIColor) -> () = {color in}
    
    private var selectedColor = 0

    init(colors clrs : [String]) {
        colors = clrs

        super.init(frame: .zero, collectionViewLayout:  layout)
        
        isPrefetchingEnabled = false

        register(PaletteCollectionCell.self, forCellWithReuseIdentifier: "Color")
        
        dataSource = self
        delegate = self
        
        backgroundColor = .clear
        
        allowsSelection = true
        allowsSelection = true
        isUserInteractionEnabled = true
        
        addGestureRecognizer(moveGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeSelection() {
        selectedColor = -1
        reloadData()
    }
    
    func setSelect(index: Int) {
        selectedColor = index
        self.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .left)
        //reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    @objc func onLongPress(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let index = indexPathForItem(at: sender.location(in: self)) {
                beginInteractiveMovementForItem(at: index)
                let cell = cellForItem(at: index) as! PaletteCollectionCell
                
                cell.setShadow(color: .black, radius: 12, opasity: 0.2)
                
                UIView.animate(withDuration: 0.2, animations: {
                    cell.contentView.subviews[0].transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                })
                
                self.bringSubviewToFront(cell)

                moving = true
                moveCell = cell
            }
            
        case .changed:
            updateInteractiveMovementTargetPosition(sender.location(in: self))
            if moveCell != nil {
                self.bringSubviewToFront(moveCell!)
            }

        case .ended:
             if moving {
               isFinish = true
               UIView.animate(withDuration: 0.15, animations: {
                   self.performBatchUpdates({
                       self.endInteractiveMovement()
                   }, completion: {isEnd in
                    UIView.animate(withDuration: 0.15, animations: {
                        self.moveCell!.contentView.subviews[0].transform = CGAffineTransform(scaleX: 1, y: 1)
                    })
                    self.moveCell!.setShadow(color: .clear, radius: 12, opasity: 1)
                    self.moving = false
                    
                    if self.cellForItem(at: IndexPath(item: self.selectedColor, section: 0)) != nil {
                        self.bringSubviewToFront(self.cellForItem(at: IndexPath(item: self.selectedColor, section: 0))!)
                    }
                    
                    self.isFinish = false
                    self.moveCell = nil
                   })
               })
           }
            
        default:
            if moving {
                isFinish = true
                UIView.animate(withDuration: 0.15, animations: {
                    self.performBatchUpdates({
                        self.cancelInteractiveMovement()
                    }, completion: {isEnd in
                        UIView.animate(withDuration: 0.15, animations: {
                            self.moveCell!.contentView.subviews[0].transform = CGAffineTransform(scaleX: 1, y: 1)
                        },completion: {isEnd in
                            self.moveCell!.setShadow(color: .clear, radius: 12, opasity: 1)
                            self.moveCell = nil
                                                    
                            self.moving = false
                            self.isFinish = false
                        })
                    })
                })
            }
        }
    }
    
}

extension PaletteCollectionModern : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFinish && moveCell != nil {
            return moveCell!
        }
        
        let cell = dequeueReusableCell(withReuseIdentifier: "Color", for: indexPath) as! PaletteCollectionCell
        cell.setColor(color: UIColor(hex: colors[indexPath.item])!)
        cell.setSelect(isSelect: indexPath.item == selectedColor, animate: false)
        
        return cell
    }
}

extension PaletteCollectionModern : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? PaletteCollectionCell
        
        cell?.setSelect(isSelect: true, animate: true)
        selectedColor = indexPath.item
        self.bringSubviewToFront(cell!)
        
        colorDelegate(UIColor(hex: colors[indexPath.item])!)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        colors.insert(colors.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
        
        if selectedColor == sourceIndexPath.item {
            selectedColor = destinationIndexPath.item
        } else if selectedColor > sourceIndexPath.item && selectedColor <= destinationIndexPath.item {
            selectedColor -= 1
        } else if selectedColor < sourceIndexPath.item && selectedColor >= destinationIndexPath.item {
            selectedColor += 1
        }
        
        replaceColorsDelegate()
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


class PaletteCollectionCell : UICollectionViewCell {
    
    var width = NSLayoutConstraint()
    var height = NSLayoutConstraint()

    lazy private var bgColor : UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "background"))
        img.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        contentView.addSubview(bgColor)
        width = bgColor.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        height = bgColor.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        
        bgColor.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        bgColor.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            width,
            height
        ])
        
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: bgColor.bounds, cornerRadius: 12).cgPath
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelect(isSelect : Bool, animate : Bool) {
      
        self.bgColor.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
        
        
        if isSelect {
            width.constant = 12;
            height.constant = 12;
        } else {
            width.constant = 0;
            height.constant = 0;
        }
        
        UIView.animate(withDuration: animate ? 0.2 : 0, animations: {
            self.bgColor.layoutIfNeeded()
            self.bgColor.StrokeAnimate(duration: animate ? 0.2 : 0, width: isSelect ? 3 : 0)
            self.bgColor.setCorners(corners: isSelect ? 12 : 0,needMask: true)
            self.contentView.setShadow(color: .black, radius: 8, opasity: isSelect ? 0.5 : 0)
            self.contentView.layer.shadowPath = UIBezierPath(roundedRect: self.contentView.bounds, cornerRadius: 12).cgPath
          
        })
    }
    
    func setColor(color : UIColor) {
        colorView.backgroundColor = color
    }
}
