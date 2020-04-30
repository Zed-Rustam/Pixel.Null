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
    lazy private var playButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "play_icon"), frame: .zero)
        btn.corners = 8
        btn.delegate = {[unowned self] in
            self.isPlay.toggle()
            btn.setIcon(ic: self.isPlay ? #imageLiteral(resourceName: "pause_icon") : #imageLiteral(resourceName: "play_icon"))
            if self.isPlay {
                self.editor?.canvas.transformView.needToSave = true
                self.editor?.finishTransform()
                
                self.list.tapgesture.isEnabled = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.list.layers?.alpha = 0
                })
                self.editor?.control.layers.settingsButton.isEnabled = false
                self.editor!.startAnimation()
            } else {
                self.editor?.control.layers.settingsButton.isEnabled = true
                self.list.tapgesture.isEnabled = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.list.layers?.alpha = 1
                })
                self.editor!.stopAnimation()
            }
        }
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return btn
    }()
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
                
        array = FrameList(frame: CGRect(x: 0, y: 0, width: frame.width - 54, height: 36), proj: project)
        array.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame : frame)

        addSubview(array)
        addSubview(playButton)
        
        
        playButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        playButton.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        array.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        array.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -8).isActive = true
        array.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        array.heightAnchor.constraint(equalToConstant: 36).isActive = true

        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
