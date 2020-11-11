//
//  CreateDialogNew.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 25.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class CreateDialogNew : UIViewController, UIPopoverPresentationControllerDelegate {
    
    weak var delegate : GalleryProjectDelegate? = nil

    lazy private var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New project"
        label.textColor = getAppColor(color: .enable)
        label.textAlignment = .left
        label.font = UIFont(name: UIFont.appBlack, size: 42)
        return label
    }()
    
    lazy private var nameField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.setCorners(corners: 12,curveType: .continuous)
        field.font = UIFont(name: UIFont.appBold, size: 20)
        field.textAlignment = .center
        field.textColor = getAppColor(color: .disable)
        field.text = getDefaultName()
        field.leftViewMode = .always
        
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        
        let titlelbl = UILabel()
        titlelbl.text = "Name"
        titlelbl.font = UIFont(name: UIFont.appBold, size: 20)
        titlelbl.textColor = getAppColor(color: .enable)
        titlelbl.translatesAutoresizingMaskIntoConstraints = false
        
        mainview.addSubviewFullSize(view: titlelbl, paddings: (12,-12,0,0))
        
        field.leftView = mainview
        
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        field.delegate = self
        return field
    }()
    
    lazy private var widthField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        field.background = nil
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.setCorners(corners: 12,curveType: .continuous)
        field.font = UIFont(name: UIFont.appBold, size: 20)
        field.textAlignment = .center
        field.textColor = getAppColor(color: .disable)
        field.text = "64"

        field.attributedPlaceholder = NSAttributedString(string: "Width",attributes: [NSAttributedString.Key.foregroundColor: getAppColor(color: .disable)])
        field.keyboardType = .numberPad
        field.leftViewMode = .always
        
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        
        let titlelbl = UILabel()
        titlelbl.text = "Width"
        titlelbl.font = UIFont(name: UIFont.appBold, size: 20)
        titlelbl.textColor = getAppColor(color: .enable)
        titlelbl.translatesAutoresizingMaskIntoConstraints = false
        mainview.addSubviewFullSize(view: titlelbl, paddings: (12,-12,0,0))

        field.leftView = mainview
        
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))

        field.delegate = self
        return field
    }()
    
    lazy private var heightField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        field.font = UIFont(name: UIFont.appBold, size: 20)
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.setCorners(corners: 12,curveType: .continuous)
        field.textAlignment = .center
        field.textColor = getAppColor(color: .disable)
        field.text = "64"
        field.attributedPlaceholder = NSAttributedString(string: "Height",attributes: [NSAttributedString.Key.foregroundColor: getAppColor(color: .disable)])
        field.keyboardType = .numberPad
        field.leftViewMode = .always
        
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        
        let titlelbl = UILabel()
        titlelbl.text = "Height"
        titlelbl.font = UIFont(name: UIFont.appBold, size: 20)
        titlelbl.textColor = getAppColor(color: .enable)
        titlelbl.translatesAutoresizingMaskIntoConstraints = false
        mainview.addSubviewFullSize(view: titlelbl, paddings: (12,-12,0,0))
        
        field.leftView = mainview
        
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))

        field.delegate = self
        return field
    }()
    
    lazy private var backgroundColor : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        field.background = nil
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.setCorners(corners: 12,curveType: .continuous)
        field.font = UIFont(name: UIFont.appBold, size: 20)
        field.textAlignment = .left
        field.textColor = getAppColor(color: .enable)
        field.attributedPlaceholder = NSAttributedString(string: "Background",attributes: [NSAttributedString.Key.foregroundColor: getAppColor(color: .enable)])
        field.isEnabled = false
        field.keyboardType = .numberPad
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 36))
        
        field.isUserInteractionEnabled = true
               
        return field
    }()
    
    lazy private var colorSelector: ColorSelector = {
        let clr = ColorSelector(frame: .zero)
        clr.translatesAutoresizingMaskIntoConstraints = false
        clr.widthAnchor.constraint(equalToConstant: 36).isActive = true
        clr.heightAnchor.constraint(equalToConstant: 36).isActive = true
        clr.color = .clear
        
        clr.delegate = {
            let colorSelectorMenu = ColorDialogController()
            
            colorSelectorMenu.delegate = {color in
                clr.color = color
            }
            
            colorSelectorMenu.setStartColor(clr: clr.color)
            
            switch UIDevice.current.userInterfaceIdiom {
                //если айфон, то просто показываем контроллер
            case .phone:
                colorSelectorMenu.modalPresentationStyle = .pageSheet
                //если айпад то немного химичим
            case .pad:
                colorSelectorMenu.modalPresentationStyle = .currentContext

            default:
                break
            }
            
            self.present(colorSelectorMenu, animated: true, completion: nil)
        }
        
        clr.isUserInteractionEnabled = true
        return clr
    }()
    
    lazy private var errorText : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        lbl.textColor = getAppColor(color: .red)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private var createBtn : UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 128).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        btn.setTitle("Create", for: .normal)

        btn.setTitleColor(getAppColor(color: .background), for: .normal)
        btn.setTitleColor(getAppColor(color: .disable), for: .disabled)
        
        btn.backgroundColor = getAppColor(color: .enable)
        btn.titleLabel?.font = UIFont(name: UIFont.appBlack, size: 20)
        
        btn.setBackgroundImage(UIImage(size: CGSize(width: 8, height: 8), bgColor: getAppColor(color: .enable)), for: .normal)
        btn.setBackgroundImage(UIImage(size: CGSize(width: 8, height: 8), bgColor: getAppColor(color: .backgroundLight)), for: .disabled)
        
        btn.setCorners(corners: 12,needMask: true, curveType: .continuous)

        return btn
    }()
    
    lazy private var tap: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer(target: self, action: #selector(onTap))
        let touch = UITouch()
        return gest
    }()
    
    @objc func onTap() {

        view.endEditing(true)
        //setEditing(false, animated: true)
        print("falsing")
    }
    
    @objc func create() {
        let project = ProjectWork(ProjectName: nameField.text! + ".pnart", ProjectSize: CGSize(width: Int(widthField.text!)!, height: Int(heightField.text!)!), bgColor: colorSelector.color)
        project.save()
        delegate?.projectAdded(name: nameField.text! + ".pnart")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getDefaultName() -> String {
        for i in 0... {
            if !getProjects().contains("\(NSLocalizedString("New project", comment: "")) \(i).pnart") { return "\(NSLocalizedString("New project", comment: "")) \(i)" }
        }
        return ""
    }
    
    override func viewDidLoad() {
        
        navigationItem.title = "New Project"
        
        view.backgroundColor = getAppColor(color: .background)
        view.setCorners(corners: 24)
        
        view.addSubview(titleLabel)
        view.addSubview(nameField)
        view.addSubview(widthField)
        view.addSubview(heightField)
        view.addSubview(backgroundColor)
        view.addSubview(colorSelector)
        view.addSubview(createBtn)
        view.addSubview(errorText)

        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        
        nameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
        
        widthField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        widthField.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -8).isActive = true
        widthField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 12).isActive = true
        
        heightField.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 8).isActive = true
        heightField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        heightField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 12).isActive = true
        
        backgroundColor.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        backgroundColor.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        backgroundColor.topAnchor.constraint(equalTo: heightField.bottomAnchor, constant: 12).isActive = true
        
        colorSelector.rightAnchor.constraint(equalTo: backgroundColor.rightAnchor).isActive = true
        colorSelector.topAnchor.constraint(equalTo: backgroundColor.topAnchor).isActive = true
        
        createBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        createBtn.topAnchor.constraint(equalTo: backgroundColor.bottomAnchor, constant: 16).isActive = true

        createBtn.addTarget(self, action: #selector(create), for: .touchUpInside)
        
        errorText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        errorText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        errorText.topAnchor.constraint(equalTo: backgroundColor.bottomAnchor, constant: 16).isActive = true
    }
}

extension CreateDialogNew : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.isEqual(nameField) {
            if(self.getProjects().contains("\(textField.text!).pnart")) {
                errorText.text = NSLocalizedString("Project exist error", comment: "")
            } else{
                errorText.text = ""
            }
            
            self.checkCreateButton()
        } else if textField.isEqual(widthField) {
            let width = Int(textField.text!) ?? -1
            
            if(width > 512) {
                textField.text = "512"
            } else if(width == -1 && textField.text != ""){
                textField.text = ""
            } else if(width == -1){
                errorText.text = ""
            }else if(width == 0){
                textField.text = ""
            }else{
                errorText.text = ""
            }
            self.checkCreateButton()
        } else if textField.isEqual(heightField) {
            let height = Int(textField.text!) ?? -1
            if(height > 512) {
                textField.text = "512"
            } else if(height == -1 && textField.text != ""){
                textField.text = ""
            } else if(height == -1){
                errorText.text = ""
            }else if(height == 0){
                textField.text = ""
            }else{
                errorText.text = ""
            }
            self.checkCreateButton()
        }
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
    
    func checkCreateButton(){
        if nameField.text != "" && widthField.text != "" && heightField.text != "" && errorText.text == "" {
            createBtn.isEnabled = true
        } else {
            createBtn.isEnabled = false
        }
    }
}
