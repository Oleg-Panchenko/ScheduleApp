//
//  TasksTableViewCell.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 07.11.2021.
//

import UIKit

class TasksTableViewCell : UITableViewCell {
    
    let taskName = UILabel(text: "Программирование", font: .avenirNextDemiBold20()!)
    let taskDescription = UILabel(text: "Научиться писать extension и правильно применять их", font: .avenirNext14()!)
    
    let readyButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //cellTaskDelegate
    weak var cellTaskDelegate: PressReadyTaskButtonProtocol?
    var index: IndexPath?
    
    //init()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        taskDescription.numberOfLines = 2
        
        setConstraints()
        
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Selector
    @objc func readyButtonTapped() {
        guard let index = index else { return }
        cellTaskDelegate?.readyButtonTapped(indexPath: index)
    }
    
    func configure(model: TasksModel) {
            
        taskName.text = model.tasksName
        taskDescription.text = model.tasksDescription
        backgroundColor = UIColor().colorFromHex(model.tasksColor)
        
        if model.tasksReady {
            readyButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        } else {
            readyButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
        }
    }
    
    //Constraints
    func setConstraints() {
        
        self.contentView.addSubview(readyButton)
        NSLayoutConstraint.activate([
            readyButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            readyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 40),
            readyButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        self.contentView.addSubview(taskName)
        NSLayoutConstraint.activate([
            taskName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            taskName.trailingAnchor.constraint(equalTo: readyButton.leadingAnchor, constant: -5),
            taskName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            taskName.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        self.contentView.addSubview(taskDescription)
        NSLayoutConstraint.activate([
            taskDescription.topAnchor.constraint(equalTo: taskName.bottomAnchor, constant: 5),
            taskDescription.trailingAnchor.constraint(equalTo: readyButton.leadingAnchor, constant: -5),
            taskDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            taskDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        
    }
}
