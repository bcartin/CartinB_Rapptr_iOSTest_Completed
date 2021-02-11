//
//  UITextField.swift
//  GTDevTools
//
//  Created by Bernie Cartin on 9/23/19.
//  Copyright © 2019 Garson Tech. All rights reserved.
//

import Foundation

extension UITextField {
    
    convenience public init(placeholder: String, font: UIFont = .systemFont(ofSize: 14), backgroundColor: UIColor = .white, borderColor: UIColor? = nil, keyboardType: UIKeyboardType = .default, isSecureText: Bool = false, cornerRadius: CGFloat = 0) {
        self.init()
        self.font = font
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
            layer.borderWidth = 0.5
        }
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureText
        self.layer.cornerRadius = cornerRadius
        
    }
}
