//
//  FrameControl.swift
//  new Testing
//
//  Created by Рустам Хахук on 09.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class FrameControl : UIViewController, UIGestureRecognizerDelegate,FrameControlUpdate {
    func updatePreview() {
        
    }
    
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func addFrame(at: Int) {
         UIView.animate(withDuration: 0.2, animations: {
            self.frames.list.performBatchUpdates({
                self.frames.list.insertItems(at: [IndexPath(item: at, section: 0)])
            },completion: nil)
         })
        
        delegate?.addFrame(frame: at)
    }
    
    func changeFrame(from: Int, to: Int) {
        project.FrameSelected = to
        project.LayerSelected = 0
        project.savePreview(frame: from)
         
        layers.list.reloadData()
        layers.checkFrame()
        layers.list.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
         
        delegate?.updateFrameSelect(lastFrame: from, newFrame: to)
        delegate?.updateCanvas()
     }
    
    func deleteFrame(frame: Int) {
        if(project.information.frames.count > 1){
            project.deleteFrame(frame: frame)
            
            project.FrameSelected = project.FrameSelected > frame || project.FrameSelected == project.frameCount ? project.FrameSelected - 1 : project.FrameSelected
            project.LayerSelected = 0
            
            self.frames.list.performBatchUpdates({
                self.frames.list.deleteItems(at: [IndexPath(item: frame, section: 0)])
            },completion: {isEnd in
                if isEnd {
                    self.frames.list.selectItem(at: IndexPath(item: self.project.FrameSelected, section: 0), animated: false, scrollPosition: .top)
                    (self.frames.list.cellForItem(at: IndexPath(item: self.project.FrameSelected, section: 0)) as? FramePreviewCell)?.setSelect(isSelect: true, animate: true)
                }
            })
            layers.checkFrame()
            
            delegate?.deleteFrame(frame: frame)
            delegate?.updateFrame(frame: project.FrameSelected)
            delegate?.updateCanvas()
        }
    }
    
    func cloneFrame(original: Int) {
        project.cloneFrame(frame: original)
        
        if project.FrameSelected > original {
            project.FrameSelected += 1
        }
        //UIView.animate(withDuration: 0.2, animations: {
           self.frames.list.performBatchUpdates({
               self.frames.list.insertItems(at: [IndexPath(item: original + 1, section: 0)])
           },completion: nil)
       //})
        
        delegate?.addFrame(frame: original + 1)
    }
    
    func updateFramePosition(from: Int, to: Int) {
        project.replaceFrame(from: from, to: to)
        delegate?.replaceFrame(from: from, to: to)
    }
    
    func changeLayerVisible(frame: Int, layer: Int) {
        project.changeLayerVisible(layer: layer, isVisible: !project.layerVisible(layer: layer))
        
        self.layers.list.performBatchUpdates({
            self.layers.list.reloadItems(at: [IndexPath(item: layer, section: 0)])
        },completion: {isEnd in
            self.layers.list.selectItem(at: IndexPath(item: layer, section: 0), animated: false, scrollPosition: .top)
        })
        
        UIView.performWithoutAnimation {
            self.frames.list.performBatchUpdates({
                self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
            }, completion: {isEnd in
                if isEnd {
                    self.frames.list.selectItem(at: IndexPath(item: self.project!.FrameSelected, section: 0), animated: false, scrollPosition: .top)
                }
            })
        }
        
        delegate?.updateLayer(layer: layer)
        delegate?.updateFrame(frame: frame)
        delegate?.updateCanvas()
    }

    func changeLayer(newLayer: Int) {
        let lastSelect = project.LayerSelected
            
        project.LayerSelected = newLayer
        delegate?.updateLayerSelect(lastLayer: lastSelect, newLayer: newLayer)
        delegate?.updateCanvas()

    }
    
    func updateLayerPosition(frame: Int, from: Int, to: Int) {
        project.replaceLayer(frame: frame, from: from, to: to)
        
        UIView.animate(withDuration: 0, animations: {
            self.frames.list.performBatchUpdates({
                self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
            }, completion: nil)
        })
        
        delegate?.replaceLayer(from: from, to: to)
        delegate?.updateFrame(frame: frame)
        delegate?.updateCanvas()
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
 
    func deleteLayer(frame: Int, layer: Int) {
        if(project.information.frames[frame].layers.count > 1){
            project.deleteLayer(frame: frame, layer: layer)

            project.LayerSelected = project.LayerSelected > layer || project.LayerSelected == project.layerCount ? project.LayerSelected - 1 : project.LayerSelected
            
            self.layers.list.performBatchUpdates({
                self.layers.list.deleteItems(at: [IndexPath(item: layer, section: 0)])
            },completion: {isEnd in
                self.layers.list.selectItem(at: IndexPath(item: self.project.LayerSelected, section: 0), animated: true, scrollPosition: .left)
                (self.layers.list.cellForItem(at: IndexPath(item: self.project.LayerSelected, section: 0)) as? LayersTableCell)?.setSelected(isSelect: true, anim: true)
            })
            
            UIView.performWithoutAnimation {
                self.frames.list.performBatchUpdates({
                    self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
                }, completion: {isEnd in
                    if isEnd {
                        self.frames.list.selectItem(at: IndexPath(item: self.project.FrameSelected, section: 0), animated: false, scrollPosition: .top)
                    }
                })
            }
            
            delegate?.deleteLayer(layer: layer)
            delegate?.updateLayer(layer: project.LayerSelected)
            delegate?.updateFrame(frame: frame)
            delegate?.updateCanvas()
        }
    }

    func cloneLayer(frame : Int, original: Int) {
        project.cloneLayer(frame: frame, layer: original)
        
        if project.LayerSelected > original {
            project.LayerSelected += 1
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layers.list.performBatchUpdates({
                self.layers.list.insertItems(at: [IndexPath(item: original + 1, section: 0)])
            },completion: nil)
        })
        
        UIView.performWithoutAnimation {
            self.frames.list.performBatchUpdates({
                self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
            }, completion: {isEnd in
                if isEnd {
                    self.frames.list.selectItem(at: IndexPath(item: self.project.FrameSelected, section: 0), animated: false, scrollPosition: .top)
                }
            })
        }
        
        delegate?.addLayer(layer: original + 1)
        delegate?.updateCanvas()
    }
    
    func addLayer(frame : Int, layer: Int) {
        UIView.animate(withDuration: 0.2) {
            self.layers.list.insertItems(at: [IndexPath(item: layer, section: 0)])
        }
        
        delegate?.addLayer(layer: layer)
    }
    
    func margeLayers(frame : Int, layer: Int) {
        project.LayerSelected = project.LayerSelected > layer ? project.LayerSelected - 1 : project.LayerSelected

        UIView.animate(withDuration: 0.2, animations: {
            self.layers.list.performBatchUpdates({
                self.layers.list.deleteItems(at: [IndexPath(item: layer + 1, section: 0)])
                self.layers.list.reloadItems(at: [IndexPath(item: layer, section: 0)])
            },completion: {isEnd in
                if isEnd {
                    self.layers.list.selectItem(at: IndexPath(item: self.project.LayerSelected, section: 0), animated: true, scrollPosition: .top)
                }
            })
        })
        
        delegate?.deleteLayer(layer: layer + 1)
        delegate?.updateLayer(layer: layer)
        delegate?.updateCanvas()
    }
        
    lazy private var frames : FramesCollectionView = {
        let frm = FramesCollectionView(proj: project)
        frm.list.frameDelegate = self

        frm.translatesAutoresizingMaskIntoConstraints = false
        frm.heightAnchor.constraint(equalToConstant: 118).isActive = true
        return frm
    }()
    
    lazy private var layers : LayersCollectionView = {
        let lays = LayersCollectionView(frame : .zero,proj: project)
        lays.translatesAutoresizingMaskIntoConstraints = false
        return lays
    }()
    
    var delegate : FrameControlDelegate? = nil
    
    weak var project : ProjectWork!
    
    override func viewDidLoad() {
        self.view.backgroundColor = getAppColor(color: .background)
        view.setCorners(corners: 32)
        
        view.addSubview(frames)
        view.addSubview(layers)
        
        frames.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        frames.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        frames.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true

        frames.list.frameDelegate = self
        frames.parentController = self
        
        layers.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        layers.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        layers.topAnchor.constraint(equalTo: frames.bottomAnchor, constant: 6).isActive = true
        layers.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        layers.list.frameDelegate = self
        
        //view.layer.shouldRasterize = true
        //view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        frames.list.selectItem(at: IndexPath(item: project.FrameSelected, section: 0), animated: true, scrollPosition: .top)
        layers.list.selectItem(at: IndexPath(item: project.LayerSelected, section: 0), animated: true, scrollPosition: .left)
    }
}

protocol FrameControlUpdate : class {
    func changeFrame(from : Int, to : Int)
    func changeLayer(newLayer : Int)
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

