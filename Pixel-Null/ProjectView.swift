//
//  ProjectView.swift
//  new Testing
//
//  Created by Рустам Хахук on 07.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectView : UIView{
    weak var delegate : ProjectActions? = nil
    
    private var _image : UIImageView = UIImageView()
    private var proj : ProjectWork!
    private var background : UIImageView = UIImageView(image: #imageLiteral(resourceName: "background"))
    private var title : UILabel = UILabel()
    private var rounded = 12
    private var blurView : UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    //UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    weak var superController : UIViewController? = nil
    
    private var tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
    
    var image : UIImage {
        get{
            _image.image!
        }
        set{
            _image.image = newValue
        }
    }
    
    var projectName : String {
        get {
            return title.text!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurFilter = CIFilter(name: "CIGaussianBlur",parameters: [kCIInputRadiusKey: 2])
        
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
        
        self.addSubview(background)
        self.addSubview(_image)
        self.addSubview(blurView)
        self.addSubview(title)
        self.backgroundColor = .clear
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        addGestureRecognizer(tapGesture)
        
        setCorners(corners: CGFloat(rounded))        
    }
    
    func blurImage(image:UIImage, forRect rect: CGRect) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(cgImage: image.cgImage!)


        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue((2.0), forKey: kCIInputRadiusKey)
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
        
        context.setFillColor(UIColor.black.withAlphaComponent(0.2).cgColor)
        context.fill(CGRect(origin: .zero, size: image.size))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    func getLayerImage() -> UIImage {
        UIGraphicsBeginImageContext(_image.layer.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        
        background.layer.render(in: context)
        var result = UIGraphicsGetImageFromCurrentImageContext()!

        _image.layer.render(in: context)
        result = UIImage.merge(images: [result, UIGraphicsGetImageFromCurrentImageContext()!])!
        UIGraphicsEndImageContext()
        
        return result
    }
    
    required init?(coder: NSCoder) {
        super.init(coder : coder)
    }

    func setData(proj : ProjectWork,width : Double){
        self.proj = proj
        var k = Double(proj.projectSize.height / proj.projectSize.width)
                
        if k > 1.5 {
            k = 1.5
        } else if k < 0.75 {
            k = 0.75
        }
        
        self.bounds = CGRect(x: 0, y: 0, width: width, height: width * k)
        self.frame = self.bounds
        
        background.layer.magnificationFilter = CALayerContentsFilter.nearest
        background.frame = self.bounds
        background.contentMode = .scaleAspectFill
        
        _image.image = proj.getFrame(frame: 0, size: self.frame.size)
        _image.backgroundColor = proj.backgroundColor
        _image.layer.magnificationFilter = CALayerContentsFilter.nearest
        _image.frame = self.bounds
        _image.contentMode = .scaleAspectFill
  
        blurView.frame = CGRect(x: 8, y: Int(Double(self.bounds.height) - Double(8) * 3), width: Int(self.bounds.width) - 8 * 2, height: 8 * 2)
        blurView.setCorners(corners: CGFloat(8))
        blurView.image = blackImage(image: blurImage(image: getLayerImage(), forRect: CGRect(x: 8, y: 8, width: Int(self.bounds.width) - 8 * 2, height: 8 * 2))!)
        
        title.frame = CGRect(x: 16, y: Int(Double(self.bounds.height) - Double(8) * 3), width: Int(self.bounds.width) - 8 * 4, height: 8 * 2)
        title.text = proj.projectName
        title.textColor = .white
        title.lineBreakMode = .byTruncatingMiddle
        title.textAlignment = .center
        title.font = UIFont(name:  "Rubik-Medium", size: 10)
    }
    
    @objc func onTap(sender : UITapGestureRecognizer){
        delegate?.projectOpen(proj: proj)
    }
    
    override func layoutSubviews() {
        blurView.image = blackImage(image: blurImage(image: getLayerImage(), forRect: CGRect(x: 8, y: 8, width: Int(self.bounds.width) - 8 * 2, height: 8 * 2))!)
    }
}

extension ProjectView : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: {() -> UIViewController? in
            let image = ProjectFullImage()
            image.setProject(proj: self.proj)
            return image
            }
        ){ action in
            let rotate = UIAction(title: "Clone",image  : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                if(self.delegate != nil) {
                    self.delegate!.projectDublicate(view: self)
                }
            })
            let getimg = UIAction(title: "Get Image", image : UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)),identifier: nil, discoverabilityTitle: nil, handler: {action in
                var array : [UIImage] = []
                for i in 0..<self.proj.information.frames.count {
                    array.append(self.proj.getFrame(frame: i, size: self.proj.projectSize))
                }
                UIImage.animatedGif(from: array)
            })
            
            let delete = UIAction(title: "Delete",image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                if(self.delegate != nil) {
                    self.delegate!.projectDelete(view: self, deletedName: self.title.text!)
                }
            })
            
                        
            let delMenu = UIMenu(title: "Delete", image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, options : .destructive, children: [delete])
            
            let edit = UIMenu(title: "", options: .displayInline, children: [delMenu])
            
            return UIMenu(title: self.projectName, image: nil, identifier: nil, children: [rotate,getimg,edit])
        }
        
        return configuration
    }
    
}
