//
//  LayersTable.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 02.06.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit
class LayersTable : UITableView {
    weak private var project : ProjectWork? = nil

    init() {
        super.init(frame: .zero, style: .plain)

        register(LayerTableCell.self, forCellReuseIdentifier: "Layer")
        dataSource = self
        delegate = self
        rowHeight = 42
        backgroundColor = .clear
        separatorStyle = .none
        dragInteractionEnabled = true
        dragDelegate = self
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LayersTable : UITableViewDelegate {

}

extension LayersTable : UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let cell = cellForRow(at: indexPath) as! LayerTableCell
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.itemProvider.accessibilityPath = UIBezierPath(rect: cell.bg.frame)
        
        item.previewProvider = {
            return UIDragPreview(view: cell)
        }
        
        return [item]
    }
}


extension LayersTable : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) {_,_,_ in
        
        }
        
        delete.image = #imageLiteral(resourceName: "delete_swipe_icon")
        delete.backgroundColor = getAppColor(color: .red)
        
        let clone = UIContextualAction(style: .normal, title: nil) {_,_,_ in
            
        }
        clone.image = #imageLiteral(resourceName: "clone_swipe_icon").withTintColor(getAppColor(color: .enable))
        clone.backgroundColor = getAppColor(color: .background)
        
        let clone2 = UIContextualAction(style: .normal, title: nil) {_,_,_ in
            
        }
        clone2.image = #imageLiteral(resourceName: "clone_swipe_icon").withTintColor(getAppColor(color: .enable))
        clone2.backgroundColor = getAppColor(color: .background)
        
        let config = UISwipeActionsConfiguration(actions: [delete,clone,clone2])
        
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "Layer", for: indexPath) as! LayerTableCell
        cell.backgroundColor = .clear
        return cell
    }
}
