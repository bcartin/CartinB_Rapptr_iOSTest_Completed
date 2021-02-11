//
//  DateSelector.swift
//  GTDevTools
//
//  Created by Bernie Cartin on 5/22/19.
//  Copyright © 2019 Garson Tech. All rights reserved.
//

import UIKit

class DateSelector: UIView {
    
    weak var delegate: DateSelectorDelegate?
    
    private var dateFormat: String = "MM/dd/yyyy"
    
    public lazy var dateTextField: CustomTextField = {
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
        addSubview(dateTextField)
        dateTextField.fillSuperview()
        addSubview(selectorButton)
        selectorButton.fillSuperview()
    }
    
    public init(placeholder: String, dateFormat: String = "MM/dd/yyyy") {
        super.init(frame: .zero)
        setupSelector()
        dateTextField.placeholder = placeholder
        self.dateFormat = dateFormat
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    fileprivate func buttonTapped() {
        delegate?.selectorButtonTapped(dateText: dateTextField.text, dateFormat: dateFormat, { (date) in
            self.dateTextField.text = date
        })
    }
}

public protocol DateSelectorDelegate: UIViewController {}

extension DateSelectorDelegate where Self : UIViewController {
    
    func selectorButtonTapped(dateText: String?, dateFormat: String, _ selectedDate: @escaping(String) -> ())  {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: self.view.frame.width ,height: 200)
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        if let dateText = dateText, dateText != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            guard let selectedDate = dateFormatter.date(from: dateText) else {return}
            datePickerView.date = selectedDate
        }
        vc.view.addSubview(datePickerView)
        datePickerView.fillSuperview()
        let dateAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        dateAlert.setValue(vc, forKey: "contentViewController")
        dateAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { (done) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            let selected = dateFormatter.string(from: datePickerView.date)
            selectedDate(selected)
        }))
        self.present(dateAlert, animated: true)
    }
}
