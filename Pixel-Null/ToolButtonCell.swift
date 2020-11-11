//
//  ToolButtonCell.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 01.11.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ToolButtonCell: UICollectionViewCell {
    lazy var btn: UIButton = {
        let btn = UIButton()
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onPress), for: .touchUpInside)
        
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.tintColor = .appEnable
        return btn
    }()
    
    private var onTap: ()->() = {}
    private var onLong: ()->() = {}

    lazy private var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .appBackground
        contentView.setCorners(corners: 12, needMask: true, curveType: .continuous)
        
        contentView.addSubviewFullSize(view: btn)
        
        longPressGesture.minimumPressDuration = 0.25
        btn.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func onPress() {
        onTap()
    }
    
    @objc func onLongPress() {
        onLong()
        longPressGesture.isEnabled = false
        longPressGesture.isEnabled = true
        btn.isUserInteractionEnabled = false
        btn.isUserInteractionEnabled = true
    }
    
    weak var delegate: ToolsActionDelegate? = nil
    
    func setSelect(isSelect: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.backgroundColor = isSelect ? UIColor.appSelect.withAlphaComponent(0.1) : .appBackground
            self.btn.imageView?.tintColor =  isSelect ? .appSelect : .appEnable
        })
    }
    
    @objc func symmetryV(sender: UIButton){
        delegate!.editorCanvas.changeSymmetry(vertical: !delegate!.editorCanvas.isVerticalSymmeyry)
        sender.imageView?.tintColor = delegate!.editorCanvas.isVerticalSymmeyry ? getAppColor(color: .select) : getAppColor(color: .enable)
    }
    
    @objc func symmetryH(sender: UIButton){
        delegate!.editorCanvas.changeSymmetry(horizontal: !delegate!.editorCanvas.isHorizontalSymmetry)
        sender.imageView?.tintColor = delegate!.editorCanvas.isHorizontalSymmetry ? getAppColor(color: .select) : getAppColor(color: .enable)

    }
    
    @objc func blockPress(sender: UIButton) {
        delegate!.editorCanvas.shapeTool.isFixed.toggle()
        sender.setImage(delegate!.editorCanvas.shapeTool.isFixed ? #imageLiteral(resourceName: "block_icon") : #imageLiteral(resourceName: "unblock_icon"), for: .normal)
        sender.imageView?.tintColor = delegate!.editorCanvas.shapeTool.isFixed ? getAppColor(color: .select) : getAppColor(color: .enable)
    }
    
    @objc func flipV(){
        delegate!.editorCanvas.transformFlip(flipX: true, flipY: false)
    }
    
    @objc func flipH(){
        delegate!.editorCanvas.transformFlip(flipX: false, flipY: true)
    }
    
    @objc func saveTransform(){
        delegate?.editorCanvas.transformView.needToSave = true
        delegate!.endTransformMode()
    }
    
    @objc func symmetryCenter(){
        delegate!.editorCanvas.centerizeSymmetry()
    }
    
    @objc func onModeChange(sender: UIButton) {
        delegate!.editorCanvas.selection.mode = delegate!.editorCanvas.selection.mode == Selection.selectMode.delete ? .add : .delete
        sender.setImage(delegate?.editorCanvas.selection.mode == Selection.selectMode.add ? #imageLiteral(resourceName: "selector_add_mode_icon").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "selector_remove_mode_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        sender.imageView?.tintColor = delegate?.editorCanvas.selection.mode == Selection.selectMode.add ? getAppColor(color: .select) : getAppColor(color: .red)
    }
    
    func setToolID(id : Int){
        switch id {
        case -5:
            btn.setImage(#imageLiteral(resourceName: "symmetry_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in
                let btnV = UIButton()
                btnV.translatesAutoresizingMaskIntoConstraints = false
                btnV.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnV.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnV.setImage(#imageLiteral(resourceName: "symmetry_vertical_icon"), for: .normal)
                btnV.imageView?.tintColor = delegate!.editorCanvas.isVerticalSymmeyry ? getAppColor(color: .select) : getAppColor(color: .enable)
                btnV.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                btnV.addTarget(self, action: #selector(symmetryV), for: .touchUpInside)

                let btnH = UIButton()
                btnH.translatesAutoresizingMaskIntoConstraints = false
                btnH.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnH.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnH.setImage(#imageLiteral(resourceName: "symmetry_horizontal_icon"), for: .normal)
                btnH.imageView?.tintColor = delegate!.editorCanvas.isHorizontalSymmetry ? getAppColor(color: .select) : getAppColor(color: .enable)
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
                
                delegate?.changeTool(tool: id,subButtons: [btnV,btnH,btnCenter])
            }

        case -4:
            btn.setImage(#imageLiteral(resourceName: "project_settings_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            onTap = {[unowned self] in
                delegate?.openProjectSettings(sender: btn)
            }
            
        case -3:
            btn.setImage(#imageLiteral(resourceName: "undo_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            onTap = {[unowned self] in
                delegate?.endTransformMode()
                delegate?.editorProject.unDo()

            }
        case -2:
            btn.setImage(#imageLiteral(resourceName: "redo_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            onTap = {[unowned self] in
                delegate?.endTransformMode()
                delegate?.editorProject.reDo()
            }
            
        case -1:
            btn.setImage(#imageLiteral(resourceName: "cancel_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in
                self.delegate?.saveAndExit()
            }
            
        case 0:
            btn.setImage(#imageLiteral(resourceName: "edit_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            onTap = {[unowned self] in
                delegate?.changeTool(tool: id,subButtons: [])
            }
            
            onLong = {[unowned self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
                delegate?.openPencilSettings(sender: self.btn)
            }
            
        case 1:
            btn.setImage(#imageLiteral(resourceName: "erase_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in
                delegate?.changeTool(tool: id,subButtons: [])
            }
            onLong = {[unowned self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
                
                delegate?.openEraseSettings(sender: self.btn)
            }
            
        case 2:
            btn.setImage(#imageLiteral(resourceName: "move_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in

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

            delegate?.changeTool(tool: id,subButtons: [flipVBtn,flipHBtn,finish])
            delegate?.startTransformMode()
           }
        
        case 3:
            btn.setImage(#imageLiteral(resourceName: "gradient_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in
                delegate?.changeTool(tool: id,subButtons: [])
            }
            
            onLong = {[unowned self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
            
                delegate?.openGradientSettings(sender: self.btn)
            }
        
        case 4:
            btn.setImage(#imageLiteral(resourceName: "fill_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in
                let styleSelectBtn = UIButton()

                styleSelectBtn.setImage(delegate!.editorCanvas.fill.style == .layer ? #imageLiteral(resourceName: "layer_icon") : #imageLiteral(resourceName: "layers_icon"), for: .normal)
                styleSelectBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                styleSelectBtn.imageView?.tintColor = getAppColor(color: .enable)

                styleSelectBtn.translatesAutoresizingMaskIntoConstraints = false
                styleSelectBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
                styleSelectBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true

                styleSelectBtn.showsMenuAsPrimaryAction = true
                styleSelectBtn.menu = UIMenu(title: "Style", image: nil, children: [
                    UIAction(title: "Layer", image: #imageLiteral(resourceName: "layer_icon").withTintColor(getAppColor(color: .enable)), handler: {_ in
                        delegate!.editorCanvas.fill.style = .layer
                        styleSelectBtn.setImage(delegate!.editorCanvas.fill.style == .layer ? #imageLiteral(resourceName: "layer_icon") : #imageLiteral(resourceName: "layers_icon"), for: .normal)
                    }),
                    UIAction(title: "Frame", image: #imageLiteral(resourceName: "layers_icon").withTintColor(getAppColor(color: .enable)), handler: {_ in
                        delegate!.editorCanvas.fill.style = .frame
                        styleSelectBtn.setImage(delegate!.editorCanvas.fill.style == .layer ? #imageLiteral(resourceName: "layer_icon") : #imageLiteral(resourceName: "layers_icon"), for: .normal)
                    })
                ])
                
                delegate?.changeTool(tool: id,subButtons: [styleSelectBtn])

            }

        case 5:
            btn.setImage(#imageLiteral(resourceName: "grid_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in
                delegate?.changeGrid()
                if delegate!.isGrid() {
                    self.btn.imageView?.tintColor = .appSelect
                } else {
                    self.btn.imageView?.tintColor = .appEnable

                }
            }
            
        case 6:
            btn.setImage(#imageLiteral(resourceName: "selection_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in

                let actionsButton = UIButton()
                actionsButton.translatesAutoresizingMaskIntoConstraints = false
                actionsButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
                actionsButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
                actionsButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
                actionsButton.showsMenuAsPrimaryAction = true

                actionsButton.imageView?.tintColor = getAppColor(color: .enable)

                actionsButton.menu = UIMenu(title: "select actions", image: nil, identifier: nil, options: .destructive, children: [
                    UIAction(title: "delete", image: UIImage(systemName: "trash",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                        delegate!.editorCanvas.deleteSelect()
                    }),
                    UIAction(title: "clear", image: UIImage(systemName: "clear",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        delegate!.editorCanvas.clearSelect()
                    }),
                    UIAction(title: "copy", image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        delegate!.saveSelection()
                    }),
                    UIAction(title: "paste", image: UIImage(systemName: "doc.on.clipboard"), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        delegate!.pasteImage()
                    }),
                    UIAction(title: "cut", image: UIImage(systemName: "scissors"), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        delegate!.saveSelection()
                        delegate!.editorCanvas.deleteSelect()
                    }),
                    UIAction(title: "reverse", image: UIImage(systemName: "arrow.right.arrow.left.square", withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        delegate!.editorCanvas.reverseSelection()
                    })
                ])
                
                let selectType = UIButton()
                selectType.translatesAutoresizingMaskIntoConstraints = false
                selectType.widthAnchor.constraint(equalToConstant: 36).isActive = true
                selectType.heightAnchor.constraint(equalToConstant: 36).isActive = true
                selectType.setImage(#imageLiteral(resourceName: "rectangle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                
                switch delegate?.editorCanvas.selection.type {
                case .rectangle:
                    selectType.setImage(#imageLiteral(resourceName: "rectangle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                case .ellipse:
                    selectType.setImage(#imageLiteral(resourceName: "circle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                case .magicTool:
                    selectType.setImage(#imageLiteral(resourceName: "selection_magic_tool_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                case .draw:
                    selectType.setImage(#imageLiteral(resourceName: "custom_shape_selector_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                default:
                    break;
                }
                
                selectType.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                selectType.showsMenuAsPrimaryAction = true
                selectType.imageView?.tintColor = getAppColor(color: .enable)

                selectType.menu = UIMenu(title: "select type", image: nil, identifier: nil, options: .destructive, children: [
                    UIAction(title: "rectangle", image: #imageLiteral(resourceName: "rectangle_icon").withRenderingMode(.alwaysTemplate).withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "rectangle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        delegate!.editorCanvas.selection.type = Selection.SelectionType.init(rawValue: 1)!
                    }),

                    UIAction(title: "circle", image: #imageLiteral(resourceName: "circle_icon").withRenderingMode(.alwaysTemplate).withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "circle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        delegate!.editorCanvas.selection.type = Selection.SelectionType.init(rawValue: 2)!
                    }),

                    UIAction(title: "custom shape", image: #imageLiteral(resourceName: "custom_shape_selector_icon").withRenderingMode(.alwaysTemplate).withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "custom_shape_selector_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        delegate!.editorCanvas.selection.type = Selection.SelectionType.init(rawValue: 0)!
                    }),

                    UIAction(title: "magic tool", image: #imageLiteral(resourceName: "selection_magic_tool_icon").withRenderingMode(.alwaysTemplate).withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "selection_magic_tool_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        delegate!.editorCanvas.selection.type = Selection.SelectionType.init(rawValue: 3)!
                    })
                ])

                
                let selectionMode = UIButton()
                selectionMode.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                selectionMode.setImage(delegate?.editorCanvas.selection.mode == Selection.selectMode.add ? #imageLiteral(resourceName: "selector_add_mode_icon").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "selector_remove_mode_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                selectionMode.imageView?.tintColor = delegate?.editorCanvas.selection.mode == Selection.selectMode.add ? getAppColor(color: .select) : getAppColor(color: .red)
                
                selectionMode.addTarget(self, action: #selector(onModeChange(sender:)), for: .touchUpInside)
                
                delegate?.changeTool(tool: id,subButtons: [actionsButton, selectType,selectionMode])
            }
            
        case 7:
            btn.setImage(#imageLiteral(resourceName: "sharp_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in
                let selectShapeBtn = UIButton()
                selectShapeBtn.translatesAutoresizingMaskIntoConstraints = false
                selectShapeBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
                selectShapeBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true

                var selectImage = UIImage()

                switch delegate!.editorCanvas.shapeTool.squareType {
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
                        delegate!.editorCanvas.shapeTool.squareType = .rectangle
                        selectShapeBtn.setImage(#imageLiteral(resourceName: "rectangle_icon"), for: .normal)
                    }),
                    UIAction(title: "Oval", image: #imageLiteral(resourceName: "circle_icon").withTintColor(getAppColor(color: .enable)), identifier: .none, discoverabilityTitle: nil, handler: {_ in
                        delegate!.editorCanvas.shapeTool.squareType = .oval
                        selectShapeBtn.setImage(#imageLiteral(resourceName: "circle_icon"), for: .normal)
                    }),
                    UIAction(title: "Line", image: #imageLiteral(resourceName: "line_icon").withTintColor(getAppColor(color: .enable)), identifier: .none, discoverabilityTitle: nil, handler: {_ in
                        delegate!.editorCanvas.shapeTool.squareType = .line
                        selectShapeBtn.setImage(#imageLiteral(resourceName: "line_icon"), for: .normal)
                    })
                ])

                let blockBtn = UIButton()
                blockBtn.setImage(delegate!.editorCanvas.shapeTool.isFixed ? #imageLiteral(resourceName: "block_icon") : #imageLiteral(resourceName: "unblock_icon"), for: .normal)
                blockBtn.imageView?.tintColor = delegate!.editorCanvas.shapeTool.isFixed ? getAppColor(color: .select) : getAppColor(color: .enable)
                blockBtn.translatesAutoresizingMaskIntoConstraints = false
                blockBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

                blockBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
                blockBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true

                blockBtn.addTarget(self, action: #selector(blockPress(sender:)), for: .touchUpInside)

                delegate?.changeTool(tool: id,subButtons: [selectShapeBtn,blockBtn])
            }

        case 8:
            btn.setImage(#imageLiteral(resourceName: "picker_icon"), for: .normal)
            btn.imageView?.tintColor = .appEnable
            
            onTap = {[unowned self] in
                delegate?.changeTool(tool: id,subButtons: [])
            }
            
        default:
            break
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColorSelectorCell: UICollectionViewCell {
    
    weak var delegate: ToolsActionDelegate? = nil
    
    lazy private var selector: ColorSelector = {
        let clr = ColorSelector(frame: .zero)
        clr.color = .black
        clr.translatesAutoresizingMaskIntoConstraints = false
        
        clr.delegate = {[unowned self] in
            self.delegate?.openPalette(sender: clr)
        }
        
        return clr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubviewFullSize(view: selector,paddings: (4,-4,4,-4))
    }
    
    var color: UIColor {
        get {
            selector.color
        }
        set {
            selector.color = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
