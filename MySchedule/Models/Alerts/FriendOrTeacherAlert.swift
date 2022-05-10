//
//  FriendOrTeacherAlert.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 19.11.2021.
//

import UIKit

extension UIViewController {
    
    func friendOrTeacherAlert(label: UILabel, completionHandler: @escaping (String) -> Void ) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //Friend
        let friend = UIAlertAction(title: "Friend", style: .default) { _ in
            
            label.text = "Friend"
            let typeContact = "Friend"
            completionHandler(typeContact)
        }
        
        //Teacher
        let teacher = UIAlertAction(title: "Teacher", style: .default) { _ in
            
            label.text = "Teacher"
            let typeContact = "Teacher"
            completionHandler(typeContact)
        }
        
        //Cancel
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alertController.negativeWidthConstraint()
        
        alertController.addAction(friend)
        alertController.addAction(teacher)
        alertController.addAction(cancel)

        present(alertController, animated: true, completion: nil)
        
    }
    
}
