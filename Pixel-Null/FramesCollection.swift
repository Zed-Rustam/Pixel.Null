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
    private var dragIndex : IndexPath? = nil
    private var previewIndex : IndexPath? = nil
        
    weak var frameDelegate : FrameControlUpdate? = nil

    var moving : Bool {
        get{
            return self.hasActiveDrop
        }
    }
    
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
        
        reorderingCadence = .immediate
        
        dragDelegate = self
        dropDelegate = self
        
        allowsSelection = true
        allowsMultipleSelection = false
        dragInteractionEnabled = true
        
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        //setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
    }
}

extension FramesCollection : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return project!.frameCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        
        print("reloading : \(indexPath.item)")

        return cell
    }
}

extension FramesCollection : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if project!.FrameSelected != indexPath.item {
            let cell = cellForItem(at: indexPath) as! FramePreviewCell
            cell.setSelect(isSelect: true, animate: true)
            print("reselect")
            frameDelegate!.changeFrame(from: project!.FrameSelected, to: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        dragIndex = indexPath
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider:nil ) {action in
                    let clone = UIAction(title: "Clone",image : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                            self.project?.addAction(action: ["ToolID" : "\(Actions.frameClone.rawValue)", "frame" : "\(indexPath.item)"])
                            self.frameDelegate?.cloneFrame(original: indexPath.item)
                    })
                    
                    let delete = UIAction(title: "Delete",image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                        if(self.project!.information.frames.count > 1) {
                            let frameJson = String(data: try! JSONEncoder().encode(self.project!.information.frames[indexPath.item]), encoding: .utf8)!

                            self.project?.addAction(action: ["ToolID" : "\(Actions.frameDelete.rawValue)", "frame" : "\(indexPath.item)", "lastID" : "\(self.project!.information.frames[indexPath.item].frameID)", "frameStruct" : frameJson])

                         try! FileManager.default.copyItem(at: self.project!.getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(self.project!.information.frames[indexPath.item].frameID)"), to: self.project!.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(self.project!.getNextActionID())"))

                            self.dragIndex = nil
                            self.frameDelegate?.deleteFrame(frame: indexPath.item)
                        }
                    })

                    let delMenu = UIMenu(title: "Delete", image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, options : .destructive, children: [delete])

                    let edit = UIMenu(title: "", options: .displayInline, children: [delMenu])

                return UIMenu(title: "", image: nil, identifier: nil, children: self.project!.information.frames.count > 1 ? [clone,edit] : [clone])
            }

        return configuration
    }

    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        if dragIndex != nil && collectionView.cellForItem(at: dragIndex!) != nil {
            let preview = UITargetedPreview(view: collectionView.cellForItem(at: dragIndex!)!)
            preview.parameters.backgroundColor = .clear
            preview.parameters.visiblePath = UIBezierPath(roundedRect: dragIndex!.item == project!.FrameSelected ? (collectionView.cellForItem(at: dragIndex!)!).bounds : collectionView.cellForItem(at: dragIndex!)!.bounds.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)), cornerRadius: dragIndex!.item == project!.FrameSelected ? 11 : 8)
            dragIndex = nil
            return preview
        } else {
            print("non preview")
            return nil
        }
    }

    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let preview = UITargetedPreview(view: collectionView.cellForItem(at: dragIndex!)!)

        preview.parameters.backgroundColor = .clear
        preview.parameters.visiblePath = UIBezierPath(roundedRect: dragIndex!.item == project!.FrameSelected ? (collectionView.cellForItem(at: dragIndex!)!).bounds : collectionView.cellForItem(at: dragIndex!)!.bounds.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)), cornerRadius: dragIndex!.item == project!.FrameSelected ? 11 : 8)
        return preview
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? FramePreviewCell
        cell?.setSelect(isSelect: false, animate: true)
    }
}

extension FramesCollection : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.localObject = ("Frame",self)
        return [item]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let params = UIDragPreviewParameters()
        params.backgroundColor = .clear
        params.visiblePath = UIBezierPath(
            roundedRect: indexPath.item == project!.FrameSelected ? (collectionView.dequeueReusableCell(withReuseIdentifier: "FrameControl", for: indexPath)
            ).bounds : collectionView.dequeueReusableCell(withReuseIdentifier: "FrameControl", for: indexPath)
            .bounds.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)),
            cornerRadius: indexPath.item == project!.FrameSelected ? 11 : 8)
        return params
    }
}

extension FramesCollection : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        switch coordinator.proposal.operation {
        case .move:
            if let destinationIndexPath = coordinator.destinationIndexPath {
                let sourceIndexPath = coordinator.items[0].sourceIndexPath!
                
                if sourceIndexPath.item < project!.FrameSelected && destinationIndexPath.item >= project!.FrameSelected {
                    project!.FrameSelected -= 1
                } else if sourceIndexPath.item  > project!.FrameSelected && destinationIndexPath.item <= project!.FrameSelected {
                    project!.FrameSelected += 1
                } else if sourceIndexPath.item == project!.FrameSelected {
                    project!.FrameSelected = destinationIndexPath.item
                }
                
                if sourceIndexPath.item != destinationIndexPath.item {
                    project?.addAction(action: ["ToolID" : "\(Actions.frameReplace.rawValue)", "from" : "\(sourceIndexPath.item)", "to" : "\(destinationIndexPath.item)"])
                }
                
                frameDelegate?.updateFramePosition(from: sourceIndexPath.item, to: destinationIndexPath.item)
                
                performBatchUpdates({
                    collectionView.deleteItems(at: [coordinator.items[0].sourceIndexPath!])
                    collectionView.insertItems(at: [coordinator.destinationIndexPath!])
                }, completion: {isEnd in
                    collectionView.selectItem(at: IndexPath(item: self.project!.FrameSelected, section: 0), animated: false, scrollPosition: .top)
                })
                
                self.dragInteractionEnabled = false
                coordinator.drop(coordinator.items[0].dragItem, toItemAt: coordinator.destinationIndexPath!)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if (session.localDragSession?.items[0].localObject as! (String,UICollectionView)) == ("Frame", self) {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden, intent: .unspecified)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let params = UIDragPreviewParameters()
        params.backgroundColor = .clear
        params.visiblePath = UIBezierPath(roundedRect: indexPath.item == project!.FrameSelected ? (collectionView.cellForItem(at: indexPath)!).bounds : collectionView.cellForItem(at: indexPath)!.bounds.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)), cornerRadius: indexPath.item == project!.FrameSelected ? 11 : 8)
        return params
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        self.dragInteractionEnabled = true
    }
}

class FramePreviewCell : UICollectionViewCell {
    
    lazy private var bg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 36).isActive = true
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.setCorners(corners: 8)
        
        view.backgroundColor = getAppColor(color: .background)
        
        view.addSubview(bgForShadow)
        bgForShadow.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        bgForShadow.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
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
        view.setCorners(corners: 11)
        view.backgroundColor = getAppColor(color: .select)
        
        return view
    }()
    
    lazy private var preview : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setCorners(corners: 8)
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
    
    lazy private var previewBg : UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "background"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img.heightAnchor.constraint(equalToConstant: 36).isActive = true
        img.setCorners(corners: 8,needMask: true)
        img.addSubviewFullSize(view: preview)
        img.layer.magnificationFilter = .nearest
        return img
    }()
    
    lazy private var bgForShadow : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 36).isActive = true
        view.heightAnchor.constraint(equalToConstant: 36).isActive = true
        view.addSubviewFullSize(view: previewBg)        
        return view
    }()
    
    lazy private var linesView : UIView = {
       let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.widthAnchor.constraint(equalToConstant: 20).isActive = true
        mainview.heightAnchor.constraint(equalToConstant: 12).isActive = true

        let topLine = UIView()
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.setCorners(corners: 2)
        topLine.backgroundColor = getAppColor(color: .disable)
        
        let bottomLine = UIView()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.setCorners(corners: 2)
        bottomLine.backgroundColor = getAppColor(color: .disable)
        
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
        
        addInteraction(UIPointerInteraction(delegate: self))
        isUserInteractionEnabled = true
        
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 6, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 3, y: 3), size: CGSize(width: 36, height: 64)), cornerRadius: 8).cgPath
        //contentView.setCorners(corners: 9)
    }
    
    func setSelect(isSelect : Bool, animate : Bool = true) {
        UIView.animate(withDuration: animate ? 0.2 : 0,delay: 0, options: .curveLinear, animations: {
            self.selectBg.transform = CGAffineTransform(scaleX: isSelect ? 1 : 0.75, y: isSelect ? 1 : 0.75)
            
            self.linesView.subviews[0].backgroundColor = isSelect ? getAppColor(color: .select) : getAppColor(color: .disable)
            self.linesView.subviews[1].backgroundColor = isSelect ? getAppColor(color: .select) : getAppColor(color: .disable)
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

extension FramePreviewCell : UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
         return UIPointerStyle(effect: .lift(UITargetedPreview(view: self)))
     }
}

class ControlList : UICollectionViewLayout {
    private var spacing = 0
    
    var attributes : [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
           return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0) * 42 + (collectionView!.numberOfItems(inSection: 0) - 1) * spacing), height: CGFloat(collectionView!.bounds.height))
    }
    
    override func prepare() {
        attributes.removeAll()
        
        for item in 0..<collectionView!.numberOfItems(inSection: 0){
            let index = IndexPath(item: item, section: 0)
            let frame = CGRect(x: item * 42 + item * spacing, y: 0, width: 42, height: 70)
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
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return attributes[indexPath.item]
    }
}
