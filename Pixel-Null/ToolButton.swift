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
                editor.canvas.selectedTool = -5
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
                self!.project.unDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
        case -2:
            button.setIcon(ic: #imageLiteral(resourceName: "redo_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                self!.project.reDo(delegate: self!.delegate)
                self!.barDelegate.UnDoReDoAction()
            }
            
        case -1:
          button.setIcon(ic: #imageLiteral(resourceName: "cancel_icon"))
          button.setIconColor(color: ProjectStyle.uiEnableColor)
          button.delegate = {[weak self] in
              self!.project.save()
              self!.project.savePreview(frame: self!.project.FrameSelected)
              
              let editor = self!.delegate as! Editor
              editor.gallery?.updateProjectView(proj: self!.project)
              editor.dismiss(animated: true, completion: nil)
          }
        case 0:
            button.setIcon(ic: #imageLiteral(resourceName: "edit_icon"))
            button.setIconColor(color: ProjectStyle.uiEnableColor)
            button.delegate = {[weak self] in
                let editor = self!.delegate as! Editor
                editor.canvas.selectedTool = 0
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
                editor.canvas.selectedTool = 1
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
               editor.canvas.selectedTool = 2
            self!.barDelegate.wasChangedTool(newTool: 2)
            self!.barDelegate.updateButtons(btns: [])
            self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
           }
            
        case 3:
          button.setIcon(ic: #imageLiteral(resourceName: "gradient_icon"))
          button.setIconColor(color: ProjectStyle.uiEnableColor)
          button.delegate = {[weak self] in
              let editor = self!.delegate as! Editor
              editor.canvas.selectedTool = 3
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
                editor.canvas.selectedTool = 4
                self!.barDelegate.wasChangedTool(newTool: 4)
                self!.barDelegate.updateButtons(btns: [])
                self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
            }
            button.longPressDelegate = {//[weak self] in
                  let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                                            impactFeedbackgenerator.prepare()
                                            impactFeedbackgenerator.impactOccurred()
                 // (self!.delegate as! ToolSettingsDelegate).openGradientSettings()
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
                editor.canvas.selectedTool = 6
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
               
                put.delegate = {
                    editor.canvas.selectedTool = 2
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
                editor.canvas.selectedTool = 7
              self!.barDelegate.wasChangedTool(newTool: 7)
              self!.barDelegate.updateButtons(btns: [])
              self!.button.setIconColor(color: ProjectStyle.uiSelectColor)
            }
            button.longPressDelegate = {[weak self] in
                  let impactFeedbackgenerator = UIImpactFeedbackGenerator (style: .heavy)
                                            impactFeedbackgenerator.prepare()
                                            impactFeedbackgenerator.impactOccurred()
                  //(self!.delegate as! ToolSettingsDelegate).openGradientSettings()
              }
            
        default:
            break
        }
    }
}
