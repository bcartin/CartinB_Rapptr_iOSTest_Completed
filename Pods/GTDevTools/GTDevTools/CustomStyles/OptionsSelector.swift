//
//  OptionsSelector.swift
//  GTDevTools
//
//  Created by Bernie Cartin on 5/22/19.
//  Copyright © 2019 Garson Tech. All rights reserved.
//

import UIKit

class OptionsSelector: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: OptionsSelectorDelegate?
    
    private var options: [String] = []
    
    public var selectedIndex: Int?
    
    let optionsPicker = UIPickerView()
    
    public lazy var optionsTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.backgroundColor = .white
        tf.placeholder = "Placeholder"
        return tf
    }()
    
    public lazy var selectorButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setupSelector() {
        addSubview(optionsTextField)
        optionsTextField.fillSuperview()
        addSubview(selectorButton)
        selectorButton.fillSuperview()
        optionsPicker.delegate = self
        optionsPicker.dataSource = self
    }
    
    public init(placeholder: String, options: [String] = []) {
        super.init(frame: .zero)
        setupSelector()
        optionsTextField.placeholder = placeholder
        self.options = options
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    fileprivate func buttonTapped() {
        delegate?.selectorButtonTapped(optionText: optionsTextField.text, options: self.options, optionsPicker: self.optionsPicker, { (selectedOption) in
            self.optionsTextField.text = self.options[selectedOption]
            self.selectedIndex = selectedOption
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
}

public protocol OptionsSelectorDelegate: UIViewController {}

extension OptionsSelectorDelegate where Self : UIViewController {
    
    func selectorButtonTapped(optionText: String?, options: [String], optionsPicker: UIPickerView, _ selectedOption: @escaping(Int) -> ())  {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: self.view.frame.width ,height: 100)
        optionsPicker.tag = 1
        if let optionText = optionText, optionText != "" {
            optionsPicker.selectRow(options.firstIndex(of: optionText)!, inComponent: 0, animated: false)
        }
        vc.view.addSubview(optionsPicker)
        optionsPicker.fillSuperview()
        let optionsAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        optionsAlert.setValue(vc, forKey: "contentViewController")
        optionsAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { (done) in
            selectedOption(optionsPicker.selectedRow(inComponent: 0))
        }))
        self.present(optionsAlert, animated: true)
    }
}
