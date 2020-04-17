//
//  ToolBar.swift
//  new Testing
//
//  Created by Рустам Хахук on 22.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ToolBar : UIView {
    lazy private var toolCollection : ToolBarCollection = {
        let collection = ToolBarCollection(frame: self.bounds, tools: [-3,-2,0,1,2,3,4,5,6,-4,-1,-5])
        collection.barDelegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        
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
        bgv.setCorners(corners: 16)
        bgv.backgroundColor = ProjectStyle.uiBackgroundColor
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

        mainView.heightAnchor.constraint(equalTo: stack.heightAnchor, constant: 0).isActive = true
        return mainView
    }()
    private var nowSelected = 2
    weak var project : ProjectWork!
    weak var delegate : FrameControlDelegate!
    
    func reLayout(){
        toolCollection.collectionViewLayout.invalidateLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(subBar)
        addSubview(bg)
        
        subBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        subBar.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        subBar.topAnchor.constraint(equalTo: bg.topAnchor, constant: 0).isActive = true
        
        bg.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        //bg.setShadow(color: ProjectStyle.uiShadowColor, radius: 4, opasity: 0.25)

        bg.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        
        self.heightAnchor.constraint(equalTo: bg.heightAnchor, constant: 48).isActive = true
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
        if newTool != nowSelected {
            let lastCell = toolCollection.cellForItem(at: IndexPath(item: toolCollection.tools.firstIndex(of: nowSelected)!, section: 0)) as! ToolButton
            lastCell.getButton().setIconColor(color: ProjectStyle.uiEnableColor)
            
            nowSelected = newTool
            
            let nowCell = toolCollection.cellForItem(at: IndexPath(item: toolCollection.tools.firstIndex(of: nowSelected)!, section: 0)) as! ToolButton
            nowCell.getButton().setIconColor(color: ProjectStyle.uiSelectColor)
        }
    }
    
    func updateButtons(btns : [UIView]) {
        subBar.updateButtons(btns: btns)
    }
    
}


protocol ToolBarDelegate : class {
    func wasChangedTool(newTool : Int)
    func updateButtons(btns : [UIView])
    func UnDoReDoAction()
}
