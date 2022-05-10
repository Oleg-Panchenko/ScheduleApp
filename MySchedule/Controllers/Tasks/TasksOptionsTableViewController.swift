//
//  TaskOptionTableViewController.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 16.11.2021.
//

import UIKit

class TasksOptionsTableViewController: UITableViewController {
    
    private let idOptionsTasksCell = "idOptionsTasksCell"
    private  let idOptionsTasksHeader = "idOptionsTasksHeader"
        
    let headerNameArray = ["DATE", "LESSON", "TASK", "COLOR", ""]
    
    let cellNameArray = ["Date", "Lesson", "Task", ""]
    
    var hexColorCell = "1A1679"
    
    private var tasksModel = TasksModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options Tasks "
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.9594197869, green: 0.9599153399, blue: 0.975127399, alpha: 1)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: idOptionsTasksCell)
        tableView.register(HeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: idOptionsTasksHeader)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTasksButton))
    }
    
    @objc private func saveTasksButton() {
        
        if tasksModel.tasksDate == nil || tasksModel.tasksName == "Unknown" {
            saveAlert(title: "Warning!", message: "Fill DATE, NAME fields")
        } else {
            tasksModel.tasksColor = hexColorCell
            RealmManager.shared.saveTasksModel(model: tasksModel)
            tasksModel = TasksModel()
            saveAlert(title: "Success", message: nil)
            hexColorCell = "1A1679"
            tableView.reloadData()
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idOptionsTasksCell, for: indexPath) as! OptionsTableViewCell
        cell.cellTasksConfigure(nameArray: cellNameArray, indexPath: indexPath, hexColor: hexColorCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idOptionsTasksHeader) as! HeaderTableViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        switch indexPath.section {
        case 0: dateAlert(label: cell.nameCellLabel) { (numberWeekday, date) in
            self.tasksModel.tasksDate = date
        }
        case 1: cellNameAlert(label: cell.nameCellLabel, name: "Name Lesson", placeholder: "Enter name lesson") { text in
            self.tasksModel.tasksName = text
        }
        case 2: cellNameAlert(label: cell.nameCellLabel, name: "Name Task", placeholder: "Enter name task") { text in
            self.tasksModel.tasksDescription = text
        }
        case 3: pushControllers(vc: TasksColorsTableViewControler())
        default: print("Tap OptionsTableView")
        }
    }
    
    func pushControllers(vc: UIViewController) {
        let viewController = vc
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}
