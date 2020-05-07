//
//  PalleteFull.swift
//  new Testing
//
//  Created by Рустам Хахук on 15.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalleteFull : UIViewController {
    private var pallete : PalleteWorker!
    
    private var bgView : UIView = {
        let bg = UIView()
        bg.layer.magnificationFilter = CALayerContentsFilter.nearest
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()
    
    private var colorsView : UIImageView = {
        let img = UIImageView()
        img.layer.magnificationFilter = CALayerContentsFilter.nearest
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    func setPallete(pal : PalleteWorker){
        pallete = pal
    }
    
    override func viewDidLoad() {
        preferredContentSize.height = view.frame.width
        
        colorsView.image = makeImage()
        view.addSubview(bgView)
        view.addSubview(colorsView)
    }
    
    override func viewDidLayoutSubviews() {
        
        bgView.backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 32 / view.frame.size.width, orientation: .down))
        
        bgView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        bgView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        colorsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        colorsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        colorsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        colorsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func makeImage() -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 16, height: 16))
        
        let img = renderer.image{context in
            for i in 0..<pallete.colors.count {
                UIColor(hex : pallete.colors[i])!.setFill()
                context.fill(CGRect(x: i % 16, y: i / 16, width: 1, height: 1))
            }
        }
        
        return img
    }
}
