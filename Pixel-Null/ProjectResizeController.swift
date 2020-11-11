//
//  ProjectResizeController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 02.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectResizeController : UIViewController {
    
    weak var project : ProjectWork? = nil
    
    var delegate : (Bool)->() = {isEnd in}
    
    lazy private var alignmentSelector : AlignmentSelector = {
       let selector = AlignmentSelector()
        
        return selector
    }()
    
    
    lazy private var titleText : UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        text.textColor = getAppColor(color: .enable)
        text.font = UIFont(name: UIFont.appBlack, size: 42)
        text.text = NSLocalizedString("Resize", comment: "")
        text.adjustsFontSizeToFitWidth = true
        text.textAlignment = .center
        
        return text
    }()
    
    lazy private var appendBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.setBackgroundImage(UIImage(size: CGSize(width: 8, height: 8), bgColor: getAppColor(color: .enable)), for: .normal)
        btn.setBackgroundImage(UIImage(size: CGSize(width: 8, height: 8), bgColor: getAppColor(color: .backgroundLight)), for: .disabled)
        
        btn.setTitleColor(getAppColor(color: .background), for: .normal)
        btn.setTitleColor(getAppColor(color: .disable), for: .disabled)

        btn.titleLabel?.font = UIFont(name: UIFont.appBlack, size: 20)
        
        btn.addTarget(self, action: #selector(onSave), for: .touchUpInside)

        btn.setCorners(corners: 12, needMask: true, curveType: .continuous)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 128).isActive = true
        return btn
    }()
    
    lazy private var widthTextField : UITextField = {
        let field = UITextField()
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.textColor = getAppColor(color: .enable)
        field.setCorners(corners: 12)
        field.delegate = sizedel
        field.keyboardType = .numberPad
        field.font = UIFont(name: UIFont.appBold, size: 20)
        
        field.text = "\(Int(project!.projectSize.width))"
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        field.attributedPlaceholder = NSAttributedString(string: "\(Int(project!.projectSize.width))",attributes: [NSAttributedString.Key.foregroundColor: getAppColor(color: .disable)])

        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        return field
    }()
    
    lazy private var heightTextField : UITextField = {
        let field = UITextField()
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.textColor = getAppColor(color: .enable)
        field.setCorners(corners: 12)
        field.delegate = sizedel
        field.keyboardType = .numberPad
        field.font = UIFont(name: UIFont.appBold, size: 20)
        
        field.text = "\(Int(project!.projectSize.height))"
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        field.attributedPlaceholder = NSAttributedString(string: "\(Int(project!.projectSize.height))",attributes: [NSAttributedString.Key.foregroundColor: getAppColor(color: .disable)])

        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        return field
    }()
    
    lazy private var AlignmentTitle : UILabel = {
        let text = UILabel()
        text.textColor = getAppColor(color: .enable)
        text.font = UIFont(name: UIFont.appBold, size: 20)
        text.text = NSLocalizedString("Alignment", comment: "")
        text.adjustsFontSizeToFitWidth = true
        //text.numberOfLines = 1
        //text.minimumScaleFactor = 2
        text.translatesAutoresizingMaskIntoConstraints = false
        
        text.widthAnchor.constraint(equalToConstant: 108).isActive = true
        
        return text
    }()

    lazy private var sizedel : TextFieldDelegate = {
        let delegate = TextFieldDelegate(method: {field in
            let height = Int(field.text!) ?? -1
            if(height > 512) {
                field.text = "512"
            } else if(height == -1 && field.text != ""){
               field.text = ""
            } else if(height == -1){
                field.text = ""
            }else if(height == 0){
                field.text = ""
            }else{
                //self.projectHeight.error = nil
            }
        })
        return delegate
    }()
    
    lazy private var WidthTitle : UILabel = {
        let text = UILabel()
        text.textColor = getAppColor(color: .enable)
        text.font = UIFont(name: UIFont.appBold, size: 20)
        text.text = NSLocalizedString("Width", comment: "")
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    lazy private var HeightTitle : UILabel = {
        let text = UILabel()
        text.textColor = getAppColor(color: .enable)
        text.font = UIFont(name: UIFont.appBold, size: 20)
        text.text = NSLocalizedString("Height", comment: "")
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()

    lazy private var ScaleContentTitle : UILabel = {
        let text = UILabel()
        text.textColor = UIColor(named: "enableColor")
        text.font = UIFont(name: UIFont.appBold, size: 20)
        text.text = NSLocalizedString("Scale content", comment: "")
        text.adjustsFontSizeToFitWidth = true

        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return text
    }()
    
    lazy private var scaleToggle : ToggleView = {
        let toggle = ToggleView()
        return toggle
    }()
    
    
    @objc private func onSave() {
        project!.resize(newSize: CGSize(width: Int(widthTextField.text ?? "") ?? Int(project!.projectSize.width),
                        height: Int(heightTextField.text ?? "") ?? Int(project!.projectSize.height)),
                        scale: scaleToggle.isCheck, alignment: alignmentSelector.alignment)
        
        delegate(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        view.setCorners(corners: 32)
        
        view.addSubview(titleText)
        view.addSubview(appendBtn)

        view.addSubview(widthTextField)
        view.addSubview(heightTextField)
        
        view.addSubview(ScaleContentTitle)
        view.addSubview(scaleToggle)
        
        view.addSubview(AlignmentTitle)
        view.addSubview(WidthTitle)
        view.addSubview(HeightTitle)

        view.addSubview(alignmentSelector)

        titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        titleText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        appendBtn.topAnchor.constraint(equalTo: scaleToggle.bottomAnchor, constant: 24).isActive = true
        appendBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true

        widthTextField.leftAnchor.constraint(equalTo: alignmentSelector.rightAnchor, constant: 16).isActive = true
        widthTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        widthTextField.topAnchor.constraint(equalTo: alignmentSelector.topAnchor, constant: 0).isActive = true
        
        heightTextField.leftAnchor.constraint(equalTo: alignmentSelector.rightAnchor, constant: 16).isActive = true
        heightTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        heightTextField.bottomAnchor.constraint(equalTo: alignmentSelector.bottomAnchor, constant: 0).isActive = true
        
        ScaleContentTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        ScaleContentTitle.rightAnchor.constraint(equalTo: scaleToggle.leftAnchor, constant: -12).isActive = true
        ScaleContentTitle.topAnchor.constraint(equalTo: alignmentSelector.bottomAnchor, constant: 12).isActive = true
        
        scaleToggle.centerYAnchor.constraint(equalTo: ScaleContentTitle.centerYAnchor).isActive = true
        scaleToggle.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -24).isActive = true

        AlignmentTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        AlignmentTitle.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 24).isActive = true
        
        alignmentSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        alignmentSelector.topAnchor.constraint(equalTo: AlignmentTitle.bottomAnchor, constant: 6).isActive = true
        
        WidthTitle.leftAnchor.constraint(equalTo: widthTextField.leftAnchor, constant: 0).isActive = true
        WidthTitle.bottomAnchor.constraint(equalTo: widthTextField.topAnchor, constant: -6).isActive = true
        
        HeightTitle.leftAnchor.constraint(equalTo: heightTextField.leftAnchor, constant: 0).isActive = true
        HeightTitle.bottomAnchor.constraint(equalTo: heightTextField.topAnchor, constant: -6).isActive = true

        view.backgroundColor = getAppColor(color: .background)
    }
}
