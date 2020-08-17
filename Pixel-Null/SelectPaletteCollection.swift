//
//  SelectPaletteCollection.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 16.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SelectPaletteCollection : UICollectionView {
    weak var mainController : PeletteSelectController? = nil
    
    private var palettes : [String] = []
    private var defaultPalettes : [String] = []
    
    private var layout = UICollectionViewFlowLayout()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        register(SelectPaletteCell.self, forCellWithReuseIdentifier: "palette")
        
        register(palettesTitle.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        layout.headerReferenceSize = CGSize(width: self.frame.size.width, height: 64)
        
        delegate = self
        dataSource = self
        backgroundColor = .clear
        contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
        
        let f = FileManager()
        do {
            let projs = try f.contentsOfDirectory(at: PalleteWorker.getDocumentsDirectory(),    includingPropertiesForKeys: nil)
           
            for i in 0..<projs.count  {
                var name : String = projs[i].lastPathComponent
                name.removeLast(10)
                palettes.append(name)
            }
        } catch {}
        
        defaultPalettes.append("Default pallete")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SelectPaletteCollection : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return defaultPalettes.count
        default:
            return palettes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = dequeueReusableCell(withReuseIdentifier: "palette", for: indexPath) as! SelectPaletteCell
            cell.contentView.frame.size = layout.layoutAttributesForItem(at: indexPath)!.frame.size
            cell.setImage(pallete: PalleteWorker(name: defaultPalettes[indexPath.row], colors: try! JSONDecoder().decode(Pallete.self, from: NSDataAsset(name: defaultPalettes[indexPath.row])!.data).colors, isSave: false))
            
            return cell
            
        default:
            let cell = dequeueReusableCell(withReuseIdentifier: "palette", for: indexPath) as! SelectPaletteCell
            cell.contentView.frame.size = layout.layoutAttributesForItem(at: indexPath)!.frame.size
            cell.setImage(pallete: PalleteWorker(fileName: palettes[indexPath.item]))
            
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! palettesTitle
            switch indexPath.section {
            case 0:
                headerView.title.text = "App's Palettes"
            default:
                headerView.title.text = "User's Palettes"
            }
            
        return headerView
        }
        fatalError()
    }
}

extension SelectPaletteCollection : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            mainController?.setSelectPalette(palette: try! JSONDecoder().decode(Pallete.self, from: NSDataAsset(name: defaultPalettes[indexPath.row])!.data).colors, name: defaultPalettes[indexPath.row])

        default:
            mainController?.setSelectPalette(palette: PalleteWorker(fileName: palettes[indexPath.item]).colors,name: PalleteWorker(fileName: palettes[indexPath.item]).palleteName)

        }
        
        mainController?.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        switch section {
        case 0:
            return defaultPalettes.count
        default:
            return palettes.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print("set size")
        return CGSize(width: self.frame.size.width, height: 64)
    }
}


class SelectPaletteCell : UICollectionViewCell {
    lazy private var cellBg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviewFullSize(view: bgPal)
        view.addSubviewFullSize(view: palette)

        view.setCorners(corners: 12,needMask: true)
        return view
    }()
    
    lazy private var palette : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.magnificationFilter = .nearest
        return img
    }()
    
    lazy private var bgPal : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.magnificationFilter = .nearest
        img.image = #imageLiteral(resourceName: "background")
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
    
    override func layoutSubviews() {
        cellBg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
        cellBg.layer.shadowPath = UIBezierPath(roundedRect: cellBg.bounds, cornerRadius: 12).cgPath
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
        UIGraphicsBeginImageContext(contentView.frame.size)
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

class palettesTitle : UICollectionReusableView {
    lazy var title : UILabel = {
        let label = UILabel()
        label.textColor = getAppColor(color: .enable)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        label.font = UIFont(name: "Rubik-Bold", size: 32)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("header created")
        addSubviewFullSize(view: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
