//
//  FramesCollection.swift
//  new Testing
//
//  Created by Рустам Хахук on 10.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FramesCollection : UICollectionView {
    weak var project : ProjectWork? = nil
    private var layout = ControlList()
    private var moveCell : FrameControlCell? = nil
    private var isFinish = false
    private var isMoving = false
    weak var frameDelegate : FrameControlUpdate? = nil

    var moving : Bool {
        get{
            return isMoving
        }
    }
    
    lazy private var moveGesture : UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(sender:)))
        gesture.minimumPressDuration = 0.35
        
        return gesture
    }()
    
    init(proj : ProjectWork) {
        project = proj
        super.init(frame: .zero, collectionViewLayout: layout)
        
        register(FrameControlCell.self, forCellWithReuseIdentifier: "FrameControl")
        
        delegate = self
        dataSource = self
        
        isUserInteractionEnabled = true
        layer.masksToBounds = false
        isPrefetchingEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        addGestureRecognizer(moveGesture)
    }
    
    @objc func onLongPress(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let cell = indexPathForItem(at: sender.location(in: self)) {
                if !isMoving {
                    beginInteractiveMovementForItem(at: cell)
                    moveCell = cellForItem(at: cell) as? FrameControlCell

                    UIView.animate(withDuration: 0.25, animations: {
                        self.moveCell!.contentView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                    })
                    isMoving = true
                }
            }
            
        case .changed:
            let location = CGPoint(x: sender.location(in: self).x, y: 30)
            updateInteractiveMovementTargetPosition(location)
            
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

extension FramesCollection : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return project!.frameCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if moveCell != nil && isFinish {
            return moveCell!
        }
        
        let cell = dequeueReusableCell(withReuseIdentifier: "FrameControl", for: indexPath) as! FrameControlCell
        
        cell.preview.image = nil

        DispatchQueue.global(qos: .userInteractive).async {
            var img : UIImage
                img = self.project!.getFrameFromLayers(frame : indexPath.item,size: CGSize(width: 36, height: 36)).flip(xFlip: self.project!.isFlipX, yFlip: self.project!.isFlipY)
            DispatchQueue.main.async {
                cell.preview.image = img
           }
        }
        
        cell.preview.setBg(color: UIColor(hex : project!.information.bgColor)!)
        cell.preview.setSelect(isSelected: indexPath.item == project!.FrameSelected  ? true : false, anim: false)
        
        return cell
    }
}

extension FramesCollection : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if project!.FrameSelected != indexPath.item {
            let cell = cellForItem(at: indexPath) as! FrameControlCell
            cell.preview.setSelect(isSelected: true, anim: true)
            
            frameDelegate?.changeFrame(from: project!.FrameSelected, to: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? FrameControlCell
        cell?.preview.setSelect(isSelected: false, anim: true)
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
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.heightAnchor.constraint(equalToConstant: 60).isActive = true
        preview.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        contentView.addSubview(preview)
        
        preview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        preview.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
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
    
//    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
//        return attributes[indexPath.item]
//    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return attributes[indexPath.item]
    }
}
