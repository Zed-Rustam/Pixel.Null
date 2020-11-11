//
//  ProjectViewNew.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 18.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectViewNew : UIView {
    weak var delegate : ProjectActions? = nil

    var project : ProjectWork? {
        get{
            return _project
        }
        
        set{
            _project = newValue
            contentImage.backgroundColor = _project!.backgroundColor
            contentImage.image = _project?.getFrame(frame: 0, size: _project!.projectSize).flip(xFlip: _project!.isFlipX, yFlip: _project!.isFlipY)
        }
    }
    
    var projectName : String {
        get{
            var name = _project!.projectName
            name.removeLast(6)
            return name
        }
    }
    
    private var _project : ProjectWork? = nil
    
    lazy private var bg : UIImageView = {
       let image = UIImageView(image: #imageLiteral(resourceName: "background"))
        image.layer.magnificationFilter = .nearest
        image.contentMode = .scaleAspectFill
        
        image.addSubviewFullSize(view: contentImage)
        return image
    }()
    
    lazy private var contentImage : UIImageView = {
       let image = UIImageView()
        image.layer.magnificationFilter = .nearest
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy private var pointer: UIPointerInteraction = {
        let point = UIPointerInteraction(delegate: self)
        
        return point
    }()
        
    init(){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviewFullSize(view: bg)

        isUserInteractionEnabled = true
        interactions.append(pointer)

        addInteraction(UIContextMenuInteraction(delegate: self))
        
        setCorners(corners: 12, needMask: true, curveType: .continuous)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProjectViewNew : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: {() -> UIViewController? in
            let image = ProjectFullImage()
            image.setProject(proj: self.project!)
            return image
            }
        ){ action in
            let rotate = UIAction(title: "Clone",image  : UIImage(systemName: "plus.square.on.square", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, handler: {action in
                if(self.delegate != nil) {
                    self.delegate!.projectDublicate(view: self)
                }
            })
            let getimg = UIAction(title: "Share", image : UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)),identifier: nil, discoverabilityTitle: nil, handler: {action in
                self.delegate?.projectExport(proj: self._project!)
            })
            let delete = UIAction(title: "Delete",image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                if(self.delegate != nil) {
                    self.delegate!.projectDelete(view: self, deletedName: "\(self.projectName).pnart")
                }
            })
            let delMenu = UIMenu(title: "Delete", image : UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), identifier: nil, options : .destructive, children: [delete])
            
            let edit = UIMenu(title: "", options: .displayInline, children: [delMenu])
            
            return UIMenu(title: self.projectName, image: nil, identifier: nil, children: [rotate,getimg,edit])
        }
        
        return configuration
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        animator?.addAnimations {
            
        }
    }
}

extension ProjectViewNew : UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        return UIPointerStyle(effect: .lift(UITargetedPreview(view: self)))
    }
}
