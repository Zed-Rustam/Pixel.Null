//
//  ToolButton.swift
//  new Testing
//
//  Created by Рустам Хахук on 22.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ToolButton : UICollectionViewCell {
    private var button : CircleButton!
    private var toolID : Int!
    weak var project : ProjectWork!
    weak var delegate : FrameControlDelegate!
    weak var barDelegate : ToolBarDelegate!
    
    func getButton() -> CircleButton { button }
    override init(frame: CGRect) {
        super.init(frame: frame)
        button = CircleButton(icon: UIImage(), frame: self.bounds)
        button.corners = 12
        button.setbgColor(color: .clear)
        //button.setCorners(corners: 4)
        button.setShadowColor(color: .clear)
        
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setToolID(id : Int){
        switch id {
        case -5:
            button.setIcon(ic: #imageLiteral(resourceName: "symmetry_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: -5)
                editor.canvas.selectTool(newTool: -5)

                self!.barDelegate.wasChangedTool(newTool: -5)
                
                let btnVert = CircleButton(icon: #imageLiteral(resourceName: "symmetry_vertical_icon"), frame: .zero)
                btnVert.setShadowColor(color: .clear)
                btnVert.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnVert.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnVert.setIconColor(color: editor.canvas.isVerticalSymmeyry ? UIColor(named: "selectColor")! : UIColor(named: "enableColor")!)
                
                btnVert.delegate = {
                    editor.canvas.changeSymmetry(vertical: !editor.canvas.isVerticalSymmeyry)
                    btnVert.setIconColor(color: editor.canvas.isVerticalSymmeyry ? UIColor(named: "selectColor")! : UIColor(named: "enableColor")!)
                }
                
                let btnHor = CircleButton(icon: #imageLiteral(resourceName: "symmetry_horizontal_icon"), frame: .zero)
                btnHor.setShadowColor(color: .clear)
                btnHor.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnHor.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnHor.setIconColor(color: editor.canvas.isHorizontalSymmetry ? UIColor(named: "selectColor")! : UIColor(named: "enableColor")!)
                btnHor.delegate = {
                    editor.canvas.changeSymmetry(horizontal: !editor.canvas.isHorizontalSymmetry)
                    btnHor.setIconColor(color: editor.canvas.isHorizontalSymmetry ? UIColor(named: "selectColor")! : UIColor(named: "enableColor")!)
                }
                
                let btnCent = CircleButton(icon: #imageLiteral(resourceName: "symmetry_centerize"), frame: .zero)
                btnCent.setShadowColor(color: .clear)
                btnCent.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnCent.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnCent.delegate = {
                    editor.canvas.centerizeSymmetry()
                }
                
                self!.barDelegate.updateButtons(btns: [btnVert,btnHor,btnCent])
            }

        case -4:
            button.setIcon(ic: #imageLiteral(resourceName: "project_settings_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[unowned self] in
                (self.delegate as! Editor).finishTransform()

                (self.delegate as! Editor).openProjectSettings()
            }
            
        case -3: 
            button.setIcon(ic: #imageLiteral(resourceName: "undo_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.finishTransform()
                
                self!.project.unDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
        case -2:
            button.setIcon(ic: #imageLiteral(resourceName: "redo_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.finishTransform()
                
                self!.project.reDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
            
        case -1:
          button.setIcon(ic: #imageLiteral(resourceName: "cancel_icon"))
          button.setIconColor(color: UIColor(named: "enableColor")!)
          button.delegate = {[weak self] in
            let editor = self!.delegate as! Editor
                editor.finishTransform()
            
              self!.project.save()
              self!.project.savePreview(frame: self!.project.FrameSelected)
              
              editor.gallery?.updateProjectView(proj: self!.project)
              editor.dismiss(animated: true, completion: nil)
          }
        case 0:
            button.setIcon(ic: #imageLiteral(resourceName: "edit_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 0)
                editor.canvas.selectTool(newTool: 0)

                self!.barDelegate.wasChangedTool(newTool: 0)
                self!.barDelegate.updateButtons(btns: [])
                self!.button.setIconColor(color: UIColor(named: "selectColor")!)
            }
            button.longPressDelegate = {[weak self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
                (self!.delegate as! ToolSettingsDelegate).openPencilSettings()
            }
            
        case 1:
            button.setIcon(ic: #imageLiteral(resourceName: "erase_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 1)
                editor.canvas.selectTool(newTool: 1)

                self!.barDelegate.wasChangedTool(newTool: 1)
                self!.barDelegate.updateButtons(btns: [])
                self!.button.setIconColor(color: UIColor(named: "selectColor")!)
            }
            button.longPressDelegate = {[weak self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                               impactFeedbackgenerator.prepare()
                               impactFeedbackgenerator.impactOccurred()
                (self!.delegate as! ToolSettingsDelegate).openEraseSettings()
            }
            
        case 2:
           button.setIcon(ic: #imageLiteral(resourceName: "move_icon"))
           button.setIconColor(color: UIColor(named: "enableColor")!)
           button.delegate = {[weak self] in
            let editor = self!.delegate as! Editor
            
            if !editor.canvas.transformView.isCopyMode {
                editor.canvas.checkTransformChangeBefore(newTool: 2)
            }
            
            editor.canvas.selectTool(newTool: 2)
            
            editor.showTransform(isShow: true)
            
            let flipV = CircleButton(icon: #imageLiteral(resourceName: "flip_horizontal_icon"), frame: .zero)
            flipV.setIconColor(color: UIColor(named: "enableColor")!)
            flipV.widthAnchor.constraint(equalToConstant: 36).isActive = true
            flipV.heightAnchor.constraint(equalToConstant: 36).isActive = true
            flipV.setShadowColor(color: .clear)
            flipV.delegate = {
                editor.canvas.transformFlip(flipX: true, flipY: false)
            }
            
            let flipH = CircleButton(icon: #imageLiteral(resourceName: "flip_vertical_icon"), frame: .zero)
            flipH.setIconColor(color: UIColor(named: "enableColor")!)
            flipH.widthAnchor.constraint(equalToConstant: 36).isActive = true
            flipH.heightAnchor.constraint(equalToConstant: 36).isActive = true
            flipH.setShadowColor(color: .clear)
            flipH.delegate = {
                editor.canvas.transformFlip(flipX: false, flipY: true)
            }
            
            let block = CircleButton(icon: #imageLiteral(resourceName: "block_icon"), frame: .zero)
            block.widthAnchor.constraint(equalToConstant: 36).isActive = true
            block.heightAnchor.constraint(equalToConstant: 36).isActive = true
            block.setShadowColor(color: .clear)
            block.delegate = {
                //editor.canvas.reverseSelection()
            }
            
            let finish = CircleButton(icon: #imageLiteral(resourceName: "save_icon"), frame: .zero)
            finish.setIconColor(color: UIColor(named: "enableColor")!)

            finish.widthAnchor.constraint(equalToConstant: 36).isActive = true
            finish.heightAnchor.constraint(equalToConstant: 36).isActive = true
            finish.setShadowColor(color: .clear)
            finish.delegate = {
                editor.finishTransform()
                //editor.canvas.finishTransform()
            }
            
            
            self!.barDelegate.wasChangedTool(newTool: 2)
            self!.barDelegate.updateButtons(btns: [flipV,flipH,finish])
            self!.button.setIconColor(color: UIColor(named: "selectColor")!)
           }
        
        case 3:
          button.setIcon(ic: #imageLiteral(resourceName: "gradient_icon"))
          button.setIconColor(color: UIColor(named: "enableColor")!)
          button.delegate = {[weak self] in
              let editor = self!.delegate as! Editor
            editor.canvas.checkTransformChangeBefore(newTool: 3)
              editor.canvas.selectTool(newTool: 3)
            
            self!.barDelegate.wasChangedTool(newTool: 3)
            self!.barDelegate.updateButtons(btns: [])
            self!.button.setIconColor(color: UIColor(named: "selectColor")!)
          }
          button.longPressDelegate = {[weak self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                                          impactFeedbackgenerator.prepare()
                                          impactFeedbackgenerator.impactOccurred()
                (self!.delegate as! ToolSettingsDelegate).openGradientSettings()
            }
        
        case 4:
            button.setIcon(ic: #imageLiteral(resourceName: "fill_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 4)
                editor.canvas.selectTool(newTool: 4)

                self!.barDelegate.wasChangedTool(newTool: 4)
                
                let selector = SegmentSelector(imgs: [#imageLiteral(resourceName: "layer_icon"),#imageLiteral(resourceName: "layers_icon")])
                switch editor.canvas.fill.style {
                case .layer:
                    selector.select = 0
                case .frame:
                    selector.select = 1
                }
                
                selector.selectDelegate = {
                    switch $0 {
                    case 0:
                        editor.canvas.fill.style = .layer
                    default:
                        editor.canvas.fill.style = .frame
                    }
                }
                
                self!.barDelegate.updateButtons(btns: [selector])
                
                self!.button.setIconColor(color: UIColor(named: "selectColor")!)
            }
            button.longPressDelegate = {
                    let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                    impactFeedbackgenerator.prepare()
                    impactFeedbackgenerator.impactOccurred()
            }

        case 5:
            button.setIcon(ic: #imageLiteral(resourceName: "grid_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                if editor.canvas.isGridVIsible {
                    self!.button.setIconColor(color: UIColor(named: "enableColor")!)
                } else {
                    self!.button.setIconColor(color: UIColor(named: "selectColor")!)
                }
                editor.canvas.isGridVIsible.toggle()
            }
            
        case 6:
            button.setIcon(ic: #imageLiteral(resourceName: "selection_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)

            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 6)
                editor.canvas.selectTool(newTool: 6)

                self!.barDelegate.wasChangedTool(newTool: 6)
                
                let actionsButton = UIButton()
                actionsButton.translatesAutoresizingMaskIntoConstraints = false
                actionsButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
                actionsButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
                actionsButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
                actionsButton.showsMenuAsPrimaryAction = true
                
                actionsButton.imageView?.tintColor = getAppColor(color: .enable)
                
                actionsButton.menu = UIMenu(title: "select actions", image: nil, identifier: nil, options: .destructive, children: [
                    UIAction(title: "copy", image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        editor.saveSelection()
                    }),
                    
                    UIAction(title: "paste", image: UIImage(systemName: "doc.on.clipboard"), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        editor.startTransformWithImage()
                    }),
                    
                    UIAction(title: "cut", image: UIImage(systemName: "scissors"), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        editor.saveSelection()
                        editor.canvas.deleteSelect()
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
                    UIAction(title: "rectangle", image: #imageLiteral(resourceName: "rectangle_icon").withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "rectangle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        editor.setSelectionSettings(mode: 1)
                    }),
                    
                    UIAction(title: "circle", image: #imageLiteral(resourceName: "circle_icon").withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "circle_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        editor.setSelectionSettings(mode: 2)
                    }),
                    
                    UIAction(title: "custom shape", image: #imageLiteral(resourceName: "custom_shape_selector_icon").withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "custom_shape_selector_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        editor.setSelectionSettings(mode: 0)

                    }),
                    
                    UIAction(title: "magic tool", image: #imageLiteral(resourceName: "selection_magic_tool_icon").withTintColor(.white), identifier: nil, discoverabilityTitle: nil, handler: {action in
                        selectType.setImage(#imageLiteral(resourceName: "selection_magic_tool_icon").withRenderingMode(.alwaysTemplate), for: .normal)
                        editor.setSelectionSettings(mode: 3)
                    })
                ])

                let reverse = CircleButton(icon: #imageLiteral(resourceName: "reverse_selection_icon"), frame: .zero)
                reverse.widthAnchor.constraint(equalToConstant: 36).isActive = true
                reverse.heightAnchor.constraint(equalToConstant: 36).isActive = true
                reverse.setShadowColor(color: .clear)
                reverse.delegate = {
                    editor.canvas.reverseSelection()
                }
                
                let clear = CircleButton(icon: #imageLiteral(resourceName: "selection_clear_icon"), frame: .zero)
                clear.widthAnchor.constraint(equalToConstant: 36).isActive = true
                clear.heightAnchor.constraint(equalToConstant: 36).isActive = true
                clear.setShadowColor(color: .clear)
                
                clear.delegate = {
                    editor.canvas.clearSelect()
                }
                
                let delete = CircleButton(icon: #imageLiteral(resourceName: "selection_delete_icon"), frame: .zero)
                delete.setIconColor(color: UIColor(named: "redColor")!)
                delete.widthAnchor.constraint(equalToConstant: 36).isActive = true
                delete.heightAnchor.constraint(equalToConstant: 36).isActive = true
                delete.setShadowColor(color: .clear)
                delete.delegate = {
                    editor.canvas.deleteSelect()
                }
                
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
                
                self!.barDelegate.updateButtons(btns: [actionsButton,reverse,clear,delete,selectMode,selectType])
                
                self!.button.setIconColor(color: UIColor(named: "selectColor")!)
            }
            
        case 7:
            button.setIcon(ic: #imageLiteral(resourceName: "sharp_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 7)
                editor.canvas.selectTool(newTool: 7)

                self!.barDelegate.wasChangedTool(newTool: 7)
                self!.button.setIconColor(color: UIColor(named: "selectColor")!)
                
                let squareSelector = SegmentSelector(imgs: [#imageLiteral(resourceName: "rectangle_icon"),#imageLiteral(resourceName: "circle_icon"),#imageLiteral(resourceName: "line_icon")])
                squareSelector.selectDelegate = {select in
                    switch select {
                    case 0:
                        editor.canvas.shapeTool.squareType = .rectangle
                    case 1:
                        editor.canvas.shapeTool.squareType = .oval
                    case 2:
                        editor.canvas.shapeTool.squareType = .line
                    default:
                        editor.canvas.shapeTool.squareType = .rectangle
                    }
                }

                let block = CircleButton(icon: editor.canvas.shapeTool.isFixed ? #imageLiteral(resourceName: "block_icon") : #imageLiteral(resourceName: "unblock_icon"), frame: .zero)
                block.setIconColor(color: editor.canvas.shapeTool.isFixed ? UIColor(named: "selectColor")! : UIColor(named: "enableColor")!)
                block.widthAnchor.constraint(equalToConstant: 36).isActive = true
                block.heightAnchor.constraint(equalToConstant: 36).isActive = true
                block.setShadowColor(color: .clear)
                
                block.delegate = {
                    editor.canvas.shapeTool.isFixed.toggle()
                    block.setIcon(ic: editor.canvas.shapeTool.isFixed ? #imageLiteral(resourceName: "block_icon") : #imageLiteral(resourceName: "unblock_icon"))
                    block.setIconColor(color: editor.canvas.shapeTool.isFixed ? UIColor(named: "selectColor")! : UIColor(named: "enableColor")!)
                }
                
                switch editor.canvas.shapeTool.squareType {
                case .rectangle:
                    squareSelector.select = 0
                case .oval:
                    squareSelector.select = 1
                case .line:
                    squareSelector.select = 2
                }

                self!.barDelegate.updateButtons(btns: [squareSelector,block])
            }

        case 8:
            button.setIcon(ic: #imageLiteral(resourceName: "picker_icon"))
            button.setIconColor(color: UIColor(named: "enableColor")!)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 8)
                editor.canvas.selectTool(newTool: 8)

                self!.barDelegate.wasChangedTool(newTool: 8)
                self!.barDelegate.updateButtons(btns: [])
                self!.button.setIconColor(color: UIColor(named: "selectColor")!)
            }
            
        default:
            break
        }
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
        color.background.setCorners(corners: 6)
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
