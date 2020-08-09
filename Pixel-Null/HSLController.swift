//
//  HSLController.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 07.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class HSLController: UIViewController {
    
    weak var delegate: ColorDelegate? = nil
    
    lazy private var circle: HSLCircle = {
        let view = HSLCircle()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy private var dark: ColorSlider = {
        let d = ColorSlider(startColor: .black, endColor: .white, orientation: .horizontal)
        
        d.translatesAutoresizingMaskIntoConstraints = false
        d.heightAnchor.constraint(equalToConstant: 36).isActive = true
        d.setPosition(pos: 1)
        d.preview = .none
        
        return d
    }()
    
    lazy private var transp: ColorSlider = {
        let d = ColorSlider(startColor: UIColor.white.withAlphaComponent(0), endColor: .white, orientation: .horizontal)
        
        d.translatesAutoresizingMaskIntoConstraints = false
        d.heightAnchor.constraint(equalToConstant: 36).isActive = true
        d.setPosition(pos: 1)
        d.preview = .none
        
        return d
    }()

    override func viewDidLoad() {        
        view.addSubview(circle)
        view.addSubview(dark)
        view.addSubview(transp)

        circle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        circle.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        circle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
        
        circle.delegate = {color in
            self.dark.resetGradient(start: .black, end: color)
            self.transp.resetGradient(start: self.dark.resultColor.withAlphaComponent(0), end: self.dark.resultColor)
            self.delegate?.changeColor(newColor: self.transp.resultColor, sender: self)
            print(self.transp.resultColor)
        }
        
        dark.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        dark.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        dark.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 12).isActive = true
        
        dark.delegate = {color in
            self.transp.resetGradient(start: self.dark.resultColor.withAlphaComponent(0), end: self.dark.resultColor)
            self.delegate?.changeColor(newColor: self.transp.resultColor, sender: self)
        }
        
        transp.delegate = {color in
            self.delegate?.changeColor(newColor: self.transp.resultColor, sender: self)
        }
        
        transp.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        transp.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        transp.topAnchor.constraint(equalTo: dark.bottomAnchor, constant: 12).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        print("yes")
    }
}

extension HSLController: ColorSelectorDelegate {
    func setColor(color: UIColor) {
        circle.setColor(color: color)
        transp.setPosition(pos: Double(color.getComponents().alpha) / 255.0)
        dark.setPosition(pos: Double(max(color.getComponents().red,color.getComponents().green,color.getComponents().blue)) / 255.0)
        dark.resetGradient(start: .black, end: circle.color)
        transp.resetGradient(start: circle.color.withAlphaComponent(0), end: circle.color)
    }
}
