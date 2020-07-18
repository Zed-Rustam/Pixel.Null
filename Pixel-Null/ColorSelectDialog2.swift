import UIKit

class ColorSelectDialog2 : UIView {
    
    lazy private var redSlider : ColorSlider = {
        let slider = ColorSlider(startColor: .black, endColor: .red, orientation: .horizontal)
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        slider.preview = .none
        
        slider.delegate = {[unowned self] position in
            self.nowred = Int(position * 255)
            self.redSliderText.filed.text = String(self.nowred)
            self.result.color =  UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha)
            self.alphaSlider.resetGradient(start: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(0), end: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(1))
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
        slider.preview = .none
        slider.delegate = {[unowned self] position in
           self.nowgreen = Int(position * 255)
            self.greenSliderText.filed.text = String(self.nowgreen)
           self.result.color = UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha)
           self.alphaSlider.resetGradient(start: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(0), end: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(1))
           self.hexText.filed.text = UIColor.toHex(color: self.result.color)
        }
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return slider
    }()
    
    lazy private var blueSlider : ColorSlider = {
        let slider = ColorSlider(startColor: .black, endColor: .blue, orientation: .horizontal)
        slider.preview = .none

        slider.delegate = {[unowned self] position in
            self.nowblue = Int(position * 255)
            self.blueSliderText.filed.text = String(self.nowblue)
            self.result.color =  UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha)
            
            self.alphaSlider.resetGradient(start: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(0), end: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(1))
            
            self.hexText.filed.text = UIColor.toHex(color: self.result.color)
        }
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return slider
    }()
    
    lazy private var alphaSlider : ColorSlider = {
        let slider = ColorSlider(startColor: UIColor.red.withAlphaComponent(0), endColor: .red, orientation: .horizontal)
        slider.preview = .none

          slider.delegate = {[unowned self] position in
            self.nowalpha = Int(position * 255)
            self.alphaSliderText.filed.text = String(self.nowalpha)
            self.result.color = UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha)
            self.hexText.filed.text = UIColor.toHex(color: self.result.color)
          }
        slider.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
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

        mainview.isUserInteractionEnabled = false
        return mainview
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
        self!.nowred = Int($0.text!)!
        self!.redSlider.setPosition(pos: Double(self!.nowred) / 255)
        
        self!.result.color = UIColor(r: self!.nowred, g: self!.nowgreen, b: self!.nowblue, a: self!.nowalpha)
        self!.alphaSlider.resetGradient(start: UIColor(r: self!.nowred, g: self!.nowgreen, b: self!.nowblue, a: self!.nowalpha).withAlphaComponent(0), end: UIColor(r: self!.nowred, g: self!.nowgreen, b: self!.nowblue, a: self!.nowalpha).withAlphaComponent(1))
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
        self.nowgreen = Int(field.text!)!
        self.greenSlider.setPosition(pos: Double(self.nowgreen) / 255)
        self.result.color = UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha)
        self.alphaSlider.resetGradient(start: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(0), end: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(1))
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
        self.nowblue = Int(field.text!)!
        self.blueSlider.setPosition(pos: Double(self.nowblue) / 255)
        self.result.color = UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha)
        self.alphaSlider.resetGradient(start: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(0), end: UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha).withAlphaComponent(1))
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
        self.nowalpha = Int(field.text!)!
        self.alphaSlider.setPosition(pos: Double(self.nowalpha) / 255)
        self.result.color = UIColor(r: self.nowred, g: self.nowgreen, b: self.nowblue, a: self.nowalpha)
        self.hexText.filed.text = UIColor.toHex(color: self.result.color)
    })

    //lazy private var keyboardBar
    lazy private var scroll : UIScrollView = {
       let scrl = UIScrollView()
        scrl.translatesAutoresizingMaskIntoConstraints = false
        scrl.layer.masksToBounds = false
        return scrl
    }()
        
    private var nowred : Int = 0
    private var nowgreen : Int = 0
    private var nowblue : Int = 0
    private var nowalpha : Int = 0
    
    func setValues(color : UIColor){
        let clr = CIColor(color: color)
        
        print("some check \(clr.red)  \(color.getComponents().red)")
        nowred = Int(round(clr.red * 255))
        nowgreen = Int(round(clr.green * 255))
        nowblue = Int(round(clr.blue * 255))
        nowalpha = Int(round(clr.alpha * 255))
        
        redSliderText.filed.text = String(nowred)
        greenSliderText.filed.text = String(nowgreen)
        blueSliderText.filed.text = String(nowblue)
        alphaSliderText.filed.text = String(nowalpha)
        
        redSlider.setPosition(pos: Double(clr.red))
        
        greenSlider.setPosition(pos: Double(clr.green))
        blueSlider.setPosition(pos: Double(clr.blue))
        alphaSlider.setPosition(pos: Double(clr.alpha))
        
        hexText.filed.text = UIColor.toHex(color: color)
        
        result.color = color
        alphaSlider.resetGradient(start: result.color.withAlphaComponent(0), end: result.color.withAlphaComponent(1))
    }
    
    func converthex(s : String) {
        if(isFormat(s: s)){
            var value = s
            value.removeFirst()
            
            nowred  = Int(String(value.removeFirst()) + String(value.removeFirst()), radix: 16)!
            nowgreen = Int(String(value.removeFirst()) + String(value.removeFirst()), radix: 16)!
            nowblue = Int(String(value.removeFirst()) + String(value.removeFirst()), radix: 16)!
            nowalpha = Int(String(value.removeFirst()) + String(value.removeFirst()), radix: 16)!

            redSliderText.filed.text = String(nowred)
            greenSliderText.filed.text = String(nowgreen)
            blueSliderText.filed.text = String(nowblue)
            alphaSliderText.filed.text = String(nowalpha)
            
            redSlider.setPosition(pos: Double(nowred) / 255)
            greenSlider.setPosition(pos: Double(nowgreen) / 255)
            blueSlider.setPosition(pos: Double(nowblue) / 255)
            alphaSlider.setPosition(pos: Double(nowalpha) / 255)
            
            result.color = UIColor(r: nowred, g: nowgreen, b: nowblue, a: nowalpha)
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
        redSlider.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 0).isActive = true
        redSlider.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        greenSlider.leftAnchor.constraint(equalTo: greenSliderText.rightAnchor, constant: 8).isActive = true
        greenSlider.topAnchor.constraint(equalTo: greenSliderText.topAnchor, constant: 0).isActive = true
        greenSlider.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        blueSlider.leftAnchor.constraint(equalTo: blueSliderText.rightAnchor, constant: 8).isActive = true
        blueSlider.topAnchor.constraint(equalTo: blueSliderText.topAnchor, constant: 0).isActive = true
        blueSlider.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        alphaSlider.leftAnchor.constraint(equalTo: alphaSliderText.rightAnchor, constant: 8).isActive = true
        alphaSlider.topAnchor.constraint(equalTo: alphaSliderText.topAnchor, constant: 0).isActive = true
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
