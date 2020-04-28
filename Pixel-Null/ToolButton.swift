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
            button.delegate = {//[weak self] in
                
            }
        case -3: 
            button.setIcon(ic: #imageLiteral(resourceName: "undo_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.resetTransform()
                
                self!.project.unDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
        case -2:
            button.setIcon(ic: #imageLiteral(resourceName: "redo_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.resetTransform()
                
                self!.project.reDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
            
        case -1:
          button.setIcon(ic: #imageLiteral(resourceName: "cancel_icon"))
          button.setIconColor(color: ProjectStyle.uiEnableColor)
          button.delegate = {[weak self] in
            let editor = self!.delegate as! Editor
            editor.canvas.resetTransform()
            
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
               editor.canvas.selectTool(newTool: 2)
            
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
            finish.delegate = {[weak self] in
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
                editor.canvas.selectTool(newTool: 4)
                self!.barDelegate.wasChangedTool(newTool: 4)
                self!.barDelegate.updateButtons(btns: [])
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
                
                let put = CircleButton(icon: #imageLiteral(resourceName: "clone_icon"), frame: .zero)
                //put.setIconColor(color: ProjectStyle.uiRedColor)
                put.widthAnchor.constraint(equalToConstant: 36).isActive = true
                put.heightAnchor.constraint(equalToConstant: 36).isActive = true
                put.setShadowColor(color: .clear)
               
                put.delegate = {[weak self] in
                    editor.canvas.selectTool(newTool: 2)
                    self!.barDelegate.wasChangedTool(newTool: 2)
                }
                
                self!.barDelegate.updateButtons(btns: [reverse,clear,delete,put])
                
                self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
            }
            
        case 7:
            button.setIcon(ic: #imageLiteral(resourceName: "sharp_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.selectTool(newTool: 7)
                self!.barDelegate.wasChangedTool(newTool: 7)
                self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
                
                let rect = CircleButton(icon: #imageLiteral(resourceName: "rectangle_icon"), frame: .zero)
                rect.widthAnchor.constraint(equalToConstant: 36).isActive = true
                rect.heightAnchor.constraint(equalToConstant: 36).isActive = true
                rect.setShadowColor(color: .clear)
                
                let oval = CircleButton(icon: #imageLiteral(resourceName: "circle_icon"), frame: .zero)
                oval.widthAnchor.constraint(equalToConstant: 36).isActive = true
                oval.heightAnchor.constraint(equalToConstant: 36).isActive = true
                oval.setShadowColor(color: .clear)
                
                let line = CircleButton(icon: #imageLiteral(resourceName: "line_icon"), frame: .zero)
                line.widthAnchor.constraint(equalToConstant: 36).isActive = true
                line.heightAnchor.constraint(equalToConstant: 36).isActive = true
                line.setShadowColor(color: .clear)
                
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
                    rect.setIconColor(color: ProjectStyle.uiSelectColor)
                case .oval:
                    oval.setIconColor(color: ProjectStyle.uiSelectColor)
                case .line:
                    line.setIconColor(color: ProjectStyle.uiSelectColor)
                }
                
                line.delegate = {
                    line.setIconColor(color: ProjectStyle.uiSelectColor)
                    rect.setIconColor(color: ProjectStyle.uiEnableColor)
                    oval.setIconColor(color: ProjectStyle.uiEnableColor)

                    editor.canvas.square.squareType = .line
                }
                oval.delegate = {
                    line.setIconColor(color: ProjectStyle.uiEnableColor)
                    rect.setIconColor(color: ProjectStyle.uiEnableColor)
                    oval.setIconColor(color: ProjectStyle.uiSelectColor)
                    
                    editor.canvas.square.squareType = .oval
                }
                rect.delegate = {
                    line.setIconColor(color: ProjectStyle.uiEnableColor)
                    rect.setIconColor(color: ProjectStyle.uiSelectColor)
                    oval.setIconColor(color: ProjectStyle.uiEnableColor)
                    
                    editor.canvas.square.squareType = .rectangle
                }

                self!.barDelegate.updateButtons(btns: [rect,oval,line,block])
            }
            
            button.longPressDelegate = {[weak self] in
                  let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                                            impactFeedbackgenerator.prepare()
                                            impactFeedbackgenerator.impactOccurred()
                  //(self!.delegate as! ToolSettingsDelegate).openGradientSettings()
              }
        case 8:
            button.setIcon(ic: #imageLiteral(resourceName: "picker_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
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
