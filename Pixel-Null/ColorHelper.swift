import UIKit
extension UIColor{
    
    convenience init(r : Int, g : Int, b : Int, a : Int){
        self.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: CGFloat(Double(a)/255.0))
    }
    
    public convenience init?(hex: String) {
        let r, g, b, a: Int
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = Int((hexNumber & 0xff000000) >> 24)
                    g = Int((hexNumber & 0x00ff0000) >> 16)
                    b = Int((hexNumber & 0x0000ff00) >> 8)
                    a = Int(hexNumber & 0x000000ff)
                    self.init(r: r, g: g, b: b, a: a)
                    return
                }
            }
        }
        return nil
    }
    
    func getPixelData() -> pixelData {
        let clr = CIColor(color: self)
        return pixelData(a: UInt8(clr.alpha * 255),r: UInt8(clr.red * 255), g: UInt8(clr.green * 255), b: UInt8(clr.blue * 255))
    }
    
    static func random() -> UIColor {
        return UIColor(red:   CGFloat.random(in: 0...1),
                          green: CGFloat.random(in: 0...1),
                          blue:  CGFloat.random(in: 0...1),
                          alpha: CGFloat.random(in: 0...1))
       }
    
    static func getColorInGradient(position p : CGFloat, colors : UIColor...) -> UIColor {
        let startColor = Int(CGFloat(colors.count - 1) * p)
        let newPosition = (p - (CGFloat(startColor) / CGFloat(colors.count - 1))) * CGFloat(colors.count - 1)
        print(newPosition)
        
        if startColor == colors.count - 1 { return colors[colors.count - 1] }
        else {
            let sc = CIColor(color : colors[startColor])
            let ec = CIColor(color : colors[startColor + 1])
            let reddiv = (ec.red - sc.red) * newPosition
            let greendiv = (ec.green - sc.green) * newPosition
            let bluediv = (ec.blue - sc.blue) * newPosition
            let alphadiv = (ec.alpha - sc.alpha) * newPosition

            return UIColor.init(red: sc.red + reddiv, green: sc.green + greendiv, blue: sc.blue + bluediv, alpha: sc.alpha + alphadiv)
        }
    }

    static func toHex(color : UIColor, withHeshTag: Bool = true) -> String {
        var result = withHeshTag ? "#" : ""
        
        let clr = CIColor(color: color)
        result += String(format : "%02X",Int(round(clr.red * 255)))
        result += String(format : "%02X",Int(round(clr.green * 255)))
        result += String(format : "%02X",Int(round(clr.blue * 255)))
        result += String(format : "%02X",Int(round(clr.alpha * 255)))
        return result
    }
    
    func getComponents() -> (red : Int,green : Int,blue : Int,alpha : Int) {
        let clr = CIColor(color: self)
        //print(clr.components)
        return (Int(clr.red * 255),Int(clr.green * 255),Int(clr.blue * 255),Int(clr.alpha * 255))
    }
}

