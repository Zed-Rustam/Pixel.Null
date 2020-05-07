import UIKit

class ColorSelector : UIView{
    
    var background : UIImageView = {
        
        let bg = UIImageView(image: UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!.cropping(to: CGRect(x: 0, y: 0, width: 4, height: 4))!))
        bg.contentMode = .scaleAspectFill
        bg.layer.magnificationFilter = CALayerContentsFilter.nearest
        bg.setCorners(corners: 12)
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()
    
    private var foreground : UIView = {
        let fg = UIView()
        //fg.setCorners(corners: 12)
        fg.backgroundColor = .clear
        fg.translatesAutoresizingMaskIntoConstraints = false
        return fg
    }()
    
    var delegate : ()->() = {}

    var color : UIColor {
        get { return foreground.backgroundColor! }
        set {
            UIView.animate(withDuration: 0.25, animations: {
                self.foreground.backgroundColor = newValue
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        addSubview(background)
        background.addSubview(foreground)
        
    }
    
    override func layoutSubviews() {
        background.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        background.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        background.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        background.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
        background.image = UIImage(cgImage: #imageLiteral(resourceName: "background").cgImage!.cropping(to: CGRect(x: 0, y: 0, width: 4, height: 4))!)

        foreground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        foreground.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        foreground.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        foreground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)

        UIView.animate(withDuration: 0.25){
            self.background.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25){
            self.background.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        delegate()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25){
            self.background.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder : coder)
    }
}

