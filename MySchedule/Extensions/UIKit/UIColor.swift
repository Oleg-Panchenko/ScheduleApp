//
//  UIColor.swift
//  MySchedule
//
//  Created by Panchenko Oleg on 27.11.2021.
//

import UIKit

extension UIColor {
    
    func colorFromHex(_ hex: String) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            return UIColor.gray
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgb & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
}
