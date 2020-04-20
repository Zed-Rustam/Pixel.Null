//
//  ProjectControl.swift
//  new Testing
//
//  Created by Рустам Хахук on 27.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectControl : UIView, UIGestureRecognizerDelegate {
    
    private var isHide = false
    
    lazy var layers : LayersView = {
        return LayersView(frame: .zero, proj: project)
    }()
    lazy var frames : FramesView = {
        return FramesView(frame: .zero, proj: project)
    }()
    
    lazy private var swipeUpGesture : UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        swipe.delaysTouchesBegan = false
        //swipe.numberOfTouchesRequired = 1
        swipe.direction = .up
        
        return swipe
    }()
    
    lazy private var swipeDownGesture : UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        swipe.delaysTouchesBegan = false
        //swipe.numerOfTouchesRequired = 1
        swipe.direction = .down
        
        return swipe
    }()
    
    weak var canvas : ProjectCanvas?
    
    private unowned var project : ProjectWork
    lazy private var bg : UIView = {
        let bgView = UIView()
        bgView.backgroundColor = ProjectStyle.uiBackgroundColor
        bgView.layer.cornerRadius = 16
        bgView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        bgView.layer.masksToBounds = true
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        return bgView
    }()
    
    lazy private var toggleView : UIView = {
        let bgView = UIView()
        bgView.backgroundColor = ProjectStyle.uiEnableColor
        bgView.layer.cornerRadius = 2
        bgView.layer.masksToBounds = true
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        bgView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        return bgView
    }()
    
    func setProject(proj : ProjectWork){
        project = proj
        layers.setProject(proj : project)
    }
    
    func setCanvas(canvas : ProjectCanvas){
        self.canvas = canvas
        layers.list.canvas = self.canvas
        frames.list.canvas = self.canvas
    }
    
    @objc private func swipe(sender : UISwipeGestureRecognizer) {
        print(sender.direction)
        if sender.direction == .up && !isHide {
            isHide = true
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y = -52
                self.frames.alpha = 0
            })
        }
        if sender.direction == .down && isHide {
            isHide = false
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y = 0
                self.frames.alpha = 1
            })
        }
    }
    
    func setPosition(){
        self.frame.origin.y = isHide ? -52 : 0
    }
    
    init(frame : CGRect, proj : ProjectWork){
        project = proj
        print("some init")
        
        
        super.init(frame: .zero)

        frames.list.layers = layers.list
        layers.list.list = frames.list
        
        
        addSubview(bg)
        
        bg.addSubview(frames)
        bg.addSubview(layers)
        bg.addSubview(toggleView)
        
        toggleView.centerXAnchor.constraint(equalTo: bg.centerXAnchor, constant: 0).isActive = true
        toggleView.topAnchor.constraint(equalTo: bg.bottomAnchor, constant: -12).isActive = true

        bg.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bg.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        bg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        frames.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        frames.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        frames.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        frames.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        layers.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        layers.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        layers.topAnchor.constraint(equalTo: frames.bottomAnchor, constant: 8).isActive = true
        layers.heightAnchor.constraint(equalToConstant: 36).isActive = true

        setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        addGestureRecognizer(swipeUpGesture)
        addGestureRecognizer(swipeDownGesture)
    }
    func updateInfo(){
        layers.list.reloadData()
        frames.list.reloadData()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol LayerProtocol {
    func changeSelect(newSelect : LayerCell)
    func changeVisible(item : LayerCell)
    func updatePositions()
}
