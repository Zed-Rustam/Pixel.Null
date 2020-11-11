//
//  SubBar.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 02.11.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SubBar: UIView {
    
    private var buttons: [UIButton] = []
    
    var offset: CGFloat = 0
    
    lazy private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 36, height: 36)
        layout.minimumInteritemSpacing = 0
        
        let cl = UICollectionView(frame: .zero,collectionViewLayout: layout)
        cl.translatesAutoresizingMaskIntoConstraints = false
        
        cl.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cl.dataSource = self
        
        cl.backgroundColor = .clear
        
        return cl
    }()
    
    init() {        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .appBackground
        setCorners(corners: 12,curveType: .continuous,activeCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        addSubviewFullSize(view: collection, paddings: (12,-12,6,-18))
    }
    
    override func layoutSubviews() {
        setShadow(color: .appShadow, radius: 12, opasity: 1)
    }
    
    func setButtons(btns: [UIButton]) {
        if buttons.count == 0 {
            buttons = btns
            collection.reloadData()
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: btns.count == 0 ? 96 + self.offset : self.offset)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 96 + self.offset)
            }, completion: {isEnd in
                self.buttons = btns
                self.collection.reloadData()
                
                if self.buttons.count != 0 {
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                        self.transform = CGAffineTransform(translationX: 0, y: self.offset)
                    }, completion: nil)
                }
            })
        }
    }
    
    func updateState() {
        if buttons.count == 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 96 + self.offset)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: self.offset)
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SubBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        buttons[indexPath.item].backgroundColor = getAppColor(color: .background)
        cell.contentView.addSubviewFullSize(view: buttons[indexPath.item])
        
        return cell
    }
}
