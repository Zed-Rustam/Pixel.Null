//
//  ToolButton.swift
//  new Testing
//
//  Created by Рустам Хахук on 22.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ToolButton : UICollectionViewCell {
    private var btn: UIButton!
    
    private var toolID : Int!
    weak var project : ProjectWork!
    weak var delegate : FrameControlDelegate!
    weak var barDelegate : ToolBarDelegate!
    
    private var onLong: ()->() = {}
    private var onTap: ()->() = {}
    
    lazy private var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))


    func getButton() -> UIButton { btn }
    override init(frame: CGRect) {
        super.init(frame: frame)
        btn = UIButton()
        btn.frame = self.bounds
        btn.setCorners(corners: 12)
        btn.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        longPressGesture.minimumPressDuration = 0.25
        btn.addGestureRecognizer(longPressGesture)
        
        contentView.addSubview(btn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onLongPress() {
        onLong()
        longPressGesture.isEnabled = false
        longPressGesture.isEnabled = true
        btn.isUserInteractionEnabled = false
        btn.isUserInteractionEnabled = true
    }
    
    @objc func onPress() {
        onTap()
    }
    
    func setToolID(id : Int){
        switch id {
        case -5:
            btn.setImage(#imageLiteral(resourceName: "symmetry_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[unowned self] in
                let editor = self.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: -5)
                editor.canvas.selectTool(newTool: -5)

                self.barDelegate.wasChangedTool(newTool: -5)
                
                let btnV = UIButton()
                btnV.translatesAutoresizingMaskIntoConstraints = false
                btnV.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnV.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnV.setImage(#imageLiteral(resourceName: "symmetry_vertical_icon"), for: .normal)
                btnV.imageView?.tintColor = getAppColor(color: .enable)
                btnV.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                btnV.addTarget(self, action: #selector(symmetryV), for: .touchUpInside)
                
                let btnH = UIButton()
                btnH.translatesAutoresizingMaskIntoConstraints = false
                btnH.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnH.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnH.setImage(#imageLiteral(resourceName: "symmetry_horizontal_icon"), for: .normal)
                btnH.imageView?.tintColor = getAppColor(color: .enable)
                btnH.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                btnH.addTarget(self, action: #selector(symmetryH), for: .touchUpInside)
                
                let btnCenter = UIButton()
                btnCenter.translatesAutoresizingMaskIntoConstraints = false
                btnCenter.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnCenter.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnCenter.setImage(#imageLiteral(resourceName: "symmetry_centerize"), for: .normal)
                btnCenter.imageView?.tintColor = getAppColor(color: .enable)
                btnCenter.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                btnCenter.addTarget(self, action: #selector(symmetryCenter), for: .touchUpInside)
                
                btn.imageView?.tintColor = getAppColor(color: .select)
                btn.backgroundColor = getAppColor(color: .select).withAlphaComponent(0.1)
                self.barDelegate.updateButtons(btns: [btnV,btnH,btnCenter])
            }

        case -4:
            btn.setImage(#imageLiteral(resourceName: "project_settings_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            onTap = {[unowned self] in
                (self.delegate as! Editor).finishTransform()
                (self.delegate as! Editor).openProjectSettings()
            }
            
        case -3:
            btn.setImage(#imageLiteral(resourceName: "undo_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            onTap = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.finishTransform()
                
                self!.project.unDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
        case -2:
            btn.setImage(#imageLiteral(resourceName: "redo_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            onTap = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.finishTransform()
                self!.project.reDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
            
        case -1:
            btn.setImage(#imageLiteral(resourceName: "cancel_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[weak self] in
                let editor = self!.delegate as! Editor
                    editor.finishTransform()
                self!.project.save()
                self!.project.savePreview(frame: self!.project.FrameSelected)
                editor.gallery?.updateProjectView(proj: self!.project)
                editor.dismiss(animated: true, completion: nil)
            }
            
        case 0:
            btn.setImage(#imageLiteral(resourceName: "edit_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            onTap = {[unowned self] in
                let editor = self.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 0)
                editor.canvas.selectTool(newTool: 0)

                self.barDelegate.wasChangedTool(newTool: 0)
                self.barDelegate.updateButtons(btns: [])
                self.btn.imageView?.tintColor = getAppColor(color: .select)
                self.btn.backgroundColor = getAppColor(color: .select).withAlphaComponent(0.1)
            }
            
            onLong = {[weak self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
                (self!.delegate as! ToolSettingsDelegate).openPencilSettings()
            }
            
        case 1:
            btn.setImage(#imageLiteral(resourceName: "erase_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[unowned self] in
                let editor = self.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 1)
                editor.canvas.selectTool(newTool: 1)

                self.barDelegate.wasChangedTool(newTool: 1)
                self.barDelegate.updateButtons(btns: [])
                self.btn.imageView?.tintColor = getAppColor(color: .select)
                self.btn.backgroundColor = getAppColor(color: .select).withAlphaComponent(0.1)

            }
            onLong = {[weak self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                               impactFeedbackgenerator.prepare()
                               impactFeedbackgenerator.impactOccurred()
                (self!.delegate as! ToolSettingsDelegate).openEraseSettings()
            }
            
        case 2:
            btn.setImage(#imageLiteral(resourceName: "move_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[unowned self] in
            let editor = self.delegate as! Editor
            
            if !editor.canvas.transformView.isCopyMode {
                editor.canvas.checkTransformChangeBefore(newTool: 2)
            }
            
            editor.canvas.selectTool(newTool: 2)
            
            editor.showTransform(isShow: true)
            
            let flipVBtn = UIButton()
            flipVBtn.translatesAutoresizingMaskIntoConstraints = false
            flipVBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
            flipVBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
            flipVBtn.setImage(#imageLiteral(resourceName: "flip_horizontal_icon"), for: .normal)
            flipVBtn.imageView?.tintColor = getAppColor(color: .enable)
            flipVBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            flipVBtn.addTarget(self, action: #selector(flipV), for: .touchUpInside)
                
            let flipHBtn = UIButton()
            flipHBtn.translatesAutoresizingMaskIntoConstraints = false
            flipHBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
            flipHBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
            flipHBtn.setImage(#imageLiteral(resourceName: "flip_vertical_icon"), for: .normal)
            flipHBtn.imageView?.tintColor = getAppColor(color: .enable)
            flipHBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            flipHBtn.addTarget(self, action: #selector(flipH), for: .touchUpInside)
            
                let finish = UIButton()
                finish.translatesAutoresizingMaskIntoConstraints = false
                finish.heightAnchor.constraint(equalToConstant: 36).isActive = true
                finish.widthAnchor.constraint(equalToConstant: 36).isActive = true
                finish.setImage(#imageLiteral(resourceName: "save_icon"), for: .normal)
                finish.imageView?.tintColor = getAppColor(color: .enable)
                finish.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                finish.addTarget(self, action: #selector(saveTransform), for: .touchUpInside)
            
            
            self.barDelegate.wasChangedTool(newTool: 2)
            self.barDelegate.updateButtons(btns: [flipVBtn,flipHBtn,finish])
            self.btn.imageView?.tintColor = getAppColor(color: .select)
            self.btn.backgroundColor = getAppColor(color: .select).withAlphaComponent(0.1)
           }
        
        case 3:
            btn.setImage(#imageLiteral(resourceName: "gradient_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[unowned self] in
                let editor = self.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 3)
                editor.canvas.selectTool(newTool: 3)
            
                self.barDelegate.wasChangedTool(newTool: 3)
                self.barDelegate.updateButtons(btns: [])
                self.btn.imageView?.tintColor = getAppColor(color: .select)
                self.btn.backgroundColor = getAppColor(color: .select).withAlphaComponent(0.1)
          }
            
          onLong = {[unowned self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
            
                (self.delegate as! ToolSettingsDelegate).openGradientSettings()
            }
        
        case 4:
            btn.setImage(#imageLiteral(resourceName: "fill_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[unowned self] in
                let editor = self.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 4)
                editor.canvas.selectTool(newTool: 4)

                self.barDelegate.wasChangedTool(newTool: 4)
                
                
                let styleSelectBtn = UIButton()
                
                styleSelectBtn.setImage(editor.canvas.fill.style == .layer ? #imageLiteral(resourceName: "layer_icon") : #imageLiteral(resourceName: "layers_icon"), for: .normal)
                styleSelectBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                styleSelectBtn.imageView?.tintColor = getAppColor(color: .enable)
                
                styleSelectBtn.translatesAutoresizingMaskIntoConstraints = false
                styleSelectBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
                styleSelectBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
                
                styleSelectBtn.showsMenuAsPrimaryAction = true
                styleSelectBtn.menu = UIMenu(title: "Style", image: nil, children: [
                    UIAction(title: "Layer", image: #imageLiteral(resourceName: "layer_icon").withTintColor(getAppColor(color: .enable)), handler: {_ in
                        editor.canvas.fill.style = .layer
                        styleSelectBtn.setImage(editor.canvas.fill.style == .layer ? #imageLiteral(resourceName: "layer_icon") : #imageLiteral(resourceName: "layers_icon"), for: .normal)
                    }),
                    UIAction(title: "Frame", image: #imageLiteral(resourceName: "layers_icon").withTintColor(getAppColor(color: .enable)), handler: {_ in
                        editor.canvas.fill.style = .frame
                        styleSelectBtn.setImage(editor.canvas.fill.style == .layer ? #imageLiteral(resourceName: "layer_icon") : #imageLiteral(resourceName: "layers_icon"), for: .normal)
                    })
                ])
                
                self.barDelegate.updateButtons(btns: [styleSelectBtn])
                
                self.btn.imageView?.tintColor = getAppColor(color: .select)
                self.btn.backgroundColor = getAppColor(color: .select).withAlphaComponent(0.1)
            }

        case 5:
            btn.setImage(#imageLiteral(resourceName: "grid_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[unowned self] in
                let editor = self.delegate as! Editor
                if editor.canvas.isGridVIsible {
                    self.btn.imageView?.tintColor = getAppColor(color: .enable)
                } else {
                    self.btn.imageView?.tintColor = getAppColor(color: .select)
                }
                editor.canvas.isGridVIsible.toggle()
            }
            
        case 6:
            btn.setImage(#imageLiteral(resourceName: "selection_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[unowned self] in
                let editor = self.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 6)
                editor.canvas.selectTool(newTool: 6)

                self.barDelegate.wasChangedTool(newTool: 6)
                
                let actionsButton = UIButton()
                actionsButton.translatesAutoresizingMaskIntoConstraints = false
                actionsButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
                actionsButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
                actionsButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
                actionsButton.showsMenuAsPrimaryAction = true
                
                actionsButton.imageView?.tintColor = getAppColor(color: .enable)
                
                actionsButton.menu = UIMenu(title: "select actions", image: nil, identifier: nil, options: .destructive, children: [
                    UIAction(title: "delete", image: UIImage(systemName: "trash",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                        editor.canvas.deleteSelect()
                    }),
                    UIAction(title: "clear", image: UIImage(systemName: "clear",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        editor.canvas.clearSelect()
                    }),
                    UIAction(title: "copy", image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        editor.saveSelection()
                    }),
                    UIAction(title: "paste", image: UIImage(systemName: "doc.on.clipboard"), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        editor.startTransformWithImage()
                    }),
                    UIAction(title: "cut", image: UIImage(systemName: "scissors"), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        editor.saveSelection()
                        editor.canvas.deleteSelect()
                    }),
                    UIAction(title: "reverse", image: UIImage(systemName: "arrow.right.arrow.left.square", withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        editor.canvas.reverseSelection()
                    })
                ])
                
                let selectType = UIButton()
                selectType.translatesAutoresizingMaskIntoConstraints = false
                selectType.widthAnchor.constraint(equalToConstant: 36).isActive = true
                selectType.heightAnchor.constraint(equalToConstant: 36).isActive = true
                selectType.setImage(#imageLiteral(resourceName: "rectangle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                selectType.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                selectType.showsMenuAsPrimaryAction = true
                selectType.imageView?.tintColor = getAppColor(color: .enable)
                
                selectType.menu = UIMenu(title: "select type", image: nil, identifier: nil, options: .destructive, children: [
                    UIAction(title: "rectangle", image: #imageLiteral(resourceName: "rectangle_icon").withRenderingMode(.alwaysTemplate).withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "rectangle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        editor.setSelectionSettings(mode: 1)
                    }),
                    
                    UIAction(title: "circle", image: #imageLiteral(resourceName: "circle_icon").withRenderingMode(.alwaysTemplate).withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "circle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        editor.setSelectionSettings(mode: 2)
                    }),
                    
                    UIAction(title: "custom shape", image: #imageLiteral(resourceName: "custom_shape_selector_icon").withRenderingMode(.alwaysTemplate).withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "custom_shape_selector_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        editor.setSelectionSettings(mode: 0)
                    }),
                    
                    UIAction(title: "magic tool", image: #imageLiteral(resourceName: "selection_magic_tool_icon").withRenderingMode(.alwaysTemplate).withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "selection_magic_tool_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        editor.setSelectionSettings(mode: 3)
                    })
                ])
                
                let selectMode = SegmentSelector(imgs: [#imageLiteral(resourceName: "selector_add_mode_icon"),#imageLiteral(resourceName: "selector_remove_mode_icon")])
                
                switch editor.canvas.selection.mode {
                case .add:
                    selectMode.select = 0
                case .delete:
                    selectMode.select = 1
                }
                
                selectMode.selectDelegate = {select in
                    editor.canvas.selection.mode = select == 0 ? .add : .delete
                }
                
                self.barDelegate.updateButtons(btns: [actionsButton,selectMode,selectType])
                
                self.btn.imageView?.tintColor = getAppColor(color: .select)
                self.btn.backgroundColor = getAppColor(color: .select).withAlphaComponent(0.1)
            }
            
        case 7:
            btn.setImage(#imageLiteral(resourceName: "sharp_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[unowned self] in
                let editor = self.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 7)
                editor.canvas.selectTool(newTool: 7)

                self.barDelegate.wasChangedTool(newTool: 7)
                
                self.btn.imageView?.tintColor = getAppColor(color: .select)
                self.btn.backgroundColor = getAppColor(color: .select).withAlphaComponent(0.1)

                let selectShapeBtn = UIButton()
                selectShapeBtn.translatesAutoresizingMaskIntoConstraints = false
                selectShapeBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
                selectShapeBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
                
                var selectImage = UIImage()
                
                switch editor.canvas.shapeTool.squareType {
                case .rectangle:
                    selectImage = #imageLiteral(resourceName: "rectangle_icon")
                case .oval:
                    selectImage = #imageLiteral(resourceName: "circle_icon")
                case .line:
                    selectImage = #imageLiteral(resourceName: "line_icon")
                }
                
                selectShapeBtn.setImage(selectImage, for: .normal)
                selectShapeBtn.imageView?.tintColor = getAppColor(color: .enable)
                selectShapeBtn.showsMenuAsPrimaryAction = true
                
                selectShapeBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                selectShapeBtn.isContextMenuInteractionEnabled = true
                selectShapeBtn.menu = UIMenu(title: "Shape", image: nil, identifier: nil, options: .displayInline, children: [
                    UIAction(title: "Rectangle", image: #imageLiteral(resourceName: "rectangle_icon").withTintColor(getAppColor(color: .enable)), identifier: .none, discoverabilityTitle: nil, handler: {_ in
                        editor.canvas.shapeTool.squareType = .rectangle
                        selectShapeBtn.setImage(#imageLiteral(resourceName: "rectangle_icon"), for: .normal)
                    }),
                    UIAction(title: "Oval", image: #imageLiteral(resourceName: "circle_icon").withTintColor(getAppColor(color: .enable)), identifier: .none, discoverabilityTitle: nil, handler: {_ in
                        editor.canvas.shapeTool.squareType = .oval
                        selectShapeBtn.setImage(#imageLiteral(resourceName: "circle_icon"), for: .normal)
                    }),
                    UIAction(title: "Line", image: #imageLiteral(resourceName: "line_icon").withTintColor(getAppColor(color: .enable)), identifier: .none, discoverabilityTitle: nil, handler: {_ in
                        editor.canvas.shapeTool.squareType = .line
                        selectShapeBtn.setImage(#imageLiteral(resourceName: "line_icon"), for: .normal)
                    })
                ])
                
                let blockBtn = UIButton()
                blockBtn.setImage(editor.canvas.shapeTool.isFixed ? #imageLiteral(resourceName: "block_icon") : #imageLiteral(resourceName: "unblock_icon"), for: .normal)
                blockBtn.imageView?.tintColor = editor.canvas.shapeTool.isFixed ? getAppColor(color: .select) : getAppColor(color: .enable)
                blockBtn.translatesAutoresizingMaskIntoConstraints = false
                blockBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                
                blockBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
                blockBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
                
                blockBtn.addTarget(self, action: #selector(blockPress(sender:)), for: .touchUpInside)

                self.barDelegate.updateButtons(btns: [selectShapeBtn,blockBtn])
            }

        case 8:
            btn.setImage(#imageLiteral(resourceName: "picker_icon"), for: .normal)
            btn.imageView?.tintColor = getAppColor(color: .enable)
            
            onTap = {[unowned self] in
                let editor = self.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 8)
                editor.canvas.selectTool(newTool: 8)

                self.barDelegate.wasChangedTool(newTool: 8)
                self.barDelegate.updateButtons(btns: [])
                
                self.btn.imageView?.tintColor = getAppColor(color: .select)
                self.btn.backgroundColor = getAppColor(color: .select).withAlphaComponent(0.1)
            }
            
        default:
            break
        }
    }
    
    @objc func blockPress(sender: UIButton) {
        let editor = self.delegate as! Editor
        editor.canvas.shapeTool.isFixed.toggle()
        sender.setImage(editor.canvas.shapeTool.isFixed ? #imageLiteral(resourceName: "block_icon") : #imageLiteral(resourceName: "unblock_icon"), for: .normal)
        sender.imageView?.tintColor = editor.canvas.shapeTool.isFixed ? getAppColor(color: .select) : getAppColor(color: .enable)
    }
    
    @objc func flipV(){
        (delegate as! Editor).canvas.transformFlip(flipX: true, flipY: false)
    }
    
    @objc func flipH(){
        (delegate as! Editor).canvas.transformFlip(flipX: false, flipY: true)
    }
    
    @objc func saveTransform(){
        (delegate as! Editor).finishTransform()
    }
    
    @objc func symmetryV(sender: UIButton){
        let editor = self.delegate as! Editor

        editor.canvas.changeSymmetry(vertical: !editor.canvas.isVerticalSymmeyry)
        sender.imageView?.tintColor = editor.canvas.isVerticalSymmeyry ? getAppColor(color: .select) : getAppColor(color: .enable)
    }
    
    @objc func symmetryH(sender: UIButton){
        let editor = self.delegate as! Editor
        
        editor.canvas.changeSymmetry(horizontal: !editor.canvas.isHorizontalSymmetry)
        sender.imageView?.tintColor = editor.canvas.isHorizontalSymmetry ? getAppColor(color: .select) : getAppColor(color: .enable)

    }
    
    @objc func symmetryCenter(){
        (delegate as! Editor).canvas.centerizeSymmetry()
    }
}

class SelectionButton : UICollectionViewCell, UIGestureRecognizerDelegate {
    weak var delegate : FrameControlDelegate? = nil
    lazy var colorSelector : ColorSelector = {
        let color = ColorSelector()
        color.translatesAutoresizingMaskIntoConstraints = false
        color.widthAnchor.constraint(equalToConstant: 24).isActive = true
        color.heightAnchor.constraint(equalToConstant: 24).isActive = true
        color.color = .black
        color.background.setCorners(corners: 6,needMask: true)
        //color.setCorners(corners: 0)
        color.delegate = {[weak self] in
            self!.delegate?.openColorSelector()
        }
        return color
    }()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        isExclusiveTouch = true
        
        contentView.addSubview(colorSelector)
        colorSelector.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 6).isActive = true
        colorSelector.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
