//
//  FrameControl.swift
//  new Testing
//
//  Created by Рустам Хахук on 09.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FrameControl : UIViewController, UIGestureRecognizerDelegate,FrameControlUpdate {
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func changeLayerVisible(frame: Int, layer: Int) {
        project.changeLayerVisible(layer: layer, isVisible: !project.layerVisible(layer: layer))
        
           self.layers.list.performBatchUpdates({
               self.layers.list.reloadItems(at: [IndexPath(item: layer, section: 0)])
           },completion: {isEnd in
               self.preview.image = self.project.getFrameFromLayers(frame: frame, size: self.project.projectSize)
            self.layers.list.selectItem(at: IndexPath(item: layer, section: 0), animated: false, scrollPosition: .top)
           })
        
        self.frames.list.performBatchUpdates({
            self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
        }, completion: nil)
    }

    func changeFrame(from: Int, to: Int) {
        project.FrameSelected = to
        project.LayerSelected = 0
        project.savePreview(frame: from)
        
        layers.list.reloadData()
        layers.checkFrame()
        layers.list.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        
        preview.image = project.getFrame(frame: to, size: project.projectSize)
        frames.delayField.filed.text = String(project.information.frames[project.FrameSelected].delay)
    }
    
    func changeLayer(frame: Int, from: Int, to: Int) {
        project.LayerSelected = to
        layers.transparentField.filed.text = "\(Int(project.information.frames[project.FrameSelected].layers[project.LayerSelected].transparent * 100))"
    }
    
    func updateFramePosition(from: Int, to: Int) {
        project.replaceFrame(from: from, to: to)
    }
    
    func updateLayerPosition(frame: Int, from: Int, to: Int) {
        project.replaceLayer(frame: frame, from: from, to: to)
        
        UIView.animate(withDuration: 0, animations: {
            self.frames.list.performBatchUpdates({
                self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
            }, completion: nil)
        })

        preview.image = project.getFrameFromLayers(frame: project.FrameSelected, size: project.projectSize)
    }
    
    func updateLayerSettings(target: Int) {
        UIView.animate(withDuration: 0, animations: {
            self.layers.list.performBatchUpdates({
                self.layers.list.reloadItems(at: [IndexPath(item: target, section: 0)])

            }, completion: {isEnd in
                self.layers.list.selectItem(at: IndexPath(item: self.project!.LayerSelected, section: 0), animated: true, scrollPosition: .top)
            })
        })
    }
    
    func updateFrameSettings(target: Int) {
        UIView.animate(withDuration: 0, animations: {
                   self.frames.list.performBatchUpdates({
                       self.frames.list.reloadItems(at: [IndexPath(item: target, section: 0)])

                   }, completion: {isEnd in
                       self.frames.list.selectItem(at: IndexPath(item: self.project!.FrameSelected, section: 0), animated: true, scrollPosition: .top)
                   })
               })
    }
    
    func deleteFrame(frame: Int) {
        if(project.information.frames.count > 1){
            project.deleteFrame(frame: frame)
            project.FrameSelected = project.information.frames.count > project.FrameSelected ? project.FrameSelected : project.FrameSelected - 1
            project.LayerSelected = 0

            print("new frame select : \(project.FrameSelected) a last : \(frame)")
            UIView.animate(withDuration: 0.2, animations: {
                self.frames.list.performBatchUpdates({
                    self.frames.list.deleteItems(at: [IndexPath(item: frame, section: 0)])
                },completion: {isEnd in

                    self.frames.list.reloadItems(at: [IndexPath(item: self.project.FrameSelected, section: 0)])
                    self.frames.list.selectItem(at: IndexPath(item: self.project.FrameSelected, section: 0), animated: true, scrollPosition: .top)

                    self.layers.list.reloadData()
                    self.preview.image = self.project.getFrameFromLayers(frame: self.project.FrameSelected, size: self.project.projectSize)
                })
            })
            layers.checkFrame()
        }
    }
    
    func deleteLayer(frame : Int, layer: Int) {
        if(project.information.frames[frame].layers.count > 1){
            project.deleteLayer(frame: frame, layer: layer)
            project.LayerSelected = project.information.frames[frame].layers.count > project.LayerSelected ? project.LayerSelected : project.LayerSelected - 1

            UIView.animate(withDuration: 0.2, animations: {
                self.layers.list.performBatchUpdates({
                    self.layers.list.deleteItems(at: [IndexPath(item: layer, section: 0)])
                },completion: {isEnd in
                    self.layers.list.reloadItems(at: [IndexPath(item: self.project.LayerSelected, section: 0)])
                    self.layers.list.selectItem(at: IndexPath(item: self.project.LayerSelected, section: 0), animated: true, scrollPosition: .left)

                    self.preview.image = self.project.getFrameFromLayers(frame: frame, size: self.project.projectSize)
                })
            })
            
            
        }
    }
    
    func cloneFrame(original: Int) {
        project.cloneFrame(frame: original)
        
        UIView.animate(withDuration: 0.2, animations: {
           self.frames.list.performBatchUpdates({
               self.frames.list.insertItems(at: [IndexPath(item: original + 1, section: 0)])
           },completion: nil)
       })
    }
    
    func addFrame(at: Int) {     
         UIView.animate(withDuration: 0.2, animations: {
            self.frames.list.performBatchUpdates({
                self.frames.list.insertItems(at: [IndexPath(item: at, section: 0)])
            },completion: nil)
         })
    }
    
    func cloneLayer(frame : Int, original: Int) {
        project.cloneLayer(frame: frame, layer: original)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layers.list.performBatchUpdates({
                self.layers.list.insertItems(at: [IndexPath(item: original + 1, section: 0)])
            },completion: nil)
        })
        
    }
    
    func addLayer(frame : Int, layer: Int) {
        UIView.animate(withDuration: 0.2, animations: {
            self.layers.list.performBatchUpdates({
                self.layers.list.insertItems(at: [IndexPath(item: layer, section: 0)])
            },completion: nil)
        })
    }
    
    func margeLayers(frame : Int, layer: Int) {
        UIView.animate(withDuration: 0.2, animations: {
            self.layers.list.performBatchUpdates({
                self.layers.list.deleteItems(at: [IndexPath(item: layer + 1, section: 0)])
                self.layers.list.reloadItems(at: [IndexPath(item: layer, section: 0)])
            },completion: nil)
        })
    }
    
    func updatePreview(){
        self.preview.image = self.project.getFrameFromLayers(frame: self.project.FrameSelected, size: self.project.projectSize)
    }
    
    lazy private var frameText : UILabel = {
        let text = UILabel(frame: .zero)
        text.text = NSLocalizedString("Frames", comment: "")
        text.font = UIFont(name: "Rubik-Medium", size: 28)
        text.textColor = UIColor(named: "enableColor")
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    lazy private var layerText : UILabel = {
        let text = UILabel(frame: .zero)
        text.text = NSLocalizedString("Layers", comment: "")
        text.font = UIFont(name: "Rubik-Medium", size: 28)
        text.textColor = UIColor(named: "enableColor")
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    
    lazy private var frames : FramesCollectionView = {
        let frm = FramesCollectionView(proj: project)
        frm.list.frameDelegate = self

        frm.translatesAutoresizingMaskIntoConstraints = false
        frm.heightAnchor.constraint(equalToConstant: 108).isActive = true
        return frm
    }()
    
    lazy private var layers : LayersCollectionView = {
        let lays = LayersCollectionView(frame : .zero,proj: project)
        //lays.list.preview = preview
        lays.list.frameDelegate = self
        lays.translatesAutoresizingMaskIntoConstraints = false
        lays.heightAnchor.constraint(equalToConstant: 108).isActive = true

        return lays
    }()
    lazy private var exitButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero)
        
        btn.delegate = {[weak self] in
            self!.delegate?.updateEditor()
            self!.dismiss(animated: true, completion: nil)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
    
    var delegate : FrameControlDelegate? = nil
    
    var preview : FramePreview!
    var project : ProjectWork!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        
        var width = 96 * (project.projectSize.width / project.projectSize.height)
        if width > self.view.frame.size.width - 72 {
            width = self.view.frame.size.width - 72
        } else if width < 32 {
            width = 32
        }
        
        preview = FramePreview(frame: CGRect(x: 12, y: 12, width: width, height: 96), image: project.getFrame(frame: project.FrameSelected, size: CGSize(width: 96, height: 96)))
        preview.layer.shadowColor = getAppColor(color: .shadow).cgColor
        preview.bgColor = UIColor(hex : project.information.bgColor)!

        view.addSubview(preview)
        view.addSubview(frameText)
        view.addSubview(frames)
        view.addSubview(layerText)
        view.addSubview(layers)
        view.addSubview(exitButton)
        
        frameText.topAnchor.constraint(equalTo: preview.bottomAnchor).isActive = true
        frameText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        
        exitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true

        frames.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        frames.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        frames.topAnchor.constraint(equalTo: frameText.bottomAnchor, constant: 0).isActive = true

        layerText.topAnchor.constraint(equalTo: frames.bottomAnchor).isActive = true
        layerText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        
        layers.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        layers.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        layers.topAnchor.constraint(equalTo: layerText.bottomAnchor, constant: 0).isActive = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    deinit {
        project = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        frames.list.selectItem(at: IndexPath(item: project.FrameSelected, section: 0), animated: true, scrollPosition: .left)
        layers.list.selectItem(at: IndexPath(item: project.LayerSelected, section: 0), animated: true, scrollPosition: .left)
    }
}

protocol FrameControlUpdate : class {
    func changeFrame(from : Int, to : Int)
    func changeLayer(frame : Int, from : Int, to : Int)
    func updateFramePosition(from : Int, to : Int)
    func updateLayerPosition(frame : Int,from : Int, to : Int)
    func updateLayerSettings(target : Int)
    func updateFrameSettings(target : Int)
    func deleteFrame(frame : Int)
    func deleteLayer(frame : Int, layer : Int)
    func cloneFrame(original : Int)
    func cloneLayer(frame : Int, original : Int)
    func addLayer(frame : Int, layer : Int)
    func addFrame(at : Int)
    func updatePreview()
    func changeLayerVisible(frame : Int,layer : Int)
    func margeLayers(frame : Int,layer : Int)
}
