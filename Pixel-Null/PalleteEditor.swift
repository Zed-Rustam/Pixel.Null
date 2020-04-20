//
//  PalleteEditor.swift
//  new Testing
//
//  Created by Рустам Хахук on 16.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.

import UIKit

class PalleteEditor : UIViewController, PalleteEditorDelegate {
    
    lazy private var colors : GridCollection = {
        let clr = GridCollection(frame: .zero, pallete : pallete)
        clr.title.text = pallete.palleteName
        clr.delegateEditor = self
        
        let title = UILabel()
        title.text = pallete.palleteName
        title.textAlignment = .left
        title.textColor = ProjectStyle.uiEnableColor
        title.lineBreakMode = .byTruncatingMiddle
        title.font = UIFont(name:  "Rubik-Medium", size: 28)
        title.translatesAutoresizingMaskIntoConstraints = false
    
        clr.addSubview(title)
        
        title.leftAnchor.constraint(equalTo: clr.leftAnchor, constant: 8).isActive = true
        title.rightAnchor.constraint(equalTo: clr.rightAnchor, constant: -52).isActive = true
        title.topAnchor.constraint(equalTo: clr.topAnchor, constant: 8).isActive = true
        title.heightAnchor.constraint(equalToConstant: 48).isActive = true

        clr.translatesAutoresizingMaskIntoConstraints = false
        
        return clr
    }()
    lazy private var editBar : PalleteEditBar = {
        let bar = PalleteEditBar(frame: .zero)
        bar.delegate = self
        bar.list = colors
        bar.controller = self
        bar.pallete = pallete
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        bar.widthAnchor.constraint(equalToConstant: 156).isActive = true

        return bar
    }()
    lazy private var exitButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero)
        btn.delegate = {[weak self] in
            self!.pallete.save()
            self!.delegate?.palleteUpdate(item: 0)
            self!.dismiss(animated: true, completion: nil)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
    weak var delegate : PalleteGalleryDelegate? = nil
    var pallete : PalleteWorker!
    
    func moveColor(from: Int, to: Int) {
        pallete.moveColor(from: from, to: to)
        colors.reloadData()
    }
    
    func addColor(color: Int, newValue: String) {
            pallete.addColor(newColor: newValue)
            self.colors.performBatchUpdates({
                self.colors.insertItems(at: [IndexPath(item: self.pallete.colors.count - 1, section: 0)])
            })
    }
    
    func deleteColor(color: Int) {
        if pallete.colors.count > 1 {
            pallete.deleteColor(index: color)
            colors.select = color == pallete.colors.count ? color - 1 : color
            
            UIView.animate(withDuration: 0.2, animations: {
                self.colors.performBatchUpdates({
                    self.colors.deleteItems(at: [IndexPath(item: color, section: 0)])
                }, completion: {isEnd in
                     UIView.animate(withDuration: 0.2, animations: {
                        self.colors.performBatchUpdates({
                            self.colors.reloadItems(at: [IndexPath(item: self.colors.select, section: 0)])
                        }, completion: nil)
                    })
                })
            })
        }
    }
    
    func cloneColor(color: Int) {
            pallete.cloneColor(index: color)
        
            colors.performBatchUpdates({
                colors.insertItems(at: [IndexPath(item: color + 1, section: 0)])
            })
    }
    
    func changeColor(color: Int, newValue: String) {
            pallete.updateColor(index: color, color: newValue)
            colors.reloadItems(at: [IndexPath(item: color, section: 0)])
    }
    
    override func viewDidLoad() {
        view.backgroundColor = ProjectStyle.uiBackgroundColor

        view.addSubview(colors)
        view.addSubview(exitButton)
        view.addSubview(editBar)

        colors.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        colors.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        colors.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        colors.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        editBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        editBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        exitButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14).isActive = true
    }
}


protocol PalleteEditorDelegate : class{
    func moveColor(from : Int, to : Int)
    func deleteColor(color : Int)
    func cloneColor(color : Int)
    func changeColor(color : Int, newValue : String)
    func addColor(color : Int, newValue : String)
}
