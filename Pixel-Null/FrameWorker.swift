import UIKit

class CorsLines : UIView {
private var line1 : UIView
private var line2 : UIView
private var cross = false
var isCross : Bool {
    get{
        return cross
    }
    set {
        if(cross != newValue){
            cross = newValue
            crossing(anim : true)
        }
    }
}

override init(frame: CGRect) {
    line1 = UIView(frame: CGRect(x: 3, y: 7.5, width: 18, height: 3))
    line2 = UIView(frame: CGRect(x: 3, y: 13.5, width: 18, height: 3))
    super.init(frame: frame)
    
    line1.backgroundColor = UIColor(named: "enableColor")
    line1.layer.cornerRadius = 1.5
    line1.layer.allowsEdgeAntialiasing = true

    
    line2.backgroundColor = UIColor(named: "enableColor")
    line2.layer.cornerRadius = 1.5
    line2.layer.allowsEdgeAntialiasing = true
    
    addSubview(line1)
    addSubview(line2)
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

    func crossing(anim : Bool) {
        let duration = anim ? 0.2 : 0
    if(cross){
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.byValue = (45.0 / 180.0) * Float.pi
        rotation.duration = duration
        
        let move = CABasicAnimation(keyPath: "position")
        move.fromValue = line1.layer.position
        move.toValue = CGPoint(x: line1.layer.position.x, y: line1.layer.position.y + 3)
        move.duration = duration
        
        line1.layer.add(rotation, forKey: "test")
        line1.layer.add(move, forKey: "test2")
        line1.layer.transform = CATransform3DMakeRotation(CGFloat((45.0 / 180.0) * Float.pi), 0, 0, 1)
        line1.layer.position.y += 3
        
        let rotation2 = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation2.fromValue = 0
        rotation2.byValue = (135.0 / 180.0) * Float.pi
        rotation2.duration = duration
        
        let move2 = CABasicAnimation(keyPath: "position")
        move2.fromValue = line2.layer.position
        move2.toValue = CGPoint(x: line2.layer.position.x, y: line2.layer.position.y - 3)
        move2.duration = duration
        
        line2.layer.add(rotation2, forKey: "test")
        line2.layer.add(move2, forKey: "test2")
        line2.layer.transform = CATransform3DMakeRotation(CGFloat((-45.0 / 180.0) * Float.pi), 0, 0, 1)
        line2.layer.position.y -= 3
    } else {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = (45.0 / 180.0) * Float.pi
        rotation.byValue = (-45.0 / 180.0) * Float.pi
        rotation.duration = duration
        
        let move = CABasicAnimation(keyPath: "position")
        move.fromValue = line1.layer.position
        move.toValue = CGPoint(x: line1.layer.position.x, y: line1.layer.position.y - 3)
        move.duration = duration
        
        line1.layer.add(rotation, forKey: "test")
        line1.layer.add(move, forKey: "test2")
        line1.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1)
        line1.layer.position.y -= 3
        
        
        let rotation2 = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation2.fromValue = (-45.0 / 180.0) * Float.pi
        rotation2.byValue = (-135.0 / 180.0) * Float.pi
        rotation2.duration = duration
        
        let move2 = CABasicAnimation(keyPath: "position")
        move2.fromValue = line2.layer.position
        move2.toValue = CGPoint(x: line2.layer.position.x, y: line2.layer.position.y + 3)
        move2.duration = duration
        
        line2.layer.add(rotation2, forKey: "test")
        line2.layer.add(move2, forKey: "test2")
        line2.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1)
        line2.layer.position.y += 3
        }
    
    }
}

class FrameWorker : UIView {
    private var bg : UIView
    private var preview : FramePreview!
    private var cross : CorsLines!
    private var img : UIImage? = nil
    private var select : Bool = false
    private var drag : Bool = false

    var image : UIImage? {
        get{
            return img
        } set {
            img = newValue
            preview.image = img
        }
    }
    
    var framePreview : FramePreview {
        get{
            return preview
        }
        set {
            preview = newValue
        }
    }
    
    var isSelect : Bool {
        get{
            return select
        } set {
            select = newValue
            
            //cross.isCross = select
            if(select){
                setSelect(isSelected: true,anim: false)
            } else {
                setSelect(isSelected: false, anim: false)
            }
        }
    }
    
    var isDrag : Bool {
        get{
           return drag
       } set {
           drag = newValue
           
           cross.isCross = select
           if(drag){
               setAnimDrag(anim: true)
           } else {
               stopDragAnim(anim: true)
           }
       }
    }
    
    func setBg(color : UIColor){
        preview.bgColor = color
    }
    
    func setSelect(isSelected : Bool, anim : Bool){
        let duration = anim ? 0.2 : 0.0

        if(select != isSelected){
            select = isSelected
            
            if isSelected {
                StrokeAnimate(duration: duration, width: 2)
                ShadowColorAnimate(duration: duration, color: UIColor(named: "selectColor")!)
                ShadowRadiusAnimate(duration : duration, radius: 4)
            } else {
                StrokeAnimate(duration: duration, width: 0)
                ShadowColorAnimate(duration: duration, color: UIColor(named: "shadowColor")!)
                ShadowRadiusAnimate(duration : duration, radius: 12)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow(color: isSelect ? UIColor(named: "selectColor")! : UIColor(named: "shadowColor")!, radius: isSelect ? 4 : 12, opasity: 1)
    }
    
    override init(frame: CGRect) {
        bg = UIView()
       
        
        super.init(frame : frame)
        bg.frame = bounds
        preview = FramePreview(frame : CGRect(x: 0, y: 0, width: frame.width, height: frame.width), image: UIImage())
        
         cross = CorsLines(frame : CGRect(x: 6, y: 36, width: 24, height: 24))
        bg.addSubview(preview)
        bg.addSubview(cross)
        addSubview(bg)
        
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        
        layer.cornerRadius = 8
        backgroundColor = UIColor(named: "backgroundColor")
        
        layer.shadowColor = UIColor(named: "shadowColor")!.cgColor
        layer.shadowRadius = 12
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.borderColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1).cgColor
        layer.allowsEdgeAntialiasing = true
        
        CATransaction.commit()
    }
    
    func inPreview(_ point : CGPoint) -> Bool{
        return preview.frame.contains(point)
    }
    
    func stopDragAnim(anim : Bool){
        layer.removeAllAnimations()

        let duration = anim ? 0.2 : 0.0
        
        let b = CABasicAnimation(keyPath: "transform.rotation.z")
        b.toValue = 0
        b.duration = 0.15
        
        layer.add(b, forKey: "drag")

        StrokeAnimate(duration: duration, width: 0)
        ShadowColorAnimate(duration: duration, color: UIColor(named: "shadowColor")!)
        ShadowRadiusAnimate(duration : duration, radius: 12)
    }
    
    func setAnimDrag(anim : Bool){
        layer.removeAllAnimations()

        let duration = anim ? 0.2 : 0.0

        let b = CABasicAnimation(keyPath: "transform.rotation.z")
        b.fromValue = -0.075
        b.toValue = 0.075
        b.repeatCount = Float.infinity
        b.duration = 0.15
        b.autoreverses = true
        
        layer.add(b, forKey: "rotate")
        StrokeAnimate(duration: duration, width: 2)
        ShadowColorAnimate(duration: duration, color: UIColor(named: "selectColor")!)
        ShadowRadiusAnimate(duration : duration, radius: 4)
    }
    
    required init?(coder: NSCoder) {
        bg = UIView()
        preview = FramePreview(coder: coder)
        cross = CorsLines()
        super.init(coder: coder)
    }
}

protocol FramesDelegate {
    var fastSelect : Bool { get set }
    func willSelect(isSelect : Bool, worker : FrameWorker)
    func startMoveMode(worker : FrameWorker)
    func continueMoveMode(pos : CGPoint)
    func endMoveMove(worker : FrameWorker)
}
