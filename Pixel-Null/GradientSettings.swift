//
//  GradientSettings.swift
//  new Testing
//
//  Created by Рустам Хахук on 05.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class GradientSettings : UIViewController {
    
    weak var project : ProjectWork? = nil

    lazy private var startColor : ColorSelector = {
        let color = ColorSelector()
        color.color = .black
        color.translatesAutoresizingMaskIntoConstraints = false
        color.widthAnchor.constraint(equalToConstant: 36).isActive = true
        color.heightAnchor.constraint(equalToConstant: 36).isActive = true
        color.delegate = {[unowned self] in
            let colorPicker = ProjectPallete()
            colorPicker.project = self.project
            colorPicker.startColor = color.color
            
            colorPicker.selectDelegate = {res in
                color.color = res
                self.startInfo.startColor = res
                (self.gradientPreview.subviews[0] as! UIImageView).image = self.makeImageGradient()
                self.delegate?.setGradientSettings(stepCount: Int(self.setpCountField.text ?? "1")!, startColor: self.startColor.color, endColor: self.endColor.color)
            }
            self.show(colorPicker, sender: self)
        }
        return color
    }()
    
    lazy private var endColor : ColorSelector = {
           let color = ColorSelector()
            color.color = .white

           color.translatesAutoresizingMaskIntoConstraints = false
           color.widthAnchor.constraint(equalToConstant: 36).isActive = true
           color.heightAnchor.constraint(equalToConstant: 36).isActive = true
           color.delegate = {[unowned self] in
               let colorPicker = ProjectPallete()
               colorPicker.project = self.project
               colorPicker.startColor = color.color
            
               colorPicker.selectDelegate = {res in
                    color.color = res
                    self.startInfo.endColor = res
                    (self.gradientPreview.subviews[0] as! UIImageView).image = self.makeImageGradient()
                    self.delegate?.setGradientSettings(stepCount: Int(self.setpCountField.text ?? "1")!, startColor: self.startColor.color, endColor: self.endColor.color)
               }
               self.show(colorPicker, sender: self)
           }
           return color
       }()
        
    lazy private var stepCountSlider : SliderView = {
        let slider = SliderView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        slider.orientation = .horizontal
        slider.delegate = {[unowned self] in
            self.setpCountField.text = "\(Int($0 * 64))"
            self.startInfo.stepCount = Int($0 * 64)
            (self.gradientPreview.subviews[0] as! UIImageView).image = self.makeImageGradient()
            self.delegate?.setGradientSettings(stepCount: Int(self.setpCountField.text ?? "1")!, startColor: self.startColor.color, endColor: self.endColor.color)
        }
        return slider
    }()

    lazy private var setpCountField : UITextField = {
        let field = UITextField()
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.textColor = getAppColor(color: .enable)
        field.setCorners(corners: 8)
        field.delegate = stepCountInputDelegate
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        field.widthAnchor.constraint(equalToConstant: 54).isActive = true
        return field
    }()
    
    lazy private var stepCountInputDelegate : TextFieldDelegate = {
        let delegate = TextFieldDelegate{[unowned self] in
            let num = Int($0.text!) ?? 0
            if num > 64 {
                $0.text = "64"
                self.startInfo.stepCount = 64
                self.stepCountSlider.setPosition(pos: 1)
                (self.gradientPreview.subviews[0] as! UIImageView).image = self.makeImageGradient()
            } else if num < 1 {
                $0.text = ""
                self.startInfo.stepCount = 1
                self.stepCountSlider.setPosition(pos: 0)
                (self.gradientPreview.subviews[0] as! UIImageView).image = self.makeImageGradient()
            } else {
                self.stepCountSlider.setPosition(pos: CGFloat(num) / 64)
                self.startInfo.stepCount = num
                (self.gradientPreview.subviews[0] as! UIImageView).image = self.makeImageGradient()
            }
            
            self.delegate?.setGradientSettings(stepCount: Int(self.setpCountField.text ?? "1")!, startColor: self.startColor.color, endColor: self.endColor.color)
        }
        return delegate
    }()
   
    private var stepCountTitle : UILabel = {
        let text = UILabel()
        text.text = NSLocalizedString("Step's count", comment: "")
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        text.textColor = getAppColor(color: .enable)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return text
    }()
    
    private var colorsTitle : UILabel = {
        let text = UILabel()
        text.text = NSLocalizedString("Colors", comment: "")
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        text.textColor = getAppColor(color: .enable)
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
        
        stack.addArrangedSubview(setpCountField)
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
        stack.setCustomSpacing(12, after: stepCountStack)
        stack.addArrangedSubview(colorsTitle)
        stack.setCustomSpacing(0, after: colorsTitle)

        stack.addArrangedSubview(GradientStack)
        return stack
    }()
    
    private var penTitle: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("Gradient", comment: "")
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 32, weight: .black)
        title.textColor = UIColor(named: "enableColor")
        
        return title
    }()
    
    lazy private var gradientPreview: UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        let inView = UIImageView()
        inView.translatesAutoresizingMaskIntoConstraints = false
        inView.setCorners(corners: 8,needMask: true)
        inView.layer.magnificationFilter = .nearest
        
        mainView.addSubview(inView)
        
        inView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        inView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        inView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        inView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
        
        mainView.heightAnchor.constraint(equalToConstant: 24).isActive = true

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
        view.backgroundColor = getAppColor(color: .background)
        view.setCorners(corners: 12)
        return view
    }()
    private var bgView : UIView = {
        let view = UIView()
        return view
    }()
    
    private var scrollView = UIScrollView()
    
    weak var delegate : ToolSettingsDelegate? = nil
    
    var startInfo : (stepCount : Int,startColor : UIColor, endColor : UIColor) = (0,.white,.black)
    
    func setSettings(stepCount : Int,startColor : UIColor, endColor : UIColor) {
        startInfo = (stepCount, startColor, endColor)
    }
    
    override func viewDidLoad() {
        view.setCorners(corners: 32)
        
        view.addSubview(scrollView)
        view.addSubview(bgView)
        view.addSubview(penTitle)
        
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
        
        penTitle.translatesAutoresizingMaskIntoConstraints = false
        penTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        penTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true

        colorsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        colorsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48).isActive = true
        colorsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        
        scrollView.contentSize = CGSize(width: 100, height: colorsView.frame.height + 44)

    }
    
    override func viewDidLayoutSubviews() {
        bgView.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
        
        gradientPreview.subviews[0].setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
        gradientPreview.layer.shadowPath = UIBezierPath(roundedRect: gradientPreview.bounds, cornerRadius: 8).cgPath
        
        gradientPreview.subviews[0].backgroundColor = UIColor(patternImage:UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!, scale: 1.0/6.0, orientation: .down))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stepCountSlider.setPosition(pos: CGFloat(startInfo.stepCount) / 64)
        setpCountField.text = "\(startInfo.stepCount)"
        
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
