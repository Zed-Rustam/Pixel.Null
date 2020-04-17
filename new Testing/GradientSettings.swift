//
//  GradientSettings.swift
//  new Testing
//
//  Created by Рустам Хахук on 05.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GradientSettings : UIViewController {
    
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
            self!.delegate?.setGradientSettings(stepCount: Int(self!.stepCountInput.filed.text ?? "1")!, startColor: self!.startColor.color, endColor: self!.endColor.color)
            self!.dismiss(animated: true, completion: nil)
        }
        return btn
    }()
    
    lazy private var startColor : ColorSelector = {
        let color = ColorSelector()
        color.color = .black
        color.translatesAutoresizingMaskIntoConstraints = false
        color.widthAnchor.constraint(equalToConstant: 48).isActive = true
        color.heightAnchor.constraint(equalToConstant: 48).isActive = true
        color.delegate = {[weak self] in
            let colorPicker = ColorSelectorController()
            colorPicker.setColor(clr: color.color)
            colorPicker.delegate = {res in
                color.color = res
                self!.startInfo.startColor = res
                (self!.gradientPreview.subviews[0] as! UIImageView).image = self!.makeImageGradient()
            }
            self!.show(colorPicker, sender: self!)
        }
        return color
    }()
    
    lazy private var endColor : ColorSelector = {
           let color = ColorSelector()
            color.color = .white

           color.translatesAutoresizingMaskIntoConstraints = false
           color.widthAnchor.constraint(equalToConstant: 48).isActive = true
           color.heightAnchor.constraint(equalToConstant: 48).isActive = true
           color.delegate = {[weak self] in
               let colorPicker = ColorSelectorController()
               colorPicker.setColor(clr: color.color)
               colorPicker.delegate = {res in
                    color.color = res
                    self!.startInfo.endColor = res
                    (self!.gradientPreview.subviews[0] as! UIImageView).image = self!.makeImageGradient()
               }
               self!.show(colorPicker, sender: self!)
           }
           return color
       }()
        
    lazy private var stepCountSlider : SliderView = {
        let slider = SliderView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        slider.orientation = .horizontal
        slider.delegate = {[weak self] in
            self!.stepCountInput.filed.text = "\(Int($0 * 64))"
            self!.startInfo.stepCount = Int($0 * 64)
            (self!.gradientPreview.subviews[0] as! UIImageView).image = self!.makeImageGradient()
        }
        return slider
    }()
    
    lazy private var stepCountInput : TextField = {
        let input = TextField()
        input.small = true
        input.translatesAutoresizingMaskIntoConstraints = true
        input.filed.text = "0"
        input.setHelpText(help: "0")
        input.filed.delegate = stepCountInputDelegate
        input.filed.textAlignment = .center
        input.filed.keyboardType = .numberPad
        
        input.heightAnchor.constraint(equalToConstant: 36).isActive = true
        input.widthAnchor.constraint(equalToConstant: 54).isActive = true
        return input
    }()
    
    lazy private var stepCountInputDelegate : TextFieldDelegate = {
        let delegate = TextFieldDelegate{[weak self] in
            let num = Int($0.text!) ?? 0
            if num > 64 {
                $0.text = "64"
                self!.startInfo.stepCount = 64
                self!.stepCountSlider.setPosition(pos: 1)
                (self!.gradientPreview.subviews[0] as! UIImageView).image = self!.makeImageGradient()
            } else if num < 1 {
                $0.text = ""
                self!.startInfo.stepCount = 1
                self!.stepCountSlider.setPosition(pos: 0)
                (self!.gradientPreview.subviews[0] as! UIImageView).image = self!.makeImageGradient()
            } else {
                self!.stepCountSlider.setPosition(pos: CGFloat(num) / 64)
                self!.startInfo.stepCount = num
                (self!.gradientPreview.subviews[0] as! UIImageView).image = self!.makeImageGradient()
            }
        }
        return delegate
    }()
   
    private var stepCountTitle : UILabel = {
        let text = UILabel()
        text.text = "Step's count"
        text.textAlignment = .left
        text.font = UIFont(name:  "Rubik-Medium", size: 24)
        text.textColor = ProjectStyle.uiEnableColor
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return text
    }()
    
    private var colorsTitle : UILabel = {
           let text = UILabel()
           text.text = "Colors"
           text.textAlignment = .left
           text.font = UIFont(name:  "Rubik-Medium", size: 24)
           text.textColor = ProjectStyle.uiEnableColor
           text.translatesAutoresizingMaskIntoConstraints = false
           text.heightAnchor.constraint(equalToConstant: 36).isActive = true
           return text
       }()

    lazy private var stepCountStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12
        
        stack.addArrangedSubview(stepCountInput)
        stack.addArrangedSubview(stepCountSlider)
        return stack
    }()

    
    lazy private var colorsView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        //stack.spacing = 12
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(stepCountTitle)
        stack.setCustomSpacing(0, after: stepCountTitle)
        stack.addArrangedSubview(stepCountStack)
        stack.setCustomSpacing(0, after: stepCountStack)
        stack.addArrangedSubview(colorsTitle)
        stack.setCustomSpacing(0, after: colorsTitle)

        stack.addArrangedSubview(GradientStack)
        return stack
    }()
    
    private var penTitle: UILabel = {
        let title = UILabel()
        title.text = "Gradient"
        title.textAlignment = .center
        title.font = UIFont(name:  "Rubik-Bold", size: 24)
        title.textColor = ProjectStyle.uiEnableColor
        
        return title
    }()
    
    lazy private var gradientPreview: UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        let inView = UIImageView()
        inView.translatesAutoresizingMaskIntoConstraints = false
        inView.setCorners(corners: 12)
        inView.backgroundColor = UIColor(patternImage: UIImage(cgImage: ProjectStyle.bgImage!.cgImage!, scale: 1.0/6.0, orientation: .down))
        inView.layer.magnificationFilter = .nearest
        
        mainView.addSubview(inView)
        
        inView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        inView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        inView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        inView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        
        mainView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        mainView.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.5)
        
        return mainView
    }()
    
    lazy private var GradientStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12
        
        stack.addArrangedSubview(startColor)
        stack.addArrangedSubview(gradientPreview)
        stack.addArrangedSubview(endColor)
        return stack
    }()
    
    func makeImageGradient() -> UIImage{
        var resImage = UIImage()
        if startInfo.stepCount == 0 {
            resImage = UIImage(size: CGSize(width: gradientPreview.frame.width, height: 1))!
        } else {
            resImage = UIImage(size: CGSize(width: startInfo.stepCount + 2, height: 1))!
        }
        
        UIGraphicsBeginImageContextWithOptions(resImage.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        for i in 0..<Int(resImage.size.width) {
            if i == 0 {
                context.setFillColor(startColor.color.cgColor)
            } else if i == Int(resImage.size.width) - 1 {
                context.setFillColor(endColor.color.cgColor)
            } else {
                context.setFillColor(UIColor.getColorInGradient(position: CGFloat(i) / resImage.size.width, colors: startColor.color,endColor.color).cgColor)
            }
            
            context.fill(CGRect(x: i, y: 0, width: 1, height: 1))
        }
        
        resImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resImage
    }
    
    private var topBarBg: UIView = {
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
    
    var startInfo : (stepCount : Int,startColor : UIColor, endColor : UIColor) = (0,.white,.black)
    
    func setSettings(stepCount : Int,startColor : UIColor, endColor : UIColor) {
        startInfo = (stepCount, startColor, endColor)
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
        stepCountSlider.setPosition(pos: CGFloat(startInfo.stepCount) / 64)
        stepCountInput.filed.text = "\(startInfo.stepCount)"
        
        startColor.color = startInfo.startColor
        endColor.color = startInfo.endColor

        gradientPreview.layoutIfNeeded()
        (gradientPreview.subviews[0] as! UIImageView).image = makeImageGradient()
        //penSmoothSlider.setPosition(pos: CGFloat(startInfo.penSmooth) / 64)
       // penSmoothInput.filed.text = "\(startInfo.penSmooth)"
        
       // pixelPerfectToggle.isCheck = startInfo.pixelPerfect
        
       // self.penColor.color = startInfo.penColor
    }
}
