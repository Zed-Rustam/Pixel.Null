//
//  ColorPallete.swift
//  new Testing
//
//  Created by Рустам Хахук on 14.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ColorPallete : UIView {
    //задний фон в виде сетки
    private var bgView : UIImageView!
    //сами цвета
    private var colorsView : UIImageView!
    //паллитра
    var pallete : PalleteWorker
    //превью цветов
    private var colorsImage : UIImage!
    //блюр для названия
    private var blur : UIVisualEffectView!
    //название паллитры
    private var title : UILabel!
    
    weak var delegate : PalleteGalleryDelegate? = nil
    
    private var tapGesture : UITapGestureRecognizer!
    
    
    private func titleInit(){
        title = UILabel(frame: CGRect(x: 16, y: frame.height - 24, width: frame.width - 32, height: 16))
        title?.text = pallete.palleteName
        title?.textAlignment = .center
        title?.textColor = .white
        title.lineBreakMode = .byTruncatingMiddle
        title.textAlignment = .center
        title.layer.masksToBounds = false
        title.font = UIFont(name:  "Rubik-Medium", size: 10)
    }
    
    private func blurInit(){
        blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        blur?.frame = CGRect(x: 8, y: frame.height - 24, width: frame.width - 16, height: 16)
        blur?.layer.masksToBounds = true
        blur?.layer.cornerRadius = 8
    }
    
    private func bgInit(){
        let img = UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1 / (frame.width / 2) * colorsImage!.size.width, orientation: .down)
        bgView = UIImageView(frame: self.bounds)
        bgView.backgroundColor = UIColor(patternImage: img)
        bgView?.layer.magnificationFilter = .nearest
    }
    
    private func colorsInit(){
        colorsView = UIImageView(frame : self.bounds)
        colorsView?.layer.magnificationFilter = .nearest
        colorsView?.image = colorsImage
    }
    
    init(width: CGFloat, pallete p : PalleteWorker) {
        pallete = p
        colorsImage = ColorPallete.makeColorImage(pallete: pallete)

        let size = CGSize(width : width, height : width * (colorsImage.size.height / colorsImage.size.width))
        super.init(frame: CGRect(origin: .zero, size: size))
        
        bgInit()
        colorsInit()
        blurInit()
        titleInit()
        
        addSubview(bgView)
        addSubview(colorsView)
        addSubview(blur)
        addSubview(title)

        setCorners(corners: 12)
        
        isUserInteractionEnabled = true
        addInteraction(UIContextMenuInteraction(delegate: self))
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func onTap(sender : UITapGestureRecognizer){
        delegate?.palleteOpen(item: self)
    }
    
    static func makeColorImage(pallete : PalleteWorker) -> UIImage{
        var width = Int(sqrt(Double(pallete.colors.count)))
                
        if pallete.colors.count > 1 && pallete.colors.count < 4  {
            width = 2
        } else if pallete.colors.count > Int(powf(Float(width + 1), 2)) - width - 1 {
            width += 1
        }
        
        var height = width
        
        if pallete.colors.count > Int(powf(Float(width),2)) && pallete.colors.count <= Int(powf(Float(width + 1),2)) - width - 1 {
            height += 1
        }
        
        let size = CGSize(width: width, height: height)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let img = renderer.image{context in
            for i in 0..<pallete.colors.count {
                UIColor(hex : pallete.colors[i])!.setFill()
                context.fill(CGRect(x: i % Int(size.width), y: i / Int(size.width), width: 1, height: 1))
            }
        }
        
        return img
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorPallete : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider:{() -> UIViewController? in
            let full = PalleteFull()
            full.setPallete(pal: self.pallete)
            return full
            }) {action in
                let viewMenu = UIAction(title: "Rename",image: UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: UIAction.Identifier(rawValue: "view")) {_ in

                }
                let clone = UIAction(title: "Clone",image : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                    self.delegate?.clonePallete(pallete : self.pallete)
                })
                
                let share = UIAction(title: "Share",image : UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                    self.delegate?.palleteShare(pallete: self.pallete)
                })
                
                let delete = UIAction(title: "Delete",image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                    self.delegate?.deletePallete(pallete: self.pallete)
                })
                
                let delMenu = UIMenu(title: "Delete", image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, options : .destructive, children: [delete])
                
                let edit = UIMenu(title: "", options: .displayInline, children: [delMenu])
                
                return UIMenu(title: self.pallete.palleteName, image: nil, identifier: nil, children: [viewMenu,clone,share,edit])
        }
        
        return configuration
    }
    
    
}
