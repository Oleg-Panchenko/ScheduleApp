//
//  TasksModel.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 02.12.2021.
//

import RealmSwift
import Foundation

class TasksModel: Object {
    
    @Persisted var tasksDate: Date?
    @Persisted var tasksName: String = "Unknown"
    @Persisted var tasksDescription: String = "Unknown"
    @Persisted var tasksColor: String = "1A1679"
    @Persisted var tasksReady: Bool = false
}
