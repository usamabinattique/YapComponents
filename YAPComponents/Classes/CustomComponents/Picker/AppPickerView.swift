//
//  AppPickerView.swift
//  YAPKit
//
//  Created by Zain on 24/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class AppPickerView: UIView {
    
    private lazy var toolbar: UIView = {
        return self.getToolBar(target: self, done: #selector(doneAction), cancel: #selector(cancelAction))
    }()
    
    fileprivate lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    fileprivate let doneSubject = PublishSubject<[(row: Int, component: Int)]>()
    fileprivate let cancelSubject = PublishSubject<Void>()
    
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
}

// MARK: View setup

private extension AppPickerView {
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

private extension AppPickerView {
    @objc func doneAction() {
        
        var indexes = [(row: Int, component: Int)]()
        for i in 0..<pickerView.numberOfComponents {
            indexes.append((row: pickerView.selectedRow(inComponent: i), component: i))
        }
        doneSubject.onNext(indexes)
    }
    
    @objc func cancelAction() {
        cancelSubject.onNext(())
    }
}

// MARK: Reactive

public extension Reactive where Base: AppPickerView {
    
    var itemSelected: ControlEvent<(row: Int, component: Int)> {
        return self.base.pickerView.rx.itemSelected
    }
    
    var done: Observable<[(row: Int, component: Int)]> {
        return self.base.doneSubject.asObservable()
    }
    
    var cancel: Observable <Void> {
        return self.base.cancelSubject.asObservable()
    }
    
    func itemTitles<S: Sequence, O: ObservableType>
        (_ source: O)
        -> (_ titleForRow: @escaping (Int, S.Iterator.Element) -> String?)
        -> Disposable where O.Element == S {
            return self.base.pickerView.rx.itemTitles(source)
    }
    
    func itemAttributedTitles<S: Sequence, O: ObservableType>
        (_ source: O)
        -> (_ attributedTitleForRow: @escaping (Int, S.Iterator.Element) -> NSAttributedString?)
        -> Disposable where O.Element == S {
            return self.base.pickerView.rx.itemAttributedTitles(source)
    }
}

// MARK: Toolbar

private extension AppPickerView {
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
