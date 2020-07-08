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
            selectedColor = 0
            selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
            reloadData()
        }
    }
    
    var moving : Bool = false
    
    private var layout = PalleteCollectionLayout(itemSize: 32, itemsSpacing: 0)
    
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
        reorderingCadence = .immediate
        
        
        dragDelegate = self
        dropDelegate = self
        
        allowsSelection = true
        dragInteractionEnabled = true
        allowsSelection = true
        isUserInteractionEnabled = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
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
        
        item.previewProvider = {
            let preview = UIDragPreview(view: (self.cellForItem(at: indexPath)! as! PaletteCollectionCell).contentView.subviews[0])
            return preview
        }
        
        item.localObject = ("Color", self)
        
        let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        moving = true
        
        return [item]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let params = UIDragPreviewParameters()
        params.backgroundColor = .clear
        params.visiblePath = UIBezierPath(roundedRect: CGRect(origin: indexPath.item == selectedColor ? CGPoint(x: -6 , y: -6) : .zero, size: indexPath.item == selectedColor ? CGSize(width: 44, height: 44) : CGSize(width: 32, height: 32)), cornerRadius: indexPath.item == selectedColor ? 12 : 0)
        
        return params
    }

    
}

extension PaletteCollectionModern : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        switch coordinator.proposal.operation {
        case .move:
            if let destinationIndexPath = coordinator.destinationIndexPath {
                let sourceIndexPath = coordinator.items[0].sourceIndexPath!
                
                if sourceIndexPath.item < selectedColor && destinationIndexPath.item >= selectedColor {
                    selectedColor -= 1
                } else if sourceIndexPath.item  > selectedColor && destinationIndexPath.item <= selectedColor {
                    selectedColor += 1
                } else if sourceIndexPath.item == selectedColor {
                    selectedColor = destinationIndexPath.item
                }
                
                colors.insert(colors.remove(at: coordinator.items[0].sourceIndexPath!.item), at: coordinator.destinationIndexPath!.item)

                performBatchUpdates({
                    collectionView.deleteItems(at: [coordinator.items[0].sourceIndexPath!])
                    collectionView.insertItems(at: [coordinator.destinationIndexPath!])
                }, completion: {isEnd in
                    collectionView.selectItem(at: IndexPath(item: self.selectedColor, section: 0), animated: false, scrollPosition: .top)
                })
                
                self.dragInteractionEnabled = false
                coordinator.drop(coordinator.items[0].dragItem, toItemAt: coordinator.destinationIndexPath!)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if (session.localDragSession?.items[0].localObject as! (String,UICollectionView)) == ("Color", self) {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden, intent: .unspecified)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let params = UIDragPreviewParameters()
        params.backgroundColor = .clear
        params.visiblePath = UIBezierPath(roundedRect: CGRect(origin: indexPath.item == selectedColor ? CGPoint(x: -6 , y: -6) : .zero, size: indexPath.item == selectedColor ? CGSize(width: 44, height: 44) : CGSize(width: 32, height: 32)), cornerRadius: indexPath.item == selectedColor ? 12 : 0)
        
        return params
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        self.dragInteractionEnabled = true
        moving = false
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
            self.bgColor.setCorners(corners: isSelect ? 12 : 0)
            self.contentView.setShadow(color: .black, radius: 8, opasity: isSelect ? 0.5 : 0)
          
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
