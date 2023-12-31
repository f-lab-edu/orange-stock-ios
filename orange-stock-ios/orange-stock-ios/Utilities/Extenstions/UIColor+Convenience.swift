//
//  UIColor+Convenience.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/11.
//

import UIKit

/// UIColor Convenience Init
extension UIColor {
    
    /// RGB Color
    convenience init(r: CGFloat,
                     g: CGFloat,
                     b: CGFloat,
                     alpha: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    /// hexCode
    convenience init(hexCode: String,
                     alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(r: CGFloat((rgbValue & 0xFF0000) >> 16),
                  g: CGFloat((rgbValue & 0x00FF00) >> 8),
                  b: CGFloat(rgbValue & 0x0000FF),
                  alpha: alpha)
    }
}
