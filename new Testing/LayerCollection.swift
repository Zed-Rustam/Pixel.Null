//
//  FramesCollection.swift
//  new Testing
//
//  Created by Рустам Хахук on 10.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayersCollection : UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var project : ProjectWork?
    weak var preview : FramePreview? = nil
    weak var list : FramesCollection? = nil
    weak var selfView : LayersCollectionView? = nil
    weak var frameDelegate : FrameControlUpdate? = nil
    
    var canMove : Bool = true
    
    private var moveFrame : FrameWorker? = nil
    private var moveCellIndex : IndexPath? = nil

    private var selectCell : LayerControlCell? = nil

    private var layout = ControlList()
    private var tapGesture : UITapGestureRecognizer!
    private var longPressGesture : UILongPressGestureRecognizer!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return project!.layerCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayerControl", for: indexPath) as! LayerControlCell
        
        cell.preview.image = nil

        DispatchQueue.global(qos: .userInteractive).async {
            let img = self.project!.getSmallLayer(frame: self.project!.FrameSelected, layer: indexPath.item,size: CGSize(width: 36, height: 36))
            DispatchQueue.main.async {
                cell.preview.image = img
            }
        }
        
        cell.preview.setBg(color: UIColor(hex : project!.information.bgColor)!)
        cell.preview.framePreview.setVisible(isVisible: project!.layerVisible(layer: indexPath.item), anim: false)
        cell.preview.setSelect(isSelected: (indexPath.item == project!.LayerSelected && moveCellIndex?.item != project!.LayerSelected) ? true : false, anim: false)
        cell.visible = true
        
        if indexPath.item == project!.LayerSelected {
            selectCell = cell
        }
        
        return cell
    }
    
    func changeSelect(newSelect: LayerControlCell) {
        selectCell?.preview.setSelect(isSelected: false, anim: true)
        
        let newCell = cellForItem(at: IndexPath(item: indexPath(for: newSelect)!.item, section: 0)) as! LayerControlCell
        newCell.preview.setSelect(isSelected: true, anim: true)
        selectCell = newCell
        
        frameDelegate?.changeLayer(frame: project!.FrameSelected, from: project!.LayerSelected, to: indexPath(for: newSelect)!.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if moveCellIndex != nil {
            UIView.animate(withDuration: 0.2, animations: {
                self.moveFrame?.center = CGPoint(x : self.longPressGesture.location(in: self).x, y : 30)
            })
        }
    }
    
    init(frame: CGRect,proj : ProjectWork) {
        
        project = proj
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(LayerControlCell.self, forCellWithReuseIdentifier: "LayerControl")

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
                  if item.item != project?.LayerSelected {
                      changeSelect(newSelect: cellForItem(at: item) as! LayerControlCell)
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
                list?.canMove = false
                beginInteractiveMovementForItem(at: item)
                moveCellIndex = item
                
                let moveCell = cellForItem(at: item) as! LayerControlCell
                moveCell.visible = false
                
                moveFrame = FrameWorker(frame: moveCell.frame)
                moveFrame?.image = moveCell.preview.image
                moveFrame?.framePreview.setVisible(isVisible: moveCell.preview.framePreview.isVisible, anim: false)
                moveFrame?.setSelect(isSelected: project?.LayerSelected == item.item, anim: false)
                moveFrame?.setBg(color: UIColor(hex : project!.information.bgColor)!)
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.moveFrame?.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
                    self.moveFrame?.center = point
                })
                self.addSubview(moveFrame!)
            }
                
            case .changed:
                updateInteractiveMovementTargetPosition(point)
                UIView.animate(withDuration: 0.2, animations: {
                    self.moveFrame?.center = point
                })
            break
            
            case .ended:
                if moveCellIndex != nil {
                    UIView.animate(withDuration: 0, animations: {
                    self.performBatchUpdates({
                        self.endInteractiveMovement()
                    }, completion: {isEnd in
                        let cell = self.cellForItem(at: self.moveCellIndex!) as? LayerControlCell
                        cell?.visible = false
                        UIView.animate(withDuration: 0.2, animations: {
                            self.moveFrame?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                            self.moveFrame?.center = cell!.center
                        },completion:  {isEnd in
                            self.moveFrame?.removeFromSuperview()
                            
                            cell?.preview.setSelect(isSelected: (self.moveCellIndex!.item == self.project!.LayerSelected) ? true : false, anim: false)
                            cell?.visible = true

                            self.moveCellIndex = nil
                            self.list?.canMove = true
                            
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
    
    //конец перемещения слоев
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        contentView.addSubview(preview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
