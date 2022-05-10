//
//  UILabel.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 06.11.2021.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont, alignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.font = font
        self.textAlignment = alignment
        self.textColor = .black
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.backgroundColor = .systemRed
    }
}
