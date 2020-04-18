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
    private var spacing : Int = 0
    private var offsetWidth : Int = 0
    private var offsetBottom : Int = 0
    private var offsetTop : Int = 0
    var columnsCount = 0
    private var itemSize : Int = 36
    
    var contentWidth : Int {
        return Int(collectionView!.bounds.width)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
       
        attributes.removeAll()
        
        columnsCount = ((Int(collectionView!.bounds.width)) / (itemSize))
        print(columnsCount)
        
        offsetWidth = Int(CGFloat(Int(collectionView!.bounds.width) - (columnsCount) * itemSize) / 2.0)
        
        print("spacing : \(spacing)")
        
        attributes.removeAll()
                
        for item in 0..<collectionView!.numberOfItems(inSection: 0){
            let index = IndexPath(item: item, section: 0)
            let frame = CGRect(x: offsetWidth + itemSize * (item % columnsCount), y: offsetTop + (itemSize) * (item / columnsCount), width: itemSize, height: itemSize)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
            attribute.frame = frame
            attributes.append(attribute)
        }
        contentHeight = Int(CGFloat(itemSize) * CGFloat(ceil(CGFloat(collectionView!.numberOfItems(inSection: 0)) / CGFloat(columnsCount))))
        print("Very very check")

        print(contentHeight)
        collectionView?.constraints.forEach({item in
            if item.firstAttribute == .height {
                item.constant = CGFloat(contentHeight) + 8
            }
        })
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
