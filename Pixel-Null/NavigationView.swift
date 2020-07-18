//
//  NavigationView.swift
//  new Testing
//
//  Created by Рустам Хахук on 30.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

protocol NavigationProtocol : class {
    func onSelectChange(select: Int, lastSelect: Int)
}

class NavigationView : UIView {
    private let bgView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        view.backgroundColor = getAppColor(color: .background)
        return view
    }()
    private var icons : [UIImage] = []
    var select : Int = 0
    private var pressSelect : Int = -1
    private var leadingOffset : Int = 16
    var bottomOffset : Int = 0
    var iconSize : Int = 28
    private var topCorners : Int = 16
    private var bottomCorners : Int = 16
    
    weak var listener : NavigationProtocol? = nil
    
    lazy private var iconStack : UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isOpaque = true
        
        for i in 0..<icons.count {
            let img = UIImageView(image: icons[i].withRenderingMode(.alwaysTemplate))
            img.contentMode = .scaleAspectFit
            img.translatesAutoresizingMaskIntoConstraints = true
            img.heightAnchor.constraint(equalToConstant: CGFloat(iconSize)).isActive = true
            if i == select {
                img.tintColor = getAppColor(color: .enable)
            } else {
                img.tintColor = getAppColor(color: .disable)
            }
            img.isUserInteractionEnabled = true
            img.interactions.append(UIPointerInteraction(delegate: self))
            img.isOpaque = true
            stack.addArrangedSubview(img)
        }
        
        return stack
    }()
    
    lazy private var tapGesture : UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(press(sender:)))
        gesture.minimumPressDuration = 0
        return gesture
    }()
    
    init(ics : [UIImage]){
        icons = ics
        super.init(frame: .zero)
                
        addGestureRecognizer(tapGesture)
        isOpaque = true
    }
    
    func setNavigationCorners(top : Int, bottom : Int){
        topCorners = top
        bottomCorners = bottom
    }
    
    override func layoutSubviews() {
        addSubview(bgView)
        bgView.addSubview(iconStack)
        
        bgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        bgView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        iconStack.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: CGFloat(leadingOffset)).isActive = true
        iconStack.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -CGFloat(leadingOffset)).isActive = true
        iconStack.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 0).isActive = true
        iconStack.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -CGFloat(bottomOffset)).isActive = true
        
        bgView.layer.mask = makeShape(topCorners: topCorners, bottomCorners: bottomCorners)
        
        setShadow(color: getAppColor(color: .shadow), radius: 8, opasity: 1)
        layer.shadowPath = makeShape(topCorners: topCorners, bottomCorners: bottomCorners).path
    }

    private func makeShape(topCorners tc : Int, bottomCorners bc : Int) -> CAShapeLayer {
        let shape = CAShapeLayer()
        
        let figure = UIBezierPath()
        print(self.frame.width)
        figure.move(to: CGPoint(x: tc, y: 0))
        figure.addLine(to: CGPoint(x: Int(self.frame.width) - tc, y: 0))
        figure.addArc(withCenter: CGPoint(x: Int(self.frame.width) - tc, y: tc), radius: CGFloat(tc), startAngle: -CGFloat.pi / 2, endAngle: 0, clockwise: true)
        
        figure.addLine(to: CGPoint(x: Int(self.frame.width), y: Int(self.frame.height) - bc))

         figure.addArc(withCenter: CGPoint(x: Int(self.frame.width) - bc, y: Int(self.frame.height) - bc), radius: CGFloat(bc), startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        
        figure.addLine(to: CGPoint(x: bc, y: Int(self.frame.height)))
        figure.addArc(withCenter: CGPoint(x: bc, y: Int(self.frame.height) - bc), radius: CGFloat(bc), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
        
        figure.addLine(to: CGPoint(x: 0, y: tc))
        figure.addArc(withCenter: CGPoint(x: tc, y: tc), radius: CGFloat(tc), startAngle: CGFloat.pi, endAngle: -CGFloat.pi / 2, clockwise: true)

        figure.close()
        
        shape.path = figure.cgPath
        return shape
    }
    
    @objc private func press(sender : UILongPressGestureRecognizer) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)

        switch sender.state {
        case .began:
            if iconStack.bounds.contains(sender.location(in: iconStack)) {
                pressSelect = Int((sender.location(in: iconStack).x / iconStack.bounds.width) * CGFloat(icons.count))
                UIView.animate(withDuration: 0.25, animations: {
                    self.iconStack.arrangedSubviews[self.pressSelect].transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                })
            }
            break
        case .changed:
            if iconStack.bounds.contains(sender.location(in: iconStack)) {
                let lastSelect = pressSelect
                pressSelect = Int((sender.location(in: iconStack).x / iconStack.bounds.width) * CGFloat(icons.count))
                if lastSelect != pressSelect {
                    
                    if lastSelect != -1 {
                        if lastSelect == select {
                            UIView.animate(withDuration: 0.25, animations: {
                                self.iconStack.arrangedSubviews[lastSelect].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            })
                        } else {
                            UIView.animate(withDuration: 0.25, animations: {
                                self.iconStack.arrangedSubviews[lastSelect].transform = CGAffineTransform(scaleX: 1, y: 1)
                            })
                        }
                    }
                    UIView.animate(withDuration: 0.25, animations: {
                        self.iconStack.arrangedSubviews[self.pressSelect].transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    })
                }
            } else {
                if pressSelect != -1 {
                    if pressSelect == select {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.iconStack.arrangedSubviews[self.pressSelect].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        })
                    } else {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.iconStack.arrangedSubviews[self.pressSelect].transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                    }
                    pressSelect = -1
                }
            }
            break
        case .ended:
             if iconStack.bounds.contains(sender.location(in: iconStack)) {
                if select != Int((sender.location(in: iconStack).x / iconStack.bounds.width) * CGFloat(icons.count)) {
                    
                    listener?.onSelectChange(select: Int((sender.location(in: iconStack).x / iconStack.bounds.width) * CGFloat(icons.count)), lastSelect: select)

                    UIView.animate(withDuration: 0.25, animations: {
                        self.iconStack.arrangedSubviews[self.select].transform = CGAffineTransform(scaleX: 1, y: 1)
                         (self.iconStack.arrangedSubviews[self.select] as! UIImageView).tintColor = getAppColor(color: .disable)
                    })
                    select = Int((sender.location(in: iconStack).x / iconStack.bounds.width) * CGFloat(icons.count))
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.iconStack.arrangedSubviews[self.select].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        (self.iconStack.arrangedSubviews[self.select] as! UIImageView).tintColor = getAppColor(color: .enable)
                    })
                } else {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.iconStack.arrangedSubviews[self.select].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    })
                }
             }
            break
            
        default:
            if pressSelect != -1 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.iconStack.arrangedSubviews[self.pressSelect].transform = CGAffineTransform(scaleX: self.pressSelect == self.select ? 1.2 : 1, y: self.pressSelect == self.select ? 1.2 : 1)
                    
                    (self.iconStack.arrangedSubviews[self.pressSelect] as! UIImageView).tintColor = self.pressSelect == self.select ? getAppColor(color: .enable) : getAppColor(color: .disable)
                })
            }
            break
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationView : UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        return UIPointerStyle(effect: .highlight(.init(view: interaction.view!)))
    }
}
