//
//  ToolBarRepositionCollection.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 11.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

func getToolsArray() -> [Int] {
    if let tools = UserDefaults.standard.array(forKey: "ToolsPosition") {
        return tools as! [Int]
    } else {
        return [-6,-3,-2,0,1,2,3,4,5,6,7,8,-4,-5,-1]
    }
}

class ToolBarRepositionCollection : UICollectionView, UIGestureRecognizerDelegate {
    var toolsArray : [Int] = getToolsArray()
    
    lazy private var moveGesture : UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(sender:)))
        gesture.minimumPressDuration = 0.35
        return gesture
    }()
    
    private var layout = ToolBarRepositionCollectionLayout()
    private var moveIndex : Int = -1
    private var isMoving : Bool = false
    private var isFinish : Bool = false
    private var moveCell : ToolBarRepositionCollectionCell? = nil

    @objc func onLongPress(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let index = indexPathForItem(at: sender.location(in: self)) {
                print("was start")
                beginInteractiveMovementForItem(at: index)
                let cell = cellForItem(at: index) as! ToolBarRepositionCollectionCell
                
                UIView.animate(withDuration: 0.2, animations: {
                    cell.contentView.subviews[0].transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                })
                
                cell.contentView.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 0.5)

                isMoving = true
                moveCell = cell
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
                        self.moveCell!.contentView.subviews[0].transform = CGAffineTransform(scaleX: 1, y: 1)
                       })
                        self.moveCell!.contentView.setShadow(color: .clear, radius: 8, opasity: 0.5)

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
                            self.moveCell!.contentView.subviews[0].transform = CGAffineTransform(scaleX: 1, y: 1)
                        },completion: {isEnd in
                            self.moveCell!.contentView.setShadow(color: .clear, radius: 8, opasity: 0.5)
                            self.moveCell = nil
                            self.isMoving = false
                            self.isFinish = false
                        })
                    })
                })
            }
        }
    }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        translatesAutoresizingMaskIntoConstraints = false
        
        register(ToolBarRepositionCollectionCell.self, forCellWithReuseIdentifier: "Tool")
        delegate = self
        dataSource = self
            
        backgroundColor = .clear
        addGestureRecognizer(moveGesture)
        //isUserInteractionEnabled = true
        
        layer.masksToBounds = false
        //isExclusiveTouch = true
       
        //isMultipleTouchEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {

        return false
    }
}

extension ToolBarRepositionCollection : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toolsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFinish && moveCell != nil {
            return moveCell!
        }
        
        let cell = dequeueReusableCell(withReuseIdentifier: "Tool", for: indexPath) as! ToolBarRepositionCollectionCell
        
        switch toolsArray[indexPath.item] {
        case -6:
            cell.setIcon(image: #imageLiteral(resourceName: "color_tool_icon"))
        case -5:
            cell.setIcon(image: #imageLiteral(resourceName: "symmetry_icon"))
        case -4:
            cell.setIcon(image: #imageLiteral(resourceName: "project_settings_icon"))
        case -3:
            cell.setIcon(image: #imageLiteral(resourceName: "undo_icon"))
        case -2:
            cell.setIcon(image: #imageLiteral(resourceName: "redo_icon"))
        case -1:
            cell.setIcon(image: #imageLiteral(resourceName: "cancel_icon"))
        case 0:
            cell.setIcon(image: #imageLiteral(resourceName: "edit_icon"))
        case 1:
            cell.setIcon(image: #imageLiteral(resourceName: "erase_icon"))
        case 2:
            cell.setIcon(image: #imageLiteral(resourceName: "move_icon"))
        case 3:
            cell.setIcon(image: #imageLiteral(resourceName: "gradient_icon"))
        case 4:
            cell.setIcon(image: #imageLiteral(resourceName: "fill_icon"))
        case 5:
            cell.setIcon(image: #imageLiteral(resourceName: "grid_icon"))
        case 6:
            cell.setIcon(image: #imageLiteral(resourceName: "selection_icon"))
        case 7:
            cell.setIcon(image: #imageLiteral(resourceName: "sharp_icon"))
        case 8:
            cell.setIcon(image: #imageLiteral(resourceName: "picker_icon"))
        default:
            cell.setIcon(image: #imageLiteral(resourceName: "background"))
        }
        
        return cell
    }
    
}

extension ToolBarRepositionCollection : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        toolsArray.insert(toolsArray.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
        
        UserDefaults.standard.set(toolsArray, forKey: "ToolsPosition")
    }
}

class ToolBarRepositionCollectionLayout: UICollectionViewLayout {
    private var attributes : [UICollectionViewLayoutAttributes] = []
    private var offsetWidth : Int = 0
    private var columnsCount : Int = 0
    private var itemSize : Int = 36
    private var offsetBottom : Int = 0
    private var offsetTop : Int = 0
    
    var contentWidth : Int {
        return Int(collectionView!.bounds.width)
    }
    private var contentHeight = 0
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    func layout() {
        attributes.removeAll()

        columnsCount = ((Int(collectionView!.bounds.width)) / (itemSize))
        
        offsetWidth = Int(CGFloat(Int(collectionView!.bounds.width) - (columnsCount) * itemSize) / 2.0)
                
        for i in 0..<collectionView!.numberOfItems(inSection: 0)  {
            let index = IndexPath(item: i, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = CGRect(x: offsetWidth + itemSize * (i % columnsCount), y: offsetTop + (itemSize) * (i / columnsCount), width: itemSize, height: itemSize)
            
            attributes.append(attribute)
        }
        
        contentHeight = Int(CGFloat(itemSize) * CGFloat(ceil(CGFloat(collectionView!.numberOfItems(inSection: 0)) / CGFloat(columnsCount))))
        
    }

    override func prepare() {
        layout()
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

class ToolBarRepositionCollectionCell: UICollectionViewCell {
    
    lazy private var bgView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCorners(corners: 12)
        view.backgroundColor = getAppColor(color: .background)
        
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubviewFullSize(view: view)
        mainView.addSubviewFullSize(view: toolIcon)

        return mainView
    }()
    
    lazy private var toolIcon : UIImageView = {
        let image = UIImageView()
        //image.setCorners(corners: 12)
        image.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        image.tintColor = getAppColor(color: .enable)
        return image
    }()
    
    func setIcon(image : UIImage) {
        toolIcon.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviewFullSize(view: bgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
