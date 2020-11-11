//
//  IpadMainNavigation.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 30.10.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class IpadMainNavigation: UINavigationController {
    let controller = IpadMenusController()
    override func viewDidLoad() {
        navigationBar.prefersLargeTitles = true
 
        let option = UINavigationBarAppearance()
        option.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        option.backgroundColor = getAppColor(color: .background).withAlphaComponent(0.75)
        
        option.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: UIFont.appBlack, size: 42)!, NSAttributedString.Key.foregroundColor: getAppColor(color: .enable)]
        option.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: UIFont.appBlack, size: 20)!, NSAttributedString.Key.foregroundColor: getAppColor(color: .enable)]
        navigationBar.standardAppearance = option
        
        pushViewController(controller, animated: false)
    }
}

class IpadMenusController: UIViewController {
    
    weak var delegate: NavigationProtocol? = nil
    
    private var menus: [String] = ["Gallery", "Palettes", "Settings"]
    
    lazy private var table: UITableView = {
        let tbl = UITableView()
        
        tbl.separatorStyle = .none
        tbl.register(MenuTitleCell.self, forCellReuseIdentifier: "Menu")
        tbl.backgroundColor = getAppColor(color: .background)
        
        tbl.rowHeight = 48
        
        tbl.dataSource = self
        tbl.delegate = self
        
        tbl.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        
        return tbl
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = getAppColor(color: .background)
        
        navigationItem.title = "Nano Art"
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubviewFullSize(view: table,paddings: (12,-12,0,0))
        
        table.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
    }
}

extension IpadMenusController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath) as! MenuTitleCell
        cell.backgroundColor = getAppColor(color: .background)
        cell.Title.text = menus[indexPath.item]
        
        return cell
    }
}

extension IpadMenusController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onSelectChange(select: indexPath.item, lastSelect: 0)
    }
}
