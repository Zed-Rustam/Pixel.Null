//
//  layersTable.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 16.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayersTable : UICollectionView {
    let layout = LayersTableLayout()
    
    weak var project : ProjectWork? = nil
    weak var frameDelegate : FrameControlDelegate? = nil
    var contextingIndex : Int? = nil
    
    init(project proj : ProjectWork, delegateFrame : FrameControlDelegate?) {
        project = proj
        frameDelegate = delegateFrame
        super.init(frame: .zero, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        isPrefetchingEnabled = false
        
        register(LayersTableCell.self, forCellWithReuseIdentifier: "Layer")
        
        backgroundColor = .clear
        self.setShadow(color: getAppColor(color: .shadow), radius: 6, opasity: 1)
        
        self.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.setShadow(color: getAppColor(color: .shadow), radius: 6, opasity: 1)
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
        return cell
    }
}

extension LayersTable : UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        contextingIndex = indexPath.item
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider:nil ) {action in
                       let clone = UIAction(title: "Clone",image : UIImage(systemName: "dublicate", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                              
                       })
            
                        let merge = UIAction(title: "Merge with bottom",image : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                   
                        })
            
                        let visible = UIAction(title: "Make visible",image : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                            
                        })
                       
                       let delete = UIAction(title: "Delete",image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                           
                       })

                       let delMenu = UIMenu(title: "Delete", image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, options : .destructive, children: [delete])

                       let edit = UIMenu(title: "", options: .displayInline, children: [delMenu])

                   return UIMenu(title: "", image: nil, identifier: nil, children: self.project!.information.frames.count > 1 ? [clone,merge,visible,edit] : [clone])
               }

           return configuration
       }

    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let target = UITargetedPreview(view: cellForItem(at: IndexPath(item: contextingIndex!, section: 0))!)
        target.parameters.backgroundColor = .clear
        target.parameters.visiblePath = UIBezierPath(roundedRect: cellForItem(at: IndexPath(item: contextingIndex!, section: 0))!.bounds, cornerRadius: 6)
        
        return target
    }

    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let target = UITargetedPreview(view: cellForItem(at: IndexPath(item: contextingIndex!, section: 0))!)
        target.parameters.visiblePath = UIBezierPath(roundedRect: cellForItem(at: IndexPath(item: contextingIndex!, section: 0))!.bounds, cornerRadius: 6)
        return target
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? LayersTableCell
        cell?.setSelected(isSelect: true, anim: true)
        //frameDelegate?.updateLayerSelect(lastLayer: <#T##Int#>, newLayer: <#T##Int#>)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? LayersTableCell
        cell?.setSelected(isSelect: false, anim: true)
    }
    
    
}

class LayersTableLayout : UICollectionViewLayout {
    var attributes : [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(collectionView!.bounds.width), height: CGFloat(6 + 42 * collectionView!.numberOfItems(inSection: 0)))
    }
    
    func layout() {
        let width = collectionView!.frame.width - 24
        
        for item in 0..<collectionView!.numberOfItems(inSection: 0) {
            let index = IndexPath(item: item, section: 0)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = CGRect(x: 12, y: 6 + 42 * item, width: Int(width), height: 36)
            
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
