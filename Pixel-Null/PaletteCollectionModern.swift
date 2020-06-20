//
//  PaletteCollectionModern.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 12.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PaletteCollectionModern : UICollectionView {
    var colors : [String]
    
    var palleteColors : [String] {
        get{
            return colors
        }
        set {
            colors = newValue
            reloadData()
        }
    }
    var moving : Bool = false
    
    private var layout = PalleteCollectionLayout(itemSize: 36, itemsSpacing: 0)

    private var selectedColor = 0

    init(colors clrs : [String]) {
        colors = clrs

        super.init(frame: .zero, collectionViewLayout:  layout)
        
        isPrefetchingEnabled = false

        register(PaletteCollectionCell.self, forCellWithReuseIdentifier: "Color")

        dataSource = self
        
        backgroundColor = .red
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaletteCollectionModern : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "Color", for: indexPath) as! PaletteCollectionCell
        cell.contentView.backgroundColor = UIColor(hex: colors[indexPath.item])
        
        return cell
    }
}

class PaletteCollectionCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaletteCollectionModern : PalleteCollectionDelegate {
    func cloneSelectedColor() {
        
    }
    
    func addColor(color: UIColor) {
        
    }
    
    func deleteSelectedColor() {
        
    }
    
    func changeSelectedColor(color: UIColor) {
        
    }
    
    func getSelectItemColor() -> UIColor {
        return UIColor.red
    }
    
    
}
