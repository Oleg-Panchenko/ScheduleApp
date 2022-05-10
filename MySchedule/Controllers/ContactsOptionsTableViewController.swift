//
//  ContactsOptionTableViewController.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 18.11.2021.
//

import UIKit

class ContactsOptionsTableViewController: UITableViewController {
    
    private let idOptionsContactCell = "idOptionsContactCell"
    private let idOptionsContactHeader = "idOptionsContactHeader"
        
    private let headerNameArray = ["NAME", "PHONE", "MAIL", "TYPE", "CHOOSE IMAGE"]
    
    var cellNameArray = ["Name", "Phone", "Mail", "Type", ""]
    
    var isImageChanged = false
    var contactsModel = ContactsModel()
    var editModel = false
    var dataImage: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options Contacts"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.9594197869, green: 0.9599153399, blue: 0.975127399, alpha: 1)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: idOptionsContactCell)
        tableView.register(HeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: idOptionsContactHeader)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveContactsButton))
        
    }
    
    @objc private func saveContactsButton() {
        
        if cellNameArray[0] == "Name" || cellNameArray[3] == "Type" {
            saveAlert(title: "Warning!", message: "Fill DATE, TYPE fields")
        } else if editModel == false {
            setImageModel()
            setModel()
            RealmManager.shared.saveContactsModel(model: contactsModel)
            contactsModel = ContactsModel()
            cellNameArray = ["Name", "Phone", "Mail", "Type", ""]
            
            saveAlert(title: "Success", message: nil)
            tableView.reloadData()
        } else {
            setImageModel()
            RealmManager.shared.updateModel(model: contactsModel, nameArray: cellNameArray, imageData: dataImage!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setModel() {
        
        contactsModel.contactsName = cellNameArray[0]
        contactsModel.contactsPhone = cellNameArray[1]
        contactsModel.contactsMail = cellNameArray[2]
        contactsModel.contactsType = cellNameArray[3]
        contactsModel.contactsImage = dataImage
    }
    
    @objc private func setImageModel() {
        
        if isImageChanged {
            let cell = tableView.cellForRow(at: [4,0]) as? OptionsTableViewCell
            
            let image = cell?.backgroundViewCell.image
            guard let imageData = image?.pngData() else { return }
            dataImage = imageData
            
            cell?.backgroundViewCell.contentMode = .scaleAspectFit
            isImageChanged = false
        } else {
            dataImage = nil
        }
    }
    
    func pushControllers(vc: UIViewController) {
        let viewController = vc
        navigationController?.navigationBar.topItem?.title = "Options"
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idOptionsContactCell, for: indexPath) as! OptionsTableViewCell
        if editModel == false {
            cell.cellContactsConfigure(nameArray: cellNameArray, indexPath: indexPath, image: nil)
        } else if let data = contactsModel.contactsImage, let image = UIImage(data: data) {
            cell.cellContactsConfigure(nameArray: cellNameArray, indexPath: indexPath, image: image)
        } else {
            cell.cellContactsConfigure(nameArray: cellNameArray, indexPath: indexPath, image: nil)
        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 4 ? 200 : 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: idOptionsContactHeader) as! HeaderTableViewCell
        header.headerConfigure(nameArray: headerNameArray, section: section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        
        switch indexPath.section {
        case 0: cellNameAlert(label: cell.nameCellLabel, name: "Name Contact", placeholder: "Enter name contact") { text in
//            self.contactsModel.contactsName = text
            self.cellNameArray[0] = text
        }
        case 1: cellNameAlert(label: cell.nameCellLabel, name: "Phone Contact", placeholder: "Enter phone contact") { text in
//            self.contactsModel.contactsPhone = text
            self.cellNameArray[1] = text
        }
        case 2: cellNameAlert(label: cell.nameCellLabel, name: "Mail Contact", placeholder: "Enter mail contact") { text in
//            self.contactsModel.contactsMail = text
            self.cellNameArray[2] = text
        }
        case 3: friendOrTeacherAlert(label: cell.nameCellLabel, completionHandler: { typeContact in
//            self.contactsModel.contactsType = typeContact
            self.cellNameArray[3] = typeContact
        })
        case 4: photoCameraAlert { source in
            self.chooseImagePicker(source: source)
        }
        default: print("Tap ContactTableView")
        }
    }
    
   
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ContactsOptionsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let cell = tableView.cellForRow(at: [4,0]) as! OptionsTableViewCell
        
        cell.backgroundViewCell.image = info[.editedImage] as? UIImage
        cell.backgroundViewCell.contentMode = .scaleAspectFill
        cell.backgroundViewCell.clipsToBounds = true
        isImageChanged = true
        dismiss(animated: true)
    }
    
}
