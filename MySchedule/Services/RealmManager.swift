//
//  RealmManager.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 25.11.2021.
//

import RealmSwift
import SwiftUI

class RealmManager {
    
    
    static var shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    
    //ScheduleModel
    func saveScheduleModel(model: ScheduleModel) {
        
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func deleteScheduleModel(model: ScheduleModel) {
        
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    
    //TasksModel
    func saveTasksModel(model: TasksModel) {
        
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func deleteTasksModel(model: TasksModel) {
        
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    func updateReadyButtonTaskModel(task: TasksModel, bool: Bool) {
        try! localRealm.write {
            task.tasksReady = bool
        }
    }
    
    
    //ContactsModel
    func saveContactsModel(model: ContactsModel) {
        
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    func deleteContactsModel(model: ContactsModel) {
        
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
    
    func updateModel(model: ContactsModel, nameArray: [String], imageData: Data) {
        
        try! localRealm.write {
            model.contactsName = nameArray[0]
            model.contactsPhone = nameArray[1]
            model.contactsMail = nameArray[2]
            model.contactsType = nameArray[3]
            model.contactsImage = imageData
        }
    }
}
