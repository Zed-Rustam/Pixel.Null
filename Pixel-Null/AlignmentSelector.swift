//
//  AlignmentSelector.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 02.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class AlignmentSelector : UIView {
    
    private var nowAlignment : ProjectAlignment = .center
    
    var alignment : ProjectAlignment {
        get{
            return nowAlignment
        }
    }
    
    private var images : [UIImageView] = [
        UIImageView(image:#imageLiteral(resourceName: "arrow_up_icon").withTintColor(UIColor(named: "enableColor")!)),
        UIImageView(image:#imageLiteral(resourceName: "arrow_up_right_icon").withTintColor(UIColor(named: "enableColor")!)),
        UIImageView(image:#imageLiteral(resourceName: "arrow_right_icon").withTintColor(UIColor(named: "enableColor")!)),
        UIImageView(image:#imageLiteral(resourceName: "arrow_down_right_icon").withTintColor(UIColor(named: "enableColor")!)),
        UIImageView(image:#imageLiteral(resourceName: "arrow_down_icon").withTintColor(UIColor(named: "enableColor")!)),
        UIImageView(image:#imageLiteral(resourceName: "arrow_down_left_icon").withTintColor(UIColor(named: "enableColor")!)),
        UIImageView(image:#imageLiteral(resourceName: "arrow_left_icon").withTintColor(UIColor(named: "enableColor")!)),
        UIImageView(image:#imageLiteral(resourceName: "arrow_up_left_icon").withTintColor(UIColor(named: "enableColor")!)),
        UIImageView(image:#imageLiteral(resourceName: "center_icon").withTintColor(UIColor(named: "enableColor")!))
    ]

    lazy private var bg : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "disableColor")!.withAlphaComponent(0.25)
        view.setCorners(corners: 12)
        return view
    }()
    
    lazy private var selectBg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "backgroundColor")!
        view.setCorners(corners: 12)
        
        let mainview = UIView()
        mainview.translatesAutoresizingMaskIntoConstraints = false
        mainview.addSubviewFullSize(view: view)
        mainview.widthAnchor.constraint(equalToConstant: 36).isActive = true
        mainview.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return mainview
        
    }()
    
    lazy private var gesture : UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
    }()
    
    @objc func onTap(sender : UITapGestureRecognizer) {
        let resultPoint = CGPoint(x: Int(sender.location(in: self).x / 36), y: Int(sender.location(in: self).y / 36))
        
        colorImage(last: nowAlignment, now: getAlignment(point: resultPoint))
        
        nowAlignment = getAlignment(point: resultPoint)
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.selectBg.frame.origin = CGPoint(x: resultPoint.x * 36, y: resultPoint.y * 36)
        },completion: nil)
    }
    
    func getAlignment(point : CGPoint) -> ProjectAlignment {
        switch point {
        case .init(x: 0, y: 0):
            return .up_left
        case .init(x: 1, y: 0):
            return .up
        case .init(x: 2, y: 0):
            return .up_right
        case .init(x: 0, y: 1):
            return .left
        case .init(x: 1, y: 1):
            return .center
        case .init(x: 2, y: 1):
            return .right
        case .init(x: 0, y: 2):
            return .down_left
        case .init(x: 1, y: 2):
            return .down
        case .init(x: 2, y: 2):
            return .down_right
        default:
            return .center
        }
    }
    
    func colorImage(last : ProjectAlignment, now : ProjectAlignment){
        if last != now {
            UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseInOut, animations: {
                switch last {
                    case .up:
                        self.images[0].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.images[0].tintColor = UIColor(named: "enableColor")
                    case .up_right:
                        self.images[1].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.images[1].tintColor = UIColor(named: "enableColor")
                    case .right:
                        self.images[2].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.images[2].tintColor = UIColor(named: "enableColor")
                    case .down_right:
                        self.images[3].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.images[3].tintColor = UIColor(named: "enableColor")
                    case .down:
                        self.images[4].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.images[4].tintColor = UIColor(named: "enableColor")
                    case .down_left:
                        self.images[5].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.images[5].tintColor = UIColor(named: "enableColor")
                    case .left:
                        self.images[6].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.images[6].tintColor = UIColor(named: "enableColor")
                    case .up_left:
                        self.images[7].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.images[7].tintColor = UIColor(named: "enableColor")
                    case .center:
                        self.images[8].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.images[8].tintColor = UIColor(named: "enableColor")
                }
                
                switch now {
                    case .up:
                        self.images[0].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        self.images[0].tintColor = UIColor(named: "selectColor")
                    case .up_right:
                        self.images[1].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        self.images[1].tintColor = UIColor(named: "selectColor")
                    case .right:
                        self.images[2].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        self.images[2].tintColor = UIColor(named: "selectColor")
                    case .down_right:
                        self.images[3].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        self.images[3].tintColor = UIColor(named: "selectColor")
                    case .down:
                        self.images[4].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        self.images[4].tintColor = UIColor(named: "selectColor")
                    case .down_left:
                        self.images[5].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        self.images[5].tintColor = UIColor(named: "selectColor")
                    case .left:
                        self.images[6].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        self.images[6].tintColor = UIColor(named: "selectColor")
                    case .up_left:
                        self.images[7].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        self.images[7].tintColor = UIColor(named: "selectColor")
                    case .center:
                        self.images[8].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
                        self.images[8].tintColor = UIColor(named: "selectColor")
                }
            },completion: nil)
        }
    }
    
    init(){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 108).isActive = true
        heightAnchor.constraint(equalToConstant: 108).isActive = true
        addSubviewFullSize(view: bg)
        
        addSubview(selectBg)
        selectBg.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        selectBg.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true

        
        images.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 36).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 36).isActive = true
            $0.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            $0.contentMode = .scaleToFill
            $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = UIColor(named: "enableColor")
        })
        
        addSubview(images[0])
        addSubview(images[1])
        addSubview(images[2])
        addSubview(images[3])
        addSubview(images[4])
        addSubview(images[5])
        addSubview(images[6])
        addSubview(images[7])
        addSubview(images[8])
        
        images[8].transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        images[8].tintColor = UIColor(named: "selectColor")

        images[7].leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        images[7].topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        images[0].leftAnchor.constraint(equalTo: images[7].rightAnchor, constant: 0).isActive = true
        images[0].topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        images[1].leftAnchor.constraint(equalTo: images[0].rightAnchor, constant: 0).isActive = true
        images[1].topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        
        images[6].leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        images[6].topAnchor.constraint(equalTo: images[7].bottomAnchor, constant: 0).isActive = true
        
        images[8].leftAnchor.constraint(equalTo: images[6].rightAnchor, constant: 0).isActive = true
        images[8].topAnchor.constraint(equalTo: images[7].bottomAnchor, constant: 0).isActive = true
        
        images[2].leftAnchor.constraint(equalTo: images[8].rightAnchor, constant: 0).isActive = true
        images[2].topAnchor.constraint(equalTo: images[7].bottomAnchor, constant: 0).isActive = true
        
        images[5].leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        images[5].topAnchor.constraint(equalTo: images[2].bottomAnchor, constant: 0).isActive = true
        
        images[4].leftAnchor.constraint(equalTo: images[5].rightAnchor, constant: 0).isActive = true
        images[4].topAnchor.constraint(equalTo: images[2].bottomAnchor, constant: 0).isActive = true
        
        images[3].leftAnchor.constraint(equalTo: images[4].rightAnchor, constant: 0).isActive = true
        images[3].topAnchor.constraint(equalTo: images[2].bottomAnchor, constant: 0).isActive = true
        
        addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectBg.setShadow(color: UIColor(named: "shadowColor")!, radius: 4, opasity: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ProjectAlignment {
    case up
    case down
    case left
    case right
    case center
    case up_left
    case up_right
    case down_left
    case down_right
}
