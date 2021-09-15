//
//  AppPickerView.swift
//  YAPKit
//
//  Created by Zain on 24/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
//import RxSwift
//import RxCocoa

open class AppPickerView: UIView {
    
    public lazy var toolbaar:ToolBaar = {
        let toolBaar = ToolBaar()
        return toolBaar
    }()
    
    public lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
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
    
    public func getSelectedIndexes() -> [(row: Int, component: Int)] {
        var indexes = [(row: Int, component: Int)]()
        for i in 0..<pickerView.numberOfComponents {
            indexes.append((row: pickerView.selectedRow(inComponent: i), component: i))
        }
        return indexes
    }
}

fileprivate extension AppPickerView {
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    // MARK: Actions
}

// MARK: View setup

private extension AppPickerView {
    func setupViews() {
        addSubview(toolbaar)
        addSubview(pickerView)
    }
    
    func setupConstraints() {
        toolbaar
            .alignEdgesWithSuperview([.left, .top, .right])
            .height(constant: 44)
        
        pickerView
            .toBottomOf(toolbaar)
            .alignEdgesWithSuperview([.left, .right, .bottom])
    }
}

// MARK: Toolbar

public class ToolBaar:UIView {
    
    public let doneButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("common_button_done"/*.localized*/, for: .normal)
        button.setTitleColor(.blue /*.primaryDark*/, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    public let cancelButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("common_button_cancel"/*.localized*/, for: .normal)
        button.setTitleColor(.blue/*.primaryDark*/, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    public func makeUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        let separator:UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .darkGray //.greyDark
            return view
        }()
        
        self.addSubview(separator)
        self.addSubview(cancelButton)
        self.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separator.topAnchor.constraint(equalTo: self.topAnchor),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: self.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            doneButton.topAnchor.constraint(equalTo: self.topAnchor),
            doneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
