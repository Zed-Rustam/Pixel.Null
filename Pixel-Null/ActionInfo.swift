//
//  ActionInfo.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 15.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ActionInfo: UIView {
    private var indexHidding = 0
    
    lazy private var title: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Rubik-Bold", size: 12)
        lbl.textColor = getAppColor(color: .enable)
        lbl.textAlignment = .center

        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return lbl
    }()
    
    lazy private var info: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Rubik-Bold", size: 10)
        lbl.textColor = getAppColor(color: .disable)
        lbl.textAlignment = .center

        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        backgroundColor = getAppColor(color: .background)
        setCorners(corners: 12)
        
        addSubview(title)
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        addSubview(info)
        info.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        info.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        info.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0).isActive = true
    }
    
    override func layoutSubviews() {
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }
    
    override func tintColorDidChange() {
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }
    
    func setAction(action: [String : String], isRedo: Bool, project: ProjectWork){
        
        let nowIndex = indexHidding + 1
        indexHidding += 1
        
        title.text = isRedo ? "Redo: " : "Undo: "
        
        switch Actions.init(rawValue: Int(action["ToolID"]!)!) {
        case .backgroundChange:
            title.text! += "Background color change"
            info.text = "Background color change on color #FFFFFFFF"
            
        case .frameAdd:
            title.text! += "Frame added"
            info.text = (isRedo ? "Add new" : "Delete ") + "frame on position \(Int(action["frame"]!)! + 1)"
            
        case .layerAdd:
            title.text! += "Layer added"
            info.text = (isRedo ? "Add new" : "Delete ") + "layer if frame \(Int(action["frame"]!)! + 1) on position \(Int(action["layer"]!)! + 1)"
            
        case .frameReplace:
            title.text! += "Frame replaced"
            info.text = "Replaced frame from position \(isRedo ? Int(action["from"]!)! + 1 : Int(action["to"]!)! + 1) to \(isRedo ? Int(action["to"]!)! + 1 : Int(action["from"]!)! + 1)"
            
        case .layerReplace:
            title.text! += "Layer replaced"
            info.text = "Replaced layer from frame \(Int(action["frame"]!)! + 1) from position \(isRedo ? Int(action["from"]!)! + 1 : Int(action["to"]!)! + 1) to \(isRedo ? Int(action["to"]!)! + 1 : Int(action["from"]!)! + 1)"
            
        case .renameLayer:
            title.text! += "Layer rename"
            info.text = "Layer \(Int(action["layer"]!)! + 1) in frame \(Int(action["frame"]!)! + 1) renamed to \(action[isRedo ? "newName" : "oldName"]!)"
            
        case .layerVisibleChange:
            title.text! += "Layer visibility change"
            info.text = "layer \(Int(action["layer"]!)! + 1) in frame \(Int(action["frame"]!)! + 1) become \(!project.information.frames[Int(action["frame"]!)!].layers[Int(action["layer"]!)!].visible ? "visible" : "unvisible")"
            
        default:
            title.text! += "Uncnown action"
            info.text = "idk what is this"
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        },completion: {isEnd in
            if isEnd {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    if nowIndex == self.indexHidding {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.alpha = 0
                        })
                    }
                })
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
