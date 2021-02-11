//
//  LoginViewController.swift
//  iOSTest
//
//  Copyright © 2020 Rapptr Labs. All rights reserved.

import UIKit
import GTDevTools

class LoginViewController: UIViewController, Alertable {
    
    /**
     * =========================================================================================
     * INSTRUCTIONS
     * =========================================================================================
     * 1) Make the UI look like it does in the mock-up.
     *
     * 2) Take email and password input from the user
     *
     * 3) Use the endpoint and paramters provided in LoginClient.m to perform the log in
     *
     * 4) Calculate how long the API call took in milliseconds
     *
     * 5) If the response is an error display the error in a UIAlertController
     *
     * 6) If the response is successful display the success message AND how long the API call took in milliseconds in a UIAlertController
     *
     * 7) When login is successful, tapping 'OK' in the UIAlertController should bring you back to the main menu.
     **/
    
    // MARK: - Properties
    private var client: LoginClient?
    
    private let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "img_login"), contentMode: .scaleToFill)
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "email", font: UIFont.systemFont(ofSize: 16, weight: .regular), backgroundColor: .white, borderColor: nil, keyboardType: .emailAddress, isSecureText: false, cornerRadius: 8)
        tf.setSizeAnchors(height: 55, width: nil)
        let attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor:UIColor(named: "FontPlaceholder") ?? .black])
        tf.attributedPlaceholder = attributedPlaceholder
        tf.textColor = UIColor(named: "FontDark")
        tf.alpha = 0.5
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "password", font: UIFont.systemFont(ofSize: 16, weight: .regular), backgroundColor: .white, borderColor: nil, keyboardType: .default, isSecureText: true, cornerRadius: 8)
        tf.setSizeAnchors(height: 55, width: nil)
        let attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor:UIColor(named: "FontPlaceholder") ?? .black])
        tf.attributedPlaceholder = attributedPlaceholder
        tf.textColor = UIColor(named: "FontDark")
        tf.alpha = 0.5
        return tf
    }()
    
    private let loginButton: UIButton = {
       let button = UIButton(title: "LOGIN", titleColor: UIColor(named: "FontLight") ?? .white, font: UIFont.systemFont(ofSize: 16, weight: .semibold), backgroundColor: UIColor(named: "Button") ?? .blue, target: self, action: #selector(didTapLogin), cornerRadius: 0)
        button.setSizeAnchors(height: 55, width: nil)
        return button
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 24
        sv.axis = .vertical
        sv.alpha = 0
        return sv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        animateButtons()
    }
    
    
    fileprivate func setupUI () {
        title = "Login"
        view.backgroundColor = UIColor(named: "Background")
        view.addSubview(backgroundImage)
        backgroundImage.fillSuperview()
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 64, left: 30, bottom: 0, right: 30))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    fileprivate func animateButtons() {
        UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseOut) {
            var stackViewFrame = self.stackView.frame
            stackViewFrame.origin.y += 50
            self.stackView.frame = stackViewFrame
            self.stackView.alpha = 1
        } completion: { (_) in
            
        }
    }
    
    @objc
    fileprivate func didTapLogin() {
        // Validate Email
        guard let email = emailTextField.text, emailTextField.text?.count ?? 0 > 0 else {
            self.showAlert(title: "Error", msg: "Email cannot be empty")
            return
        }

        //Validate Password
        guard let password = passwordTextField.text, passwordTextField.text?.count ?? 0 > 0 else {
            self.showAlert(title: "Error", msg: "Password cannot be empty")
            return
        }
        
        //Used to calculate elapsed time
        let startTime = Date()
        
        // Attempt To Login
        let loginClient = LoginClient()
        loginClient.sendLoginRequest(email: email, password: password) { [weak self] (httpCode, responseData, error) in
            
            if let error = error {
                self?.showAlert(title: "Error", msg: error.localizedDescription)
                return
            }
            
            if let responseData = responseData {
                
                var message = responseData.message
                
                // If the login was successful add the elapsed time to the message
                if httpCode?.responseType == .success {
                    message += "\n API call took \(self?.calculateTimeElapsed(from: startTime) ?? 0) milliseconds"
                }
                
                let alert = UIAlertController(title: responseData.code, message: message, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    if httpCode?.responseType == .success {
                        // Pop back to menu view
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                alert.addAction(alertAction)
                
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func calculateTimeElapsed(from startTime: Date) -> Int {
        let elapsedTime = Date().timeIntervalSince(startTime)
        let milliseconds = Int((elapsedTime*1000).truncatingRemainder(dividingBy: 1000))
        return milliseconds
    }
    
    

}
