//
//  AnimationViewController.swift
//  iOSTest
//
//  Copyright © 2020 Rapptr Labs. All rights reserved.

import UIKit

class AnimationViewController: UIViewController {
    
    
    /**
     * =========================================================================================
     * INSTRUCTIONS
     * =========================================================================================
     * 1) Make the UI look like it does in the mock-up.
     *
     * 2) Logo should fade out or fade in when the user hits the Fade In or Fade Out button
     *
     * 3) User should be able to drag the logo around the screen with his/her fingers
     *
     * 4) Add a bonus to make yourself stick out. Music, color, fireworks, explosions!!! Have Swift experience? Why not write the Animation 
     *    section in Swfit to show off your skills. Anything your heart desires!
     *
     **/
    
    // MARK: PROPERTIES
    
    // used to provide haptic feedback when the fade button is pressed, can only be tested on a real device
    private let haptics = UINotificationFeedbackGenerator()
    
    private var isLogoVisible = true
    
    private var originalCenter: CGPoint?
    private var imageCenter: CGPoint?
    
    private let fadeButton: UIButton = {
       let button = UIButton(title: "FADE OUT", titleColor: UIColor(named: "FontLight") ?? .white, font: UIFont.systemFont(ofSize: 16, weight: .semibold), backgroundColor: UIColor(named: "Button") ?? .blue, target: self, action: #selector(didTapFade), cornerRadius: 0)
        button.setSizeAnchors(height: 55, width: nil)
        
        return button
    }()
    
    let logo = UIImageView(image: #imageLiteral(resourceName: "ic_logo"), contentMode: .scaleAspectFill, size: .init(width: 317, height: 74))
    
    // used to play sounds
    let soundManager = SoundManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.imageCenter = logo.center
        self.originalCenter = logo.center
    }
    
    fileprivate func setupUI() {
        title = "Animation"
        view.backgroundColor = UIColor(named: "Background")
        
        view.addSubview(logo)
        logo.centerHorizontaly(offset: 0)
        logo.anchorTop(anchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 112)
        
        view.addSubview(fadeButton)
        
        fadeButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 64, right: 30))
  
        logo.isUserInteractionEnabled = true
        let drag = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        logo.addGestureRecognizer(drag)

    }
    
    
    
    // MARK: - Actions
    
    @objc
    fileprivate func didTapFade(_ sender: Any) {
        // Play Sound
        soundManager.playSound(sound: "riseup", type: "mp3")
        
        // Send haptic feedback
        haptics.notificationOccurred(.success)
        
        
        fadeButton.isEnabled = false
        imageCenter = originalCenter
        
        (0...150).forEach { (_) in
            self.generateAnimatedViews()
        }
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.logo.alpha = self?.isLogoVisible ?? true ? 0 : 1
        } completion: { [weak self](_) in
            self?.fadeButton.setTitle(self?.isLogoVisible ?? true ? "FADE IN" : "FADE OUT", for: .normal)
            self?.isLogoVisible.toggle()
            self?.fadeButton.isEnabled = true
            self?.view.layoutSubviews()
        }
    }
    
    func customPath() -> UIBezierPath {
        
        // Generate a random "wavy" path
        
        let width = view.frame.width
        let height = view.frame.height
        let randomXShift = Double(width * CGFloat(drand48()))
        let randomStartPoint = CGPoint(x: CGFloat(randomXShift), y: height + 20)
        
        let path = UIBezierPath()
        path.move(to: randomStartPoint)

        let randomEndPoint = CGPoint(x: randomXShift, y: -20)
        let randomYShift = 100 + drand48() * 200
        let randomXShift2 = Double(width * CGFloat(drand48()) - 100)
        
        let cp1 = CGPoint(x: randomXShift2, y: randomYShift)
        let cp2 = CGPoint(x: 200 + randomXShift2, y: randomYShift)
        path.addCurve(to: randomEndPoint, controlPoint1: cp1, controlPoint2: cp2)
        return path
    }
    
    fileprivate func generateAnimatedViews() {
        
        // Generate a logo image of random size and animated it throughout a random path.
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "rapptr_logo").withRenderingMode(.alwaysOriginal))
        imageView.tintColor = .orange
        let dimension = 20 + drand48() * 20
        imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = customPath().cgPath
        animation.duration = 3 + drand48() * 3
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        imageView.layer.add(animation, forKey: nil)
        view.addSubview(imageView)
    }
    
    @objc
    fileprivate func wasDragged(gestureRecognizer : UIPanGestureRecognizer) {
        guard let imageCenter = self.imageCenter else {return}
        let labelPoint = gestureRecognizer.translation(in: view)
        logo.center = CGPoint(x: imageCenter.x + labelPoint.x, y: imageCenter.y + labelPoint.y)
        
        if gestureRecognizer.state == .ended {
            self.imageCenter = logo.center
            self.view.layoutSubviews()
        }
    }
    
}
