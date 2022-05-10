//
//  ContactsTableViewController.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 18.11.2021.
//

import UIKit
import RealmSwift

class ContactsViewController: UIViewController {
    
   
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Friends", "Teachers"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = #colorLiteral(red: 0.9594197869, green: 0.9599153399, blue: 0.975127399, alpha: 1)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private let searchController = UISearchController()
    
    private let idContactsCell = "idOptionsTasksCell"
    
    private let localRealm = try! Realm()
    private var contactsArray: Results<ContactsModel>!
    private var filteredArray: Results<ContactsModel>!
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return true }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        view.backgroundColor = .white
        
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        contactsArray = localRealm.objects(ContactsModel.self).filter("contactsType = 'Friend'")
        
        tableView.dataSource = self
        tableView.delegate = self
        
//        tableView.bounces = false
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: idContactsCell)
        
        setConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged (target: UISegmentedControl) {
        if self.segmentedControl == target {
            
            let segmentedIndex = target.selectedSegmentIndex
            if segmentedIndex == 0 {
                contactsArray = localRealm.objects(ContactsModel.self).filter("contactsType = 'Friend'")
                tableView.reloadData()
            } else {
                contactsArray = localRealm.objects(ContactsModel.self).filter("contactsType = 'Teacher'")
                tableView.reloadData()
            }
        }
     }
    
    @objc private func addButtonTapped() {
        let contactOptions = ContactsOptionsTableViewController()
        navigationController?.pushViewController(contactOptions, animated: true)
    }
    //MARK: - editingModel
    @objc private func editingModel(contactsModel: ContactsModel) {
        let contactOptions = ContactsOptionsTableViewController()
        contactOptions.contactsModel = contactsModel
        contactOptions.editModel = true
        contactOptions.cellNameArray = [
            contactsModel.contactsName,
            contactsModel.contactsPhone,
            contactsModel.contactsMail,
            contactsModel.contactsType,
            ""]
        contactOptions.isImageChanged = true
        navigationController?.pushViewController(contactOptions, animated: true)
    }
}
//MARK: - UITableViewDataSource, UITableViewDelegate
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isFiltering ? filteredArray.count : contactsArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idContactsCell, for: indexPath) as! ContactsTableViewCell
        let model = (isFiltering ? filteredArray[indexPath.row] : contactsArray[indexPath.row])
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = contactsArray[indexPath.row]
        editingModel(contactsModel: model)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editingRow = contactsArray[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _ , _ , completionHandler in
            RealmManager.shared.deleteContactsModel(model: editingRow)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ContactsViewController {
    
    private func setConstraints() {
        
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, tableView], axis: .vertical, spacing: 0, distribution: .equalSpacing)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredArray = contactsArray.filter("contactsName CONTAINS[c] %@", searchText)
        print(searchBarIsEmpty)
        tableView.reloadData()
    }
}
