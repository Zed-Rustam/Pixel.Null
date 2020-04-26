//
//  PalleteCreateController.swift
//  new Testing
//
//  Created by Рустам Хахук on 20.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalleteCreateController : UIViewController {
    lazy private var colors : GridCollection = {
        let clrs = GridCollection(frame: .zero, pallete: pallete)
        clrs.addViewInTop(view: name)
        clrs.translatesAutoresizingMaskIntoConstraints = false
        
        return clrs
    }()
    lazy private var name : TextField = {
        let text = TextField(frame: .zero)
        text.filed.text = pallete.palleteName
        text.filed.delegate = nameDelegate
        text.setHelpText(help: "Pallete Name")
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return text
    }()
    lazy private var createButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero)
        btn.delegate = {[weak self] in
            self!.pallete.save()
            self!.pallete.rename(newName : self!.name.filed.text!)
            self!.delegate?.palleteAdded(newPallete : self!.pallete)
            self!.dismiss(animated: true, completion: nil)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return btn
    }()
    lazy private var cancelButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "cancel_icon"), frame: .zero)
        btn.delegate = {[weak self] in
            self!.pallete.delete()
            self!.dismiss(animated: true, completion: nil)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return btn
    }()
    
    private var pallete : PalleteWorker!
    private var nameDelegate : TextFieldDelegate!
    
    weak var delegate : PalleteGalleryDelegate? = nil
    
    private func getPalleteName() -> String{
        for i in 0... {
            if !getProjects().contains("New Pallete \(i)") { return "New Pallete \(i)" }
        }
        return ""
    }
    
    private func getProjects() -> [String] {
        do{
            let projs = try FileManager.default.contentsOfDirectory(at: PalleteWorker.getDocumentsDirectory(), includingPropertiesForKeys: nil)
                   
                   var names : [String] = []
                   
                   for i in 0..<projs.count  {
                       var name = projs[i].lastPathComponent
                        name.removeLast(8)
                       names.append(name)
                   }
                   
                    print(names)
                    return names
        } catch {
            return []
        }
    }
    
    override func viewDidLoad() {
        pallete = PalleteWorker(name: getPalleteName(), colors: ["#00000000"])
        
        nameDelegate = TextFieldDelegate(method: {[weak self] in
            if $0.text == "" {
                self!.createButton.isEnabled = false
                self!.name.error = nil
            } else if self!.getProjects().contains($0.text!) && $0.text! != self!.pallete.palleteName {
                self!.name.error = "A pallete with this name already exists"
                self!.createButton.isEnabled = false
            } else {
                self!.name.error = nil
                self!.createButton.isEnabled = true
            }
        })
        
        self.view.backgroundColor = ProjectStyle.uiBackgroundColor
        
        self.view.addSubview(colors)
        self.view.addSubview(createButton)
        self.view.addSubview(cancelButton)

        colors.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        colors.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        colors.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        colors.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        createButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        createButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14).isActive = true
        
        cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 14).isActive = true

        name.leftAnchor.constraint(equalTo: cancelButton.rightAnchor, constant: 8).isActive = true
        name.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -8).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true

        
        self.view.isUserInteractionEnabled = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}
