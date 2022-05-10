//
//  OptionsScheduleViewController.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 12.11.2021.
//

import UIKit

class ScheduleOptionsTableViewController: UITableViewController {
    
    private let idOptionsScheduleCell = "idOptionsScheduleCell"
    private let idOptionsScheduleHeader = "idOptionsScheduleHeader"
        
    let headerNameArray = ["DATE AND TIME", "LESSON", "TEACHER", "COLOR", "PERIOD"]
    
    var cellNameArray = [["Date", "Time"],
                         ["Name", "Type", "Building", "Auditorium"],
                         ["Teacher name"],
                         [""],
                         ["Repeat every 7 days"]]
    
    var hexColorCell = "1A1679"
    
    //ScheduleModel
    var scheduleModel = ScheduleModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options Schedule"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.9594197869, green: 0.9599153399, blue: 0.975127399, alpha: 1)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: idOptionsScheduleCell)
        tableView.register(HeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: idOptionsScheduleHeader)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))

    }
    
    @objc private func saveButtonTapped() {
        
        if scheduleModel.scheduleDate == nil || scheduleModel.scheduleTime == nil || scheduleModel.scheduleName == "Unknown" {
            saveAlert(title: "Warning!", message: "Fill DATE, TIME, NAME fields")
        } else {
            scheduleModel.scheduleColor = hexColorCell
            RealmManager.shared.saveScheduleModel(model: scheduleModel)
            scheduleModel = ScheduleModel()
            saveAlert(title: "Success", message: nil)
            hexColorCell = "1A1679"
            cellNameArray[2][0] = "Teacher name"
            //        tableView.reloadRows(at: [[0,0],[0,1],[1,0],[1,1],[1,2],[1,3],[2,0]], with: .none)
            tableView.reloadData()
            print(hexColorCell)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 4
        case 2: return 1
        case 3: return 1
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idOptionsScheduleCell, for: indexPath) as! OptionsTableViewCell
        cell.cellScheduleConfigure(nameArray: cellNameArray, indexPath: indexPath, hexColor: hexColorCell)
        cell.switchRepeatDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idOptionsScheduleHeader) as! HeaderTableViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        switch indexPath {
        case [0,0]: dateAlert(label: cell.nameCellLabel) { (numberWeekday, date) in
            self.scheduleModel.scheduleDate = date
            self.scheduleModel.scheduleWeekday = numberWeekday
        }
        case [0,1]: timeAlert(label: cell.nameCellLabel) { (timeSchedule) in
            self.scheduleModel.scheduleTime = timeSchedule
        }
        case [1,0]: cellNameAlert(label: cell.nameCellLabel, name: "Name Lesson", placeholder: "Enter name lesson") { name in
            self.scheduleModel.scheduleName = name
        }
        case [1,1]: cellNameAlert(label: cell.nameCellLabel, name: "Type Lesson", placeholder: "Enter type lesson") { type in
            self.scheduleModel.scheduleType = type
        }
        case [1,2]: cellNameAlert(label: cell.nameCellLabel, name: "Building number", placeholder: "Enter number of building") { building in
            self.scheduleModel.scheduleBuilding = building
        }
        case [1,3]: cellNameAlert(label: cell.nameCellLabel, name: "Auditorium number", placeholder: "Enter number of auditorium") { auditorium in
            self.scheduleModel.scheduleAuditorium = auditorium
        }
        case [2,0]: pushControllers(vc: TeachersTableViewController())
        case [3,0]: pushControllers(vc: ScheduleColorsViewController())
        default: print("Tap OptionsTableView")
        }
    }
    
    func pushControllers(vc: UIViewController) {
        let viewController = vc
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ScheduleOptionsTableViewController: SwitchRepeatProtocol {
    func switchRepeat(value: Bool) {
        scheduleModel.scheduleRepeat = value
    }
}
