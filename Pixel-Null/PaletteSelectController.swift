//
//  PaletteSelectController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 07.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PaletteSelectController: UIViewController {
    
    weak var delegate: ColorDelegate? = nil
    weak var parentController: UIViewController? = nil
    
    lazy private var paletteTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Default palette"
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .black)
        lbl.textAlignment = .left
        lbl.textColor = getAppColor(color: .enable)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return lbl
    }()
    
    lazy private var selectPalette: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "Palette").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        
        btn.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        btn.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return btn
    }()
    
    
    lazy private var colorPalette: PaletteCollectionModern = {
        let palette = PaletteCollectionModern(colors: try! JSONDecoder().decode(Pallete.self, from: NSDataAsset(name: "Default pallete")!.data).colors)
        
        palette.disableDragAndDrop()
        
        palette.colorDelegate = {[unowned self] in
            self.delegate?.changeColor(newColor: $0, sender: self)
        }
        
        palette.translatesAutoresizingMaskIntoConstraints = false
        
        return palette
    }()
    
    override func viewDidLoad() {
        view.addSubview(paletteTitle)
        view.addSubview(selectPalette)

        paletteTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        paletteTitle.rightAnchor.constraint(equalTo: selectPalette.leftAnchor, constant: -24).isActive = true
        paletteTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
        selectPalette.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        selectPalette.topAnchor.constraint(equalTo: paletteTitle.topAnchor).isActive = true
        
        view.addSubview(colorPalette)
        colorPalette.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        colorPalette.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        colorPalette.topAnchor.constraint(equalTo: paletteTitle.bottomAnchor, constant: 12).isActive = true
        colorPalette.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func onPress() {
        let paletteSel = PaletteSelectorNavigation()
        paletteSel.modalPresentationStyle = .formSheet
        
        paletteSel.selection.selectDelegate = {[unowned self] in
            colorPalette.palleteColors = $0.colors
            colorPalette.removeSelection()
            paletteTitle.text = $1
        }
        
        parentController?.present(paletteSel, animated: true, completion: nil)
    }
}

extension PaletteSelectController: ColorSelectorDelegate {
    func setColor(color: UIColor) {
        print("change")
        colorPalette.removeSelection()
    }
}
