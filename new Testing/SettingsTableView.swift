//
//  SettingsTableView.swift
//  new Testing
//
//  Created by Рустам Хахук on 11.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class SettingsTableView : UITableView {
    var menus : [String] = []
    
        
    init(frame: CGRect, style: UITableView.Style, labels : [String]) {
        super.init(frame: frame, style: style)
        menus = labels
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = ProjectStyle.uiBackgroundColor
        separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TableCell : UITableViewCell {
    
}
