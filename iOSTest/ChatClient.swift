//
//  ChatClient.swift
//  iOSTest
//
//  Created by Bernie Cartin on 2/11/21.
//  Copyright © 2021 D&ATechnologies. All rights reserved.
//

import Foundation

class ChatClient {
    
    
    
    func fetchMessages(completion: @escaping(_ chatData: ChatData?) -> Void) {
        //Create url
        guard let url = URL(string: "http://dev.rapptrlabs.com/Tests/scripts/chat_log.php") else {
            print("Error creating url")
            return
        }
        
        //Create url session
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error getting chat data: ", error.localizedDescription)
                return
            }
            
            if let data = data {
                
                do {
                    // Decode JSON data into Message objects
                    let chatData = try JSONDecoder().decode(ChatData.self, from: data)
                    DispatchQueue.main.async {
                        // Return Decoded Data
                        completion(chatData)
                    }
                }
                catch {
                    print("ERROR: ",error.localizedDescription)
                }
                
            }
        }.resume()
        
        
    }
    
}
