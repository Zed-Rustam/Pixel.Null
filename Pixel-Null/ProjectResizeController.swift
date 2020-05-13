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
    
    lazy private var titleBg : UIView = {
        let view = UIView()
        view.setCorners(corners: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.addSubviewFullSize(view: view)
        
        mainview.addSubview(cancelBtn)
        mainview.addSubview(appendBtn)
        mainview.addSubview(titleText)

        cancelBtn.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 0).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true

        appendBtn.rightAnchor.constraint(equalTo: mainview.rightAnchor, constant: 0).isActive = true
        appendBtn.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true

        titleText.leftAnchor.constraint(equalTo: cancelBtn.rightAnchor, constant: 0).isActive = true
        titleText.rightAnchor.constraint(equalTo: appendBtn.leftAnchor, constant: 0).isActive = true
        titleText.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true

        return mainview
    }()
    
    lazy private var titleText : UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 42).isActive = true
        text.textColor = UIColor(named: "enableColor")
        text.font = UIFont(name: "Rubik-Bold", size: 24)
        text.text = NSLocalizedString("Project resize", comment: "")
        text.adjustsFontSizeToFitWidth = true
        text.textAlignment = .center
        
        return text
    }()
    
    lazy private var cancelBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "cancel_icon"), frame: .zero,icScale: 0.35)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.corners = 12
        btn.setShadowColor(color: .clear)
        btn.delegate = {[unowned self] in
            self.delegate(false)
            self.dismiss(animated: true, completion: nil)
        }
        
        return btn
    }()
    
    lazy private var appendBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero,icScale: 0.35)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.corners = 12
        btn.setShadowColor(color: .clear)
        btn.delegate = {[unowned self] in
            self.project?.resize(newSize: CGSize(width: Int(self.widthTextField.filed.text!)!, height: Int(self.heightTextField.filed.text!)!), scale: self.scaleToggle.isCheck, alignment: self.alignmentSelector.alignment)
            self.delegate(true)
            self.dismiss(animated: true, completion: nil)
        }
        
        return btn
    }()
    
    lazy private var widthTextField : TextField = {
        let text = TextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.filed.text = "\(Int(project!.projectSize.width))"
        text.filed.keyboardType = .numberPad
        return text
    }()
    
    lazy private var heightTextField : TextField = {
        let text = TextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.filed.text = "\(Int(project!.projectSize.height))"
        text.filed.keyboardType = .numberPad
        return text
    }()
    
    lazy private var AlignmentTitle : UILabel = {
        let text = UILabel()
        text.textColor = UIColor(named: "enableColor")
        text.font = UIFont(name: "Rubik-Medium", size: 20)
        text.text = NSLocalizedString("Alignment", comment: "")
        text.adjustsFontSizeToFitWidth = true
        //text.numberOfLines = 1
        //text.minimumScaleFactor = 2
        text.translatesAutoresizingMaskIntoConstraints = false
        
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        text.widthAnchor.constraint(equalToConstant: 126).isActive = true
        
        return text
    }()

    
    lazy private var WidthTitle : UILabel = {
        let text = UILabel()
        text.textColor = UIColor(named: "enableColor")
        text.font = UIFont(name: "Rubik-Medium", size: 20)
        text.text = NSLocalizedString("Width", comment: "")
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return text
    }()
    
    lazy private var HeightTitle : UILabel = {
        let text = UILabel()
        text.textColor = UIColor(named: "enableColor")
        text.font = UIFont(name: "Rubik-Medium", size: 20)
        text.text = NSLocalizedString("Height", comment: "")
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return text
    }()

    lazy private var ScaleContentTitle : UILabel = {
        let text = UILabel()
        text.textColor = UIColor(named: "enableColor")
        text.font = UIFont(name: "Rubik-Medium", size: 20)
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
    
    override func viewDidLayoutSubviews() {
        titleBg.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 0.25)
    }
    
    override func viewDidLoad() {
        view.addSubview(titleBg)

        view.addSubview(widthTextField)
        view.addSubview(heightTextField)
        //view.addSubview(sizeStack)
        
        view.addSubview(ScaleContentTitle)
        view.addSubview(scaleToggle)

        view.addSubview(AlignmentTitle)
        view.addSubview(WidthTitle)
        view.addSubview(HeightTitle)

        view.addSubview(alignmentSelector)

        titleBg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        titleBg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        titleBg.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        titleBg.heightAnchor.constraint(equalToConstant: 42).isActive = true

        widthTextField.leftAnchor.constraint(equalTo: alignmentSelector.rightAnchor, constant: 8).isActive = true
        widthTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        widthTextField.topAnchor.constraint(equalTo: alignmentSelector.topAnchor, constant: 0).isActive = true
        
        heightTextField.leftAnchor.constraint(equalTo: alignmentSelector.rightAnchor, constant: 8).isActive = true
        heightTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        heightTextField.bottomAnchor.constraint(equalTo: alignmentSelector.bottomAnchor, constant: 0).isActive = true
        
        ScaleContentTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        ScaleContentTitle.rightAnchor.constraint(equalTo: scaleToggle.leftAnchor, constant: -12).isActive = true
        ScaleContentTitle.topAnchor.constraint(equalTo: alignmentSelector.bottomAnchor, constant: 6).isActive = true
        
        scaleToggle.centerYAnchor.constraint(equalTo: ScaleContentTitle.centerYAnchor).isActive = true
        scaleToggle.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -12).isActive = true

        AlignmentTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        //AlignmentTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        AlignmentTitle.topAnchor.constraint(equalTo: titleBg.bottomAnchor, constant: 8).isActive = true
        
        alignmentSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        alignmentSelector.topAnchor.constraint(equalTo: AlignmentTitle.bottomAnchor, constant: 0).isActive = true
        
        WidthTitle.leftAnchor.constraint(equalTo: widthTextField.leftAnchor, constant: 8).isActive = true
        WidthTitle.bottomAnchor.constraint(equalTo: widthTextField.topAnchor, constant: 0).isActive = true
        
        HeightTitle.leftAnchor.constraint(equalTo: heightTextField.leftAnchor, constant: 8).isActive = true
        HeightTitle.bottomAnchor.constraint(equalTo: heightTextField.topAnchor, constant: 0).isActive = true

        view.backgroundColor = UIColor(named: "backgroundColor")!
    }
}
