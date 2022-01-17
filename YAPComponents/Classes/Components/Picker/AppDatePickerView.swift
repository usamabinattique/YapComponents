//
//  AppDatePickerView.swift
//  YAPKit
//
//  Created by Muhammad Awais on 06/04/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

open class AppDatePickerView: UIView {
    
    private lazy var toolbar: UIView = {
        return self.getToolBar(target: self, done: #selector(doneAction), cancel: #selector(cancelAction))
    }()
    
    public lazy var pickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.datePickerMode = UIDatePicker.Mode.date
        pickerView.minimumDate = Date()
        pickerView.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        return pickerView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    
    open func setDate(date: Date) {
        pickerView.date = date
    }
    
    @objc open func datePickerChanged(picker: UIDatePicker) {
        //let selectedDate = pickerView.date
        //let selectedDateString = selectedDate.localizedStringOfDate()
    }
    
    // MARK: Actions
    
    @objc open func doneAction() {
    }
    
    @objc open func cancelAction() {
    }
}

// MARK: View setup

private extension AppDatePickerView {
    func setupViews() {
        addSubview(toolbar)
        addSubview(pickerView)
    }
    
    func setupConstraints() {
        
        toolbar
            .alignEdgesWithSuperview([.left, .top, .right])
            .height(constant: 44)
        
        pickerView
            .toBottomOf(toolbar)
            .alignEdgesWithSuperview([.left, .right, .bottom])
    }
}

// MARK: Toolbar

private extension AppDatePickerView {
    func getToolBar(target: Any?, done: Selector?, cancel: Selector?) -> UIView {
        
        let toolbar =  UIView()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.backgroundColor = .white
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .darkGray //.greyDark
        
        toolbar.addSubview(separator)
        separator
            .alignEdgesWithSuperview([.left, .top, .right])
            .height(constant: 0.5)
        
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.blue /*.primaryDark*/, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
        if let cancel = cancel {
            cancelButton.addTarget(target, action: cancel, for: .touchUpInside)
        }
        
        toolbar.addSubview(cancelButton)
        cancelButton
            .alignEdgesWithSuperview([.left, .top, .bottom], constants: [20, 0, 0])
        
        let doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.backgroundColor = .clear
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.blue /*.primaryDark*/, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        if let done = done {
            doneButton.addTarget(target, action: done, for: .touchUpInside)
        }
        
        toolbar.addSubview(doneButton)
        doneButton
            .alignEdgesWithSuperview([.right, .top, .bottom], constants: [20, 0, 0])
        
        return toolbar
    }
}



