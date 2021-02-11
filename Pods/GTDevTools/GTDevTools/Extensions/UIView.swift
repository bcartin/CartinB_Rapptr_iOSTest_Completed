//
//  UIViewExtension.swift
//  GTDevTools
//
//  Created by Bernie Cartin on 5/21/19.
//  Copyright © 2019 Garson Tech. All rights reserved.
//

import UIKit

public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIView {
    
    open func findFirstresponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        else {
            for view in self.subviews {
                let firstResponder = view.findFirstresponder()
                if firstResponder != nil {
                    return firstResponder
                }
            }
        }
        return nil
    }
    
    @discardableResult
    open func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0), size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    open func anchorTop(anchor: NSLayoutYAxisAnchor, paddingTop: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: anchor, constant: paddingTop).isActive = true
    }
    
    open func setSizeAnchors(height: CGFloat?, width: CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    open func centerHorizontaly(offset: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            self.centerXAnchor.constraint(equalTo: superviewCenterXAnchor, constant: offset).isActive = true
        }
        
    }
    
    open func centerVertically(offset: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            self.centerYAnchor.constraint(equalTo: superviewCenterYAnchor, constant: offset).isActive = true
        }
    }
    
    open func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
    }
    
    open func setupShadow(opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = .zero, color: UIColor = .black) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    
    open func fillSuperviewSafeAreaLayoutGuide() {
        if #available(iOS 11.0, *) {
            guard let superviewTopAnchor = superview?.safeAreaLayoutGuide.topAnchor,
                let superviewBottomAnchor = superview?.safeAreaLayoutGuide.bottomAnchor,
                let superviewLeftAnchor = superview?.safeAreaLayoutGuide.leadingAnchor,
                let superviewRightAnchor = superview?.safeAreaLayoutGuide.trailingAnchor else { return }
            anchor(top: superviewTopAnchor, leading: superviewLeftAnchor, bottom: superviewBottomAnchor, trailing: superviewRightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            }
    }
    
    open func fillSuperview() {
        if #available(iOS 11.0, *) {
            guard let superviewTopAnchor = superview?.topAnchor,
                let superviewBottomAnchor = superview?.bottomAnchor,
                let superviewLeftAnchor = superview?.leadingAnchor,
                let superviewRightAnchor = superview?.trailingAnchor else { return }
            anchor(top: superviewTopAnchor, leading: superviewLeftAnchor, bottom: superviewBottomAnchor, trailing: superviewRightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    @discardableResult
    func withBorder(width: CGFloat, color: UIColor) -> UIView {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
}

// Code for UIStackViews

extension UIView {
    
    fileprivate func _stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        addSubview(stackView)
        stackView.fillSuperview()
        return stackView
    }
    
    @discardableResult
    open func stack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill) -> UIStackView {
        return _stack(.vertical, views: views, spacing: spacing, alignment: alignment)
    }
    
    @discardableResult
    open func hstack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill) -> UIStackView {
        return _stack(.horizontal, views: views, spacing: spacing, alignment: alignment)
    }
    
    @discardableResult
    open func withSize<T: UIView>(_ size: CGSize) -> T {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self as! T
    }
    
    @discardableResult
    open func withHeight(_ height: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    open func withWidth(_ width: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    convenience public init(backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }

}

extension UIEdgeInsets {
    static public func allSides(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: side, bottom: side, right: side)
    }
}


