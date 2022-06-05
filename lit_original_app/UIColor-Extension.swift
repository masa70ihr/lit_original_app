//
//  UIColor-Extension.swift
//  lit_original_app
//
//  Created by MASANAO on 2022/05/29.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
