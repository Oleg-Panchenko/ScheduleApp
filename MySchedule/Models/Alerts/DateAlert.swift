//
//  DateAlert.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 14.11.2021.
//

import UIKit

extension UIViewController {
    
    func dateAlert(label: UILabel, completionHandler: @escaping (Int, Date) -> Void) {
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.locale = Locale(from: "ru_RU")
        
        alert.view.addSubview(datePicker)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: datePicker.date)
            
            let calendar = Calendar.current
            let component = calendar.dateComponents([.weekday], from: datePicker.date)
            guard let weekDay = component.weekday else { return }
            let numberWeekday = weekDay
            let date = datePicker.date
            completionHandler(numberWeekday, date)
            
            label.text = dateString
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        alert.negativeWidthConstraint()
        
        //alertConstraints
        alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        //datePicker constraints
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 160).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
        
        
        present(alert, animated: true, completion: nil)
    }
}
