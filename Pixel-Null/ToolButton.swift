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
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: -5)
                editor.canvas.selectTool(newTool: -5)

                self!.barDelegate.wasChangedTool(newTool: -5)
                
                let btnVert = CircleButton(icon: #imageLiteral(resourceName: "symmetry_vertical_icon"), frame: .zero)
                btnVert.setShadowColor(color: .clear)
                btnVert.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnVert.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnVert.setIconColor(color: editor.canvas.isVerticalSymmeyry ? ProjectStyle.uiSelectColor : ProjectStyle.uiEnableColor)
                
                btnVert.delegate = {
                    editor.canvas.changeSymmetry(vertical: !editor.canvas.isVerticalSymmeyry)
                    btnVert.setIconColor(color: editor.canvas.isVerticalSymmeyry ? ProjectStyle.uiSelectColor : ProjectStyle.uiEnableColor)
                }
                
                let btnHor = CircleButton(icon: #imageLiteral(resourceName: "symmetry_horizontal_icon"), frame: .zero)
                btnHor.setShadowColor(color: .clear)
                btnHor.widthAnchor.constraint(equalToConstant: 36).isActive = true
                btnHor.heightAnchor.constraint(equalToConstant: 36).isActive = true
                btnHor.setIconColor(color: editor.canvas.isHorizontalSymmetry ? ProjectStyle.uiSelectColor : ProjectStyle.uiEnableColor)
                btnHor.delegate = {
                    editor.canvas.changeSymmetry(horizontal: !editor.canvas.isHorizontalSymmetry)
                    btnHor.setIconColor(color: editor.canvas.isHorizontalSymmetry ? ProjectStyle.uiSelectColor : ProjectStyle.uiEnableColor)
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
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[unowned self] in
                (self.delegate as! Editor).finishTransform()

                (self.delegate as! Editor).openProjectSettings()
            }
            
        case -3: 
            button.setIcon(ic: #imageLiteral(resourceName: "undo_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.finishTransform()
                
                self!.project.unDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
        case -2:
            button.setIcon(ic: #imageLiteral(resourceName: "redo_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.finishTransform()
                
                self!.project.reDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
            
        case -1:
          button.setIcon(ic: #imageLiteral(resourceName: "cancel_icon"))
          button.setIconColor(color: ProjectStyle.uiEnableColor)
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
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 0)
                editor.canvas.selectTool(newTool: 0)

                self!.barDelegate.wasChangedTool(newTool: 0)
                self!.barDelegate.updateButtons(btns: [])
                self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
            }
            button.longPressDelegate = {[weak self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                (self!.delegate as! ToolSettingsDelegate).openPencilSettings()
            }
            
        case 1:
            button.setIcon(ic: #imageLiteral(resourceName: "erase_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 1)
                editor.canvas.selectTool(newTool: 1)

                self!.barDelegate.wasChangedTool(newTool: 1)
                self!.barDelegate.updateButtons(btns: [])
                self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
            }
            button.longPressDelegate = {[weak self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                               impactFeedbackgenerator.prepare()
                               impactFeedbackgenerator.impactOccurred()
                (self!.delegate as! ToolSettingsDelegate).openEraseSettings()
            }
            
        case 2:
           button.setIcon(ic: #imageLiteral(resourceName: "move_icon"))
           button.setIconColor(color: ProjectStyle.uiEnableColor)
           button.delegate = {[weak self] in
            let editor = self!.delegate as! Editor
            
            if !editor.canvas.transformView.isCopyMode {
                editor.canvas.checkTransformChangeBefore(newTool: 2)
            }
            
            editor.canvas.selectTool(newTool: 2)
            
            editor.showTransform(isShow: true)
            
            let flipV = CircleButton(icon: #imageLiteral(resourceName: "flip_horizontal_icon"), frame: .zero)
            flipV.widthAnchor.constraint(equalToConstant: 36).isActive = true
            flipV.heightAnchor.constraint(equalToConstant: 36).isActive = true
            flipV.setShadowColor(color: .clear)
            flipV.delegate = {
                editor.canvas.transformFlip(flipX: true, flipY: false)
            }
            
            let flipH = CircleButton(icon: #imageLiteral(resourceName: "flip_vertical_icon"), frame: .zero)
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
            finish.widthAnchor.constraint(equalToConstant: 36).isActive = true
            finish.heightAnchor.constraint(equalToConstant: 36).isActive = true
            finish.setShadowColor(color: .clear)
            finish.delegate = {
                editor.finishTransform()
                //editor.canvas.finishTransform()
            }
            
            
            self!.barDelegate.wasChangedTool(newTool: 2)
            self!.barDelegate.updateButtons(btns: [flipV,flipH,finish])
            self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
           }
        
        case 3:
          button.setIcon(ic: #imageLiteral(resourceName: "gradient_icon"))
          button.setIconColor(color: ProjectStyle.uiEnableColor)
          button.delegate = {[weak self] in
              let editor = self!.delegate as! Editor
            editor.canvas.checkTransformChangeBefore(newTool: 3)
              editor.canvas.selectTool(newTool: 3)

            self!.barDelegate.wasChangedTool(newTool: 3)
            self!.barDelegate.updateButtons(btns: [])
            self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
          }
          button.longPressDelegate = {[weak self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                                          impactFeedbackgenerator.prepare()
                                          impactFeedbackgenerator.impactOccurred()
                (self!.delegate as! ToolSettingsDelegate).openGradientSettings()
            }
        
        case 4:
            button.setIcon(ic: #imageLiteral(resourceName: "fill_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
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
                
                self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
            }
            button.longPressDelegate = {
                    let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                    impactFeedbackgenerator.prepare()
                    impactFeedbackgenerator.impactOccurred()
            }

        case 5:
            button.setIcon(ic: #imageLiteral(resourceName: "grid_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                if editor.canvas.isGridVIsible {
                    self!.button.setIconColor(color: ProjectStyle.uiEnableColor)
                } else {
                    self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
                }
                editor.canvas.isGridVIsible.toggle()
            }
            
        case 6:
            button.setIcon(ic: #imageLiteral(resourceName: "selection_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)

            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 6)
                editor.canvas.selectTool(newTool: 6)

                self!.barDelegate.wasChangedTool(newTool: 6)
                
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
                delete.setIconColor(color: ProjectStyle.uiRedColor)
                delete.widthAnchor.constraint(equalToConstant: 36).isActive = true
                delete.heightAnchor.constraint(equalToConstant: 36).isActive = true
                delete.setShadowColor(color: .clear)
                delete.delegate = {
                    editor.canvas.deleteSelect()
                }
                
                let copy = CircleButton(icon: #imageLiteral(resourceName: "copy_select_icon"), frame: .zero)
                //put.setIconColor(color: ProjectStyle.uiRedColor)
                copy.widthAnchor.constraint(equalToConstant: 36).isActive = true
                copy.heightAnchor.constraint(equalToConstant: 36).isActive = true
                copy.setShadowColor(color: .clear)
               
                copy.delegate = {
                    editor.saveSelection()
                }
                
                let paste = CircleButton(icon: #imageLiteral(resourceName: "selection_paste_icon"), frame: .zero)
                paste.widthAnchor.constraint(equalToConstant: 36).isActive = true
                paste.heightAnchor.constraint(equalToConstant: 36).isActive = true
                paste.setShadowColor(color: .clear)
                paste.delegate = {
                    editor.startTransformWithImage()
                }
                
                let cut = CircleButton(icon: #imageLiteral(resourceName: "cut_icon"), frame: .zero)
                cut.widthAnchor.constraint(equalToConstant: 36).isActive = true
                cut.heightAnchor.constraint(equalToConstant: 36).isActive = true
                cut.setShadowColor(color: .clear)
                cut.delegate = {
                    editor.saveSelection()
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
                
                self!.barDelegate.updateButtons(btns: [reverse,clear,paste,copy,cut,delete,selectMode])
                
                self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
            }
            button.longPressDelegate = {[unowned self] in
                let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
                
                (self.delegate as! Editor).openSelectorSettings()
            }
        case 7:
            button.setIcon(ic: #imageLiteral(resourceName: "sharp_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 7)
                editor.canvas.selectTool(newTool: 7)

                self!.barDelegate.wasChangedTool(newTool: 7)
                self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
                
                let squareSelector = SegmentSelector(imgs: [#imageLiteral(resourceName: "rectangle_icon"),#imageLiteral(resourceName: "circle_icon"),#imageLiteral(resourceName: "line_icon")])
                squareSelector.selectDelegate = {select in
                    switch select {
                    case 0:
                        editor.canvas.square.squareType = .rectangle
                    case 1:
                        editor.canvas.square.squareType = .oval
                    case 2:
                        editor.canvas.square.squareType = .line
                    default:
                        editor.canvas.square.squareType = .rectangle
                    }
                }

                let block = CircleButton(icon: editor.canvas.square.isFixed ? #imageLiteral(resourceName: "block_icon") : #imageLiteral(resourceName: "unblock_icon"), frame: .zero)
                block.setIconColor(color: editor.canvas.square.isFixed ? ProjectStyle.uiSelectColor : ProjectStyle.uiEnableColor)
                block.widthAnchor.constraint(equalToConstant: 36).isActive = true
                block.heightAnchor.constraint(equalToConstant: 36).isActive = true
                block.setShadowColor(color: .clear)
                
                block.delegate = {
                    editor.canvas.square.isFixed.toggle()
                    block.setIcon(ic: editor.canvas.square.isFixed ? #imageLiteral(resourceName: "block_icon") : #imageLiteral(resourceName: "unblock_icon"))
                    block.setIconColor(color: editor.canvas.square.isFixed ? ProjectStyle.uiSelectColor : ProjectStyle.uiEnableColor)
                }
                
                switch editor.canvas.square.squareType {
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
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.checkTransformChangeBefore(newTool: 8)
                editor.canvas.selectTool(newTool: 8)

                self!.barDelegate.wasChangedTool(newTool: 8)
                self!.barDelegate.updateButtons(btns: [])
                self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
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
