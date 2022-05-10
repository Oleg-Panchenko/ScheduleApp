//
//  ContactsModel.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 02.12.2021.
//

import RealmSwift
import Foundation

class ContactsModel: Object {
    
    @Persisted var contactsName: String = "Unknown"
    @Persisted var contactsPhone: String = "Unknown"
    @Persisted var contactsMail: String = "Unknown"
    @Persisted var contactsType: String = "Unknown"
    @Persisted var contactsImage: Data?
}
