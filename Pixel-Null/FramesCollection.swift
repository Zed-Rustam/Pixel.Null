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
    private var moveCell : FramePreviewCell? = nil
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
        
        register(FramePreviewCell.self, forCellWithReuseIdentifier: "FrameControl")
        
        delegate = self
        dataSource = self
        
        isUserInteractionEnabled = true
        layer.masksToBounds = false
        isPrefetchingEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        addGestureRecognizer(moveGesture)
        
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
    }
    
    @objc func onLongPress(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let cell = indexPathForItem(at: sender.location(in: self)) {
                if !isMoving {
                    beginInteractiveMovementForItem(at: cell)
                    moveCell = cellForItem(at: cell) as? FramePreviewCell

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
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
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
        
        let cell = dequeueReusableCell(withReuseIdentifier: "FrameControl", for: indexPath) as! FramePreviewCell
        
        cell.setPreview(image: nil)

        DispatchQueue.global(qos: .userInteractive).async {
            var img : UIImage
                img = self.project!.getFrameFromLayers(frame : indexPath.item,size: CGSize(width: 36, height: 36)).flip(xFlip: self.project!.isFlipX, yFlip: self.project!.isFlipY)
            DispatchQueue.main.async {
                cell.setPreview(image: img)
           }
        }
        
        cell.setBackground(color: UIColor(hex : project!.information.bgColor)!)
        
        cell.setSelect(isSelect: indexPath.item == project!.FrameSelected  ? true : false, animate: false)
        
        return cell
    }
}

extension FramesCollection : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if project!.FrameSelected != indexPath.item {
            let cell = cellForItem(at: indexPath) as! FramePreviewCell
            cell.setSelect(isSelect: true, animate: true)
            
            frameDelegate?.changeFrame(from: project!.FrameSelected, to: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? FramePreviewCell
        cell?.setSelect(isSelect: false, animate: true)
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


class FramePreviewCell : UICollectionViewCell {
    
    lazy private var bg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 36).isActive = true
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.setCorners(corners: 6)
        
        view.backgroundColor = getAppColor(color: .background)
        
        view.addSubview(previewBg)
        previewBg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        previewBg.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
        view.addSubview(linesView)
        
        linesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        linesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        
        return view
    }()
    
    lazy private var selectBg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 42).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        view.setCorners(corners: 9)
        view.backgroundColor = getAppColor(color: .select)
        
        return view
    }()
    
    lazy private var preview : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setCorners(corners: 6)
        img.contentMode = .scaleAspectFit
        img.layer.magnificationFilter = .nearest
        img.layer.minificationFilter = .nearest
        
        img.addSubviewFullSize(view: visibleImage)
        return img
    }()
    
    lazy private var visibleImage : UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "unvisible_icon").withRenderingMode(.alwaysOriginal))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy private var previewBg : UIView = {
        let img = UIView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img.heightAnchor.constraint(equalToConstant: 36).isActive = true
        img.setCorners(corners: 6)
        img.backgroundColor = getAppColor(color: .disable)
        img.addSubviewFullSize(view: preview)
        return img
    }()
    
    lazy private var linesView : UIView = {
       let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.widthAnchor.constraint(equalToConstant: 20).isActive = true
        mainview.heightAnchor.constraint(equalToConstant: 12).isActive = true

        let topLine = UIView()
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.setCorners(corners: 2)
        topLine.backgroundColor = getAppColor(color: .enable)
        
        let bottomLine = UIView()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.setCorners(corners: 2)
        bottomLine.backgroundColor = getAppColor(color: .enable)
        
        mainview.addSubviewFullSize(view: topLine, paddings: (0,0,0,-8))
        mainview.addSubviewFullSize(view: bottomLine, paddings: (0,0,8,0))

        return mainview
    }()
    
    var needFullResetImage : Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectBg)
        selectBg.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        selectBg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        
        contentView.addSubview(bg)
        bg.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        bg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        
        setVisible(isVisible: true, animate: false)
    }
    
    func setSelect(isSelect : Bool, animate : Bool = true) {
        UIView.animate(withDuration: animate ? 0.2 : 0,delay: 0, options: .curveLinear, animations: {
            self.selectBg.transform = CGAffineTransform(scaleX: isSelect ? 1 : 0.75, y: isSelect ? 1 : 0.75)
            
            self.linesView.subviews[0].backgroundColor = isSelect ? getAppColor(color: .select) : getAppColor(color: .enable)
            self.linesView.subviews[1].backgroundColor = isSelect ? getAppColor(color: .select) : getAppColor(color: .enable)
        })
    }
    
    func setPreview(image : UIImage?) {
        preview.image = image
    }
    
    func setBackground(color : UIColor) {
        preview.backgroundColor = color
    }
    
    func setVisible(isVisible : Bool, animate : Bool) {
        UIView.animate(withDuration: animate ? 0.2 : 0, animations: {
            self.visibleImage.alpha = isVisible ? 0 : 1
            self.visibleImage.backgroundColor = isVisible ? .clear : UIColor.black.withAlphaComponent(0.5)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ControlList : UICollectionViewLayout {
    private var paddingleft = 12
    private var paddingRight = 12
    private var spacing = 0
    
    var attributes : [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
           return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0) * 42 + (collectionView!.numberOfItems(inSection: 0) - 1) * spacing + paddingleft + paddingRight), height: CGFloat(collectionView!.bounds.height))
    }
    
    override func prepare() {
        attributes.removeAll()
        
        for item in 0..<collectionView!.numberOfItems(inSection: 0){
            let index = IndexPath(item: item, section: 0)
            let frame = CGRect(x: paddingleft + item * 42 + item * spacing, y: 0, width: 42, height: 70)
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
