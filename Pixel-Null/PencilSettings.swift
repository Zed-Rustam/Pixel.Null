//
//  PencilSettings.swift
//  new Testing
//
//  Created by Рустам Хахук on 29.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PencilSettings : UIViewController {
        
    lazy private var penSizeSlider : SliderView = {
        let slider = SliderView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        slider.orientation = .horizontal
        slider.delegate = {[unowned self] in
            self.penSizeField.text = "\(Int($0 * 63 + 1))"
            self.startInfo.penSize = Int($0 * 63 + 1)
            self.delegate?.setPenSettings(penSize: Int(self.penSizeField.text ?? "1")!, pixPerfect: self.pixelPerfectToggle.isCheck)
        }
        return slider
    }()
    
    lazy private var penSizeField : UITextField = {
        let field = UITextField()
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.textColor = getAppColor(color: .enable)
        field.setCorners(corners: 8)
        field.delegate = penSizeInputDelegate
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.font = UIFont(name: "Rubik-Medium", size: 20)

        field.attributedPlaceholder = NSAttributedString(string: "1",attributes: [NSAttributedString.Key.foregroundColor: getAppColor(color: .disable)])

        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        field.widthAnchor.constraint(equalToConstant: 72).isActive = true
        return field
    }()
    
    lazy private var penSizeInputDelegate : TextFieldDelegate = {
        let delegate = TextFieldDelegate{[unowned self] in
            let num = Int($0.text!) ?? 0
            
            if num > 64 {
                $0.text = "64"
                self.startInfo.penSize = 64
                self.penSizeSlider.setPosition(pos: 1)
            } else if num < 1 {
                $0.text = ""
                self.startInfo.penSize = 1
                self.penSizeSlider.setPosition(pos: 0)
            } else {
                self.penSizeSlider.setPosition(pos: CGFloat(num - 1) / 63)
                self.startInfo.penSize = num
            }
            
            self.delegate?.setPenSettings(penSize: num, pixPerfect: self.pixelPerfectToggle.isCheck)

        }
        return delegate
    }()
    
    private var penSizeTitle : UILabel = {
        let text = UILabel()
        text.text = NSLocalizedString("Width", comment: "")
        text.textAlignment = .left
        text.font = UIFont(name:  "Rubik-Medium", size: 24)
        text.textColor = UIColor(named: "enableColor")
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return text
    }()

    private var pixelPerfectTitle : UILabel = {
        let text = UILabel()
        text.text = "Pixel Perfect"
        text.textAlignment = .left
        text.font = UIFont(name:  "Rubik-Medium", size: 24)
        text.textColor = UIColor(named: "enableColor")
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return text
    }()

    lazy private var penSizeStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12
        
        stack.addArrangedSubview(penSizeField)
        stack.addArrangedSubview(penSizeSlider)
        return stack
    }()
    
    lazy private var pixelPerfectStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12
        
        stack.addArrangedSubview(pixelPerfectTitle)
        stack.addArrangedSubview(pixelPerfectToggle)
        return stack
    }()
    
    lazy private var colorsView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(penSizeTitle)
        stack.setCustomSpacing(0, after: penSizeTitle)
        stack.addArrangedSubview(penSizeStack)
        stack.setCustomSpacing(12, after: penSizeStack)
        stack.addArrangedSubview(pixelPerfectStack)
        stack.setCustomSpacing(12, after: pixelPerfectStack)

        return stack
    }()
    
    lazy private var pixelPerfectToggle : ToggleView = {
        let toggle = ToggleView()
        toggle.delegate = {[unowned self] in
            self.startInfo.pixelPerfect = $0
            self.delegate?.setPenSettings(penSize: Int(self.penSizeField.text!)!, pixPerfect: self.pixelPerfectToggle.isCheck)
        }
        return toggle
    }()
    
    private var penTitle : UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("Pencil", comment: "")
        title.textAlignment = .center
        title.font = UIFont(name:  "Rubik-Bold", size: 32)
        title.textColor = UIColor(named: "enableColor")
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return title
    }()
    
    private var bgView : UIView = {
        let view = UIView()
        return view
    }()
    
    private var scrollView = UIScrollView()
    
    weak var delegate : ToolSettingsDelegate? = nil
    
    var startInfo : (penSize : Int, pixelPerfect : Bool) = (1,false)
    
    func setSettings(penSize : Int, pixelPerfect : Bool) {
        startInfo = (penSize, pixelPerfect)
    }
    
    override func viewDidLoad() {
        view.addSubview(scrollView)
        view.addSubview(bgView)
        
        view.addSubview(penTitle)
        
        view.setCorners(corners: 32)
        //topBarBg.addSubview(exitBtn)
        //topBarBg.addSubview(appendBtn)
        //bgView.addSubview(topBarBg)
        
        scrollView.addSubview(colorsView)
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: penTitle.bottomAnchor, constant: 12).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        bgView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        bgView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        bgView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //topBarBg.translatesAutoresizingMaskIntoConstraints = false
        //topBarBg.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 0).isActive = true
        //topBarBg.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: 0).isActive = true
        //topBarBg.heightAnchor.constraint(equalToConstant: 48).isActive = true


        penTitle.translatesAutoresizingMaskIntoConstraints = false
        penTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        penTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
//        exitBtn.translatesAutoresizingMaskIntoConstraints = false
//        exitBtn.leftAnchor.constraint(equalTo: topBarBg.leftAnchor, constant: 6).isActive = true
//        exitBtn.topAnchor.constraint(equalTo: topBarBg.topAnchor, constant: 6).isActive = true
//        exitBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
//        exitBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
//
//        appendBtn.translatesAutoresizingMaskIntoConstraints = false
//        appendBtn.rightAnchor.constraint(equalTo: topBarBg.rightAnchor, constant: -6).isActive = true
//        appendBtn.topAnchor.constraint(equalTo: topBarBg.topAnchor, constant: 6).isActive = true
//        appendBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
//        appendBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
//
        colorsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        colorsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48).isActive = true
        colorsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        
        scrollView.contentSize = CGSize(width: 100, height: colorsView.frame.height + 44)

    }
    
    override func viewDidLayoutSubviews() {
        bgView.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        penSizeSlider.setPosition(pos: CGFloat(startInfo.penSize - 1) / 63)
        penSizeField.text = "\(startInfo.penSize)"
        pixelPerfectToggle.isCheck = startInfo.pixelPerfect
    }
}
