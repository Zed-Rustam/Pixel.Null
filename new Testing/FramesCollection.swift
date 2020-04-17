//
//  FramesCollection.swift
//  new Testing
//
//  Created by Рустам Хахук on 10.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FramesCollection : UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var project : ProjectWork?
    weak var preview : FramePreview? = nil
    weak var selfView : FramesCollectionView? = nil
    weak var layers : LayersCollection? = nil
    weak var frameDelegate : FrameControlUpdate? = nil
    
    var canMove : Bool = true
    
    private var moveFrame : FrameWorker? = nil
    private var moveCellIndex : IndexPath? = nil

    private var selectCell : FrameControlCell? = nil

    private var layout = ControlList()
    private var tapGesture : UITapGestureRecognizer!
    private var longPressGesture : UILongPressGestureRecognizer!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return project!.frameCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameControl", for: indexPath) as! FrameControlCell
        
        cell.preview.image = nil

        DispatchQueue.global(qos: .userInteractive).async {
            var img : UIImage
                img = self.project!.getFrameFromLayers(frame : indexPath.item,size: CGSize(width: 36, height: 36))

            DispatchQueue.main.async {
                cell.preview.image = img
           }
        }
        
        cell.preview.setBg(color: UIColor(hex : project!.information.bgColor)!)
        cell.preview.setSelect(isSelected: (indexPath.item == project!.FrameSelected && moveCellIndex?.item != project!.FrameSelected) ? true : false, anim: false)
        cell.visible = true
        print("wow!")
        
        if indexPath.item == project!.FrameSelected {
            selectCell = cell
        }
        
        return cell
    }
    
    func changeSelect(newSelect: FrameControlCell) {
        selectCell?.preview.setSelect(isSelected: false, anim: true)
        
        let newCell = cellForItem(at: IndexPath(item: indexPath(for: newSelect)!.item, section: 0)) as! FrameControlCell
        newCell.preview.setSelect(isSelected: true, anim: true)
        selectCell = newCell
        
        frameDelegate?.changeFrame(from: project!.FrameSelected, to: indexPath(for: newSelect)!.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if moveCellIndex != nil {
            UIView.animate(withDuration: 0.25, animations: {
                self.moveFrame?.center = CGPoint(x : self.longPressGesture.location(in: self).x, y : 30)
            })
        }
    }
    
    init(frame: CGRect,proj : ProjectWork) {
        
        project = proj
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(FrameControlCell.self, forCellWithReuseIdentifier: "FrameControl")

        delegate = self
        dataSource = self
        isUserInteractionEnabled = true
        layer.masksToBounds = false
        backgroundColor = .clear
        //self.isExclusiveTouch = false
              
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(sender:)))
        longPressGesture.minimumPressDuration = 0.25
        
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(longPressGesture)
    }
    
    @objc func tapGesture(sender : UITapGestureRecognizer){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)

           if sender.state == .ended && canMove {
              if let item = indexPathForItem(at: sender.location(in: sender.view)) {
                  if item.item != project?.FrameSelected {
                      changeSelect(newSelect: cellForItem(at: item) as! FrameControlCell)
                  }
              }
          }
    }
    
    @objc func longPressGesture(sender : UILongPressGestureRecognizer){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)

        let point = CGPoint(x: sender.location(in: self).x, y: 30)
        if canMove {
            switch sender.state {
            case .began:
            if let item = indexPathForItem(at: point) {
                layers?.canMove = false
                beginInteractiveMovementForItem(at: item)
                moveCellIndex = item
                
                let moveCell = cellForItem(at: item) as! FrameControlCell
                moveCell.visible = false
                
                moveFrame = FrameWorker(frame: moveCell.frame)
                moveFrame?.image = moveCell.preview.image
                moveFrame?.setSelect(isSelected: project?.FrameSelected == item.item, anim: false)
                moveFrame?.setBg(color: UIColor(hex : project!.information.bgColor)!)
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.moveFrame?.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
                    self.moveFrame?.center = point
                })
                self.addSubview(moveFrame!)
            }
                
            case .changed:
                updateInteractiveMovementTargetPosition(point)
                UIView.animate(withDuration: 0.25, animations: {
                    self.moveFrame?.center = point
                })
            break
            
            case .ended:
                if moveCellIndex != nil {
                    UIView.animate(withDuration: 0, animations: {
                        self.performBatchUpdates({
                            self.endInteractiveMovement()
                        }, completion: {isEnd in
                            let cell = self.cellForItem(at: self.moveCellIndex!) as? FrameControlCell
                            cell?.visible = false
                            UIView.animate(withDuration: 0.25, animations: {
                                self.moveFrame?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                                self.moveFrame?.center = cell!.center
                            },completion:  {isEnd in
                                self.moveFrame?.removeFromSuperview()
                                
                                cell?.preview.setSelect(isSelected: (self.moveCellIndex!.item == self.project!.FrameSelected) ? true : false, anim: false)
                                cell?.visible = true

                                self.moveCellIndex = nil
                                self.layers?.canMove = true
                            })
                        })
                    })
                }
            default:
                break
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        print("\(originalIndexPath.item)     \(proposedIndexPath.item)")
        if originalIndexPath.item != proposedIndexPath.item {
            moveCellIndex = proposedIndexPath
        }
        
        return proposedIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if sourceIndexPath.item  < project!.FrameSelected && destinationIndexPath.item >= project!.FrameSelected {
            project?.FrameSelected -= 1
        } else if sourceIndexPath.item  > project!.FrameSelected && destinationIndexPath.item <= project!.FrameSelected {
            project?.FrameSelected += 1
        } else if sourceIndexPath.item == project!.FrameSelected {
            project?.FrameSelected = destinationIndexPath.item
        }
        
        if sourceIndexPath.item != destinationIndexPath.item {
            project?.addAction(action: ["ToolID" : "\(Actions.frameReplace.rawValue)", "from" : "\(sourceIndexPath.item)", "to" : "\(destinationIndexPath.item)"])
        }
        frameDelegate?.updateFramePosition(from: sourceIndexPath.item, to: destinationIndexPath.item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FrameControlCell : UICollectionViewCell {
    var preview : FrameWorker! = nil
    
    var visible : Bool {
        get {
            return self.preview.alpha == 1 ? true : false
        }
        set {
            self.preview.alpha = newValue ? 1 : 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        preview = FrameWorker(frame : CGRect(origin: .zero, size: frame.size))
        contentView.addSubview(preview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ControlList : UICollectionViewLayout {
    private var paddingleft = 12
    private var paddingRight = 12
    private var spacing = 8
    
    var attributes : [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
           return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0) * 36 + (collectionView!.numberOfItems(inSection: 0) - 1) * spacing + paddingleft + paddingRight), height: CGFloat(collectionView!.bounds.height))
    }
    
    override func prepare() {
        attributes.removeAll()
        
        for item in 0..<collectionView!.numberOfItems(inSection: 0){
            let index = IndexPath(item: item, section: 0)
            let frame = CGRect(x: paddingleft + item * 36 + item * spacing, y: 0, width: 36, height: 60)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = frame
            attributes.append(attribute)
        }
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
    
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        return attributes[indexPath.item]
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return attributes[indexPath.item]
    }
}
