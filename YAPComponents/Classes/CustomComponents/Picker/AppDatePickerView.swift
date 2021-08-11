//
//  AppDatePickerView.swift
//  YAPKit
//
//  Created by Muhammad Awais on 06/04/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class AppDatePickerView: UIView {
    
    private lazy var toolbar: UIView = {
        return self.getToolBar(target: self, done: #selector(doneAction), cancel: #selector(cancelAction))
    }()
    
    fileprivate lazy var pickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            pickerView.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        pickerView.minimumDate = Date()
        pickerView.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        return pickerView
    }()
    
    fileprivate let doneSubject = PublishSubject<(dateString: String, date: Date)>()
    fileprivate let cancelSubject = PublishSubject<Void>()
    fileprivate let changedSubject = PublishSubject<(dateString: String, date: Date)>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func setDate(date: Date) {
        pickerView.date = date
        doneSubject.onNext((dateString: date.localizedStringOfDate(), date: date))
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
   @objc func datePickerChanged(picker: UIDatePicker) {
        let selectedDate = pickerView.date
        let selectedDateString = selectedDate.localizedStringOfDate()
        changedSubject.onNext((dateString: selectedDateString, date: selectedDate))
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

// MARK: Actions

private extension AppDatePickerView {
    @objc func doneAction() {
        let selectedDate = pickerView.date
        let selectedDateString = selectedDate.localizedStringOfDate()
        doneSubject.onNext((dateString: selectedDateString, date: selectedDate))
    }
    
    @objc func cancelAction() {
        cancelSubject.onNext(())
    }
}

// MARK: Reactive

public extension Reactive where Base: AppDatePickerView {
    
    var done: Observable<(dateString: String, date: Date)> {
        return self.base.doneSubject.asObservable()
    }
    
    var change: Observable<(dateString: String, date: Date)> {
           return self.base.changedSubject.asObservable()
       }
    
    var cancel: Observable <Void> {
        return self.base.cancelSubject.asObservable()
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
        separator.backgroundColor = .greyDark
        
        toolbar.addSubview(separator)
        separator
            .alignEdgesWithSuperview([.left, .top, .right])
            .height(constant: 0.5)
        
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle("common_button_cancel".localized, for: .normal)
        cancelButton.setTitleColor(.primaryDark, for: .normal)
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
        doneButton.setTitle("common_button_done".localized, for: .normal)
        doneButton.setTitleColor(.primaryDark, for: .normal)
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



