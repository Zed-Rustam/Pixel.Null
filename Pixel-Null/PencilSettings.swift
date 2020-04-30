//
//  PencilSettings.swift
//  new Testing
//
//  Created by Рустам Хахук on 29.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PencilSettings : UIViewController {
    
    lazy private var exitBtn : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "cancel_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.delegate = {[weak self] in
            self!.dismiss(animated: true, completion: nil)
        }
        return btn
    }()
    lazy private var appendBtn : CircleButton = {
       let btn = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame:.zero)
        btn.setShadowColor(color: .clear)
        btn.delegate = {[weak self] in
            self!.delegate?.setPenSettings(penSize: Int(self!.penSizeInput.filed.text ?? "1")!, pixPerfect: self!.pixelPerfectToggle.isCheck)
            self!.dismiss(animated: true, completion: nil)
        }
        return btn
    }()
        
    lazy private var penSizeSlider : SliderView = {
        let slider = SliderView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        slider.orientation = .horizontal
        slider.delegate = {[weak self] in
            self!.penSizeInput.filed.text = "\(Int($0 * 63 + 1))"
            self!.startInfo.penSize = Int($0 * 63 + 1)
        }
        return slider
    }()
    
    lazy private var penSizeInput : TextField = {
        let input = TextField()
        input.small = true
        input.translatesAutoresizingMaskIntoConstraints = true
        input.filed.text = "1"
        input.setHelpText(help: "1")
        input.filed.delegate = penSizeInputDelegate
        input.filed.textAlignment = .center
        input.filed.keyboardType = .numberPad
        
        input.heightAnchor.constraint(equalToConstant: 36).isActive = true
        input.widthAnchor.constraint(equalToConstant: 54).isActive = true
        return input
    }()
    
    lazy private var penSizeInputDelegate : TextFieldDelegate = {
        let delegate = TextFieldDelegate{[weak self] in
            let num = Int($0.text!) ?? 0
            if num > 64 {
                $0.text = "64"
                self!.startInfo.penSize = 64
                self!.penSizeSlider.setPosition(pos: 1)
            } else if num < 1 {
                $0.text = ""
                self!.startInfo.penSize = 1
                self!.penSizeSlider.setPosition(pos: 0)
            } else {
                self!.penSizeSlider.setPosition(pos: CGFloat(num - 1) / 63)
                self!.startInfo.penSize = num
            }
        }
        return delegate
    }()
    
    private var penSizeTitle : UILabel = {
        let text = UILabel()
        text.text = "Pen Width"
        text.textAlignment = .left
        text.font = UIFont(name:  "Rubik-Medium", size: 24)
        text.textColor = ProjectStyle.uiEnableColor
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return text
    }()
    
    private var penSmoothTitle : UILabel = {
        let text = UILabel()
        text.text = "Pen Smoothing"
        text.textAlignment = .left
        text.font = UIFont(name:  "Rubik-Medium", size: 24)
        text.textColor = ProjectStyle.uiEnableColor
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return text
    }()

    private var pixelPerfectTitle : UILabel = {
        let text = UILabel()
        text.text = "Pixel Perfect"
        text.textAlignment = .left
        text.font = UIFont(name:  "Rubik-Medium", size: 24)
        text.textColor = ProjectStyle.uiEnableColor
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
        
        stack.addArrangedSubview(penSizeInput)
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
        stack.setCustomSpacing(0, after: penSizeStack)
        stack.addArrangedSubview(pixelPerfectStack)
        stack.setCustomSpacing(12, after: pixelPerfectStack)

        return stack
    }()
    
    lazy private var pixelPerfectToggle : ToggleView = {
        let toggle = ToggleView()
        toggle.delegate = {[weak self] in
            self!.startInfo.pixelPerfect = $0
        }
        return toggle
    }()
    
    private var penTitle : UILabel = {
        let title = UILabel()
        title.text = "Pencil"
        title.textAlignment = .center
        title.font = UIFont(name:  "Rubik-Bold", size: 24)
        title.textColor = ProjectStyle.uiEnableColor
        
        return title
    }()
    private var topBarBg : UIView = {
        let view = UIView()
        view.backgroundColor = ProjectStyle.uiBackgroundColor
        view.setCorners(corners: 12)
        return view
    }()
    private var bgView : UIView = {
        let view = UIView()
        view.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
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
        topBarBg.addSubview(penTitle)
        topBarBg.addSubview(exitBtn)
        topBarBg.addSubview(appendBtn)
        bgView.addSubview(topBarBg)
        
        scrollView.addSubview(colorsView)
        view.backgroundColor = ProjectStyle.uiBackgroundColor
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        bgView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        bgView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        bgView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        topBarBg.translatesAutoresizingMaskIntoConstraints = false
        topBarBg.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 0).isActive = true
        topBarBg.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: 0).isActive = true
        topBarBg.heightAnchor.constraint(equalToConstant: 48).isActive = true


        penTitle.translatesAutoresizingMaskIntoConstraints = false
        penTitle.leftAnchor.constraint(equalTo: topBarBg.leftAnchor, constant: 48).isActive = true
        penTitle.rightAnchor.constraint(equalTo: topBarBg.rightAnchor, constant: -48).isActive = true
        penTitle.heightAnchor.constraint(equalTo: topBarBg.heightAnchor).isActive = true
        
        exitBtn.translatesAutoresizingMaskIntoConstraints = false
        exitBtn.leftAnchor.constraint(equalTo: topBarBg.leftAnchor, constant: 6).isActive = true
        exitBtn.topAnchor.constraint(equalTo: topBarBg.topAnchor, constant: 6).isActive = true
        exitBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        exitBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        appendBtn.translatesAutoresizingMaskIntoConstraints = false
        appendBtn.rightAnchor.constraint(equalTo: topBarBg.rightAnchor, constant: -6).isActive = true
        appendBtn.topAnchor.constraint(equalTo: topBarBg.topAnchor, constant: 6).isActive = true
        appendBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        appendBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        colorsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        colorsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24).isActive = true
        colorsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 44).isActive = true
        
        scrollView.contentSize = CGSize(width: 100, height: colorsView.frame.height + 44)

    }
    
    override func viewDidLayoutSubviews() {

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        penSizeSlider.setPosition(pos: CGFloat(startInfo.penSize - 1) / 63)
        penSizeInput.filed.text = "\(startInfo.penSize)"
        pixelPerfectToggle.isCheck = startInfo.pixelPerfect
    }
}
