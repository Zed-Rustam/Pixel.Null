//
//  Editor.swift
//  new Testing
//
//  Created by Рустам Хахук on 25.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit
class Editor : UIViewController {
    
    //таймер для отображения анимации
    private var timer = CADisplayLink(target: self, selector: #selector(setFrame(_:)))
    private var project : ProjectWork!
    var canvas : ProjectCanvas!
    var control : ProjectControl!
    
    private var animationTime : Int = 0
    private var nowFrameIndex : Int = 0
    
    lazy private var actionInfo: ActionInfo = {
        let info = ActionInfo()
        return info
    }()

    lazy var toolBar : ToolBar = {
        let tb = ToolBar(frame: .zero)
        tb.setData(project: project, delegate: self)
        tb.translatesAutoresizingMaskIntoConstraints = false
        
        return tb
    }()
        
    lazy var transformSize : UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        let bg = UIView()
        bg.backgroundColor = getAppColor(color: .background)
        bg.setCorners(corners: 8)
        bg.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubviewFullSize(view: bg)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = getAppColor(color: .enable)
        title.text = "1024x1024"
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        
        let bg = UIView()
        bg.backgroundColor = getAppColor(color: .background)
        bg.setCorners(corners: 8)
        bg.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubviewFullSize(view: bg)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = UIColor(named: "enableColor")
        title.text = "0°"
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
    
    func setProject(proj : ProjectWork){
        project = proj
        control?.setProject(proj : project)
        control?.updateInfo()
    }
    
    deinit {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = UIUserInterfaceStyle.init(rawValue: UserDefaults.standard.integer(forKey: "themeMode"))!
        
        control = ProjectControl(frame:.zero, proj: project)
        
        control.translatesAutoresizingMaskIntoConstraints = false

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

        control.heightAnchor.constraint(equalToConstant: 118 + UIApplication.shared.windows[0].safeAreaInsets.top).isActive = true
        control.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        control.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        control.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        view.addSubview(toolBar)
        view.addSubview(transformSize)
        view.addSubview(transformAngle)
        
        view.addSubview(actionInfo)
        
        actionInfo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        actionInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        actionInfo.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -12).isActive = true

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
        control.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 114).isActive = true
        
        transformSize.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        transformSize.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 6).isActive = true
        
        transformAngle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        transformAngle.topAnchor.constraint(equalTo: transformSize.bottomAnchor, constant: 6).isActive = true
        
        view.backgroundColor = getAppColor(color: .background)
        showTransform(isShow: false)
        
        actionInfo.transform = CGAffineTransform(translationX: 0, y: 42)
        actionInfo.alpha = 0
        actionInfo.isHidden = true
        
        toolBar.toolbarChangesDelegate = {isSubbarHide, isHide in
            var offset = isSubbarHide ? 42 : 0
            offset += isHide ? 42 : 0
            
            UIView.animate(withDuration: 0.25, animations: {
                self.actionInfo.transform = CGAffineTransform(translationX: 0, y: CGFloat(offset))
            })
        }
        
        control.ControlHideDelegate = {isHide in
            UIView.animate(withDuration: 0.25, animations: {
                self.transformSize.transform = CGAffineTransform(translationX: 0, y: isHide ? -52 : 0)
                self.transformAngle.transform = CGAffineTransform(translationX: 0, y: isHide ? -52 : 0)
            })
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        toolBar.layoutIfNeeded()
        toolBar.wasChangedTool(newTool: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //toolBar.clickTool(tool: 0)
        //toolBar.updateButtons(btns: [])
    }
    
    override func viewWillLayoutSubviews() {
        toolBar.reLayout()
        transformSize.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
        transformSize.layer.shadowPath = UIBezierPath(roundedRect: transformSize.bounds, cornerRadius: 8).cgPath
        
        transformAngle.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
        transformAngle.layer.shadowPath = UIBezierPath(roundedRect: transformSize.bounds, cornerRadius: 8).cgPath
    }
    
    override func viewDidLayoutSubviews() {
        control.setPosition()
        toolBar.setPosition()
        toolBar.tintColorDidChange()

        appMovedToForeground()
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
    
    @objc func appMovedToForeground() {
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))

        anim.duration = 1
        anim.fromValue = 0.5
        anim.toValue = 0.1
        anim.autoreverses = true
        anim.repeatCount = .infinity
        anim.timingFunction = .init(name: .easeInEaseOut)
        canvas.selectionImage.layer.add(anim, forKey: "test")
    }
}

extension Editor : FrameControlDelegate{
    
    func historyChange(action: [String : String], isRedo: Bool) {
        actionInfo.setAction(action: action, isRedo: isRedo,project: project)
    }
    

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

        self.show(pallete, sender: self)
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
        frameControl.setProject(proj: project)
        frameControl.delegate = self

        frameControl.modalPresentationStyle = .formSheet
    
        //self.view.layer.shouldRasterize = true
        
        present(frameControl, animated: true, completion: nil)
        //show(frameControl, sender: self)
    }

    func updateEditor() {
        control.updateInfo()
        canvas.updateLayers()
    }

    func updateCanvas() {
        canvas.updateLayers()
    }

    func resizeProject(){
        control.updateInfo()
        canvas.resizeProject()
    }

    func updateLayer(layer : Int){
        UIView.performWithoutAnimation {
            self.control.layers.list.reloadItems(at: [IndexPath(item: layer, section: 0)])
        }
    }

    func updateLayers(){
        UIView.performWithoutAnimation {
            self.control.layers.list.reloadData()
        }
    }

    func updateFrame(frame : Int){
        UIView.performWithoutAnimation {
            self.control.frames.list.reloadItems(at: [IndexPath(item: frame, section: 0)])
        }
    }

    func addLayer(layer: Int) {
        UIView.performWithoutAnimation {
            self.control.layers.list.insertItems(at: [IndexPath(item: layer, section: 0)])
        }
    }

    func addFrame(frame: Int) {
        UIView.performWithoutAnimation {
            self.control.frames.list.insertItems(at: [IndexPath(item: frame, section: 0)])
        }
    }

    func deleteLayer(layer : Int){
        UIView.performWithoutAnimation {
            self.control.layers.list.deleteItems(at: [IndexPath(item: layer, section: 0)])
        }
    }

    func deleteFrame(frame : Int){
        UIView.performWithoutAnimation {
            self.control.frames.list.deleteItems(at: [IndexPath(item: frame, section: 0)])
        }
    }

    func updateFrameSelect(lastFrame : Int, newFrame: Int) {
        if newFrame != lastFrame {
            UIView.performWithoutAnimation {
                self.control.frames.list.reloadItems(at: [IndexPath(item: lastFrame, section: 0),IndexPath(item: newFrame, section: 0)])
            }
            control.layers.list.reloadData()
        }
    }

    func updateLayerSelect(lastLayer : Int, newLayer: Int) {
        if newLayer != lastLayer {
            UIView.performWithoutAnimation {
                self.control.layers.list.reloadItems(at: [IndexPath(item: lastLayer, section: 0),IndexPath(item: newLayer, section: 0)])
            }
        }
    }

    func replaceLayer(from: Int, to: Int) {
        if from != to {
            UIView.performWithoutAnimation {
                self.control.layers.list.moveItem(at: IndexPath(item: from, section: 0), to: IndexPath(item: to, section: 0))
            }
        }
    }

    func replaceFrame(from: Int, to: Int) {
        if from != to {
            UIView.performWithoutAnimation {
                self.control.frames.list.moveItem(at: IndexPath(item: from, section: 0), to: IndexPath(item: to, section: 0))
            }
        }
    }
}

extension Editor : ToolSettingsDelegate {
    func openProjectSettings() {
        project.savePreview(frame: project.FrameSelected)
        
        let projectSettings = ProjectSettingsController()
        projectSettings.project = project
        projectSettings.editor = self
        projectSettings.modalPresentationStyle = .pageSheet
        self.show(projectSettings, sender: self)
    }
    
    func setSelectionSettings(mode: Int) {
        canvas.selection.type = Selection.SelectionType.init(rawValue: mode)!
    }
    
    func openPencilSettings() {
        let pencilSettings = PencilSettings()
        pencilSettings.modalPresentationStyle = .formSheet
        pencilSettings.delegate = self
        pencilSettings.setSettings(penSize: Int(canvas.penTool.width), pixelPerfect: canvas.penTool.pixPerfect)
        self.show(pencilSettings, sender: self)
    }
    
    func openEraseSettings() {
        let eraseSettings = EraseSettings()
        eraseSettings.modalPresentationStyle = .formSheet
        eraseSettings.delegate = self
        eraseSettings.setSettings(eraseSize: canvas.eraserTool.width)
        self.show(eraseSettings, sender: self)
    }
    
    func openGradientSettings() {
        let gradientSettings = GradientSettings()
        gradientSettings.project = project
        gradientSettings.modalPresentationStyle = .formSheet
        gradientSettings.delegate = self
        gradientSettings.setSettings(stepCount: canvas.gradientTool.stepCount, startColor: canvas.gradientTool.startColor, endColor: canvas.gradientTool.endColor)
        self.show(gradientSettings, sender: self)
    }
    
    func setEraseSettings(eraseSize : Int) {
        canvas.eraserTool.width = eraseSize
    }
    
    func setPenSettings(penSize: Int, pixPerfect : Bool) {
        canvas.penTool.width = penSize
        canvas.penTool.pixPerfect = pixPerfect
    }
    
    func setGradientSettings(stepCount: Int, startColor: UIColor, endColor: UIColor) {
        canvas.gradientTool.stepCount = stepCount
        canvas.gradientTool.startColor = startColor
        canvas.gradientTool.endColor = endColor
    }
}

extension Editor {
    func startAnimation() {
        project.savePreview(frame: project.FrameSelected)
        nowFrameIndex = project.FrameSelected
        project.LayerSelected = 0
        for i in 0..<project.FrameSelected {
            animationTime += project.information.frames[i].delay
        }
        
        toolBar.isUserInteractionEnabled = false
        toolBar.animationStart()
        timer = CADisplayLink(target: self, selector: #selector(setFrame(_:)))
        canvas.startAnimationMode()
        canvas.setImageFromAnimation(img: project.getFrame(frame: project.FrameSelected, size: project.projectSize).flip(xFlip: project.isFlipX, yFlip: project.isFlipY))

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
                
                UIView.animate(withDuration: 0.0, animations: {
                    self.control.frames.list.reloadItems(at: [IndexPath(item: i, section: 0),IndexPath(item: self.nowFrameIndex, section: 0)])
                    self.control.frames.list.selectItem(at: IndexPath(item: i, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                })
                
                nowFrameIndex = i
                canvas.setImageFromAnimation(img: project.getFrame(frame: i, size: project.projectSize).flip(xFlip: project.isFlipX, yFlip: project.isFlipY))
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
            toolBar.clickTool(tool: canvas.transformView.lastToolSelected)
            canvas.transformView.isCopyMode = false
        }
    }
    
    func startTransformWithImage() {
        if !canvas.selection.isSelectEmpty(select:UIImage.merge(images: [project.loadCopyImage()])!.flip(xFlip: project.isFlipX, yFlip: project.isFlipY)) {
            canvas.transformView.isCopyMode = true
            canvas.transformView.lastToolSelected = 6
            canvas.setTransformCopyImage()
            canvas.isSelected = true
            toolBar.clickTool(tool: 2)
        }
    }
    
    
    func saveSelection(){
        if canvas.isSelected {
            try! project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected).inner(image : UIImage.merge(images: [canvas.selectionLayer])!.flip(xFlip: project.isFlipX, yFlip: project.isFlipY)).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("copy.png"))
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
    
    func historyChange(action: [String : String], isRedo: Bool)
}

protocol ToolSettingsDelegate : class{
    func openPencilSettings()
    func openProjectSettings()
    func openEraseSettings()
    func openGradientSettings()
    
    func setPenSettings(penSize : Int, pixPerfect : Bool)
    func setEraseSettings(eraseSize : Int)
    func setSelectionSettings(mode : Int)
    func setGradientSettings(stepCount : Int,startColor : UIColor, endColor : UIColor)
}

//protocol ProjectActionDelegate : class
