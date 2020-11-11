//
//  EditorModern.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 31.10.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class EditorModern: UIViewController {
    
    private var timer = CADisplayLink(target: self, selector: #selector(setFrame(_:)))
    private var animationTime : Int = 0
    private var nowFrameIndex : Int = 0
    
    private unowned var gallery: GalleryControl
    
    //пространство для рисования
    private var canvas: ProjectCanvas!
    //бар с иснтсументами
    private var toolBar: ToolBarView
    private var subBar: SubBar
    //бар со слоями и кадрами
    private var projectControl: ProjectControlView!
    //Рабочий прокет
    private unowned var project: ProjectWork
    
    init(proj: ProjectWork, gallery gal: GalleryControl) {
        project = proj
        toolBar = ToolBarView()
        subBar = SubBar()
        gallery = gal
        
        super.init(nibName: nil, bundle: nil)
        
        project.editorDelegate = self
        toolBar.delegate = self
        
        projectControl = ProjectControlView(proj: project,frameDelegate: self)

    }
    
    private func setupViews() {
        canvas = ProjectCanvas(frame: view.frame, proj: project)
        canvas.delegate = self
        
        view.addSubview(canvas)
        view.addSubview(projectControl)
        view.addSubview(subBar)
        view.addSubview(toolBar)

        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        NSLayoutConstraint.activate([
            projectControl.topAnchor.constraint(equalTo: view.topAnchor),
            projectControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            projectControl.rightAnchor.constraint(equalTo: view.rightAnchor),
            projectControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 114),
            
            
            toolBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: CGFloat(-toolBar.getColumnsCount(ofWidth: Int(view.frame.width)) * 36 - 32)),
            toolBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            toolBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            subBar.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: -48),
            subBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            subBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            subBar.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: 12),
        ])
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
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)

        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subBar.setNeedsLayout()
        subBar.layoutIfNeeded()
        
        toolBar.setNeedsLayout()
        toolBar.layoutIfNeeded()
        changeTool(tool: 0, subButtons: [])
        
        actionHistoryChange()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditorModern: FrameActionDelegate {
    func replaceFrame(from: Int, to: Int) {
        projectControl.replaceFrame(from: from, to: to)
    }
    
    func updateFrameSelect(lastFrame: Int, newFrame: Int) {
        if newFrame != lastFrame {
            canvas.transformView.needToSave = false
            endTransformMode()
            
            project.savePreview(frame: project.FrameSelected)
            
            project.LayerSelected = 0            
            project.FrameSelected = newFrame
            
            projectControl.updateFrameSelect(last: lastFrame, now: newFrame)
            canvas.updateLayers()
        }
    }
    
    func updateFrame(frame: Int) {
        projectControl.updateFrame(index: frame)
    }
    
    func addFrame(frame: Int) {
        projectControl.addFrame(at: frame)
    }
    
    func deleteFrame(frame: Int) {
        projectControl.deleteFrame(at: frame)
    }
    
    func updateCanvas() {
        canvas.updateLayers()
    }
    
    func openFrameControl() {
        endTransformMode()

        let frm = FrameControl()
        frm.setProject(proj: project)
        frm.editorDelegate = self
        
        frm.modalPresentationStyle = .pageSheet
        
        present(frm, animated: true, completion: nil)
    }
}

extension EditorModern: LayerActionDelegate {
    func updateLayers() {
        projectControl.reloadLayers()
    }
    
    func replaceLayer(from: Int, to: Int) {
        projectControl.replaceLayer(from: from, to: to)
        projectControl.updateFrame(index: project.FrameSelected)
        canvas.updateLayers()
    }
    
    func updateLayerSelect(lastFrame: Int, newFrame: Int) {
        if newFrame != lastFrame {
            endTransformMode()
            
            project.LayerSelected = newFrame
            projectControl.updateLayerSelect(last:lastFrame , now: newFrame)
            canvas.updateLayers()
        }
    }
    
    func updateLayer(frame: Int) {
        projectControl.updateLayer(index: frame)
        canvas.updateLayers()
    }
    
    func addLayer(frame: Int) {
        projectControl.addLayer(at: frame)
    }
    
    func deleteLayer(frame: Int) {
        projectControl.deleteLayer(at: frame)
    }
}

extension EditorModern: EditorDrawDelegate {
    func drawingEnd() {
        updateFrame(frame: project.FrameSelected)
        updateLayer(frame: project.LayerSelected)
    }
}

extension EditorModern: AnimationDelegate {
    func onStartAnimation() {
        endTransformMode()
        
        toolBar.setDisable(isDisable: true)
        
        subBar.setButtons(btns: [])
        
        project.savePreview(frame: project.FrameSelected)
        nowFrameIndex = project.FrameSelected
        project.LayerSelected = 0
        for i in 0..<project.FrameSelected {
            animationTime += project.information.frames[i].delay
        }
        
        timer = CADisplayLink(target: self, selector: #selector(setFrame(_:)))
        canvas.startAnimationMode()
        canvas.setImageFromAnimation(img: project.getFrame(frame: project.FrameSelected, size: project.projectSize).flip(xFlip: project.isFlipX, yFlip: project.isFlipY))

        timer.add(to: .main, forMode: .common)
    }
    
    func onStopAnimation() {
        timer.invalidate()
        
        toolBar.setDisable(isDisable: false)
        actionHistoryChange()
        
        projectControl.updateFrameSelect(last: project.FrameSelected, now: nowFrameIndex)
        project.FrameSelected = nowFrameIndex

        projectControl.reloadLayers()
        
        canvas.endAnimationMode()
    }
    
    @objc func setFrame(_ displayLink: CADisplayLink) {
        animationTime += Int(displayLink.duration * 1000)
        if animationTime >= project.animationDelay {
            animationTime = animationTime % project.animationDelay
        }
        
        var nowTime = 0
        for i in 0..<project.information.frames.count {
            nowTime += project.information.frames[i].delay
            if nowTime >= animationTime && nowTime - project.information.frames[i].delay < animationTime && i != nowFrameIndex {
                project.FrameSelected = i
                
                projectControl.updateFrame(index: i)
                projectControl.updateFrame(index: nowFrameIndex)
                projectControl.moveFrameToCenter()
                
                nowFrameIndex = i
                
                canvas.setImageFromAnimation(img: project.getFrame(frame: i, size: project.projectSize).flip(xFlip: project.isFlipX, yFlip: project.isFlipY))
                break
            } else if nowTime >= animationTime {
                break
            }
        }
    }
}

extension EditorModern: ToolsActionDelegate {
    func changeColor(newColor: UIColor) {
        canvas.selectorColor = newColor
        toolBar.changeColorSelected(newColor: newColor)
    }
    
    func actionHistoryChange() {
        if project.information.actionList.lastActiveAction < project.information.actionList.actions.count - 1 {
            toolBar.getBtnTool(id: -2)!.isEnabled = true
        } else {
            toolBar.getBtnTool(id: -2)!.isEnabled = false
        }

        if project.information.actionList.lastActiveAction >= 0 {
            toolBar.getBtnTool(id: -3)!.isEnabled = true
        } else {
            toolBar.getBtnTool(id: -3)!.isEnabled = false
        }
    }
    
    func updateSelection(selection: UIImage, isSelected: Bool) {
        canvas.isSelected = isSelected
        canvas.selectionLayer = selection
        canvas.selectionImage.image = canvas.selectionLayer
        try! canvas.selectionLayer.pngData()!.write(to: project.getProjectDirectory().appendingPathComponent("selection.png"))
    }
    
    func pasteImage() {
        if !canvas.selection.isSelectEmpty(select:UIImage.merge(images: [project.loadCopyImage()])!.flip(xFlip: project.isFlipX, yFlip: project.isFlipY)) {
            canvas.transformView.isCopyMode = true
            canvas.transformView.lastToolSelected = 6
            canvas.setTransformCopyImage()
            canvas.isSelected = true
            toolBar.getBtnTool(id: 2)?.sendActions(for: .touchUpInside)
        }
    }
    
    func saveSelection() {
        if canvas.isSelected {
            try! project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected).inner(image : UIImage.merge(images: [canvas.selectionLayer])!.flip(xFlip: project.isFlipX, yFlip: project.isFlipY)).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("copy.png"))
        }
    }
    
    var editorCanvas: ProjectCanvas {
        canvas
    }
    
    func startTransformMode() {
        if canvas.transformView.isCopyMode {
            canvas.checkTransformChangeBefore(newTool: 2)
        }
    }
    
    func endTransformMode() {
        if canvas.selectedTool == 2 {
            changeTool(tool: 0,subButtons: [])
            canvas.transformView.isCopyMode = false
        }
    }
    
    func changeToolBarState(isToolsHide: Bool?, isSubBarHide: Bool?) {
        if isToolsHide != nil {
            subBar.offset = isToolsHide! ? 48 : 0
            subBar.updateState()
        }
    }
    
    func resizeProject() {
        projectControl.updateAll()
        canvas.resizeProject()
    }
    
    
    func projectSettingsChange() {
        projectControl.updateAll()
        canvas.updateLayers()
    }
    
    func isGrid() -> Bool {
        return canvas.isGridVIsible
    }
    
    func changeGrid() {
        canvas.isGridVIsible.toggle()
    }
    
    var editorProject: ProjectWork {
        project
    }
    
    func openPencilSettings(sender: UIView) {
        endTransformMode()

        let settings = PencilSettings()
        settings.delegate2 = self
        settings.setSettings(penSize: canvas.penTool.width, pixelPerfect: canvas.penTool.pixPerfect)
        settings.modalPresentationStyle = .pageSheet
        
        present(settings, animated: true, completion: nil)
    }
    
    func openEraseSettings(sender: UIView) {
        endTransformMode()

        let settings = EraseSettings()
        settings.delegate2 = self
        settings.setSettings(eraseSize: canvas.eraserTool.width)
        settings.modalPresentationStyle = .pageSheet
        
        present(settings, animated: true, completion: nil)
    }
    
    func openGradientSettings(sender: UIView) {
        endTransformMode()

        let settings = GradientSettings()
        settings.delegate2 = self
        settings.setSettings(stepCount: canvas.gradientTool.stepCount, startColor: canvas.gradientTool.startColor, endColor: canvas.gradientTool.endColor)
        settings.modalPresentationStyle = .pageSheet
        
        present(settings, animated: true, completion: nil)
    }
    
    func openProjectSettings(sender: UIView) {
        endTransformMode()

        let settings = ProjectSettingsController()
        settings.project = project
        settings.delegate = self
        settings.modalPresentationStyle = .pageSheet
        
        present(settings, animated: true, completion: nil)
    }
    
    func openPalette(sender: UIView) {
        endTransformMode()

        let pallete = ProjectPalleteNavigation()

        pallete.isModalInPresentation = true
        
        //начальный цвет
        pallete.controller.startColor = canvas.selectorColor

        //проект для доступа к паллитре
        pallete.controller.project = project

        //при завершении выбора
        pallete.controller.selectDelegate = {[unowned self] in
            self.canvas.selectorColor = $0
            (sender as! ColorSelector).color = $0
        }
        
        present(pallete, animated: true, completion: nil)
    }
    
    func saveAndExit() {
        endTransformMode()

        project.save()
        project.savePreview(frame: project.FrameSelected)
        project.saveWidgetPreview()
        
        gallery.updateProjectView(proj: project)
        
        dismiss(animated: true, completion: nil)
    }
    
    func changeTool(tool: Int,subButtons: [UIButton]) {
        canvas.checkTransformChangeBefore(newTool: tool)
        
        subBar.setButtons(btns: subButtons)
        
        toolBar.changeToolSelect(tool: tool)
        canvas.selectedTool = tool
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
    
    func setSelectionSettings(mode: Int) {
        canvas.selection.type = Selection.SelectionType.init(rawValue: mode)!
    }
}

protocol AnimationDelegate: class {
    func onStartAnimation()
    func onStopAnimation()
}

protocol FrameActionDelegate: class {
    func replaceFrame(from : Int, to : Int)
    func updateFrameSelect(lastFrame : Int, newFrame : Int)
    func updateFrame(frame : Int)
    func addFrame(frame : Int)
    func deleteFrame(frame : Int)
    
    func openFrameControl()
    func updateCanvas()
}

protocol LayerActionDelegate: class {
    func replaceLayer(from : Int, to : Int)
    func updateLayerSelect(lastFrame : Int, newFrame : Int)
    func updateLayer(frame : Int)
    func addLayer(frame : Int)
    func deleteLayer(frame : Int)
    
    func updateLayers()
}

protocol EditorDrawDelegate: class {
    func drawingEnd()
}

protocol ToolsActionDelegate: class {
    func openPencilSettings(sender: UIView)
    func openEraseSettings(sender: UIView)
    func openGradientSettings(sender: UIView)
    func openProjectSettings(sender: UIView)
    func openPalette(sender: UIView)

    func setPenSettings(penSize : Int, pixPerfect : Bool)
    func setEraseSettings(eraseSize : Int)
    func setSelectionSettings(mode : Int)
    func setGradientSettings(stepCount : Int,startColor : UIColor, endColor : UIColor)
    
    func changeGrid()
    func isGrid() -> Bool
    
    func projectSettingsChange()
    func resizeProject()
    
    func saveAndExit()

    func changeTool(tool: Int, subButtons: [UIButton])
    
    func changeToolBarState(isToolsHide: Bool?, isSubBarHide: Bool?)
    
    func startTransformMode()
    
    func endTransformMode()
    
    func saveSelection()
    
    func pasteImage()
    
    func updateSelection(selection: UIImage, isSelected: Bool)
    
    func actionHistoryChange()
    
    func changeColor(newColor: UIColor)
    
    var editorProject: ProjectWork {get}
    var editorCanvas: ProjectCanvas {get}
}
