//
//  ScheduleViewController.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 25.10.2021.
//

import UIKit
import FSCalendar
import RealmSwift

class ScheduleViewController: UIViewController {

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
    
    private let idScheduleCell = "isScheduleCell"

    //MARK: - REALM
    let localRealm = try! Realm()
    var scheduleArray: Results<ScheduleModel>!
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: = viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Schedule"
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: idScheduleCell)
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.scope = .week
        
        setConstraints()
        swipeAction()
        scheduleOnDate(date: Date())
        
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        if #available(iOS 15.0, *) {
        navigationController?.tabBarController?.tabBar.scrollEdgeAppearance = navigationController?.tabBarController?.tabBar.standardAppearance
        }
    }
    
    @objc private func addButtonTapped() {
        
        let scheduleOptions = ScheduleOptionsTableViewController()
        navigationController?.pushViewController(scheduleOptions, animated: true) 
    }
    
    //Swipe
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
    
    func scheduleOnDate(date: Date) {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        guard let weekday = components.weekday else { return }
        //        print(weekday)
        
        let startDate = date
        let endDate: Date = {
            
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: startDate)!
        }()
        
        let predicateRepeat = NSPredicate(format: "scheduleWeekday = \(weekday) AND scheduleRepeat = true")
        let predicateNotRepeat = NSPredicate(format: "scheduleRepeat = false AND scheduleDate BETWEEN %@", [startDate, endDate])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateNotRepeat])
        
        scheduleArray = localRealm.objects(ScheduleModel.self).filter(compound).sorted(byKeyPath: "scheduleTime")
        tableView.reloadData()
    }
}
    


//MARK: UITableViewDataSource, UITableViewDelegate

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idScheduleCell, for: indexPath) as! ScheduleTableViewCell
        let model = scheduleArray[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editingRow = scheduleArray[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            RealmManager.shared.deleteScheduleModel(model: editingRow)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: FSCalendarDelegate, FSCalendarDataSource

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded() //Для плавной анимации
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       scheduleOnDate(date: date)
    }
}

//MARK: SetConstraints

extension ScheduleViewController {
    
    func setConstraints() {
        //Calendar
        view.addSubview(calendar)
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        calendar.addConstraint(calendarHeightConstraint)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        
        //ShowHideButton
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
