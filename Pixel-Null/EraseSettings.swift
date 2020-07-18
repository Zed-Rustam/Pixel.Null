//
//  EraseSettings.swift
//  new Testing
//
//  Created by Рустам Хахук on 03.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class EraseSettings : UIViewController {
    
    lazy private var eraseSizeField : UITextField = {
        let field = UITextField()
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.textColor = getAppColor(color: .enable)
        field.setCorners(corners: 12)
        field.delegate = eraseSizeInputDelegate
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.font = UIFont(name: "Rubik-Medium", size: 20)

        field.attributedPlaceholder = NSAttributedString(string: "1",attributes: [NSAttributedString.Key.foregroundColor: getAppColor(color: .disable)])

        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        field.widthAnchor.constraint(equalToConstant: 72).isActive = true
        return field
    }()
    
    lazy private var eraseSizeSlider : SliderView = {
        let slider = SliderView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        slider.orientation = .horizontal
        slider.delegate = {[unowned self] in
            self.eraseSizeField.text = "\(Int($0 * 63 + 1))"
            self.size = Int($0 * 63 + 1)
            self.delegate?.setEraseSettings(eraseSize : Int(self.eraseSizeField.text ?? "1")!)
        }
        return slider
    }()
    
    lazy private var eraseSizeStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12
        
        stack.addArrangedSubview(eraseSizeField)
        stack.addArrangedSubview(eraseSizeSlider)
        return stack
    }()
    
    lazy private var eraseSizeInputDelegate : TextFieldDelegate = {
        let delegate = TextFieldDelegate{[unowned self] in
            let num = Int($0.text!) ?? 0
            if num > 64 {
                $0.text = "64"
                self.size = 65
                self.eraseSizeSlider.setPosition(pos: 1)
            } else if num < 1 {
                $0.text = ""
                self.size = 1
                self.eraseSizeSlider.setPosition(pos: 0)
            } else {
                self.eraseSizeSlider.setPosition(pos: CGFloat(num - 1) / 63)
                self.size = num
            }
            
            self.delegate?.setEraseSettings(eraseSize : Int($0.text == "" ? "1" : $0.text!)!)
        }
        return delegate
    }()
    
    private var eraseSizeTitle : UILabel = {
        let text = UILabel()
        text.text = NSLocalizedString("Width", comment: "")
        text.textAlignment = .left
        text.font = UIFont(name:  "Rubik-Medium", size: 24)
        text.textColor = UIColor(named: "enableColor")
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return text
    }()

    lazy private var colorsView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        //stack.spacing = 12
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(eraseSizeTitle)
        stack.setCustomSpacing(0, after: eraseSizeTitle)
        stack.addArrangedSubview(eraseSizeStack)
        
        return stack
    }()

    private var eraseTitle : UILabel = {
           let title = UILabel()
           title.text = NSLocalizedString("Eraser", comment: "")
           title.textAlignment = .center
           title.font = UIFont(name:  "Rubik-Bold", size: 32)
           title.textColor = UIColor(named: "enableColor")
           
           return title
       }()
    
       private var topBarBg : UIView = {
           let view = UIView()
           view.backgroundColor = UIColor(named: "backgroundColor")
           view.setCorners(corners: 12)
           return view
       }()
    
    weak var delegate : ToolSettingsDelegate? = nil

    private var scrollView = UIScrollView()
    
    private var size : Int = 1
    
    func setSettings(eraseSize : Int) {
        size = eraseSize
    }
    
    private var bgView : UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        view.setCorners(corners: 32)
        
        view.addSubview(scrollView)
        view.addSubview(bgView)
        view.addSubview(eraseTitle)
        //topBarBg.addSubview(exitBtn)
        //topBarBg.addSubview(appendBtn)
        
        scrollView.addSubview(colorsView)
        //scrollView.addSubview(vStack)
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: eraseTitle.bottomAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        bgView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        bgView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        bgView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        eraseTitle.translatesAutoresizingMaskIntoConstraints = false
        eraseTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        eraseTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        
        colorsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        colorsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48).isActive = true
        colorsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        
        scrollView.contentSize = CGSize(width: 100, height: colorsView.frame.height + 44)

    }
 
    
    override func viewDidLayoutSubviews() {
        bgView.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        eraseSizeSlider.setPosition(pos: CGFloat(size - 1) / 63)
        eraseSizeField.text = "\(size)"
    }
}
