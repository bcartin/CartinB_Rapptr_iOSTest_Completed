//
//  UIColor.swift
//  GTDevTools
//
//  Created by Bernie Cartin on 5/21/19.
//  Copyright © 2019 Garson Tech. All rights reserved.
//

import UIKit

extension UIColor {
    
    static public func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }

    
}
