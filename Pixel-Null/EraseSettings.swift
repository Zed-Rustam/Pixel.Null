//
//  EraseSettings.swift
//  new Testing
//
//  Created by Рустам Хахук on 03.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class EraseSettings : UIViewController {
    
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
            self!.delegate?.setEraseSettings(eraseSize : Int(self!.eraseSizeInput.filed.text ?? "1")!)
            self!.dismiss(animated: true, completion: nil)
        }
        return btn
    }()
    
    lazy private var eraseSizeInput : TextField = {
        let input = TextField()
        input.small = true
        input.translatesAutoresizingMaskIntoConstraints = true
        input.filed.text = "1"
        input.setHelpText(help: "1")
        input.filed.delegate = eraseSizeInputDelegate
        input.filed.textAlignment = .center
        input.filed.keyboardType = .numberPad
        
        input.heightAnchor.constraint(equalToConstant: 36).isActive = true
        input.widthAnchor.constraint(equalToConstant: 54).isActive = true
        return input
    }()
    
    lazy private var eraseSizeSlider : SliderView = {
        let slider = SliderView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        slider.orientation = .horizontal
        slider.delegate = {[weak self] in
            self!.eraseSizeInput.filed.text = "\(Int($0 * 63 + 1))"
            self!.size = Int($0 * 63 + 1)
        }
        return slider
    }()
    
    lazy private var eraseSizeStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12
        
        stack.addArrangedSubview(eraseSizeInput)
        stack.addArrangedSubview(eraseSizeSlider)
        return stack
    }()
    
    lazy private var eraseSizeInputDelegate : TextFieldDelegate = {
        let delegate = TextFieldDelegate{[weak self] in
            let num = Int($0.text!) ?? 0
            if num > 64 {
                $0.text = "64"
                self!.size = 65
                self!.eraseSizeSlider.setPosition(pos: 1)
            } else if num < 1 {
                $0.text = ""
                self!.size = 1
                self!.eraseSizeSlider.setPosition(pos: 0)
            } else {
                self!.eraseSizeSlider.setPosition(pos: CGFloat(num - 1) / 63)
                self!.size = num
            }
        }
        return delegate
    }()
    
    private var eraseSizeTitle : UILabel = {
        let text = UILabel()
        text.text = NSLocalizedString("Eraser width", comment: "")
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
           title.font = UIFont(name:  "Rubik-Bold", size: 24)
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
        view.addSubview(scrollView)
        view.addSubview(bgView)
        topBarBg.addSubview(eraseTitle)
        topBarBg.addSubview(exitBtn)
        topBarBg.addSubview(appendBtn)
        bgView.addSubview(topBarBg)
        
        scrollView.addSubview(colorsView)
        //scrollView.addSubview(vStack)
        view.backgroundColor = UIColor(named: "backgroundColor")
        
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


        eraseTitle.translatesAutoresizingMaskIntoConstraints = false
        eraseTitle.leftAnchor.constraint(equalTo: topBarBg.leftAnchor, constant: 48).isActive = true
        eraseTitle.rightAnchor.constraint(equalTo: topBarBg.rightAnchor, constant: -48).isActive = true
        eraseTitle.heightAnchor.constraint(equalTo: topBarBg.heightAnchor).isActive = true
        
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
        bgView.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        eraseSizeSlider.setPosition(pos: CGFloat(size - 1) / 63)
        eraseSizeInput.filed.text = "\(size)"
    }
}
