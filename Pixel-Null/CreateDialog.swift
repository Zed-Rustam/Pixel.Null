//
//  CreateDialog.swift
//  new Testing
//
//  Created by Рустам Хахук on 11.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class CreateDialog : UIView{
    private var dialogTitle : UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Rubik-Bold", size: 24)
        title.textColor = UIColor(named: "enableColor")
        title.textAlignment = .center
        title.text = NSLocalizedString("New project", comment: "")
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    weak var delegate : CreateDialogDelegate? = nil
    
    lazy private var projectName : TextField = {
        let field = TextField()
        field.filed.text = getDefaultName()
        field.error = nil
        field.setHelpText(help: NSLocalizedString("Project name", comment: ""))
        field.filed.delegate = namedel
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy private var projectWidth : TextField = {
        let field = TextField()
        field.filed.text = "64"
        field.error = nil
        field.filed.keyboardType = .numberPad
        field.setHelpText(help: NSLocalizedString("Width", comment: ""))
        field.filed.delegate = widthdel
        field.translatesAutoresizingMaskIntoConstraints = false

        return field
    }()
    lazy private var projectHeight : TextField = {
        let field = TextField()
        field.filed.text = "64"
        field.error = nil
        field.filed.keyboardType = .numberPad
        field.setHelpText(help: NSLocalizedString("Height", comment: ""))
        field.filed.delegate = heightdel
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    lazy private var projectBackground : TextField = {
       let field = TextField()
       field.filed.text = NSLocalizedString("Background", comment: "")
       field.setHelpText(help: NSLocalizedString("Background", comment: ""))
       field.filed.isUserInteractionEnabled = false
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    var backgroundSelector : ColorSelector = {
        let color = ColorSelector()
        color.translatesAutoresizingMaskIntoConstraints = false
        
        return color
    }()
    
    lazy private var vStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.spacing = 12

        let sizeStack = UIStackView()
        sizeStack.axis = .horizontal
        sizeStack.translatesAutoresizingMaskIntoConstraints = false
        sizeStack.distribution = .fillEqually
        sizeStack.spacing = 12
        
        sizeStack.addArrangedSubview(projectWidth)
        sizeStack.addArrangedSubview(projectHeight)
        
        stack.addArrangedSubview(projectName)
        stack.addArrangedSubview(sizeStack)
        stack.addArrangedSubview(projectBackground)
        projectBackground.addSubview(backgroundSelector)


        return stack
    }()
    lazy private var namedel : TextFieldDelegate = {
        let delegate = TextFieldDelegate(method: {field in
            if(self.getProjects().contains(field.text!)) {
                self.projectName.error = NSLocalizedString("Project exist error", comment: "")
            } else if (field.text == ""){
                self.projectName.error = nil
            } else {
                self.projectName.error = nil
            }
            self.checkCreateButton()
        })
        return delegate
    }()
    lazy private var widthdel : TextFieldDelegate = {
        let delegate = TextFieldDelegate(method: {field in
           let width = Int(field.text!) ?? -1
           if(width > 1024) {
               field.text = "1024"
           } else if(width == -1 && field.text != ""){
               field.text = ""
           } else if(width == -1){
               self.projectWidth.error = nil
           }else if(width == 0){
               field.text = ""
           }else{
               self.projectWidth.error = nil
           }
           self.checkCreateButton()
       })
        return delegate
    }()
    lazy private var heightdel : TextFieldDelegate = {
        let delegate = TextFieldDelegate(method: {field in
            let height = Int(field.text!) ?? -1
            if(height > 1024) {
                field.text = "1024"
            } else if(height == -1 && field.text != ""){
               field.text = ""
            } else if(height == -1){
                self.projectHeight.error = nil
            }else if(height == 0){
                field.text = ""
            }else{
                self.projectHeight.error = nil
            }
            self.checkCreateButton()
        })
        return delegate
    }()
    
    private var titleBg : UIView = {
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = getAppColor(color: .background)
        
        bg.setCorners(corners: 12)

        let mainBg = UIView()
        
        mainBg.addSubview(bg)
        bg.leftAnchor.constraint(equalTo: mainBg.leftAnchor, constant: 0).isActive = true
        bg.rightAnchor.constraint(equalTo: mainBg.rightAnchor, constant: 0).isActive = true
        bg.topAnchor.constraint(equalTo: mainBg.topAnchor, constant: 0).isActive = true
        bg.bottomAnchor.constraint(equalTo: mainBg.bottomAnchor, constant: 0).isActive = true
                
        mainBg.translatesAutoresizingMaskIntoConstraints = false
        return mainBg
    }()
    lazy private var createButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setShadowColor(color: .clear)
        btn.delegate = {self.delegate?.onCreate(
            name: self.projectName.filed.text!,
            width: Int(self.projectWidth.filed.text!)!,
            height: Int(self.projectHeight.filed.text!)!,
            bgColor: self.backgroundSelector.color
            )}
        return btn
    }()
    
    lazy private var cancelButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "cancel_icon"), frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setShadowColor(color: .clear)
        btn.delegate = {self.delegate?.onCancel()}
        return btn
    }()
        
    func checkCreateButton(){
        if  (projectName.filed.text != "" && projectName.error == nil) &&
            (projectWidth.filed.text != "" && projectWidth.error == nil) &&
            (projectHeight.filed.text != "" && projectHeight.error == nil) {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
    }
    
    func setDefault(){
        projectName.filed.text = getDefaultName()
        projectWidth.filed.text = "64"
        projectHeight.filed.text = "64"
        backgroundSelector.color = .clear
    }
    
    override init(frame : CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: Int(frame.width), height: Int(frame.height)))
        
        checkCreateButton()
    
        addSubview(titleBg)
        titleBg.addSubview(dialogTitle)
        titleBg.addSubview(createButton)
        titleBg.addSubview(cancelButton)
        
        addSubview(vStack)

        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        titleBg.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        titleBg.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        titleBg.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        titleBg.heightAnchor.constraint(equalToConstant: 48).isActive = true

        dialogTitle.topAnchor.constraint(equalTo: titleBg.topAnchor, constant: 6).isActive = true
        dialogTitle.leftAnchor.constraint(equalTo: titleBg.leftAnchor, constant: 48).isActive = true
        dialogTitle.rightAnchor.constraint(equalTo: titleBg.rightAnchor, constant: -48).isActive = true
        dialogTitle.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        createButton.rightAnchor.constraint(equalTo: titleBg.rightAnchor, constant: -6).isActive = true
        createButton.topAnchor.constraint(equalTo: titleBg.topAnchor, constant: 6).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        cancelButton.leftAnchor.constraint(equalTo: titleBg.leftAnchor, constant: 6).isActive = true
        cancelButton.topAnchor.constraint(equalTo: titleBg.topAnchor, constant: 6).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        vStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        vStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        vStack.topAnchor.constraint(equalTo: titleBg.bottomAnchor, constant: 12).isActive = true
        vStack.backgroundColor = .red

        projectName.heightAnchor.constraint(equalToConstant: 48).isActive = true
        projectWidth.heightAnchor.constraint(equalToConstant: 48).isActive = true
        projectHeight.heightAnchor.constraint(equalToConstant: 48).isActive = true
        projectBackground.heightAnchor.constraint(equalToConstant: 48).isActive = true

        backgroundSelector.rightAnchor.constraint(equalTo: projectBackground.rightAnchor, constant: 0).isActive = true
        backgroundSelector.topAnchor.constraint(equalTo: projectBackground.topAnchor, constant: 0).isActive = true
        backgroundSelector.widthAnchor.constraint(equalToConstant: 48).isActive = true
        backgroundSelector.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        titleBg.setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    private func getProjects() -> [String] {
        do{
            let projs = try FileManager.default.contentsOfDirectory(at: ProjectWork.getDocumentsDirectory(), includingPropertiesForKeys: nil)
                   
                   var names : [String] = []
                   
                   for i in 0..<projs.count  {
                       let name = projs[i].lastPathComponent
                       names.append(name)
                   }
                   
                   return names
        } catch {
            return []
        }
    }
    
    private func getDefaultName() -> String {
        for i in 0... {
            if !getProjects().contains("\(NSLocalizedString("New project", comment: "")) \(i)") { return "\(NSLocalizedString("New project", comment: "")) \(i)" }
        }
        return ""
    }
}

protocol CreateDialogDelegate : class{
    func onCreate(name : String,width : Int,height : Int,bgColor : UIColor)
    func onCancel()
}
