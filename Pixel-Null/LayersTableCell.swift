//
//  LayerstableCell.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 16.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class LayersTableCell : UICollectionViewCell {
    
    var delegate: LayersTableDelegate? = nil
    
    private var isUpdateImageMode : Bool = false
        
    lazy private var background : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = getAppColor(color: .content)
        
        view.addSubview(previewBackground)
        previewBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        previewBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
        view.setCorners(corners: 8,curveType: .continuous)
        
        view.addSubview(layerName)

        layerName.leftAnchor.constraint(equalTo: previewBackground.rightAnchor, constant: 6).isActive = true
        layerName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        layerName.topAnchor.constraint(equalTo: previewBackground.topAnchor, constant: 0).isActive = true
        
        return view
    }()
    
    lazy private var previewBackground : UIView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 36).isActive = true
        view.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addSubviewFullSize(view: previewImageBack)
        view.setCorners(corners: 8,needMask: true)
        return view
    }()
    
    lazy private var previewImage : UIImageView = {
        let image = UIImageView()
        image.layer.magnificationFilter = .nearest
        image.contentMode = .scaleAspectFit
        
        image.addSubviewFullSize(view: unvisibleImage)
        return image
    }()
    
    lazy private var unvisibleImage : UIImageView = {
        let image = UIImageView()
        image.setCorners(corners: 8)
        image.image = #imageLiteral(resourceName: "unvisible_icon").withRenderingMode(.alwaysOriginal)
        image.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return image
    }()
    
    lazy private var previewImageBack : UIImageView = {
        let image = UIImageView()
        image.layer.magnificationFilter = .nearest
        image.image = #imageLiteral(resourceName: "background")
        image.setCorners(corners: 8)
        
        image.addSubviewFullSize(view: previewImage)
        
        return image
    }()
    
    lazy private var layerName : UITextField = {
        let label = UITextField()
        label.text = "New layer"
        label.font = UIFont(name: UIFont.appBlack, size: 16)
        label.textColor = getAppColor(color: .enable)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        label.delegate = self
        
        label.isEnabled = false

        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onRenameDone))
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onRenameCancel))

        let bar = UIToolbar()
        bar.items = [done,cancel]
        bar.sizeToFit()

        label.inputAccessoryView = bar
        
        return label
    }()
    
    lazy private var settingsButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true

        btn.addTarget(self, action: #selector(onSettings), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviewFullSize(view: background)
        
        contentView.layoutIfNeeded()
        contentView.isUserInteractionEnabled = true
        background.isUserInteractionEnabled = true
    }
    
    func StartRename() {
        layerName.isEnabled = true
        layerName.becomeFirstResponder()
    }
    
    @objc func onRenameDone(){
        delegate?.finishRenaming(newName: layerName.text!)
        layerName.isEnabled = false
    }
    
    @objc func onRenameCancel(){
        delegate?.onCancelRenaming()
        layerName.isEnabled = false
    }
    
    @objc func onSettings() {
        
    }
    
    func setSelected(isSelect : Bool, anim : Bool) {
        layerName.textColor = isSelect ? getAppColor(color: .select) : getAppColor(color: .enable)
        
    }
    
    func setName(name: String){
        layerName.text = name
    }
    
    func setPreview(image : UIImage) {
        previewImage.image = image
    }
    
    func setBgColor(color : UIColor) {
        previewImage.backgroundColor = color
    }
    
    func setVisible(isVisible : Bool, animate : Bool) {
        UIView.animate(withDuration: animate ? 0.2 : 0, animations: {
            self.unvisibleImage.alpha = isVisible ? 0 : 1
        })
    }
    
    func isVisibleName(isVisible: Bool){
        layerName.alpha = isVisible ? 1 : 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension LayersTableCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.changeNamelayer()
    }
}
