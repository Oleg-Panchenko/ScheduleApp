//
//  CellNameAlert.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 15.11.2021.
//

import UIKit

extension UIViewController {
    
    func cellNameAlert(label: UILabel, name: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let textFieldAlert = alert.textFields?.first
            guard let text = textFieldAlert?.text else { return }
            label.text = (!text.isEmpty ? text : label.text)
            completionHandler(text)
        }
        
        alert.addTextField { (textFieldAlert) in
            
            textFieldAlert.placeholder = placeholder
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
