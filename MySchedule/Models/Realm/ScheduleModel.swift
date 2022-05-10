//
//  ScheduleModel.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 21.11.2021.
//

import RealmSwift
import Foundation

class ScheduleModel: Object {
    
    @Persisted var scheduleDate: Date?
    @Persisted var scheduleTime: Date?
    @Persisted var scheduleName: String = "Unknown"
    @Persisted var scheduleType: String = "Unknown"
    @Persisted var scheduleBuilding: String = "Unknown"
    @Persisted var scheduleAuditorium: String = "Unknown"
    @Persisted var scheduleTeacher: String = "Name LastName"
    @Persisted var scheduleColor: String = "1A1679"
    @Persisted var scheduleRepeat: Bool = true
    @Persisted var scheduleWeekday: Int = 1


}
