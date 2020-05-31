//
//  ProjectCanvas.swift
//  new Testing
//
//  Created by Рустам Хахук on 25.02.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectCanvas : UIView,UIGestureRecognizerDelegate, EditorDelegate {
    
    //Editor Delegate
    var selecion: UIImage? {
        get{
            return isSelected ? selectionLayer : nil
        }
    }
    
    var symmetry: CGPoint {
        get{
            return CGPoint(x: !isVerticalSymmeyry ? 0 : symmetryView.startX, y: !isHorizontalSymmetry ? 0 : symmetryView.startY)
        }
    }
    
    var color: UIColor {
        get{
            return selectorColor
        }
    }
    
    var selectLayer : UIImage {
        get{
            return targetLayer
        }
        set {
            targetLayer = newValue
            targetImage.image = targetLayer
        }
    }
    
    var actionLayer: UIImage {
        get{
            return ActionLayer
        }
        set{
            ActionLayer = newValue
            actionImage.image = ActionLayer
        }
    }
    
    var editorProject: ProjectWork {
        get{
            return project
        }
    }

    func startDrawing() {
        targetImage.isHidden = true
    }
    
    func endDrawing() {
        targetLayer = actionLayer
        targetImage.isHidden = false
        targetImage.image = targetLayer
        actionLayer = UIImage(size: project.projectSize)!
        actionImage.image = actionLayer
        
        delegate?.updateFrame(frame: project.FrameSelected)
        delegate?.updateLayer(layer: project.LayerSelected)
        
        barDelegate?.UnDoReDoAction()
    }
    
    func actionCancel() {
        targetImage.isHidden = false
        actionLayer = UIImage(size: project.projectSize)!
        actionImage.image = actionLayer
    }
    //
    
    private var bgLayers : UIImage?
    private var targetLayer : UIImage!
    private var fgLayers : UIImage?
    private var ActionLayer : UIImage!
    private var framesLayer : UIImage?

    var selectionLayer : UIImage!
    
    private var isAnimation : Bool = false
    
    private var bg : UIImageView!
    private var framesImage : UIImageView!
    private var bgImage : UIImageView!
    private var targetImage : UIImageView!
    private var fgImage : UIImageView!
    private var actionImage : UIImageView!
    var selectionImage : UIImageView!

    private var grid : GridView!
    private var symmetryView : SymmetryView!
    var transformView : TransformView!
    
    private var symmetryChangeVertical = false
    private var symmetryChangeHorizontal = false

    private var scaleRecognizer : UIPinchGestureRecognizer!
    private var actionRecognizer : UILongPressGestureRecognizer!
    private var moveRecognizer : UIPanGestureRecognizer!
    lazy private var transformGest = UILongPressGestureRecognizer(target: self, action: #selector(transformGesture(sender:)))

    private var scale : CGFloat = 1.0
    private var offset : CGPoint = .zero
    private var k : CGFloat = 1.0
    private var animationDelta = 0.05
    
    weak var barDelegate : ToolBarDelegate? = nil
    weak var editor : Editor? = nil

    private var isScaling = false
    private var isMoving = false
    var isVerticalSymmeyry = false
    var isHorizontalSymmetry = false
    var isTransform = false
    
    var isSelected = false
    var selectorColor : UIColor = .black
    
    var isGridVIsible : Bool {
        get{
            return grid.isVisible
        }
        set{
            grid.isVisible = newValue
            UIView.animate(withDuration: 0.2, animations: {
                self.grid.alpha = newValue ? 1 : 0
            })
        }
    }
    
    lazy var penTool = PencilTool(editorDelegate: self)
    lazy var eraserTool = EraserTool(editorDelegate: self)
    lazy var shapeTool = ShapeTool(editorDelegate: self)
    lazy var gradientTool = GradientTool(editorDelegate: self)
    
    //var pen = Pencil()
    var move = Move()
    //var erase = Erase()
    //var gradient = Gradient()
    var fill = Fill()
    var selection = Selection()
    //var square = Square()

    var selectedTool : Int = 0
    
    private unowned var project : ProjectWork
    weak var delegate : FrameControlDelegate? = nil
    
    func updateLayers(){
        var imgs : [UIImage] = []
        
        for i in project.FrameSelected - 2...project.FrameSelected + 2 {
            if i >= 0 && i < project.information.frames.count && i != project.FrameSelected{
                imgs.append(project.getFrame(frame: i, size: project.projectSize).withAlpha(pow(0.5,CGFloat(abs(project.FrameSelected - i)))).flip(xFlip: project.isFlipX, yFlip: project.isFlipY))
            }
        }
        
        framesLayer = UIImage.merge(images: imgs)
        
        imgs.removeAll()
        
        for i in 0..<project.LayerSelected {
            if project.information.frames[project.FrameSelected].layers[project.LayerSelected - i - 1].visible {
                imgs.append(project.getLayer(frame: project.FrameSelected, layer: (project.LayerSelected - i - 1)).flip(xFlip: project.isFlipX, yFlip: project.isFlipY).withAlpha(CGFloat(project.information.frames[project.FrameSelected].layers[project.LayerSelected - i - 1].transparent)))
            }
        }
        
        fgLayers = UIImage.merge(images: imgs)
        imgs.removeAll()
        
        
        for i in project.LayerSelected + 1..<project.layerCount {
            if project.information.frames[project.FrameSelected].layers[project.layerCount - i + project.LayerSelected].visible {
                imgs.append(project.getLayer(frame: project.FrameSelected, layer: (project.layerCount - i + project.LayerSelected)).flip(xFlip: project.isFlipX, yFlip: project.isFlipY).withAlpha(CGFloat(project.information.frames[project.FrameSelected].layers[project.layerCount - i + project.LayerSelected].transparent)))
            }
        }
        
        bgLayers = UIImage.merge(images: imgs)
        
        targetLayer = project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected).flip(xFlip: project.isFlipX, yFlip: project.isFlipY)
        
        selectionLayer = project.loadSelection().flip(xFlip: project.isFlipX, yFlip: project.isFlipY)
        
        selectionImage.image = selectionLayer
        framesImage?.image = framesLayer
        bgImage?.image = bgLayers
        bgImage?.backgroundColor = project.backgroundColor
        targetImage?.image = targetLayer
        fgImage?.image = fgLayers
        
        targetImage?.alpha = project.information.frames[project.FrameSelected].layers[project.LayerSelected].visible ? CGFloat(project.information.frames[project.FrameSelected].layers[project.LayerSelected].transparent) : 0
        
        actionImage?.alpha = project.information.frames[project.FrameSelected].layers[project.LayerSelected].visible ? CGFloat(project.information.frames[project.FrameSelected].layers[project.LayerSelected].transparent) : 0
    }
    
    func getPreview() -> UIImage{
        let bg : UIImage = bgLayers ?? UIImage(size : project.projectSize)!
        let fg : UIImage = fgLayers ?? UIImage(size : project.projectSize)!

        return UIImage.merge(images: [bg,targetLayer,fg])!
    }
    
    init(frame: CGRect, proj : ProjectWork) {
        
        project = proj
        ActionLayer = UIImage(size : project.projectSize)
        selectionLayer = proj.loadSelection()
        
        super.init(frame: frame)
        
        let startScale = frame.width / project.projectSize.width
        scale = startScale
        k = project.projectSize.height / project.projectSize.width
        
        bg = UIImageView(frame: frame)
        
        selectionImage = UIImageView(frame: CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height))
        selectionImage.image = selectionLayer
        selectionImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        selectionImage.contentMode = .scaleAspectFit
        selectionImage.alpha = 0.5
                
        bg.layer.magnificationFilter = CALayerContentsFilter.nearest
        bg.contentMode = .scaleAspectFit
        bg.frame = CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height)
        offset = bg.frame.origin
//        bg.backgroundColor = UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 0.1, orientation: .down))
        
        bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height))
        bgImage.image = bgLayers
        bgImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        bgImage.contentMode = .scaleAspectFit
        bgImage.backgroundColor = project.backgroundColor

        actionImage = UIImageView(frame: CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height))
        actionImage.image = ActionLayer
        actionImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        actionImage.contentMode = .scaleAspectFit
        
        targetImage = UIImageView(frame: CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height))
        targetImage.image = targetLayer
        targetImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        targetImage.contentMode = .scaleAspectFit
        
        fgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height))
        fgImage.image = fgLayers
        fgImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        fgImage.contentMode = .scaleAspectFit
        
        framesImage = UIImageView(frame: CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height))
        framesImage.image = framesLayer
        framesImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        framesImage.contentMode = .scaleAspectFit
        
        grid = GridView(frame: self.bounds)
        grid.gridSize = project.projectSize
        grid.alpha = 0
        isGridVIsible = false

        symmetryView = SymmetryView(frame : self.bounds)
        symmetryView.project = project
        symmetryView.startX = project.projectSize.width / 2.0
        symmetryView.startY = project.projectSize.height / 2.0
        symmetryView.isHorizontal = false
        symmetryView.isVertical = false
        
        
        
        transformView = TransformView(frame: self.bounds,canvas: self)
        //grid.project = project
        
        scaleRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onScale(sender:)))
        actionRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onAction2(sender:)))
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onMove(sender:)))

        scaleRecognizer.delegate = self
        actionRecognizer.delegate = self
        moveRecognizer.delegate = self

        moveRecognizer.minimumNumberOfTouches = 2
        moveRecognizer.maximumNumberOfTouches = 2
        
        actionRecognizer.minimumPressDuration = 0
        actionRecognizer.delaysTouchesBegan = false
        //actionRecognizer.maximumNumberOfTouches = 1
        
        
        addGestureRecognizer(scaleRecognizer)
        addGestureRecognizer(moveRecognizer)
        addGestureRecognizer(actionRecognizer)
        
        let gest = UILongPressGestureRecognizer(target: self, action: #selector(touch(sender:)))
        gest.minimumPressDuration = 0
        addGestureRecognizer(gest)
        
        
        transformGest.minimumPressDuration = 0
        addGestureRecognizer(transformGest)
        transformGest.isEnabled = false
        //move.setImage(image: targetLayer, startpos: .zero, selection: nil)
        transformView.alpha = 0
        
        
        //addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(symmetry.touch(sender:))))

        self.addSubview(bg)
  
        bg.addSubview(framesImage)
        bg.addSubview(bgImage)
        bg.addSubview(targetImage)
        bg.addSubview(actionImage)
        bg.addSubview(fgImage)
        bg.addSubview(selectionImage)
        
        self.addSubview(grid)
        self.addSubview(symmetryView)
        self.addSubview(transformView)

        bg.transform = CGAffineTransform(scaleX: scale, y: scale)
        (grid.layer as! GridLayer).gridScale = scale
        (grid.layer as! GridLayer).startPos = CGPoint(x: 0, y: (frame.height - project.projectSize.height * scale) / 2)
        bg.frame.origin = CGPoint(x: 0, y: (frame.height - project.projectSize.height * scale) / 2)
        offset = bg.frame.origin
        symmetryView.offset = offset
        symmetryView.scale = scale
        symmetryView.setNeedsDisplay()
        
        isSelected = false
        if project.information.actionList.lastActiveAction >= 0 {
            for i in 0...project.information.actionList.lastActiveAction {
                if Int(project.information.actionList.actions[i]["ToolID"]!) == Actions.selectionChange.rawValue {
                    isSelected = Bool(project.information.actionList.actions[i]["nowSelected"]!)!
                }
            }
        }
        
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        updateLayers()
        
    }
    
    func transformFlip(flipX : Bool, flipY : Bool) {
        move.flipImage(flipX: flipX, flipY: flipY)
        ActionLayer = move.drawOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)),rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
        actionImage.image = ActionLayer
        selectionLayer = move.drawSelectionOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)), rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
        selectionImage.image = selectionLayer
    }
    
    func selectTool(newTool : Int){
        if selectedTool != newTool {
            selectedTool = newTool
        }
    }
    
    func checkTransformChangeBefore(newTool : Int) {
        if newTool == 2 && newTool != selectedTool {
            isTransform = true
            transformView.offset = offset
            transformView.scale = scale
            transformView.angle = 0
            transformView.lastToolSelected = selectedTool
            transformView.setRect(image: UIImage.merge(images: [selectionLayer])!, isSelected: isSelected)
            move.setImage(image: targetLayer.inner(image: isSelected ? selectionLayer : nil).getImageFromRect(rect: transformView.position), startpos: .zero, selection: selectionLayer.getImageFromRect(rect: transformView.position),size: project.projectSize, startImg: targetLayer.cut(image: isSelected ? selectionLayer : nil))
            
            //actionImage.image =
            targetLayer = targetLayer.cut(image: isSelected ? selectionLayer : nil)
            targetImage.image = targetLayer
            
            ActionLayer = move.drawOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)),rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
            actionImage.image = ActionLayer
            
            transformView.alpha = 1
            transformGest.isEnabled = true
            targetImage.isHidden = true

        } else if selectedTool == 2 && selectedTool != newTool {
            if transformView.needToSave {
                finishTransform()
            } else {
               transformView.needToSave = true
                finishTransform(needUpdateControl: false)
            }
            transformView.alpha = 0
            transformGest.isEnabled = false
            ActionLayer = UIImage(size: project.projectSize)
            actionImage.image = ActionLayer
            editor?.showTransform(isShow: false)
        }
    }
    
    func makeSelecion(img : UIImage) -> UIImage {
        UIGraphicsBeginImageContext(project.projectSize)
        let context = UIGraphicsGetCurrentContext()!

        context.setFillColor(getAppColor(color: .select).cgColor)
        context.addRect(CGRect(origin: .zero, size: project.projectSize))
        context.fillPath()
        
        img.draw(at: .zero,blendMode: .destinationOut,alpha: 1)
        
        context.setBlendMode(.sourceOut)
        context.setFillColor(getAppColor(color: .select).cgColor)
        context.addRect(CGRect(origin: .zero, size: project.projectSize))
        context.fillPath()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func fixAlpha(image : UIImage) -> UIImage {
        var data = image.getPixelsArray()
        
        for i in 0..<data.count {
            if data[i].a > 0 {
                data[i].a = 255
            }
        }
        return imageFromARGB32Bitmap(pixels: data, width: UInt(image.size.width), height: UInt(image.size.height))
        
    }
    
    func setTransformCopyImage() {
        let imageTransform = UIImage.merge(images: [project.loadCopyImage()])!.flip(xFlip: project.isFlipX, yFlip: project.isFlipY)
        
        selectedTool = 2
        
        isTransform = true
        transformView.offset = offset
        transformView.scale = scale
        transformView.angle = 0
        transformView.setRect(image: getTintImage(image: imageTransform, color: getAppColor(color: .select)), isSelected: true)
        transformView.lastSelect = selectionLayer

        selectionLayer = fixAlpha(image : imageTransform).withTintColor(getAppColor(color: .select))
        selectionImage.image = selectionLayer
        
        move.setImage(image: imageTransform.getImageFromRect(rect: transformView.position), startpos: .zero, selection: selectionLayer.getImageFromRect(rect: transformView.position),size: project.projectSize, startImg: UIImage.merge(images: [targetLayer])!)
        
        ActionLayer = move.drawOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)),rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
        actionImage.image = ActionLayer
        
        transformView.alpha = 1
        transformGest.isEnabled = true
        
        targetImage.isHidden = true
    }
    
    func startAnimationMode(){
        bgImage.image = nil
        framesImage.image = nil
        targetImage.image = nil
        fgImage.image = nil
        selectionImage.image = nil
        actionImage.image = nil
        actionRecognizer.isEnabled = false
        isAnimation = true
    }
    
    func endAnimationMode(){
        updateLayers()
        actionRecognizer.isEnabled = true
        isAnimation = false
    }
    
    func setImageFromAnimation(img : UIImage) {
        bgImage.image = img
    }
    
    func updateTransformRotate(num : Int) {
        transformView.setAngle(newAngle: CGFloat(num))
        
        ActionLayer = move.drawOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)),rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
        actionImage.image = ActionLayer
        
        selectionLayer = move.drawSelectionOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)),rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
        selectionImage.image = selectionLayer
    }
    
    @objc func transformGesture(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            transformView.getTransformMode(location: sender.location(in: transformView))
        case .changed:
            switch transformView.activeMode {
            case .move:
                transformView.move(nextLocation: sender.location(in: transformView))
            case .scaleUpLeft, .up, .down, .left, .right, .scaleUpRight, .scaleDownLeft, .scaleDownRight:
                transformView.resize(nextLocation: sender.location(in: transformView))
            case .rotate:
                transformView.rotate(nextLocation: sender.location(in: transformView))
            default:
                break
            }

            ActionLayer = move.drawOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)),rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
            actionImage.image = ActionLayer
            
            selectionLayer = move.drawSelectionOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)),rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
            selectionImage.image = selectionLayer
            
        case .ended:
            switch transformView.activeMode {
                case .scaleUpLeft, .up, .down, .left, .right, .scaleUpRight, .scaleDownLeft, .scaleDownRight:
                    transformView.finishReSize()
            default:
                break
            }
            transformView.lastInformation = (transformView.position,transformView.angle)
        
        case .cancelled:
            transformView.position = transformView.lastInformation.position
            transformView.angle = transformView.lastInformation.angle
            transformView.rotateDelegate(CGFloat(transformView.angle))
            transformView.resizeDelegate(transformView.position.size)
            transformView.lastSize = CGSize(width: ((transformView.lastInformation.position.origin.x + transformView.lastInformation.position.size.width / 2.0)), height: ((transformView.lastInformation.position.origin.y + transformView.lastInformation.position.size.height / 2.0)))
            
            transformView.setNeedsDisplay()
            
            ActionLayer = move.drawOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)),rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
            actionImage.image = ActionLayer
            
            selectionLayer = move.drawSelectionOn(position: transformView.position, rotation: transformView.Radians(CGFloat(transformView.angle)),rotateCenter: CGPoint(x: transformView.lastSize.width, y: transformView.lastSize.height))
            selectionImage.image = selectionLayer
        default:
            break
        }
    }
    
    func finishTransform(needUpdateControl : Bool = true){
        if transformView.isChanged {
            print("changed")
            let wasImg = project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected)
            
            targetLayer = UIImage.merge(images: [ActionLayer])
            targetImage.image = targetLayer
            
            project.addAction(action :["ToolID" : "\(Actions.transform.rawValue)", "frame" : "\(project.FrameSelected)", "layer" : "\(project.LayerSelected)"])
            
            try! UIImage.merge(images: [targetLayer.flip(xFlip: project.isFlipX, yFlip: project.isFlipY)])!.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(project.information.frames[project.FrameSelected].frameID)").appendingPathComponent("layer-\(project.information.frames[project.FrameSelected].layers[project.LayerSelected].layerID).png"))
            try! UIImage.merge(images: [selectionLayer.flip(xFlip: project.isFlipX, yFlip: project.isFlipY)])!.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("selection.png"))
            
            try! wasImg.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID())-was.png"))
            try! project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID()).png"))
            
            try! transformView.lastSelect!.flip(xFlip: project.isFlipX, yFlip: project.isFlipY).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-select-\(project.getNextActionID())-was.png"))
            try! project.loadSelection().pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-select-\(project.getNextActionID()).png"))
            
            ActionLayer = UIImage(size : project.projectSize)
            actionImage.image = ActionLayer
            delegate?.updateCanvas()
            
            delegate?.updateFrame(frame: project.FrameSelected)
            if needUpdateControl {
                delegate?.updateLayer(layer: project.LayerSelected)
            }
            
            barDelegate?.UnDoReDoAction()
        } else {
            print("dont changed")
            clearTransform()
        }
        targetImage.isHidden = false
        editor?.canvas.transformView.isCopyMode = false
    }
    
    func clearTransform() {
        ActionLayer = move.drawOn(position: transformView.startInformation.position, rotation: 0, rotateCenter: .zero)
        
        targetLayer = UIImage.merge(images: [ActionLayer])!
        targetImage.image = targetLayer
        
        ActionLayer = UIImage(size: project.projectSize)
        actionImage.image = ActionLayer
        editor?.showTransform(isShow: false)
        editor?.canvas.transformView.isCopyMode = false
        targetImage.isHidden = false
    }
    
    @objc private func touch(sender : UILongPressGestureRecognizer) {
          switch sender.state {
          case .began:
              if (CGRect(x: symmetryView.offset.x + symmetryView.startX * symmetryView.scale - 16, y: symmetryView.offset.y - 32 - 16, width: 32, height: 32).contains(sender.location(in: self)) ||
                CGRect(x: symmetryView.offset.x + symmetryView.startX * symmetryView.scale - 16, y: symmetryView.offset.y + project.projectSize.height * symmetryView.scale + 16, width: 32, height: 24).contains(sender.location(in: self))
                ) && isVerticalSymmeyry {
                symmetryChangeVertical = true
            }
            
              if (CGRect(x: symmetryView.offset.x - 32 - 16, y: symmetryView.offset.y + symmetryView.startY * symmetryView.scale - 16, width: 32, height: 32).contains(sender.location(in: self)) ||
                CGRect(x: symmetryView.offset.x + symmetryView.project.projectSize.width * symmetryView.scale + 16, y: symmetryView.offset.y + symmetryView.startY * symmetryView.scale - 16, width: 32, height: 32).contains(sender.location(in: self))
                ) && isHorizontalSymmetry {
                symmetryChangeHorizontal = true
            }
            
          case .changed:
            if symmetryChangeVertical {
                symmetryView.startX = ceil((sender.location(in: self).x - offset.x) / scale * 2) / 2.0
                if symmetryView.startX < 0 {
                    symmetryView.startX = 0
                } else if symmetryView.startX > project.projectSize.width {
                    symmetryView.startX = project.projectSize.width
                }
            }
            
            if symmetryChangeHorizontal {
                symmetryView.startY = ceil((sender.location(in: self).y - offset.y) / scale * 2) / 2.0
                if symmetryView.startY < 0 {
                    symmetryView.startY = 0
                } else if symmetryView.startY > project.projectSize.height {
                    symmetryView.startY = project.projectSize.height
                }
            }
            
            symmetryView.setNeedsDisplay()

          case .ended:
            symmetryChangeVertical = false
            symmetryChangeHorizontal = false
          default:
              break
          }
      }
    
    override func layoutSubviews() {
        bg.backgroundColor = UIColor(patternImage:UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 0.1, orientation: .down))
    }
    
    func checkActions(){
        if !isScaling && !isMoving && !isAnimation {
            actionRecognizer.isEnabled = true
            if selectedTool == 2 {
                transformGest.isEnabled = true
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func centerizeSymmetry() {
        symmetryView.startX = project.projectSize.width / 2.0
        symmetryView.startY = project.projectSize.height / 2.0
        symmetryView.setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onScale(sender : UIPinchGestureRecognizer) {
        if sender.numberOfTouches == 2 {
            switch sender.state {

            case .changed:
                isScaling = true
                let lastScale = scale
                scale *= sender.scale
                actionRecognizer.isEnabled = false
                transformGest.isEnabled = false
                
                let xk = sender.scale * bg.frame.width -  bg.frame.width
                let posx = (sender.location(in: self).x - bg.frame.origin.x) / bg.frame.width
                
                let yk = sender.scale *  bg.frame.height -  bg.frame.height
                let posy = (sender.location(in: self).y - bg.frame.origin.y) /  bg.frame.height

                
                print("scale : \(scale) and size : \(bg.frame.width) last")

                if scale < 0.1 {
                    scale = 0.1
                } else if scale > 200 {
                    scale = 200
                } else {
                    offset.x -= posx * xk
                    offset.y -= posy * yk
                }
                
                UIView.animate(withDuration: animationDelta,delay: 0,options: .curveLinear, animations: {
                    self.bg.transform = CGAffineTransform(scaleX: lastScale, y: lastScale).scaledBy(x: sender.scale, y: sender.scale)
                    self.bg.layer.frame.origin = self.offset
                })
                
                print("scale : \(scale) and size : \(bg.frame.width) now")

                
                let anim = CABasicAnimation(keyPath: "startPos")
                anim.isAdditive = true
                anim.fromValue = (grid.layer as! GridLayer).startPos.offset(x: -offset.x, y: -offset.y)
                anim.toValue = CGPoint.zero
                anim.duration = animationDelta
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                (grid.layer as! GridLayer).startPos = offset
                CATransaction.commit()
                
                (grid.layer as! GridLayer).add(anim, forKey: nil)
                
                
                let anim2 = CABasicAnimation(keyPath: "gridScale")
                anim2.isAdditive = true
                anim2.fromValue = (grid.layer as! GridLayer).gridScale - self.scale
                anim2.toValue = 0
                anim2.duration = animationDelta
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                (grid.layer as! GridLayer).gridScale = self.scale
                CATransaction.commit()
                
                (grid.layer as! GridLayer).add(anim2, forKey: nil)
                
                symmetryView.offset = offset
                symmetryView.scale = scale
                symmetryView.setNeedsDisplay()
                
                transformView.offset = offset
                transformView.scale = scale
                transformView.setNeedsDisplay()
                sender.scale = 1.0
                
            case .ended:
                isScaling = false
                checkActions()

            default:
                break
            }
        }
            
        else {
            isScaling = false
            checkActions()
        }
    }
    
    func reverseSelection() {
        if isSelected {
            
            let nowSelected = !selection.isSelectEmpty(select: selection.reverse(select: selectionLayer))
            project.addAction(action :["ToolID" : "\(Actions.selectionChange.rawValue)", "wasSelected" : "true", "nowSelected" : "\(nowSelected)"])

            try! selectionLayer.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID())-was.png"))
            
            try! selection.reverse(select: selectionLayer).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID()).png"))
            
            selectionLayer = selection.reverse(select: selectionLayer)
            
            try! selectionLayer.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("selection.png"))

            selectionImage.image = selectionLayer
            barDelegate?.UnDoReDoAction()
            isSelected = nowSelected
        }
    }
    
    func clearSelect() {
     if isSelected {
        project.addAction(action :["ToolID" : "\(Actions.selectionChange.rawValue)", "wasSelected" : "true", "nowSelected" : "false"])
        try! selectionLayer.flip(xFlip: project.isFlipX, yFlip: project.isFlipY).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID())-was.png"))
        
        selectionLayer = UIImage(size: project.projectSize)
        
        try! selectionLayer.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID()).png"))
        
        selectionImage.image = selectionLayer
        
        try! selectionLayer.flip(xFlip: project.isFlipX, yFlip: project.isFlipY).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("selection.png"))

        isSelected = false
        barDelegate?.UnDoReDoAction()
        }
    }
    
    func deleteSelect() {
        if isSelected {
            let newLay = project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected).cut(image: project.loadSelection())
            project.addAction(action :["ToolID" : "\(Actions.drawing.rawValue)", "frame" : "\(project.FrameSelected)", "layer" : "\(project.LayerSelected)"])

            try! newLay.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(project.information.frames[project.FrameSelected].frameID)").appendingPathComponent("layer-\(project.information.frames[project.FrameSelected].layers[project.LayerSelected].layerID).png"))
            
            try! targetLayer.flip(xFlip: project.isFlipX, yFlip: project.isFlipY).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID())-was.png"))
            
            try! newLay.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID()).png"))
            
            targetLayer = newLay.flip(xFlip: project.isFlipX, yFlip: project.isFlipY)
            targetImage.image = targetLayer
            
            delegate?.updateFrame(frame: project.FrameSelected)
            delegate?.updateLayer(layer: project.LayerSelected)
            
            barDelegate?.UnDoReDoAction()
        }
    }
   
    func changeSymmetry(vertical : Bool) {
        isVerticalSymmeyry = vertical
        symmetryView.isVertical = vertical
        symmetryView.setNeedsDisplay()
    }
    
    func changeSymmetry(horizontal : Bool) {
        isHorizontalSymmetry = horizontal
        symmetryView.isHorizontal = horizontal
        symmetryView.setNeedsDisplay()
    }
    
    @objc private func onMove(sender : UIPanGestureRecognizer) {
        if sender.numberOfTouches == 2 {
            switch sender.state {
            case .changed:
                isMoving = true
                actionRecognizer.isEnabled = false
                transformGest.isEnabled = false

                offset.x += sender.translation(in: self).x
                offset.y += sender.translation(in: self).y
                
                if offset.x > self.frame.width / 2 {
                    offset.x = self.frame.width / 2
                } else if offset.x + bg.frame.width <  self.frame.width / 2 {
                    offset.x = self.frame.width / 2 -  bg.frame.width
                }

                if offset.y > self.frame.height / 2 {
                    offset.y = self.frame.height / 2
                } else if offset.y +  bg.frame.height <  self.frame.height / 2 {
                    offset.y = self.frame.height / 2 -  bg.frame.height
                }
                                
                sender.setTranslation(.zero, in: self)
                
                UIView.animate(withDuration: animationDelta,delay: 0,options: .curveLinear, animations: {
                    self.bg.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
                    self.bg.layer.frame.origin = self.offset
                        
                })
                
                let anim = CABasicAnimation(keyPath: "startPos")
                anim.isAdditive = true
                anim.timingFunction = .init(name: .easeInEaseOut)
                anim.fromValue = (grid.layer as! GridLayer).startPos.offset(x: -offset.x, y: -offset.y)
                anim.toValue = CGPoint.zero
                anim.duration = animationDelta
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                (grid.layer as! GridLayer).startPos = offset
                CATransaction.commit()
                
                (grid.layer as! GridLayer).add(anim, forKey: nil)
                
                
                let anim2 = CABasicAnimation(keyPath: "gridScale")
                anim2.isAdditive = true
                anim2.fromValue = (grid.layer as! GridLayer).gridScale - self.scale
                anim2.toValue = 0
                anim2.duration = animationDelta
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                (grid.layer as! GridLayer).gridScale = self.scale
                CATransaction.commit()
                
                (grid.layer as! GridLayer).add(anim2, forKey: nil)
                
                symmetryView.offset = offset
                symmetryView.setNeedsDisplay()
                
                transformView.offset = offset
                transformView.setNeedsDisplay()
                
            case .ended:
                isMoving = false
                checkActions()
            default:
                
                break
            }
        }
        else {
            isMoving = false
            checkActions()
        }
    }
    
    func getSymmetry() -> CGPoint {
        return CGPoint(x: !isVerticalSymmeyry ? 0 : symmetryView.startX, y: !isHorizontalSymmetry ? 0 : symmetryView.startY)
    }
    
    func resizeProject(){

        ActionLayer = UIImage(size: project.projectSize)!
        actionImage.image = ActionLayer
        
        bg.transform = CGAffineTransform(scaleX: 1, y: 1)

        scale = frame.width / project.projectSize.width

        bg.frame = CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height)

        bgImage.frame = CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height)

        actionImage.frame = CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height)

        targetImage.frame = CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height)

        fgImage.frame = CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height)

        framesImage.frame = CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height)

        selectionImage.frame = CGRect(x: 0, y: 0, width: project.projectSize.width, height: project.projectSize.height)
        
        bg.transform = CGAffineTransform(scaleX: scale, y: scale)

        bg.backgroundColor = UIColor(patternImage: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 0.1, orientation: .down))
        
        offset = CGPoint(x: 0, y: (frame.height - project.projectSize.height * scale) / 2)
        bg.frame.origin = offset
        
        (grid.layer as! GridLayer).startPos = offset
        (grid.layer as! GridLayer).gridScale = scale
        grid.gridSize = project.projectSize
        
        symmetryView.scale = scale
        symmetryView.offset = offset
        symmetryView.setNeedsDisplay()
        
        grid.setNeedsDisplay()
        
        updateLayers()
    }
    
    @objc private func onAction2(sender : UILongPressGestureRecognizer){
        var location = sender.location(in: bg)
        location.x *= (project.projectSize.width / actionImage.frame.width)
        location.y *= (project.projectSize.height / actionImage.frame.height)
        location.x = CGFloat(floor(location.x))
        location.y = CGFloat(floor(location.y))
        
        if !actionImage.bounds.contains(location) && sender.state == .began{
            sender.isEnabled = false
            sender.isEnabled = true
        }
        
        switch selectedTool {
        case 0:
            penTool.action(location: location, gestureState: sender.state)
        case 1:
            eraserTool.action(location: location, gestureState: sender.state)
            
        case 3:
            gradientTool.action(location: location, gestureState: sender.state)
                    
        case 4:
            switch sender.state {
            case .ended:
                location.x = CGFloat(floor(location.x))
                location.y = CGFloat(floor(location.y))
                if actionImage.bounds.contains(location) {
                    switch fill.style {
                    case .frame:
                        
                        //MARK: remake
                        ActionLayer =  UIImage.merge(images: [targetLayer,fill.drawOnFrame(image: UIImage.merge(images: [project.getFrameFromLayers(frame: project.FrameSelected, size: project.projectSize).flip(xFlip: project.isFlipX, yFlip: project.isFlipY)])!, point: location, selection: isSelected ? selectionLayer : nil, fillColor: selectorColor)])
                    case .layer:
                        ActionLayer = fill.drawOn(image:  UIImage.merge(images: [targetLayer])!, point: location,selection: isSelected ? selectionLayer : nil, fillColor: selectorColor)
                    }
                    
                    let wasImg = project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected)
                    
                    targetLayer = UIImage.merge(images: [ActionLayer.flip(xFlip: self.project.isFlipX, yFlip: self.project.isFlipY)])
                    targetImage.image = targetLayer
                    
                    project.addAction(action :["ToolID" : "\(Actions.drawing.rawValue)", "frame" : "\(project.FrameSelected)", "layer" : "\(project.LayerSelected)"])
                    
                    try! UIImage.merge(images: [targetLayer])!.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("frames").appendingPathComponent("frame-\(project.information.frames[project.FrameSelected].frameID)").appendingPathComponent("layer-\(project.information.frames[project.FrameSelected].layers[project.LayerSelected].layerID).png"))
                    
                    try! wasImg.pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID())-was.png"))
                    
                    try! project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID()).png"))
                    
                    ActionLayer = UIImage(size : project.projectSize)
                    actionImage.image = ActionLayer
                    
                    delegate?.updateCanvas()
                    delegate?.updateFrame(frame: project.FrameSelected)
                    delegate?.updateLayer(layer: project.LayerSelected)
                    barDelegate?.UnDoReDoAction()
                }
            default:
                break
            }
            
            //MARK: need remake!
        case 6:
            switch sender.state {
            case .began:
                location.x = CGFloat(floor(location.x))
                location.y = CGFloat(floor(location.y))
                selection.restart(img: selectionLayer, startPoint: location)
                
                if selection.type != .magicTool {
                    selectionLayer = selection.drawOn(image: selectionLayer, point: location,symmetry: getSymmetry())
                    selectionLayer = selection.drawOn(image: selectionLayer, point: location,symmetry: getSymmetry())
                    selectionImage.image = selectionLayer
                }
            case .changed:
                location.x = CGFloat(floor(location.x))
                location.y = CGFloat(floor(location.y))
                if selection.type != .magicTool {
                    selectionLayer = selection.drawOn(image: selectionLayer, point: location,symmetry: getSymmetry())
                    selectionImage.image = selectionLayer
                }
            case .ended:
                location.x = CGFloat(floor(location.x))
                location.y = CGFloat(floor(location.y))
                
                if selection.type != .magicTool {
                    selectionLayer = selection.finishSelection()
                } else {
                    selection.magicSelection(image : UIImage.merge(images: [project.getLayer(frame: project.FrameSelected, layer: project.LayerSelected)])!.flip(xFlip: project.isFlipX, yFlip: project.isFlipY), point: location)
                    selectionLayer = selection.finishSelection()
                }
                
                selectionImage.image = selectionLayer
                let isselect = selection.mode == .add ? true : !selection.isSelectEmpty(select: selectionLayer)
                
                
                project.addAction(action :["ToolID" : "\(Actions.selectionChange.rawValue)", "wasSelected" : "\(isSelected)", "nowSelected" : "\(isselect)"])
                isSelected = true
                
                try! selection.lastSelection?.flip(xFlip: project.isFlipX, yFlip: project.isFlipY).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID())-was.png"))
                
                try! selectionLayer.flip(xFlip: project.isFlipX, yFlip: project.isFlipY).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("actions").appendingPathComponent("action-\(project.getNextActionID()).png"))
                
                try! selectionLayer.flip(xFlip: project.isFlipX, yFlip: project.isFlipY).pngData()?.write(to: project.getProjectDirectory().appendingPathComponent("selection.png"))
                
                barDelegate?.UnDoReDoAction()
                isSelected = isselect

            case .cancelled:
                selectionLayer = project.loadSelection().flip(xFlip: project.isFlipX, yFlip: project.isFlipY)
                selectionImage.image = selectionLayer
            default:
                break
            }
            
        case 7:
            shapeTool.action(location: location, gestureState: sender.state)
        case 8:
            switch sender.state {
            case .ended:
                location.y = CGFloat(floor(location.y))
                if actionImage.bounds.contains(location) {
                    let color = project.getFrameFromLayers(frame: project.FrameSelected, size: project.projectSize).flip(xFlip: project.isFlipX, yFlip: project.isFlipY).pixelColor(x: Int(location.x), y: Int(location.y))
                    delegate?.changeMainColor(color: color)
                }
            default:
                break
            }
        default:
            break
        }
    }
}
