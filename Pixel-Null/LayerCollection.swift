//
//  FramesCollection.swift
//  new Testing
//
//  Created by Рустам Хахук on 10.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit


class LayersCollection : UICollectionView {
    weak var project : ProjectWork? = nil
    private var layout = ControlList()
    private var moveCell : LayerControlCell? = nil
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
        
        register(LayerControlCell.self, forCellWithReuseIdentifier: "LayerControl")
        
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
                    moveCell = cellForItem(at: cell) as? LayerControlCell

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

extension LayersCollection : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return project!.information.frames[project!.FrameSelected].layers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if moveCell != nil && isFinish {
            return moveCell!
        }
        
        let cell = dequeueReusableCell(withReuseIdentifier: "LayerControl", for: indexPath) as! LayerControlCell
        
        cell.preview.image = nil

        DispatchQueue.global(qos: .userInteractive).async {
            let img = self.project!.getSmallLayer(frame: self.project!.FrameSelected, layer: indexPath.item,size: CGSize(width: 36, height: 36))
            DispatchQueue.main.async {
                cell.preview.image = img
            }
        }
        
        cell.preview.setBg(color: UIColor(hex : project!.information.bgColor)!)
        
        cell.preview.framePreview.setVisible(isVisible: project!.layerVisible(layer: indexPath.item), anim: false)
        cell.preview.setSelect(isSelected: indexPath.item == project!.LayerSelected  ? true : false, anim: false)
        
        return cell
    }
}

extension LayersCollection : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if project!.LayerSelected != indexPath.item {
            let cell = cellForItem(at: indexPath) as! LayerControlCell
            cell.preview.setSelect(isSelected: true, anim: true)
            
            frameDelegate?.changeLayer(frame: project!.FrameSelected, from: project!.LayerSelected, to: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? LayerControlCell
        cell?.preview.setSelect(isSelected: false, anim: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
       if sourceIndexPath.item  < project!.LayerSelected && destinationIndexPath.item >= project!.LayerSelected {
            project?.LayerSelected -= 1
        } else if sourceIndexPath.item  > project!.LayerSelected && destinationIndexPath.item <= project!.LayerSelected {
            project?.LayerSelected += 1
        } else if sourceIndexPath.item == project!.LayerSelected {
            project?.LayerSelected = destinationIndexPath.item
        }
        if sourceIndexPath.item != destinationIndexPath.item {
            project?.addAction(action: ["ToolID" : "\(Actions.layerReplace.rawValue)","frame" : "\(project!.FrameSelected)", "from" : "\(sourceIndexPath.item)", "to" : "\(destinationIndexPath.item)"])
        }

        
        frameDelegate?.updateLayerPosition(frame: project!.FrameSelected, from: sourceIndexPath.item, to: destinationIndexPath.item)
    }
}


class LayerControlCell : UICollectionViewCell {
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
