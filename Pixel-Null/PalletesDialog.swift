//
//  PalletesDialog.swift
//  new Testing
//
//  Created by Рустам Хахук on 12.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalletesDialog: UIView {

    weak var controller : UIViewController? = nil
    
    lazy private var palleteTitle : UILabel = {
        let label = UILabel()
        
        label.textColor = getAppColor(color: .enable)
        label.textAlignment = .left
        label.font = UIFont(name:  "Rubik-Medium", size: 18)
        label.text = NSLocalizedString("Default palette", comment: "")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return label
    }()
    
    lazy private var palleteSelect : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "pallete_collection_item"), frame: .zero)
        btn.setShadowColor(color: .clear)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        btn.delegate = {[unowned self] in
            let paletteSel = PeletteSelectController()
            paletteSel.modalPresentationStyle = .formSheet
            
            paletteSel.selectDelegate = {[unowned self] in
                self.setColors(newColors: $0.colors)
                self.palleteTitle.text = $1
            }
            
            self.controller?.show(paletteSel, sender: nil)
        }
        return btn
    }()
    
    lazy private var PalleteBar : UIView = {
        let mainview = UIView()
        
        let subview = UIView()
        subview.setCorners(corners: 12)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = getAppColor(color: .background)
        
        mainview.addSubview(subview)
        mainview.addSubview(palleteTitle)
        mainview.addSubview(palleteSelect)
        
        subview.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 0).isActive = true
        subview.rightAnchor.constraint(equalTo: mainview.rightAnchor, constant: 0).isActive = true
        subview.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true
        subview.bottomAnchor.constraint(equalTo: mainview.bottomAnchor, constant: 0).isActive = true

        palleteSelect.centerYAnchor.constraint(equalTo: mainview.centerYAnchor, constant: 0).isActive = true
        palleteSelect.rightAnchor.constraint(equalTo: mainview.rightAnchor, constant: -4).isActive = true
        
        palleteTitle.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 8).isActive = true
        palleteTitle.rightAnchor.constraint(equalTo: palleteSelect.leftAnchor, constant: -8).isActive = true
        palleteTitle.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true
        
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return mainview
    }()
    
    lazy var collection : PalleteCollectionV2 = {
        let clrs = PalleteCollectionV2(colors: try! JSONDecoder().decode(Pallete.self, from: NSDataAsset(name: "Default pallete")!.data).colors)
        clrs.setEnableMoving(enable: false)
        clrs.layer.masksToBounds = true
        
        clrs.colorDelegate = {[unowned self] in
            self.colorSelected = $0
        }
        
        (clrs.collectionViewLayout as! PalleteCollectionLayout).topOffset = 16
        (clrs.collectionViewLayout as! PalleteCollectionLayout).bottomOffset = 16
        return clrs
    }()
    
    func setColors(newColors : [String]) {
        collection.palleteColors = newColors
    }
   
    lazy var colorSelected : UIColor = collection.getSelectItemColor()
    
    init() {
        super.init(frame: .zero)

        addSubview(collection)
        addSubview(PalleteBar)
        
        PalleteBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        PalleteBar.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        PalleteBar.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
               
        collection.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        collection.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        collection.topAnchor.constraint(equalTo: PalleteBar.bottomAnchor, constant: -8).isActive = true
        collection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        
        translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        PalleteBar.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
