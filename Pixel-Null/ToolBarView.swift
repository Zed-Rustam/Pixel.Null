//
//  ToolBarView.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 31.10.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ToolBarView: UIView {
    
    private var tools: [Int] = getToolsArray()
    
    private var isHide: Bool = false
    
    lazy var selectedTool: Int = {
        tools.firstIndex(of: 0)!
    }()
    
    unowned var delegate: ToolsActionDelegate!
    
    lazy private var swipeDownGesture: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(gesture:)))
        swipe.direction = .down
        
        return swipe
    }()
    
    lazy private var swipeUpGesture: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(gesture:)))
        swipe.direction = .up
        
        return swipe
    }()
    
    lazy private var swipeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 4),
            view.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        view.setCorners(corners: 2)
        view.backgroundColor = getAppColor(color: .enable)
        
        return view
    }()
    
    lazy private var toolCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 36, height: 36)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let tools = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        tools.register(ToolButtonCell.self, forCellWithReuseIdentifier: "tool")
        tools.register(ColorSelectorCell.self, forCellWithReuseIdentifier: "color")
        
        tools.dataSource = self
        tools.translatesAutoresizingMaskIntoConstraints = false
        tools.backgroundColor = .clear
        return tools
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = getAppColor(color: .background)
        setCorners(corners: 12, needMask: false, curveType: .continuous, activeCorners: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    func setDisable(isDisable: Bool) {
        
        toolCollection.isUserInteractionEnabled = !isDisable
        for i in 0..<tools.count {
            if tools[i] != -6 {
                getBtnTool(id: tools[i])?.isEnabled = !isDisable
            }
        }
        
        if isDisable == false {
            getBtnTool(id: tools[selectedTool])?.sendActions(for: .touchUpInside)
        }
    }
    @objc func onSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down && !isHide {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 48)
            })
            isHide.toggle()

            delegate.changeToolBarState(isToolsHide: isHide, isSubBarHide: nil)

        } else if gesture.direction == .up && isHide {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            isHide.toggle()

            delegate.changeToolBarState(isToolsHide: isHide, isSubBarHide: nil)
        }
        
        checkButtons()
    }
    
    private func checkButtons() {
        for i in ((Int(frame.width) - 24) / 36)..<tools.count {
            UIView.animate(withDuration: 0.2, animations: {
                self.toolCollection.cellForItem(at: IndexPath(item: i, section: 0))?.alpha = self.isHide ? 0 : 1
            })
        }
    }
    
    func changeToolSelect(tool: Int) {
        let lastSelect = toolCollection.cellForItem(at: IndexPath(item: selectedTool, section: 0)) as! ToolButtonCell
        let nowSelect = toolCollection.cellForItem(at: IndexPath(item: tools.firstIndex(of: tool)!, section: 0)) as! ToolButtonCell
        
        lastSelect.setSelect(isSelect: false)
        nowSelect.setSelect(isSelect: true)
        
        selectedTool = tools.firstIndex(of: tool)!
    }
    
    func getBtnTool(id: Int) -> UIButton? {
        return (toolCollection.cellForItem(at: IndexPath(item: tools.firstIndex(of: id)!, section: 0)) as? ToolButtonCell)?.btn
    }
    
    func getColumnsCount(ofWidth: Int) -> Int {
        let sizeOneRow = (ofWidth - 24) / 36
        
        let count = tools.count / sizeOneRow + (tools.count % sizeOneRow == 0 ? 0 : 1)
        
        return count
    }
    
    func changeColorSelected(newColor: UIColor) {
        (toolCollection.cellForItem(at: IndexPath(item: tools.firstIndex(of: -6)!, section: 0)) as! ColorSelectorCell).color = newColor
    }
    
    private func setupViews() {
        addSubview(swipeView)
        addSubview(toolCollection)
        
        addGestureRecognizer(swipeUpGesture)
        addGestureRecognizer(swipeDownGesture)
    
        NSLayoutConstraint.activate([
            swipeView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            swipeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            toolCollection.leftAnchor.constraint(equalTo: leftAnchor,constant: 8),
            toolCollection.rightAnchor.constraint(equalTo: rightAnchor,constant: -8),
            toolCollection.topAnchor.constraint(equalTo: topAnchor,constant: 20),
            toolCollection.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    override func layoutSubviews() {
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        toolCollection.setNeedsLayout()
        toolCollection.layoutIfNeeded()
        changeToolSelect(tool: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToolBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if tools[indexPath.item] == -6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath) as! ColorSelectorCell
            cell.delegate = delegate
            //cell.setToolID(id: tools[indexPath.item])
            //cell.delegate = delegate
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tool", for: indexPath) as! ToolButtonCell
            
            cell.setToolID(id: tools[indexPath.item])
            cell.delegate = delegate
            
            return cell
        }
    }
}
