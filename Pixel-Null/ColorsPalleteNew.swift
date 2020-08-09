//
//  ColorsPalleteNew.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 17.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ColorsPaletteNew : UIView {
    private var pallete : PalleteWorker? = nil

    lazy private var bg : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "background")
        view.contentMode = .scaleAspectFill
        view.layer.magnificationFilter = .nearest
        view.addSubviewFullSize(view: contentImage)
        return view
    }()
    
    lazy private var contentImage : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.magnificationFilter = .nearest
        return view
    }()
    
    lazy private var titleBg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.setCorners(corners: 8)
        view.addSubviewFullSize(view: titleLabel, paddings: (8,-8,0,0))
        return view
    }()
    
    lazy private var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Rubik-Medium", size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    weak var delegate : PalleteGalleryDelegate? = nil

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

    func setPallete(newPallete : PalleteWorker, width : Int) {
        layoutIfNeeded()
        pallete = newPallete
        contentImage.image = ColorsPaletteNew.makeColorImage(pallete: pallete!)
        titleBg.backgroundColor = UIColor(patternImage: blackImage(image: blurImage(image: getLayerImage(), forRect: CGRect(x: 8, y: 8, width: titleBg.frame.width, height: 16))!))
        titleLabel.text = pallete!.palleteName
    }
    
    func blurImage(image:UIImage, forRect rect: CGRect) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(cgImage: image.cgImage!)


        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue((4.0), forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage

        var cgImage:CGImage?

        if let asd = outputImage {
            cgImage = context.createCGImage(asd, from: rect)
        }

        if let cgImageA = cgImage {
            return UIImage(cgImage: cgImageA)
        }

        return nil
    }
    
    func blackImage(image : UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()!
        image.draw(at: .zero)
        
        context.setFillColor(UIColor.black.withAlphaComponent(0.25).cgColor)
        context.fill(CGRect(origin: .zero, size: image.size))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    func getLayerImage() -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        
        bg.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviewFullSize(view: bg)
        addSubview(titleBg)
        
        titleBg.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        titleBg.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        titleBg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        setCorners(corners: 12,needMask: true)

        isUserInteractionEnabled = true
        addInteraction(UIContextMenuInteraction(delegate: self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ColorsPaletteNew : UIContextMenuInteractionDelegate {
func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    
    let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider:{() -> UIViewController? in
        let full = PalleteFull()
        full.setPallete(pal: self.pallete!)
        return full
        }) {action in
                let clone = UIAction(title: "Clone",image : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                    self.delegate?.clonePallete(pallete : self.pallete!)
                })
                
                let share = UIAction(title: "Share",image : UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                    self.delegate?.palleteShare(pallete: self.pallete!)
                })
                
                let delete = UIAction(title: "Delete",image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                    self.delegate?.deletePallete(pallete: self.pallete!)
                })
                
                let delMenu = UIMenu(title: "Delete", image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, options : .destructive, children: [delete])
                
                let edit = UIMenu(title: "", options: .displayInline, children: [delMenu])
                
                return UIMenu(title: self.pallete!.palleteName, image: nil, identifier: nil, children: [clone,share,edit])
            }
    
    return configuration

    }
}
