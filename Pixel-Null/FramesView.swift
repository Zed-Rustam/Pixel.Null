//
//  FrameView.swift
//  new Testing
//
//  Created by Рустам Хахук on 09.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FramesView : UIView {
    private var isPlay : Bool = false
    private unowned var project : ProjectWork
    
    lazy var playButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 8,needMask: false)
        
        btn.setImage(self.isPlay ? #imageLiteral(resourceName: "pause_icon").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "play_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.imageView?.tintColor = getAppColor(color: .enable)
        
        btn.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        
        btn.setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
        btn.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 36, height: 36), cornerRadius: 8).cgPath
        
        return btn
    }()
    
    
    @objc func onPress() {
        isPlay.toggle()
        playButton.setImage(self.isPlay ? #imageLiteral(resourceName: "pause_icon").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "play_icon").withRenderingMode(.alwaysTemplate), for: .normal)

        if isPlay {
            editor?.canvas.transformView.needToSave = true
            editor?.finishTransform()
            
            list.tapgesture.isEnabled = false
            UIView.animate(withDuration: 0.2, animations: {
                self.list.layers?.alpha = 0
            })
            editor?.control.layers.settingsButton.isEnabled = false
            editor!.startAnimation()
        } else {
            editor?.control.layers.settingsButton.isEnabled = true
            list.tapgesture.isEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                self.list.layers?.alpha = 1
            })
            editor!.stopAnimation()
        }
    }
    
    weak var editor : Editor? = nil
    
    private var array : FrameList
    
    var list : FrameList{
        get{
            return array
        }
    }
    
    func setProject(proj : ProjectWork){
        project = proj
        array.setProject(proj : project)
    }
    
    init(frame : CGRect, proj : ProjectWork){
        project = proj
                
        array = FrameList(frame: CGRect(x: 0, y: 0, width: frame.width - 54, height: 42), proj: project)
        array.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame : frame)

        addSubview(array)
        addSubview(playButton)
        
        
        playButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        playButton.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        array.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        array.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -8).isActive = true
        array.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        array.heightAnchor.constraint(equalToConstant: 42).isActive = true

        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
