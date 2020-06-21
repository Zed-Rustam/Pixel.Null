//
//  ProjectViewNew.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 18.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectViewNew : UIView {
    weak var delegate : ProjectActions? = nil

    var project : ProjectWork? {
        get{
            return _project
        }
        set{
           // print("some mome \(newValue!.projectName)")
            _project = newValue
            contentImage.backgroundColor = _project!.backgroundColor
            contentImage.image = _project?.getFrame(frame: 0, size: _project!.projectSize).flip(xFlip: _project!.isFlipX, yFlip: _project!.isFlipY)
            
            let clr1 = self.getLayerImage()
            let clr2 = self.blurImage(image: clr1, forRect: CGRect(x: 8, y: 8, width: self.titleBg.frame.width, height: 16))!
            
            let clr3 = self.blackImage(image: clr2)
                
            self.titleBg.backgroundColor = UIColor(patternImage: clr3)
            titleLabel.text = self.projectName
        }
    }
    
    var projectName : String {
        get{
            var name = _project!.projectName
            name.removeLast(6)
            return name
        }
    }
    
    private var _project : ProjectWork? = nil
    
    lazy private var bg : UIImageView = {
       let image = UIImageView(image: #imageLiteral(resourceName: "background"))
        image.layer.magnificationFilter = .nearest
        image.contentMode = .scaleAspectFill
        
        image.addSubviewFullSize(view: contentImage)
        return image
    }()
    
    lazy private var contentImage : UIImageView = {
       let image = UIImageView()
        image.layer.magnificationFilter = .nearest
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy private var titleBg : UIView = {
        let bg = UIView()
        bg.setCorners(corners: 8)
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        bg.addSubviewFullSize(view: titleLabel, paddings: (8,-8,0,0))
        return bg
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Rubik-Medium", size: 10)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.setShadow(color: UIColor.black, radius: 3, opasity: 0.2)
        return label
    }()
    
    lazy private var pointer: UIPointerInteraction = {
        let point = UIPointerInteraction(delegate: self)
        
        return point
    }()
    
    func blurImage(image:UIImage, forRect rect: CGRect) -> UIImage? {
        let context = CIContext(options: nil)
        
        //let mainimg = UIImage(cgImage: image.cgImage!, scale: 0.01, orientation: .down)
        
        let inputImage = CIImage(cgImage: image.cgImage!)


        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue((8.0), forKey: kCIInputRadiusKey)
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
        
        context.setFillColor(UIColor.black.withAlphaComponent(0.1).cgColor)
        context.fill(CGRect(origin: .zero, size: image.size))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    func getLayerImage() -> UIImage {
        layoutIfNeeded()
        UIGraphicsBeginImageContext(layer.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        
        bg.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    init(){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviewFullSize(view: bg)
        addSubview(titleBg)
        
        titleBg.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        titleBg.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        titleBg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        isUserInteractionEnabled = true
        interactions.append(pointer)

        addInteraction(UIContextMenuInteraction(delegate: self))
        
        setCorners(corners: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProjectViewNew : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: {() -> UIViewController? in
            let image = ProjectFullImage()
            image.setProject(proj: self.project!)
            return image
            }
        ){ action in
            let rotate = UIAction(title: "Clone",image  : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                if(self.delegate != nil) {
                    self.delegate!.projectDublicate(view: self)
                }
            })
            let getimg = UIAction(title: "Share", image : UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)),identifier: nil, discoverabilityTitle: nil, handler: {action in
                self.delegate?.projectExport(proj: self._project!)
            })
            let delete = UIAction(title: "Delete",image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                if(self.delegate != nil) {
                    self.delegate!.projectDelete(view: self, deletedName: "\(self.projectName).pnart")
                }
            })
            let delMenu = UIMenu(title: "Delete", image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, options : .destructive, children: [delete])
            
            let edit = UIMenu(title: "", options: .displayInline, children: [delMenu])
            
            return UIMenu(title: self.projectName, image: nil, identifier: nil, children: [rotate,getimg,edit])
        }
        
        return configuration
    }
    
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
//        let preview = UITargetedPreview(view: interaction.view!, parameters: UIPreviewParameters(), target: UIPreviewTarget(container: self, center: self.center))
//        preview.parameters.backgroundColor = .black
//        preview.parameters.visiblePath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12)
//
//        return preview
//    }
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
//        let preview = UITargetedPreview(view: self, parameters: UIPreviewParameters(), target: UIPreviewTarget(container: self, center: self.center))
//        preview.parameters.backgroundColor = .black
//        preview.parameters.visiblePath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12)
//        return preview
//    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        animator?.addAnimations {
            
        }
    }
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
//        animator?.addAnimations {
//            //interaction
//        }
//    }
}

extension ProjectViewNew : UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        return UIPointerStyle(effect: .lift(UITargetedPreview(view: self)))
    }
}
