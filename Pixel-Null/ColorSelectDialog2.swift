import UIKit

class ColorSelectDialog2 : UIView {
    
    lazy private var redSlider : ColorSlider = {
        let slider = ColorSlider(startColor: .black, endColor: .red, orientation: .horizontal)
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        slider.preview = .down
        
        slider.delegate = {position in
            self.nowred = position
            self.redSliderText.filed.text = String(Int(255 * position))
            self.result.color =  UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha)
            self.alphaSlider.resetGradient(start: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(0), end: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(1))
            self.hexText.filed.text = UIColor.toHex(color: self.result.color)
        }
        
        return slider
    }()

    lazy private var redSliderText : TextField = {
        let text = TextField(frame: .zero)
        text.setHelpText(help: "0")
        text.filed.text = ""
        text.filed.textAlignment = .center
        text.small = true
        text.filed.keyboardType = .numberPad
        text.setFIeldDelegate(delegate: redDelegate)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.widthAnchor.constraint(equalToConstant: 72).isActive = true
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneSetDelay))
        bar.items = [done]
        bar.sizeToFit()
        
        text.filed.inputAccessoryView = bar
        
        return text
    }()
    
    lazy private var redStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        
        stack.addArrangedSubview(redSliderText)
        stack.addArrangedSubview(redSlider)
        return stack
    }()
    
    lazy private var greenStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        
        stack.addArrangedSubview(greenSliderText)
        stack.addArrangedSubview(greenSlider)
        return stack
    }()
    
    lazy private var blueStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        
        stack.addArrangedSubview(blueSliderText)
        stack.addArrangedSubview(blueSlider)
        return stack
    }()

    lazy private var alphaStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        
        stack.addArrangedSubview(alphaSliderText)
        stack.addArrangedSubview(alphaSlider)
        return stack
    }()
    
    lazy private var greenSliderText : TextField = {
        let text = TextField(frame: .zero)
        text.setHelpText(help: "0")
        text.filed.text = ""
        text.filed.textAlignment = .center
        text.small = true
        text.setFIeldDelegate(delegate: greenDelegate)
        text.filed.keyboardType = .numberPad
        text.translatesAutoresizingMaskIntoConstraints = false
        text.widthAnchor.constraint(equalToConstant: 72).isActive = true
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneSetDelay))
        bar.items = [done]
        bar.sizeToFit()
        
        text.filed.inputAccessoryView = bar
        
        return text
    }()
    
    lazy private var blueSliderText : TextField = {
        let text = TextField(frame: .zero)
        text.setHelpText(help: "0")
        text.filed.text = ""
        text.filed.textAlignment = .center
        text.small = true
        text.setFIeldDelegate(delegate: blueDelegate)
        text.filed.keyboardType = .numberPad
        text.translatesAutoresizingMaskIntoConstraints = false
        text.widthAnchor.constraint(equalToConstant: 72).isActive = true
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneSetDelay))
        bar.items = [done]
        bar.sizeToFit()
        
        text.filed.inputAccessoryView = bar
        return text
    }()
    
    lazy private var alphaSliderText : TextField = {
       let text = TextField(frame: CGRect(x: 16, y: 142, width: 72, height: 36))
        text.setHelpText(help: "0")
        text.filed.text = ""
        text.filed.textAlignment = .center
        text.small = true
        text.setFIeldDelegate(delegate: alphaDelegate)
        text.filed.keyboardType = .numberPad
        text.translatesAutoresizingMaskIntoConstraints = false
        text.widthAnchor.constraint(equalToConstant: 72).isActive = true
        text.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneSetDelay))
        bar.items = [done]
        bar.sizeToFit()
        
        text.filed.inputAccessoryView = bar
        
        return text
    }()
    
    lazy var hexText : TextField = {
        let text = TextField(frame: .zero)
       text.setHelpText(help: "#00000000")
       text.filed.text = ""
       text.small = false
       text.setFIeldDelegate(delegate: hexDelegate)
       text.translatesAutoresizingMaskIntoConstraints = false
       text.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneSetDelay))
        bar.items = [done]
        bar.sizeToFit()
        
        text.filed.font = UIFont(name: "Rubik-Medium", size: 20)
        text.filed.inputAccessoryView = bar
       return text
    }()
    
    @objc func doneSetDelay() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }

    lazy private var greenSlider : ColorSlider = {
        let slider  = ColorSlider(startColor: .black, endColor: .green, orientation: .horizontal)
        slider.delegate = {position in
           self.nowgreen = position
           self.greenSliderText.filed.text = String(Int(255 * position))
           self.result.color = UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha)
           self.alphaSlider.resetGradient(start: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(0), end: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(1))
           self.hexText.filed.text = UIColor.toHex(color: self.result.color)
        }
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return slider
    }()
    
    lazy private var blueSlider : ColorSlider = {
        let slider = ColorSlider(startColor: .black, endColor: .blue, orientation: .horizontal)
        slider.delegate = {position in
            self.nowblue = position
            self.blueSliderText.filed.text = String(Int(255 * position))
            self.result.color =  UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha)
            
            self.alphaSlider.resetGradient(start: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(0), end: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(1))
            
            self.hexText.filed.text = UIColor.toHex(color: self.result.color)
        }
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return slider
    }()
    
    lazy private var alphaSlider : ColorSlider = {
        let slider = ColorSlider(startColor: UIColor.red.withAlphaComponent(0), endColor: .red, orientation: .horizontal)
        
          slider.delegate = {[weak self] in
              self!.nowalpha = $0
              self!.alphaSliderText.filed.text = String(Int(255 * $0))
              self!.result.color = UIColor(red: self!.nowred, green: self!.nowgreen, blue: self!.nowblue, alpha: self!.nowalpha)
              self!.hexText.filed.text = UIColor.toHex(color: self!.result.color)
          }
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return slider
    }()
    
    var result : ColorSelector = {
        let res  = ColorSelector(frame: .zero)
        res.translatesAutoresizingMaskIntoConstraints = false
        res.widthAnchor.constraint(equalToConstant: 42).isActive = true
        res.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        res.background.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        return res
    }()
    
    var lastresult : ColorSelector = {
        let res  = ColorSelector(frame: .zero)
        res.translatesAutoresizingMaskIntoConstraints = false
        res.widthAnchor.constraint(equalToConstant: 42).isActive = true
        res.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        res.background.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        return res
    }()
    
    lazy private var results : UIView = {
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        
        mainview.addSubview(lastresult)
        mainview.addSubview(result)

        result.leftAnchor.constraint(equalTo: mainview.leftAnchor, constant: 0).isActive = true
        result.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true

        lastresult.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 0).isActive = true
        lastresult.leftAnchor.constraint(equalTo: result.rightAnchor, constant: 0).isActive = true

        mainview.widthAnchor.constraint(equalToConstant: 84).isActive = true
        mainview.heightAnchor.constraint(equalToConstant: 42).isActive = true

        return mainview
    }()
    
    lazy private var resultStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .fill
               
        stack.addArrangedSubview(hexText)
        stack.addArrangedSubview(result)
        return stack
    }()
    
    lazy private var hexDelegate : TextFieldDelegate = TextFieldDelegate(method: {field in
        let text = field.text!
        if text.count != 9 {
            self.hexText.error = "invalid format"
        } else {
            self.hexText.error = nil
            self.converthex(s: self.hexText.filed.text!)
        }
    })
    
    lazy private var redDelegate : TextFieldDelegate = TextFieldDelegate(method: {[weak self] in
        while ($0.text!.count > 3) {
            $0.text!.removeLast()
        }
        
        if(Int($0.text!) ?? -1 == -1) {
            $0.text = "0"
            return
        }
        
        if($0.text == "") {
            $0.text = "0"
        } else if(Int($0.text!)! > 255){
            $0.text = "255"
        } else if($0.text!.count > 1 && $0.text!.first == "0"){
            $0.text!.removeFirst()
        }
        self!.nowred = CGFloat(Int($0.text!)!) / 255.0
        self!.redSlider.setPosition(pos: self!.nowred)
        
        self!.result.color = UIColor(red: self!.nowred, green: self!.nowgreen, blue: self!.nowblue, alpha: self!.nowalpha)
        self!.alphaSlider.resetGradient(start: UIColor(red: self!.nowred, green: self!.nowgreen, blue: self!.nowblue, alpha: self!.nowalpha).withAlphaComponent(0), end: UIColor(red: self!.nowred, green: self!.nowgreen, blue: self!.nowblue, alpha: self!.nowalpha).withAlphaComponent(1))
        self!.hexText.filed.text = UIColor.toHex(color: self!.result.color)
    })
    
    lazy private var greenDelegate : TextFieldDelegate = TextFieldDelegate(method: {field in
        while (field.text!.count > 3) {
            field.text!.removeLast()
        }
        if(field.text == "") {
            field.text = "0"
        } else if(Int(field.text!)! > 255){
            field.text = "255"
        } else if(field.text!.count > 1 && field.text!.first == "0"){
            field.text!.removeFirst()
        }
        self.nowgreen = CGFloat(Int(field.text!)!) / 255.0
        self.greenSlider.setPosition(pos: self.nowgreen)
        self.result.color = UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha)
        self.alphaSlider.resetGradient(start: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(0), end: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(1))
        self.hexText.filed.text = UIColor.toHex(color: self.result.color)
    })
    
    lazy private var blueDelegate : TextFieldDelegate = TextFieldDelegate(method: {field in
        while (field.text!.count > 3) {
            field.text!.removeLast()
        }
        if(field.text == "") {
            field.text = "0"
        } else if(Int(field.text!)! > 255){
            field.text = "255"
        } else if(field.text!.count > 1 && field.text!.first == "0"){
            field.text!.removeFirst()
        }
        self.nowblue = CGFloat(Int(field.text!)!) / 255.0
        self.blueSlider.setPosition(pos: self.nowblue)
        self.result.color = UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha)
        self.alphaSlider.resetGradient(start: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(0), end: UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha).withAlphaComponent(1))
        self.hexText.filed.text = UIColor.toHex(color: self.result.color)
    })
    
    lazy private var alphaDelegate : TextFieldDelegate = TextFieldDelegate(method: {field in
        while (field.text!.count > 3) {
            field.text!.removeLast()
        }
        if(field.text == "") {
            field.text = "0"
        } else if(Int(field.text!)! > 255){
            field.text = "255"
        } else if(field.text!.count > 1 && field.text!.first == "0"){
            field.text!.removeFirst()
        }
        self.nowalpha = CGFloat(Int(field.text!)!) / 255.0
        self.alphaSlider.setPosition(pos: self.nowalpha)
        self.result.color = UIColor(red: self.nowred, green: self.nowgreen, blue: self.nowblue, alpha: self.nowalpha)
        self.hexText.filed.text = UIColor.toHex(color: self.result.color)
    })

    //lazy private var keyboardBar
    lazy private var scroll : UIScrollView = {
       let scrl = UIScrollView()
        scrl.translatesAutoresizingMaskIntoConstraints = false
        scrl.layer.masksToBounds = false
        return scrl
    }()
    
    private var nowred : CGFloat = 0.0
    private var nowgreen : CGFloat = 0.0
    private var nowblue : CGFloat = 0.0
    private var nowalpha : CGFloat = 0.0
    
    func setValues(color : UIColor){
        let clr = CIColor(color: color)
        
        nowred = clr.red
        nowgreen = clr.green
        nowblue = clr.blue
        nowalpha = clr.alpha
        
        redSliderText.filed.text = String(Int(clr.red * 255))
        greenSliderText.filed.text = String(Int(clr.green * 255))
        blueSliderText.filed.text = String(Int(clr.blue * 255))
        alphaSliderText.filed.text = String(Int(clr.alpha * 255))
        
        redSlider.setPosition(pos: clr.red)
        
        greenSlider.setPosition(pos: clr.green)
        blueSlider.setPosition(pos: clr.blue)
        alphaSlider.setPosition(pos: clr.alpha)
        
        hexText.filed.text = UIColor.toHex(color: color)
        
        result.color = color
        alphaSlider.resetGradient(start: result.color.withAlphaComponent(0), end: result.color.withAlphaComponent(1))
    }
    
    func converthex(s : String) {
        if(isFormat(s: s)){
            var value = s
            value.removeFirst()
            
            nowred  = CGFloat(UInt8(String(value.removeFirst()) + String(value.removeFirst()), radix: 16)!) / 255.0
            nowgreen = CGFloat(UInt8(String(value.removeFirst()) + String(value.removeFirst()), radix: 16)!) / 255.0
            nowblue = CGFloat(UInt8(String(value.removeFirst()) + String(value.removeFirst()), radix: 16)!) / 255.0
            nowalpha = CGFloat(UInt8(String(value.removeFirst()) + String(value.removeFirst()), radix: 16)!) / 255.0

            redSliderText.filed.text = String(Int(nowred * 255))
            greenSliderText.filed.text = String(Int(nowgreen * 255))
            blueSliderText.filed.text = String(Int(nowblue * 255))
            alphaSliderText.filed.text = String(Int(nowalpha * 255))
            
            redSlider.setPosition(pos: nowred)
            
            greenSlider.setPosition(pos: nowgreen)
            blueSlider.setPosition(pos: nowblue)
            alphaSlider.setPosition(pos: nowalpha)
            
            result.color = UIColor(red: nowred, green: nowgreen, blue: nowblue, alpha: nowalpha)
        }
    }
    
    func isFormat(s : String) -> Bool{
        var res = s
        if(res.removeFirst() == "#") {
            while(res.count > 0){
                if(!filter(filter: "0123456789ABCDEF", checkChar: res.removeFirst())) {return false}
            }
            return true
        } else { return false }
    }
    
    func filter(filter : String, checkChar : Character) -> Bool{
        return filter.contains(checkChar.uppercased())
    }
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        addSubview(scroll)
        scroll.addSubview(redSliderText)
        scroll.addSubview(greenSliderText)
        scroll.addSubview(blueSliderText)
        scroll.addSubview(alphaSliderText)

        scroll.addSubview(greenSlider)
        scroll.addSubview(blueSlider)
        scroll.addSubview(alphaSlider)
        scroll.addSubview(redSlider)

        scroll.addSubview(hexText)
        scroll.addSubview(results)

        redSliderText.leftAnchor.constraint(equalTo: scroll.leftAnchor, constant: 0).isActive = true
        redSliderText.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 0).isActive = true
        
        greenSliderText.leftAnchor.constraint(equalTo: scroll.leftAnchor, constant: 0).isActive = true
        greenSliderText.topAnchor.constraint(equalTo: redSliderText.bottomAnchor, constant: 12).isActive = true
        
        blueSliderText.leftAnchor.constraint(equalTo: scroll.leftAnchor, constant: 0).isActive = true
        blueSliderText.topAnchor.constraint(equalTo: greenSliderText.bottomAnchor, constant: 12).isActive = true
        
        alphaSliderText.leftAnchor.constraint(equalTo: scroll.leftAnchor, constant: 0).isActive = true
        alphaSliderText.topAnchor.constraint(equalTo: blueSliderText.bottomAnchor, constant: 12).isActive = true
        
        redSlider.leftAnchor.constraint(equalTo: redSliderText.rightAnchor, constant: 8).isActive = true
        redSlider.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 3).isActive = true
        redSlider.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        greenSlider.leftAnchor.constraint(equalTo: greenSliderText.rightAnchor, constant: 8).isActive = true
        greenSlider.topAnchor.constraint(equalTo: greenSliderText.topAnchor, constant: 3).isActive = true
        greenSlider.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        blueSlider.leftAnchor.constraint(equalTo: blueSliderText.rightAnchor, constant: 8).isActive = true
        blueSlider.topAnchor.constraint(equalTo: blueSliderText.topAnchor, constant: 3).isActive = true
        blueSlider.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        alphaSlider.leftAnchor.constraint(equalTo: alphaSliderText.rightAnchor, constant: 8).isActive = true
        alphaSlider.topAnchor.constraint(equalTo: alphaSliderText.topAnchor, constant: 3).isActive = true
        alphaSlider.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        hexText.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        hexText.topAnchor.constraint(equalTo: alphaSliderText.bottomAnchor, constant: 12).isActive = true
        hexText.rightAnchor.constraint(equalTo: results.leftAnchor, constant: -8).isActive = true
        
        results.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        results.topAnchor.constraint(equalTo: alphaSliderText.bottomAnchor, constant: 12).isActive = true
                
        translatesAutoresizingMaskIntoConstraints = false
        scroll.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        scroll.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(sender:)), name: UIApplication.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(sender:)), name: UIApplication.keyboardWillHideNotification, object: nil)
// NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    @objc func keyboardChange(sender : NSNotification) {
        let info = sender.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
 
        if hexText.filed.isFirstResponder && hexText.frame.origin.y + hexText.frame.height + 12 > scroll.frame.height - rect.height  {
            scroll.contentOffset = CGPoint(x: 0, y: 96)
        } else {
            scroll.contentOffset = .zero
        }
    }
    
    @objc func keyboardHide(sender : NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scroll.contentInset = contentInsets;
        scroll.scrollIndicatorInsets = contentInsets;
        scroll.contentOffset = .zero
    }
    
    override func layoutSubviews() {
        //layoutIfNeeded()
        
        scroll.contentSize.height = 240
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
