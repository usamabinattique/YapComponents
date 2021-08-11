//
//  UIBottomBorderTestField.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 19/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum TextFieldValidationStatus {
    case valid
    case inValid
    case notDetermined
}

public class UIBottomBarTextField: UIView {
    
    let verticalSpacing: CGFloat = 0
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = verticalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 02
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(forTextStyle: .small)
        label.alpha = 0.5
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var validationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_check", in: yapKitBundle, compatibleWith: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColor(ofType: .primarySoft)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textField: UITextField = {
        var textField = UITextField()
        return textField
    }()
    
    public var textFieldPlaceHolder: String? = "newemail@company.com" {
        didSet {
            textField.placeholder = textFieldPlaceHolder
        }
    }
    
    public var titleLabelText: String? = "Enter your new email address" {
        didSet {
            self.titleLabel.text = titleLabelText
        }
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupViews()
        setupConstraints()
        configureTitleLabel()
        textField.delegate = self
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func configureTitleLabel() {
        titleLabel.text = titleLabelText
        textField.placeholder = textFieldPlaceHolder
    }
    
    private func setupViews() {
        stackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(textField)
        horizontalStackView.addArrangedSubview(validationImageView)
        stackView.addArrangedSubview(horizontalStackView)
        stackView.addArrangedSubview(bottomBarView)
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        
        let titleLabelConstraints = [
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let validationImageViewConstraint = [
            validationImageView.widthAnchor.constraint(equalToConstant: 20),
            validationImageView.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let textFieldConstraints = [
            textField.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let underLineViewConstraints = [
            bottomBarView.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        let stackViewContraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints
            + textFieldConstraints
            + validationImageViewConstraint
            + underLineViewConstraints
            + stackViewContraints)
    }
    
    fileprivate var isTitleLableActive: Bool = false {
        didSet {
            titleLabel.alpha = isTitleLableActive ? 1.0 : 0.5
        }
    }
    
    public var isInputValid: TextFieldValidationStatus = .valid {
        didSet {
            switch isInputValid {
            case .valid:
                validationImageView.image =  UIImage(named: "icon_check", in: yapKitBundle, compatibleWith: nil)
            case .inValid:
                validationImageView.image = UIImage(named: "icon_invalid", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            case .notDetermined:
                validationImageView.image = nil
            }
        }
    }
}

extension UIBottomBarTextField: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isTitleLableActive = true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.isTitleLableActive = false
    }
    
}

extension Reactive where Base: UIBottomBarTextField {
    public var isInputValid: Binder<TextFieldValidationStatus> {
        return Binder(self.base) { textField, isValid in
            textField.isInputValid = isValid
        }
    }
}
