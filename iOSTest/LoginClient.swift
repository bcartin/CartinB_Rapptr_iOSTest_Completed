//
//  LoginClient.swift
//  iOSTest
//
//  Created by Bernie Cartin on 2/10/21.
//  Copyright © 2021 D&ATechnologies. All rights reserved.
//

import Foundation

class LoginClient {

    func sendLoginRequest(email: String, password: String, completion: @escaping(_ httpCode: HTTPStatusCode?, _ response: LoginResponse?, _ error: Error?) -> Void) {
                
        // Create URL
        let url = URL(string: "https://dev.rapptrlabs.com/Tests/scripts/login.php")
        
        guard let requestUrl = url else { fatalError() }
        
        var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "email", value: email.lowercased()),
            URLQueryItem(name: "password", value: password)
        ]
        
        let query = components?.url?.query

        // Create URL Request
        var request = URLRequest(url: requestUrl)
        
        // Specify HTTP Method to use
        request.httpMethod = "POST"
        
        // Set the request body with the parameters
        request.httpBody = Data(query!.utf8)
                
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            var requestError: Error? = error
            var httpStatusCode: HTTPStatusCode?
            var requestData: LoginResponse?

            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                httpStatusCode = HTTPStatusCode(rawValue: response.statusCode)
            }
                        
            // Convert HTTP Response Data to object
            if let data = data {
                do {
                    requestData = try JSONDecoder().decode(LoginResponse.self, from: data)
                }
                catch {
                    requestError = error
                }
            }
            
            DispatchQueue.main.async {
                completion(httpStatusCode, requestData, requestError)
            }
            
        }
        task.resume()
    }
}



