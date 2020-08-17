//
//  layersTable.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 16.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.

import UIKit

class LayersTable : UICollectionView {
    let layout = LayersTableLayout()
    
    var renamingLayer: Int = -1
    var renamingMode: Bool = false
    
    weak var project : ProjectWork? = nil
    weak var frameDelegate : FrameControlUpdate? = nil
    var contextingIndex : Int? = nil
    
    init(project proj : ProjectWork, delegateFrame : FrameControlUpdate?) {
        project = proj
        frameDelegate = delegateFrame
        super.init(frame: .zero, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        isPrefetchingEnabled = false
        
        dragDelegate = self
        dropDelegate = self
        dragInteractionEnabled = true
        
        register(LayersTableCell.self, forCellWithReuseIdentifier: "Layer")
        
        backgroundColor = .clear
        
        self.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        self.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        let keyboardsize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        if renamingMode {
        contentInset.bottom = keyboardsize - 118 + 24 - UIApplication.shared.windows[0].safeAreaInsets.bottom
        selectItem(at: IndexPath(row: renamingLayer, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LayersTable : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return project!.information.frames[project!.FrameSelected].layers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "Layer", for: indexPath) as! LayersTableCell
        cell.setSelected(isSelect: indexPath.item == project!.LayerSelected, anim: false)
        cell.setPreview(image: project!.getSmallLayer(frame: project!.FrameSelected, layer: indexPath.item, size: CGSize(width: 36, height: 36)))
        cell.setSelected(isSelect: project!.LayerSelected == indexPath.item, anim: false)
        cell.setBgColor(color: project!.backgroundColor)
        cell.setVisible(isVisible: project!.information.frames[project!.FrameSelected].layers[indexPath.item].visible, animate: false)
        cell.delegate = self
        cell.isVisibleName(isVisible: (renamingMode && indexPath.item != renamingLayer) ? false : true)
        cell.setName(name: project!.information.frames[project!.FrameSelected].layers[indexPath.item].name ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if renamingMode && renamingLayer == indexPath.item {
            (cell as! LayersTableCell).StartRename()
        }
    }
}

extension LayersTable : UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        contextingIndex = indexPath.item
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider:nil ) {action in
                let clone = UIAction(title: "Clone",image : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                    self.project?.addAction(action: ["ToolID" : "\(Actions.layerClone.rawValue)", "frame" : "\(self.project!.FrameSelected)", "layer" : "\(self.project!.LayerSelected)"])

                    self.frameDelegate?.cloneLayer(frame: self.project!.FrameSelected, original: indexPath.item)
                })

                let rename = UIAction(title: "Rename",image : UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                    
                    self.frameDelegate?.onRenameLayerModeStart(isStart: true)
                    self.renamingLayer = indexPath.item
                    self.renamingMode = true
                    self.reloadData()
                    
                    self.isUserInteractionEnabled = false

                })

                
                let merge = UIAction(title: "Merge with bottom layer",image : UIImage(systemName: "link", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                    if self.project!.layerCount > 1 && indexPath.item != self.project!.layerCount - 1 {
                        self.project!.addAction(action: ["ToolID" : "\(Actions.mergeLayers.rawValue)",
                            "frame" : "\(self.project!.FrameSelected)",
                            "layer" : "\(indexPath.item)",
                            "firstLayerOpasity" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[indexPath.item].transparent)",
                            "secondLayerOpasity" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[indexPath.item + 1].transparent)",
                            "isFirstLayerVisible" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[indexPath.item].visible)",
                            "isSecondLayerVisible" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[indexPath.item + 1].visible)",
                        ])

                        try! self.project!.getLayer(frame: self.project!.FrameSelected, layer: indexPath.item).pngData()?.write(to: self.project!.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-first-\(self.project!.getNextActionID()).png"))
                        try! self.project!.getLayer(frame: self.project!.FrameSelected, layer: indexPath.item + 1).pngData()?.write(to: self.project!.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-second-\(self.project!.getNextActionID()).png"))

                        self.project!.mergeLayers(frame: self.project!.FrameSelected, layer: indexPath.item)
                        self.frameDelegate?.margeLayers(frame: self.project!.FrameSelected, layer: indexPath.item)
                    }
                })
                
                let visible = UIAction(title: self.project!.information.frames[self.project!.FrameSelected].layers[indexPath.item].visible ? "Make unvisible" : "Make visible",image : UIImage(systemName: self.project!.information.frames[self.project!.FrameSelected].layers[indexPath.item].visible ? "eye.slash" : "eye", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                    self.frameDelegate?.changeLayerVisible(frame: self.project!.FrameSelected, layer: indexPath.item)
                    self.project!.addAction(action: ["ToolID" : "\(Actions.layerVisibleChange.rawValue)", "frame" : "\(self.project!.FrameSelected)", "layer" : "\(indexPath.item)"])
                })
                
                

                let delete = UIAction(title: "Delete",image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in

                    self.project?.addAction(action: ["ToolID" : "\(Actions.layerDelete.rawValue)","frame" : "\(self.project!.FrameSelected)", "layer" : "\(indexPath.item)", "wasVisible" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[indexPath.item].visible)", "transparent" : "\(self.project!.information.frames[self.project!.FrameSelected].layers[indexPath.item].transparent)"])

                    try! self.project?.getLayer(frame: self.project!.FrameSelected, layer: indexPath.item).pngData()?.write(to: self.project!.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(self.project!.getNextActionID()).png"))

                    self.frameDelegate?.deleteLayer(frame: self.project!.FrameSelected, layer: indexPath.item)
                })

                let delMenu = UIMenu(title: "Delete", image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, options : .destructive, children: [delete])

                let edit = UIMenu(title: "", options: .displayInline, children: [delMenu])


                var menu : [UIMenuElement] = []

                if self.project!.layerCount != 16 {
                    menu.append(clone)
                }
                menu.append(visible)
                menu.append(rename)

                if indexPath.item != self.project!.layerCount - 1 {
                    menu.append(merge)
                }

                if self.project!.layerCount > 1 {
                    menu.append(edit)
                }

                return UIMenu(title: "", image: nil, identifier: nil, children: menu)
            }
        return configuration
    }

    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        if (contextingIndex != nil && self.cellForItem(at: IndexPath(item: contextingIndex!, section: 0)) != nil) {
            let target = UITargetedPreview(view: collectionView.cellForItem(at: IndexPath(item: contextingIndex!, section: 0))!)
            target.parameters.backgroundColor = .clear
            target.parameters.visiblePath = UIBezierPath(roundedRect: collectionView.cellForItem(at: IndexPath(item: contextingIndex!, section: 0))!.bounds, cornerRadius: 8)

            return target
        } else {
            return nil
        }
    }

    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let target = UITargetedPreview(view: collectionView.cellForItem(at: IndexPath(item: contextingIndex!, section: 0))!)
        target.parameters.visiblePath = UIBezierPath(roundedRect: collectionView.cellForItem(at: IndexPath(item: contextingIndex!, section: 0))!.bounds, cornerRadius: 8)
        return target
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? LayersTableCell
        cell?.setSelected(isSelect: true, anim: true)
        
        frameDelegate!.changeLayer(newLayer: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? LayersTableCell
        cell?.setSelected(isSelect: false, anim: true)
    }
}

extension LayersTable : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.localObject = ("Layer", self)
        return [item]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: self.cellForItem(at: indexPath)!.bounds, cornerRadius: 8)
        
        return parameters
    }
}

extension LayersTable : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        switch coordinator.proposal.operation {
        case .move:
            if let destinationIndexPath = coordinator.destinationIndexPath {
                let sourceIndexPath = coordinator.items[0].sourceIndexPath!
                
                if sourceIndexPath.item < project!.LayerSelected && destinationIndexPath.item >= project!.LayerSelected {
                    project!.LayerSelected -= 1
                } else if sourceIndexPath.item  > project!.LayerSelected && destinationIndexPath.item <= project!.LayerSelected {
                    project!.LayerSelected += 1
                } else if sourceIndexPath.item == project!.LayerSelected {
                    project!.LayerSelected = destinationIndexPath.item
                }
                
                if sourceIndexPath.item != destinationIndexPath.item {
                    project?.addAction(action: ["ToolID" : "\(Actions.layerReplace.rawValue)","frame" : "\(project!.FrameSelected)", "from" : "\(sourceIndexPath.item)", "to" : "\(destinationIndexPath.item)"])
                }
                
                frameDelegate?.updateLayerPosition(frame: project!.FrameSelected, from: sourceIndexPath.item, to: destinationIndexPath.item)
                
                performBatchUpdates({
                    collectionView.deleteItems(at: [coordinator.items[0].sourceIndexPath!])
                    collectionView.insertItems(at: [coordinator.destinationIndexPath!])
                }, completion: {isEnd in
                    collectionView.selectItem(at: IndexPath(item: self.project!.LayerSelected, section: 0), animated: false, scrollPosition: .left)
                })
                
                self.dragInteractionEnabled = false
                coordinator.drop(coordinator.items[0].dragItem, toItemAt: coordinator.destinationIndexPath!)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if (session.localDragSession?.items[0].localObject as! (str: String, collection: UICollectionView)) == ("Layer", self) {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden, intent: .unspecified)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let params = UIDragPreviewParameters()
        params.backgroundColor = .clear
        params.visiblePath = UIBezierPath(roundedRect: (collectionView.cellForItem(at: indexPath)!).bounds, cornerRadius: 8)
        return params
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        self.dragInteractionEnabled = true
    }
}

class LayersTableLayout : UICollectionViewLayout {
    var attributes : [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(collectionView!.bounds.width), height: CGFloat(6 + 42 * collectionView!.numberOfItems(inSection: 0)))
    }
    
    func layout() {
        let width = collectionView!.frame.width - 48
        
        for item in 0..<collectionView!.numberOfItems(inSection: 0) {
            let index = IndexPath(item: item, section: 0)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = CGRect(x: 24, y: 42 * item, width: Int(width), height: 36)
            
            attributes.append(attribute)
        }
    }
    
    override func prepare() {
        attributes.removeAll()
        
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

extension LayersTable: LayersTableDelegate{
    func changeNamelayer() {
        print("yes")
    }
    
    func finishRenaming(newName: String){
        
        project!.addAction(action: ["ToolID":"\(Actions.renameLayer.rawValue)","frame" : "\(project!.FrameSelected)","layer" : "\(renamingLayer)", "oldName" : project!.information.frames[project!.FrameSelected].layers[renamingLayer].name ?? "", "newName" : newName])

        project!.renameLayer(frame: project!.FrameSelected, layer: renamingLayer, newName: newName)

        renamingLayer = -1
        renamingMode = false
        
        reloadData()
        selectItem(at: IndexPath(row: project!.LayerSelected, section: 0), animated: false, scrollPosition: .left)

        self.frameDelegate?.onRenameLayerModeStart(isStart: false)
        self.contentInset.bottom = 24
        self.isUserInteractionEnabled = true
    }
    
    func onCancelRenaming() {
        renamingLayer = -1
        renamingMode = false
        
        reloadData()
        selectItem(at: IndexPath(row: project!.LayerSelected, section: 0), animated: false, scrollPosition: .left)

        self.frameDelegate?.onRenameLayerModeStart(isStart: false)
        self.contentInset.bottom = 24
        self.isUserInteractionEnabled = true
    }
}


protocol LayersTableDelegate: class{
    func changeNamelayer()
    func finishRenaming(newName: String)
    func onCancelRenaming()
}
