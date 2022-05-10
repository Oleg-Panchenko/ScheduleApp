//
//  PhotoCameraAlert.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 20.11.2021.
//

import UIKit

extension UIViewController {
    
    func photoCameraAlert(completionHandler: @escaping (UIImagePickerController.SourceType) -> Void ) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //Friend
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            
            let camera = UIImagePickerController.SourceType.camera
            completionHandler(camera)
        }
        
        //Teacher
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
            
            let photoLibrary = UIImagePickerController.SourceType.photoLibrary
            completionHandler(photoLibrary)
        }
        
        //Cancel
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alertController.negativeWidthConstraint()
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)

        present(alertController, animated: true, completion: nil)
        
    }
    
}
