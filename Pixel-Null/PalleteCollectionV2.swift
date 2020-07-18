//
//  PalleteCollectionV2.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 25.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

//MARK: Palette Collection Layout
class PalleteCollectionLayout : UICollectionViewLayout {
    //size of item
    var itemSize : CGFloat = 44
    var itemsCountInLine: Int = 0
    var itemsCountInColumn: Int = 0

    var topOffset : CGFloat = 24
    var bottomOffset : CGFloat = 60

    //attributes of items
    private var attributes : [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    private var contentSize : CGSize = .zero
    
    init(itemSize size : CGFloat = 44, itemsSpacing : CGFloat = 4) {
        itemSize = size
        super.init()
    }
    
    override func prepare() {
        layout()
    }
    
    //calculate items attributes
    private func layout() {
        //clear all attributes
        attributes.removeAll()
        //count items of one row
        let rowCount = floor((collectionView!.bounds.width) / (itemSize))
        
        itemsCountInLine = Int(rowCount)
        itemsCountInColumn = Int(ceil(CGFloat(collectionView!.numberOfItems(inSection: 0)) / rowCount))
        
        //offset for centerize items
        let offset = (collectionView!.bounds.width - itemSize * rowCount) / 2.0
        
        //set attributes
        for item in 0..<collectionView!.numberOfItems(inSection: 0) {
            let itemAttribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            let itemFrame : CGRect = CGRect(origin: CGPoint(x: offset + itemSize * CGFloat(item % Int(rowCount)),y: topOffset + (floor(CGFloat(item) / rowCount)) * itemSize),
                                            size: CGSize(width: itemSize, height: itemSize))
            
            itemAttribute.frame = itemFrame
            
            attributes.append(itemAttribute)
        }
        
        contentSize = CGSize(width: collectionView!.bounds.width,
                             height: topOffset + ceil(CGFloat(collectionView!.numberOfItems(inSection: 0)) / rowCount) * itemSize + bottomOffset)
    }
    
    //get visible attributes
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Palette Collection Cell
class PalleteColorCell : UICollectionViewCell {
    //color setter and getter
    var color : UIColor {
        get{
            return colorView.subviews[0].backgroundColor!
        }
        set{
            colorView.subviews[0].backgroundColor = newValue
        }
    }
    
    //color view
    lazy private var colorView : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        mainView.isOpaque = true
        
        mainView.setCorners(corners: 12)
        mainView.layer.magnificationFilter = .nearest
        
        mainView.tintColor = .clear
        
        let color = UIView()
        color.backgroundColor = .clear
        color.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(color)
        color.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        color.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        color.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        color.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        
        return mainView
    }()
    
    lazy private var selectStroke : UIView = {
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.backgroundColor = .clear
        mainview.setShadow(color: getAppColor(color: .select), radius: 4, opasity: 0.25)
        
        mainview.widthAnchor.constraint(equalToConstant: 44).isActive = true
        mainview.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let stroke = UIView()
        stroke.layer.borderColor = getAppColor(color: .select).cgColor
        stroke.layer.borderWidth = 3
        stroke.setCorners(corners: 18)
        stroke.translatesAutoresizingMaskIntoConstraints = false
        stroke.backgroundColor = .clear
        stroke.widthAnchor.constraint(equalToConstant: 44).isActive = true
        stroke.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        mainview.addSubview(stroke)
        stroke.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 0).isActive = true
        stroke.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true

        return mainview
    }()
    
    //show and hide select scroke
    func setVisible(visible : Bool, withAnim : Bool = true) {
        UIView.animate(withDuration: withAnim ? 0.25 : 0.0, animations: {
            self.selectStroke.alpha = visible ? 1 : 0
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        contentView.addSubview(selectStroke)
        
        colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        
        selectStroke.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        selectStroke.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        setVisible(visible: false, withAnim: false)
        
        isOpaque = true
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorView.backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 0.25, orientation: .down))
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Palette Collection Delegate
//protocol for working with collection
protocol PalleteCollectionDelegate : class {
    func cloneSelectedColor()
    func addColor(color : UIColor)
    func deleteSelectedColor()
    func changeSelectedColor(color : UIColor)
    func getSelectItemColor() -> UIColor
}
