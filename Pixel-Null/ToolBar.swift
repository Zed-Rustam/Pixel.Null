//
//  ToolBar.swift
//  new Testing
//
//  Created by Рустам Хахук on 22.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ToolBar : UIView {
    
    private var isHide = false

    var toolbarChangesDelegate: (Bool,Bool)->() = {_,_ in}
    
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
    
    lazy private var toolCollection : ToolBarCollection = {
        let collection = ToolBarCollection(frame: self.bounds, tools: getToolsArray())
        collection.barDelegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.layer.masksToBounds = true
        return collection
    }()
    
    lazy private var subBar : FastActionBar = {
        let actions = FastActionBar()
        return actions
    }()
    
    lazy private var bg : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        let bgv = UIView()
        bgv.setCorners(corners: 16, needMask: false, curveType: .continuous)
        bgv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        bgv.backgroundColor =  UIColor(named: "backgroundColor")
        bgv.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        bgv.addSubview(stack)
        stack.addArrangedSubview(toolCollection)
        
        stack.leftAnchor.constraint(equalTo: bgv.leftAnchor, constant: 0).isActive = true
        stack.rightAnchor.constraint(equalTo: bgv.rightAnchor, constant: 0).isActive = true
        stack.bottomAnchor.constraint(equalTo: bgv.bottomAnchor, constant: 0).isActive = true

        toolCollection.leftAnchor.constraint(equalTo: stack.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        toolCollection.rightAnchor.constraint(equalTo: stack.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        toolCollection.bottomAnchor.constraint(equalTo: bgv.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        
        mainView.addSubview(bgv)
        bgv.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        bgv.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        bgv.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        bgv.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        
        mainView.addSubview(swipeView)
        
        swipeView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8).isActive = true
        swipeView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0).isActive = true
       
        mainView.heightAnchor.constraint(equalTo: stack.heightAnchor, constant: 16).isActive = true
        return mainView
    }()
    
    lazy private var swipeView : UIView = {
        let topview = UIView()
        topview.setCorners(corners: 2, needMask: false)
        
        topview.backgroundColor = UIColor(named: "enableColor")
        topview.translatesAutoresizingMaskIntoConstraints = false
        topview.widthAnchor.constraint(equalToConstant: 36).isActive = true
        topview.heightAnchor.constraint(equalToConstant: 4).isActive = true

        return topview
    }()
    
    private var nowSelected = 0
    weak var project : ProjectWork!
    weak var delegate : FrameControlDelegate!
    
    func reLayout(){
        toolCollection.collectionViewLayout.invalidateLayout()
    }
    
    func updateSelectedColor(newColor : UIColor) {
        (toolCollection.cellForItem(at: IndexPath(item: toolCollection.tools.firstIndex(of: -6)!, section: 0)) as! SelectionButton).colorSelector.color = newColor
    }
    
    @objc private func swipe(sender : UISwipeGestureRecognizer) {
        print(sender.direction)
        if sender.direction == .up && isHide {
            isHide = false
            toolbarChangesDelegate(subBar.isHide, isHide)

            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y -= 42
            })
        }
        if sender.direction == .down && !isHide {
            isHide = true
            toolbarChangesDelegate(subBar.isHide, isHide)

            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y += 42
            })
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.hideItems()
        })
    }
    
    func hideItems() {
        if isHide {
            print("start hidding")
            if (toolCollection.collectionViewLayout as! ToolBarLayout).columnsCount < toolCollection.tools.count{
                for i in (toolCollection.collectionViewLayout as! ToolBarLayout).columnsCount..<toolCollection.tools.count {
                    toolCollection.cellForItem(at: IndexPath(item: i, section: 0))?.alpha = 0
                }
            }
    } else {
            if (toolCollection.collectionViewLayout as! ToolBarLayout).columnsCount < toolCollection.tools.count {
                for i in (toolCollection.collectionViewLayout as! ToolBarLayout).columnsCount..<toolCollection.tools.count {
                    toolCollection.cellForItem(at: IndexPath(item: i, section: 0))?.alpha = 1
                }
            }
        }
    }
    
    func animationStart(){
        for i in 0..<toolCollection.tools.count {
            (toolCollection.cellForItem(at: IndexPath(item: i, section: 0)) as? ToolButton)?.getButton().isEnabled = false
            swipeView.backgroundColor = getAppColor(color: .backgroundLight)
        }
        subBar.updateButtons(btns: [])
    }
    func animationStop(){
        for i in 0..<toolCollection.tools.count {
            (toolCollection.cellForItem(at: IndexPath(item: i, section: 0)) as? ToolButton)?.getButton().isEnabled = true
            swipeView.backgroundColor = getAppColor(color: .enable)
        }
        (toolCollection.cellForItem(at: IndexPath(item: toolCollection.tools.firstIndex(of: nowSelected)!, section: 0)) as! ToolButton).getButton().sendActions(for: .touchUpInside)
        //toolCollection.reloadData()
    }
    
    func setPosition() {
        if isHide {
            self.frame.origin.y += 42
        }
        toolCollection.layoutIfNeeded()
        UIView.animate(withDuration: 0.0, animations: {
            self.hideItems()
        })    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(subBar)
        addSubview(bg)
        
        subBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        subBar.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        subBar.topAnchor.constraint(equalTo: bg.topAnchor, constant: 0).isActive = true
        
        subBar.updateButtons(btns: [])
        
        bg.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        //bg.setShadow(color: ProjectStyle.uiShadowColor, radius: 4, opasity: 0.25)

        self.heightAnchor.constraint(equalTo: bg.heightAnchor, constant: 48).isActive = true
        
        addGestureRecognizer(swipeUpGesture)
        addGestureRecognizer(swipeDownGesture)
        
        bg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
        bg.layer.shadowPath = UIBezierPath(roundedRect: bg.bounds, cornerRadius: 16).cgPath
    }
    override func tintColorDidChange() {
        bg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
        bg.layer.shadowPath = UIBezierPath(roundedRect: bg.bounds, cornerRadius: 16).cgPath
    }
    
    func setData(project proj : ProjectWork, delegate del : FrameControlDelegate){
        project = proj
        delegate = del
        
        toolCollection.editorDelegate = delegate
        toolCollection.project = project
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToolBar : ToolBarDelegate {
    func UnDoReDoAction() {
        let undoCell = toolCollection.cellForItem(at: IndexPath(item: toolCollection.tools.firstIndex(of: -3)!, section: 0)) as! ToolButton
        
        if project.information.actionList.lastActiveAction < 0 {
            undoCell.getButton().isEnabled = false
        } else {
            undoCell.getButton().isEnabled = true
        }
        
        let redoCell = toolCollection.cellForItem(at: IndexPath(item: toolCollection.tools.firstIndex(of: -2)!, section: 0)) as! ToolButton
        
        if project.information.actionList.lastActiveAction == project.information.actionList.actions.count - 1 {
            redoCell.getButton().isEnabled = false
        } else {
            redoCell.getButton().isEnabled = true
        }
    }
    
    func wasChangedTool(newTool: Int) {
        //if newTool != nowSelected {
        let lastCell = toolCollection.cellForItem(at: IndexPath(item: toolCollection.tools.firstIndex(of: nowSelected)!, section: 0)) as! ToolButton
        lastCell.getButton().imageView?.tintColor = getAppColor(color: .enable)
        lastCell.getButton().backgroundColor = .clear
            
        nowSelected = newTool
            
        let nowCell = toolCollection.cellForItem(at: IndexPath(item: toolCollection.tools.firstIndex(of: nowSelected)!, section: 0)) as! ToolButton
        nowCell.getButton().imageView?.tintColor = getAppColor(color: .enable)
       //}
    }
    
    func clickTool(tool : Int) {
        (toolCollection.cellForItem(at: IndexPath(item: toolCollection.tools.firstIndex(of: tool)!, section: 0)) as! ToolButton).getButton().sendActions(for: .touchUpInside)
    }
    
    
    func updateButtons(btns : [UIView]) {
        subBar.updateButtons(btns: btns)
        toolbarChangesDelegate(subBar.isHide, isHide)
    }
}

protocol ToolBarDelegate : class {
    func wasChangedTool(newTool : Int)
    func updateButtons(btns : [UIView])
    func UnDoReDoAction()
}
