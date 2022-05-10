//
//  PressButtonProtocols.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 07.11.2021.
//

import Foundation

protocol PressReadyTaskButtonProtocol: AnyObject {
    
    func readyButtonTapped(indexPath: IndexPath)
}

protocol SwitchRepeatProtocol: AnyObject {
    
    func switchRepeat(value: Bool)
}
