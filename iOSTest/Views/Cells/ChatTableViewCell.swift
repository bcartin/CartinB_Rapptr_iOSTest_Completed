//
//  ChatTableViewCell.swift
//  iOSTest
//
//  Copyright © 2020 Rapptr Labs. All rights reserved.

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    /**
     * =========================================================================================
     * INSTRUCTIONS
     * =========================================================================================
     * 1) Setup cell to match mockup
     *
     * 2) Include user's avatar image
     **/
    
    // MARK: PROPERTIES
    
    // User Image
    let userImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, size: .init(width: 48, height: 48), cornerRadius: 24)
    
    // Username
    let usernameLabel = UILabel(text: nil, font: UIFont.systemFont(ofSize: 13, weight: .semibold), textColor: UIColor(named: "FontDark") ?? .black, textAlignment: .left, numberOfLines: 1)
    
    // Message Text
    let messageLabel = UILabel(text: nil, font: UIFont.systemFont(ofSize: 15, weight: .regular), textColor: UIColor(named: "FontDark") ?? .black, textAlignment: .natural, numberOfLines: 0)
    
    // Bubble View
    let bubbleView: UIView = {
        let view = UIView(backgroundColor: .white)
        view.layer.borderColor = UIColor(named: "Border")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        contentView.backgroundColor = UIColor(named: "Background")
        
        contentView.addSubview(userImageView)
        userImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        
        contentView.addSubview(usernameLabel)
        usernameLabel.anchor(top: contentView.topAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 7, bottom: 0, right: 0))
        
        contentView.addSubview(bubbleView)
        contentView.addSubview(messageLabel)
        messageLabel.anchor(top: usernameLabel.bottomAnchor, leading: userImageView.trailingAnchor, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 12, left: 15, bottom: 32, right: 44))
        
        // Number is calculated to try an satisfy the requirement of having 36px of traling space
        let maxWidth = UIScreen.main.bounds.width - 123
        
        // Constraint is set to lessThanOrEqual so that short messages don't have an extra wide bubble
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        
        bubbleView.anchor(top: messageLabel.topAnchor, leading: messageLabel.leadingAnchor, bottom: messageLabel.bottomAnchor, trailing: messageLabel.trailingAnchor, padding: .init(top: -8, left: -8, bottom: -8, right: -8))
    }
    

    // MARK: - Public
    func setCellData(message: Message) {
        userImageView.loadImage(from: message.avatarUrl)
        usernameLabel.text = message.name
        messageLabel.text = message.message
    }
}
