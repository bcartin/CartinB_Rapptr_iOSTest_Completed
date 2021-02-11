//
//  ChatViewController.swift
//  iOSTest
//
//  Copyright © 2020 Rapptr Labs. All rights reserved.

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     * =========================================================================================
     * INSTRUCTIONS
     * =========================================================================================
     * 1) Make the UI look like it does in the mock-up.
     *
     * 2) Using the following endpoint, fetch chat data
     *    URL: http://dev.rapptrlabs.com/Tests/scripts/chat_log.php
     *
     * 3) Parse the chat data using 'Message' model
     *
     **/
    
    // MARK: - Properties
    private var client: ChatClient?
    private var messages: [Message]?
    
    // MARK: - Outlets
    let chatTable = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        messages = [Message]()
        configureTable(tableView: chatTable)
        
        loadMessages()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        title = "Chat"
        view.backgroundColor = UIColor(named: "Background")
        view.addSubview(chatTable)
        chatTable.fillSuperview()
    }
    
    
    private func configureTable(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func loadMessages() {
        let chatClient = ChatClient()
        chatClient.fetchMessages { [weak self](chatData) in
            if let data = chatData {
                self?.messages = data.messages
                self?.chatTable.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        cell.setCellData(message: messages![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages!.count
    }
}
