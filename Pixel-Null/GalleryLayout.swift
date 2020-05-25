//
//  GalleryLayout.swift
//  new Testing
//
//  Created by Рустам Хахук on 08.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GalleryLayout : UICollectionViewLayout{
    var columnsCount = 0
    var padding = 12.0
    var spacing = 12.0
    weak var delegate : GalleryDelegate? = nil
    var columnsHeights : [Double] = []
    var bottomOffset = 0.0
    var attributes : [UICollectionViewLayoutAttributes] = []
    
    var contentWidth : Double {
        return Double(collectionView!.bounds.width)
    }
    
    var contentHeight = 0.0
    
    override var collectionViewContentSize: CGSize {
    
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    func setData(columnsCount count : Int, delegate del : GalleryDelegate){
        columnsCount = count
        delegate = del
    }
    
    override func prepare() {
        attributes.removeAll()
        columnsHeights.removeAll()
        for _ in 0..<columnsCount {
            columnsHeights.append(Double(padding) + Double(UIApplication.shared.windows[0].safeAreaInsets.top))
        }
        
        let itemWidth : Double = (contentWidth - padding * 2.0 - spacing * (Double(columnsCount) - 1.0)) / Double(columnsCount)
        for item in 0..<collectionView!.numberOfItems(inSection: 0){
            let index = IndexPath(item: item, section: 0)

            if(delegate?.getItemClass(indexItem: index) == "Project"){
            let itemHeight = delegate!.getItemHeight(indexItem: index) * itemWidth
            let ypos = columnsHeights.min()! + spacing
            let xpos = padding + (Double(columnsHeights.firstIndex(of: columnsHeights.min()!)!) * (itemWidth)) + (Double(columnsHeights.firstIndex(of: columnsHeights.min()!)!) * spacing);

            let frame = CGRect(x: xpos, y: ypos, width: itemWidth, height: itemHeight)
            
            columnsHeights[columnsHeights.firstIndex(of: columnsHeights.min()!)!] += itemHeight + spacing
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = frame
            attributes.append(attribute)
            
            } else if (delegate?.getItemClass(indexItem: index) == "Title"){
                let titleHeight = 52.0
                let maxcolumn = columnsHeights.max()!
                
                let frame = CGRect(x: padding, y: maxcolumn, width: contentWidth - padding * 2.0, height: titleHeight)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
                attribute.frame = frame
                attributes.append(attribute)
                
                for i in 0..<columnsHeights.count {
                    columnsHeights[i] = maxcolumn + titleHeight
                }
            }
        } 
        
        contentHeight = columnsHeights.max()! - spacing + padding + bottomOffset
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
