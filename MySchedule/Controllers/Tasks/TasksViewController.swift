//
//  TasksViewController.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 25.10.2021.
//

import UIKit
import FSCalendar
import RealmSwift

class TasksViewController: UIViewController {

    private var calendarHeightConstraint: NSLayoutConstraint!
        
    private var calendar: FSCalendar = {
       var calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    private let showHideButton: UIButton = {
       var button = UIButton()
        button.setTitle("Open calendar", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let idTasksCell = "idTasksCell"
    
    //REALM
    private let localRealm = try! Realm()
    private var tasksArray: Results<TasksModel>!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tasks"
        view.backgroundColor = .white
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scope = .week
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: idTasksCell)
        
        
        setConstraints()
        swipeAction()
        
        setTaskOnDate(date: calendar.today!)
        
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    //Selector 
    @objc private func addButtonTapped() {
        let tasksOption = TasksOptionsTableViewController()
        navigationController?.pushViewController(tasksOption, animated: true)
    }
    
    private func setTaskOnDate(date: Date) {
        
        let dateStart = date
        
        let dateEnd: Date = {
           
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: dateStart)!
        }()
        tasksArray = localRealm.objects(TasksModel.self).filter("tasksDate BETWEEN %@", [dateStart, dateEnd])
        tableView.reloadData()
    }
    
    //MARK: - Swipe
    private func swipeAction() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
                                                 
    }
    
    @objc private func handleSwipe(swipe: UISwipeGestureRecognizer) {
        switch swipe.direction {
        case .up: showHideButtonTapped()
        case .down: showHideButtonTapped()
        default: break
        }
    }
    @objc private func showHideButtonTapped() {
        
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
        } else {
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
        }
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idTasksCell, for: indexPath) as! TasksTableViewCell
        cell.cellTaskDelegate = self
        cell.index = indexPath
        let model = tasksArray[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editingRow = tasksArray[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _ , _ , completionHandler in
            RealmManager.shared.deleteTasksModel(model: editingRow)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: PressReadyTaskButtonProtocol

extension TasksViewController: PressReadyTaskButtonProtocol {
    func readyButtonTapped(indexPath: IndexPath) {
        
        let task = tasksArray[indexPath.row]
        RealmManager.shared.updateReadyButtonTaskModel(task: task, bool: !task.tasksReady)
        tableView.reloadData()
    }
}

//MARK: FSCalendarDelegate, FSCalendarDataSource

extension TasksViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded() //Для плавной анимации
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        setTaskOnDate(date: date)
    }
}

//MARK: SetConstraints

extension TasksViewController {
    
    func setConstraints() {
        
        //FSCalendar
        view.addSubview(calendar)
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        calendar.addConstraint(calendarHeightConstraint)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        
        //showHideButton
        view.addSubview(showHideButton)
        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            showHideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            showHideButton.heightAnchor.constraint(equalToConstant: 20),
            showHideButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        //TableView
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}


