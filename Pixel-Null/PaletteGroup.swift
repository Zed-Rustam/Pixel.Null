//
//  PaletteGroup.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 18.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PaletteGroup: UICollectionViewCell {
    
    var delegate: PalleteGalleryDelegate? = nil
    
    var palette: PalleteWorker? = nil
    
    var isSystem: Bool = false
    
    lazy private var bg: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "background"))
        view.layer.magnificationFilter = .nearest
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCorners(corners: 12,needMask: true)
        
        view.addSubviewFullSize(view: palettePreview)
        
        return view
    }()
    
    lazy private var palettePreview: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.magnificationFilter = .nearest
        img.contentMode = .scaleAspectFill

        return img
    }()
    
    lazy private var paletteName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        lbl.textColor = getAppColor(color: .enable)
        lbl.textAlignment = .center
        lbl.lineBreakMode = .byTruncatingMiddle
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        return lbl
    }()
    
    private func makeColorImage(pallete : PalleteWorker) -> UIImage{
        var width = Int(sqrt(Double(palette!.colors.count)))
        
        if width * width < palette!.colors.count {
            width += 1
        }
        
        if width > 16 {
            width = 16
        }
        
        let height = width
        
        let size = CGSize(width: width, height: height)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        var colorsCount = palette!.colors.count
        if colorsCount > 256 {
            colorsCount = 256
        }
        
        let img = renderer.image{context in
            for i in 0..<colorsCount {
                UIColor(hex : pallete.colors[i])!.setFill()
                context.fill(CGRect(x: i % Int(size.width), y: i / Int(size.width), width: 1, height: 1))
            }
        }
        
        return img
    }
    
    func setPalette(newPal: PalleteWorker){
        palette = newPal
        palettePreview.image = makeColorImage(pallete: palette!)
        paletteName.text = newPal.palleteName
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviewFullSize(view: bg,paddings: (0,0,0,-24))
        contentView.addSubview(paletteName)
        
        paletteName.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        paletteName.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        paletteName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        bg.isUserInteractionEnabled = true
        bg.addInteraction(UIContextMenuInteraction(delegate: self))
        
        contentView.layoutIfNeeded()
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: bg.bounds, cornerRadius: 12).cgPath
    }
    
    override func tintColorDidChange() {
        contentView.layoutIfNeeded()
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: bg.bounds, cornerRadius: 12).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PaletteGroup : UIContextMenuInteractionDelegate {
func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    
    let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider:{() -> UIViewController? in
        let full = PalleteFull()
        full.setPallete(pal: self.palette!)
        return full
        }) {action in
        let clone = UIAction(title: "Clone",image : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
            self.delegate?.clonePallete(pallete : self.palette!)
        })
                
        let share = UIAction(title: "Share",image : UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
            self.delegate?.palleteShare(pallete: self.palette!)
        })
                
        let delete = UIAction(title: "Delete",image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
            self.delegate?.deletePallete(pallete: self.palette!)
        })
                
        let delMenu = UIMenu(title: "Delete", image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, options : .destructive, children: [delete])
                
        let edit = UIMenu(title: "", options: .displayInline, children: [delMenu])
        
        if self.isSystem {
            return UIMenu(title: self.palette!.palleteName, image: nil, identifier: nil, children: [clone])
        } else {
            return UIMenu(title: self.palette!.palleteName, image: nil, identifier: nil, children: [clone,share,edit])
        }
        
    }

    return configuration

    }
}
