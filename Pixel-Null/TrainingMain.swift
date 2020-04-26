//
//  TrainingMain.swift
//  new Testing
//
//  Created by Рустам Хахук on 13.04.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit


class TrainingMain : UIViewController {
    weak var navigation : UINavigationController? = nil
    private var menus : [String] = ["Editor","Layers","Frames","Pencil", "Erase", "Transform","Gradient","Fill","Symmetry","Selection","Square"]
    
    lazy private var scroll : UIScrollView = {
        let scr = UIScrollView()
        scr.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .top
        stack.distribution = .equalCentering
        
        scr.addSubview(stack)
        stack.leftAnchor.constraint(equalTo: scr.leftAnchor, constant: 0).isActive = true
        stack.rightAnchor.constraint(equalTo: scr.rightAnchor, constant: 0).isActive = true
        stack.topAnchor.constraint(equalTo: scr.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        stack.bottomAnchor.constraint(equalTo: scr.bottomAnchor, constant: 0).isActive = true
        
        stack.addArrangedSubview(table)
        table.heightAnchor.constraint(equalToConstant: 300).isActive = true

        return scr
    }()
    
    lazy private var titleTraining : UILabel = {
       let label = UILabel()
        label.font = UIFont(name:  "Rubik-Medium", size: 48)
        label.textColor = ProjectStyle.uiEnableColor
        label.text = "Training"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var table : UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Table")
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = ProjectStyle.uiBackgroundColor
        
        view.addSubview(table)
        
        table.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        table.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

extension TrainingMain : UITableViewDelegate, UITableViewDataSource {
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
                
        
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = menus[3]
                case 1:
                cell.textLabel!.text = menus[4]
                case 2:
                cell.textLabel!.text = menus[5]
                case 3:
                cell.textLabel!.text = menus[6]
                case 4:
                cell.textLabel!.text = menus[7]
                case 5:
                cell.textLabel!.text = menus[8]
                case 6:
                cell.textLabel!.text = menus[9]
                case 7:
                cell.textLabel!.text = menus[10]
            default:
                break
            }
            case 0:
               switch indexPath.row {
               case 0:
                   cell.textLabel!.text = menus[0]
                   case 1:
                   cell.textLabel!.text = menus[1]
                   case 2:
                   cell.textLabel!.text = menus[2]
                   
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
            return 8
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "EDITOR STRUCTURE"
        case 1:
            return "TOOLS"
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
        return 2
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                let editor = EditorController()
                navigation?.pushViewController(editor, animated: true)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.setSelected(false, animated: true)
            default:
                break
            }
        case 1:
            switch indexPath.item {
            case 0:
                let pencil = PencilController()
                navigation?.pushViewController(pencil, animated: true)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.setSelected(false, animated: true)
            case 1:
               let eraser = EraseController()
               navigation?.pushViewController(eraser, animated: true)
               
               let cell = tableView.cellForRow(at: indexPath)
               cell?.setSelected(false, animated: true)
                
            case 6:
                let select = SelectionController()
                navigation?.pushViewController(select, animated: true)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.setSelected(false, animated: true)
                
            case 4:
                let fill = FillController()
                navigation?.pushViewController(fill, animated: true)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.setSelected(false, animated: true)
            case 5:
                let symmetry = SymmetryController()
                navigation?.pushViewController(symmetry, animated: true)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.setSelected(false, animated: true)
            case 3:
                let gradient = GradientController()
                navigation?.pushViewController(gradient, animated: true)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.setSelected(false, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
}
