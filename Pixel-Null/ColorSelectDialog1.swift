import UIKit
class ColorSelectDialog1 : UIView {
    
    lazy private var blackSlider : ColorSlider = {
        let slider = ColorSlider(startColor: nowSelectColor, endColor: .black, orientation: .vertical)
        slider.delegate = {[weak self] in
            self!.blackd = CGFloat(1 - $0)
            self!.resetColorBlack()
        }
        slider.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return slider
    }()
    lazy private var whiteSlider : ColorSlider = {
        let slider = ColorSlider(startColor: .white, endColor: nowSelectColor, orientation: .vertical)
        slider.delegate = {[weak self] in
            self!.whited = CGFloat(1 - $0)
            self!.resetColor()
        }
        slider.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return slider
    }()
    lazy private var alphaSlider : ColorSlider = {
        let slider = ColorSlider(startColor: nowSelectColor.withAlphaComponent(0), endColor: nowSelectColor, orientation: .horizontal)
        slider.delegate = {[weak self] in
            self!.alphad = CGFloat($0)
            self!.resetColorAlpha()
        }
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return slider
    }()
    lazy var selectedColorShow : ColorSelector = {
        let color = ColorSelector(frame:.zero)
        color.color = nowSelectColor
        color.translatesAutoresizingMaskIntoConstraints = false
        color.widthAnchor.constraint(equalToConstant: 48).isActive = true
        color.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        color.background.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        color.setShadow(color: .clear, radius: 0, opasity: 0)
        
        return color
    }()
    lazy var lastSelectedColorShow : ColorSelector = {
        let color = ColorSelector(frame:.zero)
        color.color = nowSelectColor
        color.translatesAutoresizingMaskIntoConstraints = false
        color.widthAnchor.constraint(equalToConstant: 48).isActive = true
        color.heightAnchor.constraint(equalToConstant: 48).isActive = true
        color.background.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        color.setShadow(color: .clear, radius: 0, opasity: 0)
        return color
    }()

    lazy var circleSelector : CircleSelector = {
        let selector = CircleSelector()
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.heightAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        selector.widthAnchor.constraint(equalTo: selector.heightAnchor).isActive = true

        selector.addSubview(selectedColorShow)
        selector.addSubview(lastSelectedColorShow)

        selector.delegate = {[weak self] in
            self!.nowSelectColor = $0
            self!.whiteSlider.resetGradient(start: UIColor.white, end: self!.nowSelectColor)
            self!.resetColor()
        }
        
        selectedColorShow.centerXAnchor.constraint(equalTo: selector.centerXAnchor, constant: -24).isActive = true
        selectedColorShow.centerYAnchor.constraint(equalTo: selector.centerYAnchor, constant: 0).isActive = true
        lastSelectedColorShow.centerXAnchor.constraint(equalTo: selector.centerXAnchor, constant: 24).isActive = true
        lastSelectedColorShow.centerYAnchor.constraint(equalTo: selector.centerYAnchor, constant: 0).isActive = true
        return selector
    }()
    
    
    private var nowSelectColor : UIColor = UIColor.red
    
    lazy private var stack : UIStackView = {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.spacing = 12
        mainStack.distribution = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        let firstStack = UIStackView()
        firstStack.axis = .horizontal
        firstStack.alignment = .fill
        firstStack.spacing = 12
        firstStack.distribution = .fill
        firstStack.translatesAutoresizingMaskIntoConstraints = false

        
        firstStack.addArrangedSubview(circleSelector)
        firstStack.addArrangedSubview(whiteSlider)
        firstStack.addArrangedSubview(blackSlider)
        
        mainStack.addArrangedSubview(firstStack)
        mainStack.addArrangedSubview(alphaSlider)
        
        return mainStack
    }()
    
    private var whited : CGFloat = 0
    private var blackd : CGFloat = 1
    private var alphad : CGFloat = 1

//    func ChangeSelection(select: CGFloat) {
//        print(select)
//        nowSelectColor = UIColor.getColorInGradient(position: CGFloat((Int(select) + 270) % 360) / 360.0, colors: UIColor.red,UIColor.yellow,UIColor.green,UIColor.cyan,UIColor.blue,UIColor.magenta,UIColor.red)
//        whiteSlider.resetGradient(start: UIColor.white, end: nowSelectColor)
//
//        resetColor()
//    }
    
    func resetColor(){
        let clr = CIColor(color: nowSelectColor)
        let redd = (1 - clr.red) * whited
        let greend = (1 - clr.green) * whited
        let blued = (1 - clr.blue) * whited
        let blkClr = UIColor(red: (clr.red + redd), green: (clr.green + greend), blue: (clr.blue + blued), alpha: 1)
        let newClr = UIColor(red: (clr.red + redd) * blackd, green: (clr.green + greend) * blackd, blue: (clr.blue + blued) * blackd, alpha: alphad)
        
        blackSlider.resetGradient(start: blkClr, end: UIColor.black)
        
        alphaSlider.resetGradient(start: newClr.withAlphaComponent(0), end: newClr.withAlphaComponent(1))
        selectedColorShow.color = newClr
    }
    
    func resetColorAlpha(){
        let clr = CIColor(color: nowSelectColor)
        let redd = (1 - clr.red) * whited
        let greend = (1 - clr.green) * whited
        let blued = (1 - clr.blue) * whited
        let newClr = UIColor(red: (clr.red + redd) * blackd, green: (clr.green + greend) * blackd, blue: (clr.blue + blued) * blackd, alpha: alphad)
        
        selectedColorShow.color = newClr
    }
    
    func setColor(color : UIColor){
        let clr = CIColor(color: color)
        selectedColorShow.color = color

        if max(clr.red,clr.green,clr.blue) != 0 {
            whiteSlider.setPosition(pos: Double(1 - (min(clr.red,clr.green,clr.blue)) / max(clr.red,clr.green,clr.blue)))
            whited = 1 - (1 - (min(clr.red,clr.green,clr.blue)) / max(clr.red,clr.green,clr.blue))
        } else {
            whiteSlider.setPosition(pos: 1)
            whited = 0
        }
        blackSlider.setPosition(pos: Double(1 - max(clr.red,clr.green,clr.blue)))
        blackd = 1 - (1 - max(clr.red,clr.green,clr.blue))
        
        circleSelector.setAngle(angle: getAngle(r: clr.red, g: clr.green, b: clr.blue))
        
        print("some test \(clr.alpha)   \(alphaSlider.frame.width)")
        alphaSlider.setPosition(pos: Double(clr.alpha))
        alphad = clr.alpha
        selectedColorShow.color = color
        nowSelectColor = color

        //selectedColorShow.color = color

        //nowSelectColor = color
        
        //resetColor()
    }
    
    func getAngle(r : CGFloat, g : CGFloat, b : CGFloat) -> CGFloat{
        var angle : CGFloat = 0
        if r > g && r > b {
            angle += 90
            if g > b {
                angle += 60 * (1 - ((1 - (g / r)) / (1 - (b / r))))
            } else if b > g {
                angle -= 60 * (1 - ((1 - (b / r)) / (1 - (g / r))))
            }
        } else if g > r && g > b {
            angle += 210
            if r > b {
                angle -= 60 * (1 - ((1 - (r / g)) / (1 - (b / g))))
            } else if b > r {
                angle += 60 * (1 - ((1 - (b / g)) / (1 - (r / g))))
            }
        } else if b > r && b > g {
            angle += 330
            if r > g {
                angle += 60 * (1 - ((1 - (r / b)) / (1 - (g / b))))
            } else if g > r {
                angle -= 60 * (1 - ((1 - (g / b)) / (1 - (r / b))))
            }
        } else if r == g && r > b {
            angle += 150
        } else if r == b && r > g {
            angle += 30
        } else if g == b && g > r {
            angle += 270
        } else if r == g && g == b {
            angle += 0
        }
        
        //print("check here red : \(r)")

        return angle
    }
    
    func resetColorBlack(){
        let clr = CIColor(color: nowSelectColor)
        let redd = (1 - clr.red) * whited
        let greend = (1 - clr.green) * whited
        let blued = (1 - clr.blue) * whited
        let newClr = UIColor(red: (clr.red + redd) * blackd, green: (clr.green + greend) * blackd, blue: (clr.blue + blued) * blackd, alpha: alphad)
        
        alphaSlider.resetGradient(start: newClr.withAlphaComponent(0), end: newClr.withAlphaComponent(1))
        selectedColorShow.color = newClr
    }
    
    override init(frame: CGRect) {

       
        super.init(frame: frame)
                
        addSubview(stack)
        stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let clr = CIColor(color : selectedColorShow.color)
        circleSelector.setAngle(angle: getAngle(r: clr.red, g: clr.green, b: clr.blue))
        whiteSlider.setPosition(pos: Double(1 - min(clr.red,clr.green,clr.blue)))
        blackSlider.setPosition(pos: Double(1 - max(clr.red,clr.green,clr.blue)))
        alphaSlider.setPosition(pos: Double(clr.alpha))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
