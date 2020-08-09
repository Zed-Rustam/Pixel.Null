//
//  ColorSelectController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 07.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ColorDialogController: UIViewController {
    
    private var resultColor: UIColor = .white
    
    var delegate: (UIColor) -> () = {color in}
    
    private var controllers: [UIViewController] = [
        HSLController(),
        ARGBController(),
        PaletteSelectController(),
    ]
    
    lazy private var navigation: NavigationView = {
        let nav = NavigationView(ics: [#imageLiteral(resourceName: "color_selector_1_icon"),#imageLiteral(resourceName: "color_selector_2_icon"),#imageLiteral(resourceName: "pallete_collection_item")])
        nav.translatesAutoresizingMaskIntoConstraints = false
        nav.widthAnchor.constraint(equalToConstant: 164).isActive = true
        nav.heightAnchor.constraint(equalToConstant: 42).isActive = true
        nav.listener = self
        return nav
    }()
    
    lazy private var selectButton: UIButton = {
        let btn = UIButton()
        
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12)
        
        btn.setImage(#imageLiteral(resourceName: "select_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        btn.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 42).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        btn.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        return btn
    }()
    
    lazy private var lastColor: UIView = {
        let last = UIView()
        last.translatesAutoresizingMaskIntoConstraints = false
        last.widthAnchor.constraint(equalToConstant: 42).isActive = true
        last.heightAnchor.constraint(equalToConstant: 42).isActive = true
        last.setCorners(corners: 12,curveType: .continuous)

        let mask = CAShapeLayer()
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: 42))
        path.addLine(to: CGPoint(x: 42, y: 42))
        path.close()
        
        mask.path = path.cgPath
        
        last.layer.mask = mask
        
        return last
    }()
    
    lazy private var newColor: UIView = {
        let last = UIView()
        last.translatesAutoresizingMaskIntoConstraints = false
        last.widthAnchor.constraint(equalToConstant: 42).isActive = true
        last.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        last.setCorners(corners: 12,curveType: .continuous)
        //last.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        
        let mask = CAShapeLayer()
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 42, y: 0))
        path.addLine(to: CGPoint(x: 42, y: 42))
        path.close()
        
        mask.path = path.cgPath
        
        last.layer.mask = mask

        return last
    }()
    
    lazy private var colorsView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 42).isActive = true
        view.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        view.addSubview(lastColor)
        view.addSubview(newColor)
        
        lastColor.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lastColor.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        newColor.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        newColor.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.setCorners(corners: 12,curveType: .continuous)
        
        view.backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 4.0 / 42.0, orientation: .down))
        view.layer.magnificationFilter = .nearest

        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        view.setCorners(corners: 32)
        view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        view.addSubview(navigation)
        view.addSubview(selectButton)
        view.addSubview(colorsView)

        navigation.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        navigation.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        selectButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23).isActive = true
        selectButton.topAnchor.constraint(equalTo: navigation.topAnchor).isActive = true
        
        colorsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        colorsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true

        controllers[0].view.isHidden = false
        controllers[1].view.isHidden = true
        controllers[2].view.isHidden = true
        
        setupControllers()
        changeColor(newColor: resultColor, sender: nil)
    }
    
    private func setupControllers() {
        (controllers[0] as! HSLController).delegate = self
        (controllers[1] as! ARGBController).delegate = self
        (controllers[2] as! PaletteSelectController).delegate = self
        
        for i in controllers {
            view.addSubview(i.view)
            i.view.translatesAutoresizingMaskIntoConstraints = false
            i.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            i.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            i.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            i.view.topAnchor.constraint(equalTo: navigation.bottomAnchor,constant: 12).isActive = true
            i.view.setNeedsLayout()
            i.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        navigation.setShadow(color: .clear, radius: 0, opasity: 0)
        
        colorsView.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        colorsView.layer.shadowPath = UIBezierPath(roundedRect: colorsView.bounds, cornerRadius: 12).cgPath
        
        selectButton.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        selectButton.layer.shadowPath = UIBezierPath(roundedRect: selectButton.bounds, cornerRadius: 12).cgPath
        
        
    }
    
    @objc func onPress(){
        delegate(resultColor)
        dismiss(animated: true, completion: nil)
    }
    
    func setStartColor(clr : UIColor){
        resultColor = clr
        lastColor.backgroundColor = resultColor
        newColor.backgroundColor = resultColor
    }
}

extension ColorDialogController: NavigationProtocol {
    func onSelectChange(select: Int, lastSelect: Int) {
        
        controllers[select].view.transform = CGAffineTransform(translationX: 0, y: 100)
        controllers[select].view.isHidden = false
        controllers[select].view.alpha = 0
        
        controllers[lastSelect].view.isHidden = false
        controllers[lastSelect].view.alpha = 1
        controllers[lastSelect].view.transform = CGAffineTransform(translationX: 0, y: 0)

        UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseInOut, animations: {
            self.controllers[lastSelect].view.alpha = 0
            self.controllers[select].view.alpha = 1
        })
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.controllers[lastSelect].view.transform = CGAffineTransform(translationX: 0, y: -100)
            
            self.controllers[select].view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: {isEnd in
            if lastSelect != self.navigation.select {
                self.controllers[lastSelect].view.alpha = 1
                self.controllers[lastSelect].view.transform = CGAffineTransform(translationX: 0, y: 0)
                self.controllers[lastSelect].view.isHidden = true
            }
        })
    }
}

extension ColorDialogController: ColorDelegate {
    func changeColor(newColor: UIColor, sender: ColorSelectorDelegate?) {
        resultColor = newColor
        self.newColor.backgroundColor = resultColor
        
        for i in controllers {
            if !i.isEqual(sender) || sender == nil {
                (i as? ColorSelectorDelegate)?.setColor(color: newColor)
            }
        }
    }
}
