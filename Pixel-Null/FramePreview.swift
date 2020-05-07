//
//  FramePreview.swift
//  new Testing
//
//  Created by Рустам Хахук on 27.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FramePreview : UIView {
    private var bg : UIImageView
    private static var bgImg = #imageLiteral(resourceName: "background")
    private var img : UIImageView
    private weak var picToImg : UIImage?
    private var visibility = true
    private var bgVisible : UIView
    private var imageVisible : UIImageView
    
    var isVisible : Bool {
        get{
            return visibility
        }
    }
    
    var bgColor : UIColor {
        get{
            return img.backgroundColor!
        } set{
            img.backgroundColor = newValue
        }
    }
    
    func setVisible(isVisible : Bool,anim : Bool = true){
        visibility = isVisible
        
        if visibility {
            UIView.animate(withDuration: anim ? 0.2 : 0.0){
                self.bgVisible.alpha = 0
                self.imageVisible.alpha = 0
            }
        } else {
            UIView.animate(withDuration: anim ? 0.2 : 0.0){
                self.bgVisible.alpha = 1
                self.imageVisible.alpha = 1
           }
        }
    }
    
    var image : UIImage? {
        get{
            return picToImg
        }
        set {
            picToImg = newValue
            img.image = picToImg
        }
    }
    
    init(frame: CGRect, image : UIImage) {
        bg = UIImageView(image: FramePreview.bgImg)
        picToImg = image
        
        img = UIImageView(image: picToImg!)

        
        bgVisible = UIView(frame: CGRect(origin: .zero, size: frame.size))
        bgVisible.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        imageVisible = UIImageView(image: #imageLiteral(resourceName: "unvisible_icon"))
        imageVisible.frame = CGRect(origin: .zero, size: frame.size)
        imageVisible.tintColor = .white
        
        bgVisible.alpha = 0
        imageVisible.alpha = 0
        
        super.init(frame: frame)
        
        bg.frame = bounds
        img.frame = bounds
        
        bg.contentMode = .scaleAspectFill
        bg.layer.magnificationFilter = CALayerContentsFilter.nearest
        
        img.contentMode = .scaleAspectFit
        img.layer.magnificationFilter = CALayerContentsFilter.nearest
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        addSubview(bg)
        addSubview(img)

        addSubview(bgVisible)
        addSubview(imageVisible)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

