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
        cell.textLabel!.textColor = ProjectStyle.uiEnableColor
        cell.textLabel!.font = UIFont(name:  "Rubik-Regular", size: 16)
        cell.backgroundColor = ProjectStyle.uiDisableColor.withAlphaComponent(0.25)
        cell.tintColor = ProjectStyle.uiEnableColor
        cell.selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = ProjectStyle.uiDisableColor.withAlphaComponent(0.5)
            return view
        }()
                
        cell.accessoryView = {
            let img = UIImageView(image: #imageLiteral(resourceName: "next_icon").withTintColor(ProjectStyle.uiEnableColor))
            img.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            return img
        }()
        
        print("\(indexPath.section)   \(indexPath.row)   \(indexPath.row)")
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = settings[0]
            case 1:
                cell.textLabel!.text = settings[1]
            case 2:
                cell.textLabel!.text = settings[2]
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = settings[3]
            case 1:
                cell.textLabel!.text = settings[4]
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = settings[5]
            case 1:
                cell.textLabel!.text = settings[6]
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("i'm alive!")
        switch section {
        case 0:
            return 3
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
        myLabel.textColor = ProjectStyle.uiEnableColor
        
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
    
    let settings : [String] = ["App theme", "Language" ,"iCloud synchronization", "Tool bar", "Undo / Redo","About","Contacts"]
    
    
    lazy private var icon : UIImageView = {
       let img = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
        img.contentMode = .scaleToFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 108).isActive = true
        img.heightAnchor.constraint(equalToConstant: 108).isActive = true
        
        return img
    }()
    
    lazy private var appTitle : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        label.text = "Pixel.Null"
        
        label.textColor = ProjectStyle.uiEnableColor
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
        tv.tintColor = ProjectStyle.uiEnableColor.withAlphaComponent(0.5)
        tv.isScrollEnabled = false
        
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    
    override func viewDidLoad() {
        
        //navigationBar.isHidden = true
        view.addSubview(icon)
        view.addSubview(appTitle)
        view.addSubview(table)
        
        icon.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        
        appTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        appTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        appTitle.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: -16).isActive = true
        
        table.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        table.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: 8).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true


        view.backgroundColor = ProjectStyle.uiBackgroundColor
    }
}
