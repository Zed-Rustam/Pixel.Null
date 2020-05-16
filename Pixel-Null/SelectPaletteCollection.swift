//
//  SelectPaletteCollection.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 16.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SelectPaletteCollection : UICollectionView {
    private var palettes : [String] = []
    private var layout = UICollectionViewFlowLayout()
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        register(SelectPaletteCell.self, forCellWithReuseIdentifier: "palette")
        delegate = self
        dataSource = self
        backgroundColor = .clear
        contentInset = UIEdgeInsets(top: 24, left: 8, bottom: 0, right: 8)
        
        let f = FileManager()
        do {
            let projs = try f.contentsOfDirectory(at: PalleteWorker.getDocumentsDirectory(),    includingPropertiesForKeys: nil)
           
            for i in 0..<projs.count  {
                var name : String = projs[i].lastPathComponent
                name.removeLast(10)
                palettes.append(name)
            }
        } catch {}
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
    }
}

extension SelectPaletteCollection : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return palettes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "palette", for: indexPath) as! SelectPaletteCell
        cell.setImage(pallete: PalleteWorker(fileName: palettes[indexPath.item]))
        
        return cell
    }
}

extension SelectPaletteCollection : UICollectionViewDelegate {
    
}


class SelectPaletteCell : UICollectionViewCell {
    lazy private var cellBg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviewFullSize(view: bgPal)
        view.addSubviewFullSize(view: palette)

        return view
    }()
    
    lazy private var palette : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.magnificationFilter = .nearest
        img.setCorners(corners: 12)
        return img
    }()
    
    lazy private var bgPal : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.magnificationFilter = .nearest
        img.image = #imageLiteral(resourceName: "background")
        img.setCorners(corners: 12)
        return img
    }()
    
    lazy private var titleBg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.setCorners(corners: 8)
        
        view.addSubviewFullSize(view: paletteName, paddings: (6,-6,0,0))
        return view
    }()
    
    lazy private var paletteName : UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Rubik-Medium", size: 10)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        contentView.addSubviewFullSize(view: cellBg)
        
        contentView.addSubview(titleBg)
        
        titleBg.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        titleBg.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        titleBg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
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
        layoutIfNeeded()
        UIGraphicsBeginImageContext(cellBg.frame.size)
        print(contentView.frame)
        let context = UIGraphicsGetCurrentContext()!
        
        cellBg.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        
        //result = UIImage.merge(images: [result])!
        UIGraphicsEndImageContext()
        
        return result
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
    
    func setImage(pallete : PalleteWorker){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 16, height: 16))
     
        paletteName.text = pallete.palleteName
        
        let img = renderer.image{context in
            for i in 0..<pallete.colors.count {
                UIColor(hex : pallete.colors[i])!.setFill()
                context.fill(CGRect(x: i % 16, y: i / 16, width: 1, height: 1))
            }
        }
        
        palette.image = img
        
        titleBg.backgroundColor = UIColor(patternImage: blackImage(image: blurImage(image: getLayerImage(), forRect: CGRect(x: 8, y: 8, width: titleBg.frame.width, height: 16))!))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
