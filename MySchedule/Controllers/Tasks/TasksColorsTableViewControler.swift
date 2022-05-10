//
//  TasksColorTableViewControler.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 17.11.2021.
//

import UIKit

class TasksColorsTableViewControler: UITableViewController {
    
    private let idTasksColorCell = "idTasksColorCell"
    private let idTasksColorHeader = "idTasksColorHeader"
        
    let headerNameArray = ["RED", "ORANGE", "YELLOW", "GREEN", "BLUE", "DEEP BLUE", "PURPLE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Colors Tasks"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.9594197869, green: 0.9599153399, blue: 0.975127399, alpha: 1)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(ColorsTableViewCell.self, forCellReuseIdentifier: idTasksColorCell)
        tableView.register(HeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: idTasksColorHeader)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idTasksColorCell, for: indexPath) as! ColorsTableViewCell
        cell.cellConfigure(indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idTasksColorHeader) as! HeaderTableViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: setColor(color: "851C0D")
        case 1: setColor(color: "EF5931")
        case 2: setColor(color: "F3AF22")
        case 3: setColor(color: "467C24")
        case 4: setColor(color: "2D7FC1")
        case 5: setColor(color: "1A1679")
        case 6: setColor(color: "9828DE")
        default: setColor(color: "246590")
        }
    }
    
    private func setColor(color: String) {
        let tasksOptions = self.navigationController?.viewControllers[1] as? TasksOptionsTableViewController
        tasksOptions?.hexColorCell = color
        tasksOptions?.navigationController?.popViewController(animated: true)
        tasksOptions?.tableView.reloadRows(at: [[3,0]], with: .none)
    }
}

