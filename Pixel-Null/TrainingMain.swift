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
    private var menus : [String] = ["Editor","Pencil", "Erase", "Transform","Gradient","Fill","Symmetry","Selection","Shape"]
        
    lazy private var titleTraining : UILabel = {
       let label = UILabel()
        label.font = UIFont(name:  "Rubik-Medium", size: 48)
        label.textColor = UIColor(named: "enableColor")
        label.text = "Training"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var table : UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        
        let head = UILabel()
        head.textColor = UIColor(named: "enableColor")
        head.translatesAutoresizingMaskIntoConstraints = false
        head.font = UIFont(name: "Rubik-Bold", size: 48)
        head.text = "Training"
        //head.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        let bgview = UIView()
        bgview.addSubviewFullSize(view: head, paddings: (16,0,8,0))
        bgview.frame.size = CGSize(width: 200, height: 76)
        
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Table")
        tv.register(TableTitle.self, forCellReuseIdentifier: "Title")
        tv.tableHeaderView = bgview
        
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
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
        cell.textLabel!.textColor = UIColor(named: "enableColor")
        cell.textLabel!.font = UIFont(name:  "Rubik-Regular", size: 16)
        cell.backgroundColor = UIColor(named: "disableColor")!.withAlphaComponent(0.25)
        cell.tintColor = UIColor(named: "enableColor")
        cell.selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor(named: "disableColor")!.withAlphaComponent(0.5)
            return view
        }()
                
        cell.accessoryView = {
            let img = UIImageView(image: #imageLiteral(resourceName: "next_icon").withTintColor(UIColor(named: "enableColor")!))
            img.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            return img
        }()
                
        
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = menus[1]
                case 1:
                cell.textLabel!.text = menus[2]
                case 2:
                cell.textLabel!.text = menus[3]
                case 3:
                cell.textLabel!.text = menus[4]
                case 4:
                cell.textLabel!.text = menus[5]
                case 5:
                cell.textLabel!.text = menus[6]
                case 6:
                cell.textLabel!.text = menus[7]
                case 7:
                cell.textLabel!.text = menus[8]
            default:
                break
            }
            case 0:
               switch indexPath.row {
               case 0:
                   cell.textLabel!.text = menus[0]
                   
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
            return 1
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
        myLabel.textColor = UIColor(named: "enableColor")
        
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
            case 2:
                let transform = TransformController()
                navigation?.pushViewController(transform, animated: true)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.setSelected(false, animated: true)
            case 6:
                let select = SelectionController()
                navigation?.pushViewController(select, animated: true)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.setSelected(false, animated: true)
            case 7:
                let shape = ShapeController()
                navigation?.pushViewController(shape, animated: true)
                
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

class TableTitle : UITableViewCell {
    lazy var title : UILabel = {
        let text = UILabel()
        text.textColor = UIColor(named: "enableColor")
        text.text = "Test"
        return text
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        title.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
