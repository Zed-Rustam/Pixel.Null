//
//  MainSettingsMenu.swift
//  new Testing
//
//  Created by Рустам Хахук on 12.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit


class MainSettingsMenu : UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var navigation : UINavigationController? = nil

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Table")!
        cell.textLabel!.textColor = getAppColor(color: .enable)
        cell.textLabel!.font = UIFont(name:  "Rubik-Regular", size: 16)
        cell.backgroundColor = getAppColor(color: .disable).withAlphaComponent(0.25)
        cell.tintColor = getAppColor(color: .enable)
        cell.selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = getAppColor(color: .disable).withAlphaComponent(0.5)
            return view
        }()
                
        cell.accessoryView = {
            let img = UIImageView(image: #imageLiteral(resourceName: "next_icon").withTintColor(getAppColor(color: .enable)))
            img.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            return img
        }()
        
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = settings[0]
            case 1:
                cell.textLabel!.text = settings[1]
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = settings[2]
            case 1:
                cell.textLabel!.text = settings[3]
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = settings[4]
            case 1:
                cell.textLabel!.text = settings[5]
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "APP"
        case 1:
            return "EDITOR"
        case 2:
            return "MORE"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 0, width: 200, height: 24)
        myLabel.font = UIFont(name:  "Rubik-Bold", size: 14)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        myLabel.textColor = UIColor(named: "enableColor")
        
        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let themeSelect = ThemeSelect()
        navigation?.pushViewController(themeSelect, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
    }
    
    let settings : [String] = ["App theme", "Language", "Tool bar", "Undo / Redo","About","Contacts"]
    
    
    lazy private var icon : UIImageView = {
       let img = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
        img.contentMode = .scaleToFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 72).isActive = true
        img.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        return img
    }()
    
    override func viewDidLayoutSubviews() {
        icon.setShadow(color: getAppColor(color: .shadow), radius: 4, opasity: 1)
    }
    
    lazy private var appTitle : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        label.text = "Pixel.Null"
        
        label.textColor = getAppColor(color: .enable)
        label.textAlignment = .center
        label.font = UIFont(name:  "Rubik-Bold", size: 36)
        
        return label
    }()
    
    lazy private var table : UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Table")
        tv.separatorStyle = .none
        tv.tintColor = getAppColor(color: .enable).withAlphaComponent(0.5)
        //tv.isScrollEnabled = false
        
        tv.tableHeaderView = tableTitle
        
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    lazy private var tableTitle : UIView = {
        let bgview = UIView()
        bgview.addSubview(icon)
        bgview.addSubview(appTitle)
        
        
        icon.centerXAnchor.constraint(equalTo: bgview.centerXAnchor, constant: 0).isActive = true
        icon.topAnchor.constraint(equalTo: bgview.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        appTitle.leftAnchor.constraint(equalTo: bgview.leftAnchor, constant: 12).isActive = true
        appTitle.rightAnchor.constraint(equalTo: bgview.rightAnchor, constant: -12).isActive = true
        appTitle.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 0).isActive = true
        
        bgview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 132)
        return bgview
    }()
    
    
    override func viewDidLoad() {
        
        view.addSubview(table)
    
        table.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        table.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}
