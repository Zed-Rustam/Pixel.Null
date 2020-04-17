//
//  ToolBarCollection.swift
//  new Testing
//
//  Created by Рустам Хахук on 22.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ToolBarCollection : UICollectionView {
    var tools : [Int] = []
    private var layout = ToolBarLayout()
    weak var project : ProjectWork!
    weak var editorDelegate : FrameControlDelegate!
    weak var barDelegate : ToolBarDelegate!

    init(frame : CGRect, tools t : [Int]){
        tools = t
        
        super.init(frame: frame, collectionViewLayout: layout)
        register(ToolButton.self, forCellWithReuseIdentifier: "Tool")
        
        self.delegate = self
        self.dataSource = self
        
        self.backgroundColor = .clear
        
        self.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToolBarCollection : UICollectionViewDelegate {

}

extension ToolBarCollection : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tool", for: indexPath) as! ToolButton
        cell.setToolID(id: tools[indexPath.item])
        cell.project = project
        cell.delegate = editorDelegate
        cell.barDelegate = barDelegate
        return cell
    }
}

class ToolBarLayout : UICollectionViewLayout {
    private var attributes : [UICollectionViewLayoutAttributes] = []
    private var contentHeight = 0
    private var spacing : Int = 6
    private var offsetWidth : Int = 8
    private var offsetBottom : Int = 8
    private var offsetTop : Int = 8

    private var itemSize : Int = 32
    
    var contentWidth : Int {
        return Int(collectionView!.bounds.width)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
       
        attributes.removeAll()
        
        var columnsCount = ((Int(collectionView!.bounds.width) - offsetWidth * 2) / (itemSize))
        print(columnsCount)
        
        spacing = ((Int(collectionView!.bounds.width) - offsetWidth * 2) - (itemSize * columnsCount)) / (columnsCount - 1)
        
        if spacing < 8 {
            columnsCount -= 1
            spacing = ((Int(collectionView!.bounds.width) - offsetWidth * 2) - (itemSize * columnsCount)) / (columnsCount - 1)
        }
        
        print("spacing : \(spacing)")
        
        attributes.removeAll()
                
        for item in 0..<collectionView!.numberOfItems(inSection: 0){
            let index = IndexPath(item: item, section: 0)
            let frame = CGRect(x: offsetWidth + (itemSize + spacing) * (item % columnsCount) - spacing / 2, y: offsetTop + (itemSize + spacing) * (item / columnsCount) - spacing / 2, width: itemSize + spacing, height: itemSize + spacing)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = frame
            attributes.append(attribute)
        }
        contentHeight = itemSize + spacing + itemSize * (collectionView!.numberOfItems(inSection: 0) / columnsCount) + spacing * (collectionView!.numberOfItems(inSection: 0) / columnsCount) + offsetTop + offsetBottom
        
        //print("now \(contentHeight)")
        //collectionView!.removeConstraint(collectionView!.heightAnchor.constraint(equalTo: collectionView!.heightAnchor))
        collectionView?.constraints.forEach({item in
            if item.firstAttribute == .height {
                item.constant = CGFloat(contentHeight)
            }
        })
        //collectionView!.heightAnchor.constraint(equalToConstant: CGFloat(contentHeight)).isActive = true
        //(collectionView!.numberOfItems(inSection: 0) / columnsCount) * (itemSize + spacing) + offsetTop  + (collectionView!.numberOfItems(inSection: 0) % columnsCount != 0 ? (itemSize + spacing) : 0) + offsetBottom + 48 + 12
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
    
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        return attributes[indexPath.item]
    }
}
