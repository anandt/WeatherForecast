//
//  ColorExtensions.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
import UIKit

// MARK: - Color Codes
struct WFColors {
    static let blue: String  = "#3683d6"
    static let gray: String  = "#31465c"
    static let dargray: String  = "#222729"
}

// MARK: - Color Names
extension UIColor {
    static var appBlueColor: UIColor {
        return UIColor(hexString: WFColors.blue)
    }
    static var apgrayColor: UIColor {
        return UIColor(hexString: WFColors.gray)
    }
    static var darkgrayColor: UIColor {
        return UIColor(hexString: WFColors.dargray)
    }
    
}

extension UIColor {
    private convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
