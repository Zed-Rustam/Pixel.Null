//
//  Editor.swift
//  new Testing
//
//  Created by Рустам Хахук on 25.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit
class Editor : UIViewController {
    
    private var project : ProjectWork!
    var canvas : ProjectCanvas!
    private var control : ProjectControl!
    
    lazy private var toolBar : ToolBar = {
        let tb = ToolBar(frame: .zero)
        tb.setData(project: project, delegate: self)
        tb.translatesAutoresizingMaskIntoConstraints = false
        
        return tb
    }()
    private var longTap : UILongPressGestureRecognizer!
    weak var gallery : GalleryControl? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setProject(proj : ProjectWork){
        project = proj
        control?.setProject(proj : project)
        control?.updateInfo()
    }
    
    
    override func viewDidLoad() {
        control = ProjectControl(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 94 + UIApplication.shared.windows[0].safeAreaInsets.top), proj: project)
        control.updateInfo()
        control.layers.frameControlDelegate = self
        canvas = ProjectCanvas(frame: self.view.bounds, proj: project)
        canvas.delegate = self
        
        control.setCanvas(canvas: canvas)
        
        view.addSubview(canvas)
        view.addSubview(control)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(close), name: UIApplication.willTerminateNotification, object: nil)

        view.addSubview(toolBar)
        
        toolBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        toolBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        canvas.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        canvas.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        canvas.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        canvas.barDelegate = toolBar
        
        control.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        control.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        control.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        control.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 108).isActive = true
        
        view.backgroundColor = ProjectStyle.uiBackgroundColor
    }
    @objc func rotate() {
        //toolBar.reLayout()

    }
    @objc func close() {
        print("now exit")
        project.save()
        //toolBar.reLayout()

    }
    
    override func viewWillLayoutSubviews() {
        print("some shit is here")
        toolBar.reLayout()
    }
    
    override func viewDidLayoutSubviews() {
        control.setPosition()
        toolBar.setPosition()
    }
    
    
    @objc func appMovedToBackground() {
        project.save()
        project.savePreview(frame: project.FrameSelected)
    }
}

extension Editor : FrameControlDelegate{
    
    func updateSelection(select: UIImage, isSelected : Bool) {
        canvas.isSelected = isSelected
        canvas.selectionLayer = select
        canvas.selectionImage.image = canvas.selectionLayer
        try! canvas.selectionLayer.pngData()!.write(to: project.getProjectDirectory().appendingPathComponent("selection.png"))
    }
    
    
    func openFrameControl(project: ProjectWork) {
        let frameControl = FrameControl()
        frameControl.project = project
        frameControl.delegate = self
        
        frameControl.modalPresentationStyle = .pageSheet
        frameControl.modalTransitionStyle = .coverVertical
        frameControl.isModalInPresentation = true
        show(frameControl, sender: self)
    }
      
    func updateEditor() {
        control.updateInfo()
        canvas.updateLayers()
    }
    
    func updateCanvas() {
        canvas.updateLayers()
    }
    
    func updateLayer(layer : Int){
        UIView.animate(withDuration: 0.0, animations: {
             //self.control.layers?.list.performBatchUpdates({
                self.control.layers.list.reloadItems(at: [IndexPath(item: layer, section: 0)])
             //})
        })
    }
    
    func updateLayers(){
        UIView.animate(withDuration: 0.0, animations: {
            self.control.layers.list.reloadData()
        })
    }
    
    func updateFrame(frame : Int){
        UIView.animate(withDuration: 0.0, animations: {
            self.control.frames.list.reloadItems(at: [IndexPath(item: frame, section: 0)])
        })
    }
    
    func addLayer(layer: Int) {
        UIView.animate(withDuration: 0.0, animations: {
            self.control.layers.list.insertItems(at: [IndexPath(item: layer, section: 0)])
        })
    }
    
    func addFrame(frame: Int) {
        UIView.animate(withDuration: 0.0, animations: {
            self.control.frames.list.insertItems(at: [IndexPath(item: frame, section: 0)])
        })
    }
    
    func deleteLayer(layer : Int){
        UIView.animate(withDuration: 0.0, animations: {
            self.control.layers.list.performBatchUpdates({
                self.control.layers.list.deleteItems(at: [IndexPath(item: layer, section: 0)])
            }, completion: nil)
        })
    }
    
    func deleteFrame(frame : Int){
        UIView.animate(withDuration: 0.0, animations: {
            self.control.frames.list.deleteItems(at: [IndexPath(item: frame, section: 0)])
        })
    }
    
    func updateFrameSelect(lastFrame : Int, newFrame: Int) {
        if newFrame != lastFrame {
            UIView.animate(withDuration: 0.0, animations: {
                self.control.frames.list.performBatchUpdates({
                    self.control.frames.list.reloadItems(at: [IndexPath(item: lastFrame, section: 0),IndexPath(item: newFrame, section: 0)])
                })
            })
            control.layers.list.reloadData()
        }
    }
    
    func updateLayerSelect(lastLayer : Int, newLayer: Int) {
        if newLayer != lastLayer {
            UIView.animate(withDuration: 0.0, animations: {
                self.control.layers.list.reloadItems(at: [IndexPath(item: lastLayer, section: 0),IndexPath(item: newLayer, section: 0)])
            })
        }
    }
    
    func replaceLayer(from: Int, to: Int) {
        if from != to {
            UIView.animate(withDuration: 0.0, animations: {
                self.control.layers.list.moveItem(at: IndexPath(item: from, section: 0), to: IndexPath(item: to, section: 0))
            })
        }
    }
    func replaceFrame(from: Int, to: Int) {
        if from != to {
            UIView.animate(withDuration: 0.0, animations: {
                self.control.frames.list.moveItem(at: IndexPath(item: from, section: 0), to: IndexPath(item: to, section: 0))
            })
        }
    }
}

extension Editor : ToolSettingsDelegate {
    func openPencilSettings() {
        let pencilSettings = PencilSettings()
        pencilSettings.modalPresentationStyle = .pageSheet
        pencilSettings.delegate = self
        pencilSettings.setSettings(penSize: Int(canvas.pen.size), penColor: UIColor(hex: canvas.pen.color)!, penSmooth: canvas.pen.smooth, pixelPerfect: canvas.pen.pixPerfect)
        self.show(pencilSettings, sender: self)
    }
    func openEraseSettings() {
        let eraseSettings = EraseSettings()
        eraseSettings.modalPresentationStyle = .pageSheet
        eraseSettings.delegate = self
        eraseSettings.setSettings(eraseSize: Int(canvas.erase.size))
        self.show(eraseSettings, sender: self)
    }
    func openGradientSettings() {
        let gradientSettings = GradientSettings()
        gradientSettings.modalPresentationStyle = .pageSheet
        gradientSettings.delegate = self
        gradientSettings.setSettings(stepCount: canvas.gradient.stepCount, startColor: canvas.gradient.startColor, endColor: canvas.gradient.endColor)
        self.show(gradientSettings, sender: self)
    }
    func setEraseSettings(eraseSize : Int) {
        canvas.erase.size = Double(eraseSize)
    }
    func setPenSettings(penSize: Int,penColor: UIColor, penSmooth: Int, pixPerfect : Bool) {
        canvas.pen.color = UIColor.toHex(color: penColor)
        canvas.pen.size = Double(penSize)
        canvas.pen.smooth = penSmooth
        canvas.pen.pixPerfect = pixPerfect
    }
    func setGradientSettings(stepCount: Int, startColor: UIColor, endColor: UIColor) {
        canvas.gradient.stepCount = stepCount
        canvas.gradient.startColor = startColor
        canvas.gradient.endColor = endColor
    }
}

protocol FrameControlDelegate : class {
    func openFrameControl(project : ProjectWork)
    func updateEditor()
    func updateLayer(layer : Int)
    func updateLayers()
    func updateSelection(select : UIImage, isSelected : Bool)

    func updateFrame(frame : Int)
    
    func replaceLayer(from : Int, to : Int)
    func replaceFrame(from : Int, to : Int)
    
    func updateFrameSelect(lastFrame : Int, newFrame : Int)
    func updateLayerSelect(lastLayer : Int, newLayer : Int)

    func addLayer(layer : Int)
    func addFrame(frame : Int)
    func deleteLayer(layer : Int)
    func deleteFrame(frame : Int)
    func updateCanvas()
}

protocol ToolSettingsDelegate : class{
    func openPencilSettings()
    func openEraseSettings()
    func openGradientSettings()
    
    func setPenSettings(penSize : Int, penColor : UIColor, penSmooth : Int, pixPerfect : Bool)
    func setEraseSettings(eraseSize : Int)
    func setGradientSettings(stepCount : Int,startColor : UIColor, endColor : UIColor)
}
