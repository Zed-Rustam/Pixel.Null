//
//  CreateDIalogController.swift
//  new Testing
//
//  Created by Рустам Хахук on 19.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class CreateDialogController : UIViewController, CreateDialogDelegate{

    weak var delegate : GalleryProjectDelegate? = nil
    
    lazy private var createDialog : CreateDialog = {
        let dialog = CreateDialog(frame: .zero)
        dialog.delegate = self
        dialog.translatesAutoresizingMaskIntoConstraints = false
        
        dialog.backgroundSelector.delegate = {[weak self] in
            let colorDialog = ColorSelectorController()
            colorDialog.delegate = {res in
                print("color Change")
                self!.createDialog.backgroundSelector.color = res
            }
            colorDialog.setColor(clr : self!.createDialog.backgroundSelector.color)

            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                colorDialog.modalPresentationStyle = .pageSheet
                self!.show(colorDialog, sender: self!)
            case .pad:
                colorDialog.modalPresentationStyle = .popover
                
                if let popover = colorDialog.popoverPresentationController {
                    popover.sourceView = dialog.backgroundSelector
                    popover.permittedArrowDirections = [.up,.right]
                }
                self!.present(colorDialog, animated: true, completion: nil)

            default:
                break
            }
            
        }
        
        return dialog
    }()
        
    var proj : ProjectWork!
    
    func onCreate(name: String, width: Int, height: Int, bgColor: UIColor) {
        let project = ProjectWork(ProjectName : name + ".pnart", ProjectSize: CGSize(width: width, height: height), bgColor: bgColor)
        project.save()
        delegate?.projectAdded(name: name + ".pnart")
        
        self.dismiss(animated: true)
    }
    
    func onCancel() {
        self.dismiss(animated: true)
    }
    
    func setDefault(){
        createDialog.setDefault()
    }
    
    override func viewDidLoad() {
        createDialog.setDefault()
        self.view.addSubview(createDialog)
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")

    }
    
    override func viewDidLayoutSubviews() {
        createDialog.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        createDialog.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        createDialog.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        createDialog.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}
