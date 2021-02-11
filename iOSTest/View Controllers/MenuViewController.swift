//
//  MenuViewController.swift
//  iOSTest
//
//  Copyright © 2020 Rapptr Labs. All rights reserved.

import UIKit
import GTDevTools

class MenuViewController: UIViewController {
    
    /**
     * =========================================================================================
     * INSTRUCTIONS
     * =========================================================================================
     *
     * 1) UI must work on iOS phones of multiple sizes. Do not worry about iPads.
     *
     * 2) Use Autolayout to make sure all UI works for each resolution
     *
     * 3) Use this starter project as a base and build upon it. It is ok to remove some of the
     *    provided code if necessary. It is ok to add any classes. This is your project now!
     *
     * 4) Read the additional instructions comments throughout the codebase, they will guide you.
     *
     * 5) Please take care of the bug(s) we left for you in the project as well. Happy hunting!
     *
     * Thank you and Good luck. - Rapptr Labs
     * =========================================================================================
     */
    
    // MARK: - Outlets
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var animationButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavBar()
        animateButtons()
        
    }
    
    fileprivate func animateButtons() {
        stackView.centerVertically(offset: -50)
        UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseOut) {
            var stackViewFrame = self.stackView.frame
            stackViewFrame.origin.y += 50
            self.stackView.frame = stackViewFrame
            self.stackView.alpha = 1
        } completion: { (_) in
            
        }
    }

    
    fileprivate func setupNavBar() {
        navigationController?.isNavigationBarHidden = false
        title = "Coding Tasks"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "FontLight"), NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .semibold)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.barTintColor = UIColor(named: "Header")
        navigationController?.navigationBar.tintColor = UIColor(named: "FontLight")
        navigationController?.navigationItem.backButtonTitle = ""
        
    }
    
    // MARK: - Actions
    @IBAction func didPressChatButton(_ sender: Any) {
        let chatViewController = ChatViewController()
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    @IBAction func didPressLoginButton(_ sender: Any) {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
        
    }
    
    @IBAction func didPressAnimationButton(_ sender: Any) {
        let animationViewController = AnimationViewController()
        navigationController?.pushViewController(animationViewController, animated: true)
    }
    
    
}
