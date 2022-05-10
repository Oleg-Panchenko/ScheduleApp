//
//  TeachersViewController.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 15.11.2021.
//

import UIKit
import RealmSwift

class TeachersTableViewController: UITableViewController {

    private let localRealm = try! Realm()
    private var contactsArray: Results<ContactsModel>!
    private let teacherId = "teacherId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Teachers"
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: teacherId)
        
        contactsArray = localRealm.objects(ContactsModel.self).filter("contactsType = 'Teacher'")
    }
    
    private func setTeacher(teacher: String) {
        let schedule = self.navigationController?.viewControllers[1] as? ScheduleOptionsTableViewController
        schedule?.scheduleModel.scheduleTeacher = teacher
        schedule?.cellNameArray[2][0] = teacher
        schedule?.tableView.reloadRows(at: [[2,0]], with: .none)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: teacherId, for: indexPath) as! ContactsTableViewCell
        let model = contactsArray[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = contactsArray[indexPath.row]
        setTeacher(teacher: model.contactsName)
    }
}

