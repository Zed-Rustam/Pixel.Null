//
//  PaletteCollection3.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 20.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PaletteCollectionV3 : UICollectionView {
    
    private var colors : [String]

    private var layout = PalleteCollectionLayout()
    
    private var selectedColor = 0
    
    //показывает происходит ли сейчас перемещение, для того, что бы можно было отключить другие действия с паллитрой
    private var isMoving = false
    //нужен чтобы при прекращении перемещения передать ячейку, которая перемещалась
    private var isFinish = false
    
    private var moveCell : PalleteColorCell? = nil

    var startIndexMoving : IndexPath? = nil
    
    //вкл/выкл перемещение
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
        set {
            colors = newValue
            reloadData()
        }
    }
    
    //делегат, который вызывается при выборе цвета и передает цвет
    var colorDelegate : (UIColor) -> () = {color in}
    
    lazy private var moveGesture : UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(sender:)))
        gesture.minimumPressDuration = 0.35
        
        return gesture
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow(color: UIColor(named : "shadowColor")!, radius: 4, opasity: 0.5)
    }

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
        
        setShadow(color: UIColor(named : "shadowColor")!, radius: 4, opasity: 0.5)
        
        isPrefetchingEnabled = false
    }
    
    @objc func onLongPress(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let cell = indexPathForItem(at: sender.location(in: self)) {
                if !isMoving {
                    beginInteractiveMovementForItem(at: cell)
                    moveCell = cellForItem(at: cell) as? PalleteColorCell
                    startIndexMoving = cell
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.moveCell!.contentView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                    })
                    isMoving = true
                }
            }
            
        case .changed:
                updateInteractiveMovementTargetPosition(sender.location(in: self))
            
        case .ended:
            if isMoving {
                isFinish = true
                UIView.animate(withDuration: 0.15, animations: {
                    self.performBatchUpdates({
                        self.endInteractiveMovement()
                    }, completion: {isEnd in
                        UIView.animate(withDuration: 0.15, animations: {
                            self.moveCell!.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                        self.isMoving = false
                        self.isFinish = false
                        self.moveCell = nil
                    })
                })
            }
            
        default:
            if isMoving {
                isFinish = true
                UIView.animate(withDuration: 0.15, animations: {
                    self.performBatchUpdates({
                        self.cancelInteractiveMovement()
                    }, completion: {isEnd in
                        UIView.animate(withDuration: 0.15, animations: {
                            self.moveCell!.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        },completion: {isEnd in
                            self.moveCell = nil
                            self.isMoving = false
                            self.isFinish = false
                            self.startIndexMoving = nil
                        })
                    })
                })
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaletteCollectionV3 : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFinish && moveCell != nil{
            return moveCell!
        }
        
        let cell = dequeueReusableCell(withReuseIdentifier: "Color", for: indexPath) as! PalleteColorCell
        cell.color = UIColor(hex: colors[indexPath.item])!
        cell.setVisible(visible: selectedColor == indexPath.item ? true : false, withAnim: false)
        
        return cell
    }
}

//MARK: Palette Collection Delegate
extension PaletteCollectionV3 : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedColor != indexPath.item {
            selectedColor = indexPath.item
            
            let cellnew = cellForItem(at: indexPath) as! PalleteColorCell
            cellnew.setVisible(visible: true, withAnim: true)
        }
        
        colorDelegate(UIColor(hex: colors[selectedColor])!)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cellnew = cellForItem(at: indexPath) as? PalleteColorCell
        cellnew?.setVisible(visible: false, withAnim: true)
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

extension PaletteCollectionV3 : PalleteCollectionDelegate {
    
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
                if isEnd {
                    (self.cellForItem(at: IndexPath(item: self.selectedColor, section: 0)) as! ColorCell).setVisible(visible: true)
                    self.selectItem(at: IndexPath(item: self.selectedColor, section: 0), animated: true, scrollPosition: .left)
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
        })
    }
    
    func getSelectItemColor() -> UIColor {
        return UIColor(hex: colors[selectedColor])!
    }
}

class ColorCell: UICollectionViewCell {
    
    lazy private var bg: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 32).isActive = true
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return view
    }()
    
    var color : UIColor? {
        get{
            return bg.backgroundColor
        }
        set{
            bg.backgroundColor = newValue
        }
    }
    
    private var select = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bg)
        bg.centerYAnchor.constraint(equalToSystemSpacingBelow: contentView.centerYAnchor, multiplier: 1).isActive = true
        bg.centerXAnchor.constraint(equalToSystemSpacingAfter: contentView.centerXAnchor, multiplier: 1).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEdgeMode(edge : Int) {
        let view : UIView? = edge == -1 ? nil : UIView(frame: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        
        UIView.animate(withDuration: 0.2, animations: {
            view?.setCorners(corners: 8)
        })
        
        view?.backgroundColor = .red
        switch edge {
        case 0:
            view?.layer.maskedCorners = [.layerMinXMinYCorner]
        case 1:
            view?.layer.maskedCorners = [.layerMaxXMinYCorner]
        case 2:
            view?.layer.maskedCorners = [.layerMaxXMaxYCorner]
        default:
            view?.layer.maskedCorners = [.layerMaxXMaxYCorner]
        }
        
        bg.mask = view
    }
    
    func setVisible(visible : Bool, withAnim : Bool = true, delay : Double = 0) {
        select = visible
        
        if select {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.contentView.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
            }, completion: {isEnd in
                self.superview?.bringSubviewToFront(self)
            })
            
            UIView.animate(withDuration: withAnim ? 0.2 : 0, delay: delay, options: .curveEaseInOut, animations: {
                self.bg.setCorners(corners: 8)
                self.setShadow(color: .black, radius: 16, opasity: 0.75)
                self.contentView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            })
        } else {
            UIView.animate(withDuration: withAnim ? 0.2 : 0, delay : delay, options: .curveEaseInOut, animations: {
                self.bg.setCorners(corners: 0)
                self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.setShadow(color: .black, radius: 16, opasity: 0)
            },completion: {isEnd in
                self.superview?.sendSubviewToBack(self)
            })
        }
    }
    
    func setSelect(isSelect : Bool,withAnim : Bool = true, delay : Double = 0) {
        if select {
            self.bg.layer.borderWidth = 0
            self.bg.layer.borderColor = getAppColor(color: .select).cgColor
        
            self.bg.StrokeAnimate(duration: 0.2, width: 2)
        } else {
            self.bg.StrokeAnimate(duration: 0.2, width: 0)
        }
    }
}
