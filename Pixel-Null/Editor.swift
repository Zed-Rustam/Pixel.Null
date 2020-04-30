//
//  Editor.swift
//  new Testing
//
//  Created by Рустам Хахук on 25.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit
class Editor : UIViewController {
    private var timer = CADisplayLink(target: self, selector: #selector(setFrame(_:)))
    private var project : ProjectWork!
    var canvas : ProjectCanvas!
    var control : ProjectControl!
    private var animationTime : Int = 0
    private var nowFrameIndex : Int = 0

    lazy var toolBar : ToolBar = {
        let tb = ToolBar(frame: .zero)
        tb.setData(project: project, delegate: self)
        tb.translatesAutoresizingMaskIntoConstraints = false
        
        return tb
    }()
    
    lazy var transformSize : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        
        let bg = UIView()
        bg.backgroundColor = ProjectStyle.uiBackgroundColor
        bg.setCorners(corners: 8)
        bg.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubviewFullSize(view: bg)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = ProjectStyle.uiEnableColor
        title.text = "1024x1024"
        title.font = UIFont(name: "Rubik-Bold", size: 16)
        title.textAlignment = .center
        
        self.canvas.transformView.resizeDelegate = {size in
            title.text = "\(Int(abs(size.width)))x\(Int(abs(size.height)))"
        }
        
        mainView.addSubviewFullSize(view: title)
        
        mainView.widthAnchor.constraint(equalToConstant: 132).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return mainView
    }()

    lazy var transformAngle : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        
        let bg = UIView()
        bg.backgroundColor = ProjectStyle.uiBackgroundColor
        bg.setCorners(corners: 8)
        bg.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubviewFullSize(view: bg)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = ProjectStyle.uiEnableColor
        title.text = "0°"
        title.font = UIFont(name: "Rubik-Bold", size: 16)
        title.textAlignment = .center
        
        self.canvas.transformView.rotateDelegate = {angle in
            title.text = "\(Int(angle))°"
        }
        
        mainView.addSubviewFullSize(view: title)
        
        mainView.widthAnchor.constraint(equalToConstant: 132).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return mainView
    }()
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }
    
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
    
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        control = ProjectControl(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 94 + UIApplication.shared.windows[0].safeAreaInsets.top), proj: project)
        control.updateInfo()
        control.layers.frameControlDelegate = self
        canvas = ProjectCanvas(frame: self.view.bounds, proj: project)
        canvas.delegate = self
        canvas.editor = self
        
        control.setCanvas(canvas: canvas)
        control.frames.editor = self
        control.frames.list.editor = self
        
        control.layers.list.editor = self

        view.addSubview(canvas)
        view.addSubview(control)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: UIDevice.orientationDidChangeNotification, object: nil)

        view.addSubview(toolBar)
        view.addSubview(transformSize)
        view.addSubview(transformAngle)

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
        
        transformSize.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        transformSize.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 6).isActive = true
        
        transformAngle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        transformAngle.topAnchor.constraint(equalTo: transformSize.bottomAnchor, constant: 6).isActive = true
        
        view.backgroundColor = ProjectStyle.uiBackgroundColor
        showTransform(isShow: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func rotate() {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        toolBar.layoutIfNeeded()
        toolBar.wasChangedTool(newTool: 0)
    }
    
    override func viewWillLayoutSubviews() {
        print("some shit is here")
        toolBar.reLayout()
    }
    
    override func viewDidLayoutSubviews() {
        control.setPosition()
        toolBar.setPosition()
    }
    
    func showTransform(isShow : Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transformSize.alpha = isShow ? 1 : 0
            self.transformAngle.alpha = isShow ? 1 : 0
        })
    }
    
    @objc func appMovedToBackground() {
        project.save()
        project.savePreview(frame: project.FrameSelected)
    }
}

extension Editor : FrameControlDelegate{
    
    //открываем окно паллитры проекта
    func openColorSelector() {
        let pallete = ProjectPallete()
        
        //начальный цвет
        pallete.startColor = canvas.selectorColor
        
        //проект для доступа к паллитре
        pallete.project = project
        
        //при завершении выбора
        pallete.selectDelegate = {[unowned self] in
            self.canvas.selectorColor = $0
            self.toolBar.updateSelectedColor(newColor: $0)
        }
        pallete.modalPresentationStyle = .formSheet
        
        self.show(pallete, sender: nil)
    }
    
    func changeMainColor(color: UIColor) {
        canvas.selectorColor = color
        toolBar.updateSelectedColor(newColor: color)
    }
    
    func updateSelection(select: UIImage, isSelected : Bool) {
        canvas.isSelected = isSelected
        canvas.selectionLayer = select
        canvas.selectionImage.image = canvas.selectionLayer
        try! canvas.selectionLayer.pngData()!.write(to: project.getProjectDirectory().appendingPathComponent("selection.png"))
    }
    
    func openFrameControl(project: ProjectWork) {
        
        finishTransform()
        project.savePreview(frame: project.FrameSelected)
        
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
                self.control.layers.list.reloadItems(at: [IndexPath(item: layer, section: 0)])
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
        pencilSettings.setSettings(penSize: Int(canvas.pen.size), pixelPerfect: canvas.pen.pixPerfect)
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
    
    func setPenSettings(penSize: Int, pixPerfect : Bool) {
        canvas.pen.size = Double(penSize)
        canvas.pen.pixPerfect = pixPerfect
    }
    
    func setGradientSettings(stepCount: Int, startColor: UIColor, endColor: UIColor) {
        canvas.gradient.stepCount = stepCount
        canvas.gradient.startColor = startColor
        canvas.gradient.endColor = endColor
    }
}

extension Editor {
    func startAnimation() {
        project.savePreview(frame: project.FrameSelected)
        nowFrameIndex = project.FrameSelected
        
        for i in 0..<project.FrameSelected {
            animationTime += project.information.frames[i].delay
        }
        
        toolBar.isUserInteractionEnabled = false
        toolBar.animationStart()
        timer = CADisplayLink(target: self, selector: #selector(setFrame(_:)))
        canvas.startAnimationMode()
        timer.add(to: .main, forMode: .common)
    }
   
    func stopAnimation() {
        toolBar.isUserInteractionEnabled = true
        toolBar.animationStop()
        toolBar.UnDoReDoAction()

        timer.invalidate()
        project.FrameSelected = nowFrameIndex
        
        control.frames.list.reloadData()
        control.layers.list.reloadData()
        canvas.endAnimationMode()
    }
    
    @objc func setFrame(_ displayLink: CADisplayLink) {
        print(displayLink.duration)
        animationTime += Int(displayLink.duration * 1000)
        if animationTime >= project.animationDelay {
            animationTime = animationTime % project.animationDelay
        }
        
        var nowTime = 0
        for i in 0..<project.information.frames.count {
            nowTime += project.information.frames[i].delay
            if nowTime >= animationTime && nowTime - project.information.frames[i].delay < animationTime && i != nowFrameIndex {
                print("currect frame : \(i)")
                project.FrameSelected = i
                control.frames.list.reloadItems(at: [IndexPath(item: i, section: 0),IndexPath(item: nowFrameIndex, section: 0)])
                nowFrameIndex = i
                canvas.setImageFromAnimation(img: project.getFrame(frame: i, size: project.projectSize))
                break
            } else if nowTime >= animationTime {
                break
            }
        }
    }
    
    
}

extension Editor {
    func finishTransform() {
        if canvas.selectedTool == 2 {
            showTransform(isShow: false)
            canvas.transformView.isCopyMode = false
            toolBar.clickTool(tool: canvas.transformView.lastToolSelected)
        }
    }
    
    func startTransformWithImage() {
        if !canvas.selection.isSelectEmpty(select:UIImage.merge(images: [project.loadCopyImage()])!) {
            canvas.transformView.isCopyMode = true
            canvas.setTransformCopyImage()
            canvas.isSelected = true
            toolBar.clickTool(tool: 2)
        }
    }
    
    
    func saveSelection(){
        if canvas.isSelected {
            try! project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected).inner(image : UIImage.merge(images: [canvas.selectionLayer])!).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("copy.png"))
        }
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
    
    func changeMainColor(color : UIColor)
    func openColorSelector()
}

protocol ToolSettingsDelegate : class{
    func openPencilSettings()
    func openEraseSettings()
    func openGradientSettings()
    
    func setPenSettings(penSize : Int, pixPerfect : Bool)
    func setEraseSettings(eraseSize : Int)
    func setGradientSettings(stepCount : Int,startColor : UIColor, endColor : UIColor)
}

