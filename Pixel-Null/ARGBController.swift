import UIKit

class ARGBController: UIViewController {
    
    var delegate: ColorDelegate? = nil
    
    lazy private var redSlider: ColorSlider = {
        let slider = ColorSlider(startColor: .black, endColor: .red, orientation: .horizontal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        slider.delegate = {pos in
            self.alphaSlider.resetGradient(start: self.getResultColor().withAlphaComponent(0), end: self.getResultColor())
            self.delegate?.changeColor(newColor: self.getResultColor().withAlphaComponent(self.alphaSlider.position), sender: self)
            self.redInput.text = "\(Int(pos * 255))"
            self.hexInput.text = UIColor.toHex(color: self.getResultColor().withAlphaComponent(self.alphaSlider.position), withHeshTag: false)
        }
        
        slider.preview = .none
        
        return slider
    }()
    
    lazy private var greenSlider: ColorSlider = {
        let slider = ColorSlider(startColor: .black, endColor: .green, orientation: .horizontal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        slider.delegate = {pos in
            self.alphaSlider.resetGradient(start: self.getResultColor().withAlphaComponent(0), end: self.getResultColor())
            self.delegate?.changeColor(newColor: self.getResultColor().withAlphaComponent(self.alphaSlider.position), sender: self)
            self.greenInput.text = "\(Int(pos * 255))"
            self.hexInput.text = UIColor.toHex(color: self.getResultColor().withAlphaComponent(self.alphaSlider.position), withHeshTag: false)
        }
        
        slider.preview = .none
        
        return slider
    }()
    
    lazy private var blueSlider: ColorSlider = {
        let slider = ColorSlider(startColor: .black, endColor: .blue, orientation: .horizontal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        slider.delegate = {pos in
            self.alphaSlider.resetGradient(start: self.getResultColor().withAlphaComponent(0), end: self.getResultColor())
            self.delegate?.changeColor(newColor: self.getResultColor().withAlphaComponent(self.alphaSlider.position), sender: self)
            self.blueInput.text = "\(Int(pos * 255))"
            self.hexInput.text = UIColor.toHex(color: self.getResultColor().withAlphaComponent(self.alphaSlider.position), withHeshTag: false)

        }
        
        slider.preview = .none

        return slider
    }()
    
    lazy private var alphaSlider: ColorSlider = {
        let slider = ColorSlider(startColor: UIColor.white.withAlphaComponent(0), endColor: .white, orientation: .horizontal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        slider.delegate = {pos in
            self.delegate?.changeColor(newColor: self.getResultColor().withAlphaComponent(self.alphaSlider.position), sender: self)
            self.alphaInput.text = "\(Int(pos * 255))"
            self.hexInput.text = UIColor.toHex(color: self.getResultColor().withAlphaComponent(self.alphaSlider.position), withHeshTag: false)
        }
        
        slider.preview = .none
        
        return slider
    }()
    
    lazy private var redInput: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: 64).isActive = true
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.setCorners(corners: 8)

        field.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        field.textColor = getAppColor(color: .enable)
        field.textAlignment = .center
        field.text = "255"
        field.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : getAppColor(color: .disable)])
        
        field.keyboardType = .numberPad
        
        field.delegate = self

        return field
    }()
    
    lazy private var greenInput: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: 64).isActive = true
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.setCorners(corners: 8)
        
        field.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        field.textColor = getAppColor(color: .enable)
        field.textAlignment = .center
        field.text = "255"
        field.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : getAppColor(color: .disable)])

        field.keyboardType = .numberPad
        
        field.delegate = self


        return field
    }()
    
    lazy private var blueInput: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: 64).isActive = true
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.setCorners(corners: 8)

        field.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        field.textColor = getAppColor(color: .enable)
        field.textAlignment = .center
        field.text = "255"
        field.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : getAppColor(color: .disable)])

        field.keyboardType = .numberPad

        field.delegate = self

        return field
    }()
    
    lazy private var alphaInput: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: 64).isActive = true
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        field.backgroundColor = getAppColor(color: .backgroundLight)
        field.setCorners(corners: 8)
        
        field.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        field.textColor = getAppColor(color: .enable)
        field.textAlignment = .center
        field.text = "255"
        field.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : getAppColor(color: .disable)])

        field.keyboardType = .numberPad

        field.delegate = self

        return field
    }()

    lazy private var hexInput: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        field.backgroundColor = getAppColor(color: .backgroundLight)
        
        let leftLabel = UILabel()
        leftLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        leftLabel.textColor = getAppColor(color: .enable)
        leftLabel.textAlignment = .right
        leftLabel.text = "#"
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
        leftLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true

        field.leftViewMode = .always
        field.leftView = leftLabel
        
        field.setCorners(corners: 8)
        
        field.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        field.textColor = getAppColor(color: .enable)
        field.textAlignment = .left
        field.text = "FFFFFFF"
        field.attributedPlaceholder = NSAttributedString(string: "FFFFFFFF", attributes: [NSAttributedString.Key.foregroundColor : getAppColor(color: .disable)])
        
        field.delegate = self
        
        return field
    }()
    
    private func getResultColor() -> UIColor {
        return UIColor(r: Int(redSlider.position * 255), g: Int(greenSlider.position * 255), b: Int(blueSlider.position * 255), a: 255)
    }
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = UIUserInterfaceStyle.init(rawValue: UserDefaults.standard.integer(forKey: "themeMode"))!

        view.addSubview(redSlider)
        view.addSubview(greenSlider)
        view.addSubview(blueSlider)
        view.addSubview(alphaSlider)
        
        view.addSubview(redInput)
        view.addSubview(greenInput)
        view.addSubview(blueInput)
        view.addSubview(alphaInput)

        view.addSubview(hexInput)

        redInput.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 24).isActive = true
        redInput.topAnchor.constraint(equalTo: view.topAnchor,constant: 24).isActive = true
        
        greenInput.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 24).isActive = true
        greenInput.topAnchor.constraint(equalTo: redInput.bottomAnchor,constant: 12).isActive = true
        
        blueInput.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 24).isActive = true
        blueInput.topAnchor.constraint(equalTo: greenInput.bottomAnchor,constant: 12).isActive = true

        alphaInput.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 24).isActive = true
        alphaInput.topAnchor.constraint(equalTo: blueInput.bottomAnchor,constant: 12).isActive = true
        
        redSlider.leftAnchor.constraint(equalTo: redInput.rightAnchor,constant: 12).isActive = true
        redSlider.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -24).isActive = true
        redSlider.topAnchor.constraint(equalTo: view.topAnchor,constant: 24).isActive = true
        
        greenSlider.leftAnchor.constraint(equalTo: greenInput.rightAnchor,constant: 12).isActive = true
        greenSlider.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -24).isActive = true
        greenSlider.topAnchor.constraint(equalTo: redSlider.bottomAnchor,constant: 12).isActive = true
        
        blueSlider.leftAnchor.constraint(equalTo: blueInput.rightAnchor,constant: 12).isActive = true
        blueSlider.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -24).isActive = true
        blueSlider.topAnchor.constraint(equalTo: greenSlider.bottomAnchor,constant: 12).isActive = true
        
        alphaSlider.leftAnchor.constraint(equalTo: alphaInput.rightAnchor,constant: 12).isActive = true
        alphaSlider.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -24).isActive = true
        alphaSlider.topAnchor.constraint(equalTo: blueSlider.bottomAnchor,constant: 12).isActive = true
        
        hexInput.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 24).isActive = true
        hexInput.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -24).isActive = true
        hexInput.topAnchor.constraint(equalTo: alphaInput.bottomAnchor,constant: 12).isActive = true
    }
    
    private func isFormat(s : String) -> Bool{
        var res = s
        
        while(res.count > 0){
            if(!filter(filter: "0123456789ABCDEF", checkChar: res.removeFirst())) {return false}
        }
        return true
    }
    
    private func filter(filter : String, checkChar : Character) -> Bool{
        return filter.contains(checkChar.uppercased())
    }
}

extension ARGBController: ColorSelectorDelegate {
    func setColor(color: UIColor) {
        redSlider.setPosition(pos: Double(color.getComponents().red) / 255.0)
        greenSlider.setPosition(pos: Double(color.getComponents().green) / 255.0)
        blueSlider.setPosition(pos: Double(color.getComponents().blue) / 255.0)
        alphaSlider.setPosition(pos: Double(color.getComponents().alpha) / 255.0)
        
        alphaSlider.resetGradient(start: getResultColor().withAlphaComponent(0), end: getResultColor())
        
        redInput.text = "\(color.getComponents().red)"
        greenInput.text = "\(color.getComponents().green)"
        blueInput.text = "\(color.getComponents().blue)"
        alphaInput.text = "\(color.getComponents().alpha)"
        
        hexInput.text = UIColor.toHex(color: color, withHeshTag: false)
    }
}

extension ARGBController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == hexInput {
            if isFormat(s: textField.text!) && textField.text?.count == 8 {
                let newclr = UIColor(hex: "#\(textField.text!)")!
                delegate?.changeColor(newColor: newclr, sender: self)
                setColor(color: newclr)
            }
        } else {
            while (textField.text!.count > 3) {
                textField.text!.removeLast()
            }
            
            if(Int(textField.text!) ?? -1 == -1) {
                textField.text = "0"
                return
            }
            
            if(textField.text == "") {
                textField.text = "0"
            } else if(Int(textField.text!)! > 255){
                textField.text = "255"
            } else if(textField.text!.count > 1 && textField.text!.first == "0"){
                textField.text!.removeFirst()
            }
            
            if textField == redInput {
                redSlider.setPosition(pos: Double(textField.text!)! / 255.0)
            } else if textField == greenInput {
                greenSlider.setPosition(pos: Double(textField.text!)! / 255.0)
            } else if textField == blueInput {
                blueSlider.setPosition(pos: Double(textField.text!)! / 255.0)
            } else if textField == alphaInput {
                alphaSlider.setPosition(pos: Double(textField.text!)! / 255.0)
            }
            
            self.hexInput.text = UIColor.toHex(color: self.getResultColor().withAlphaComponent(self.alphaSlider.position), withHeshTag: false)
        }
    }
}
