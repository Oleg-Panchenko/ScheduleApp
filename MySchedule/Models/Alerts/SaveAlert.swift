//
//  SavedAlert.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 27.11.2021.
//

import UIKit

extension UIViewController {
    
    func saveAlert(title: String, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
   
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
}
