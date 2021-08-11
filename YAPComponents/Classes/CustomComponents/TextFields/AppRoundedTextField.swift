//
//  AppRoundedTextField.swift
//  YAPKit
//
//  Created by Zain on 21/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum AppRoundedTextFieldValidation {
    case valid
    case invalid
    case neutral
}

public class AppRoundedTextField: UITextField {
    
    static public let maxAllowedCharacters = 50
    
    fileprivate lazy var iconImage: UIButton = {
        let icon = UIButton()
        icon.isHidden = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    fileprivate lazy var validationImage: UIImageView = {
        let validationImage = UIImageView()
        validationImage.contentMode = .scaleAspectFit
        validationImage.translatesAutoresizingMaskIntoConstraints = false
        return validationImage
    }()
    
    fileprivate lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.zPosition = -1
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
        view.layer.borderWidth = 1.6
        view.backgroundColor = bgColor
        view.layer.borderColor = bgColor.cgColor
        return view
    }()
    
    fileprivate lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(forTextStyle: .micro)
        label.textColor = UIColor.appColor(ofType: .greyDark)
        label.textAlignment = .center
        label.isHidden = true
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Control varibales
    
    public var invalidInputImage: UIImage? = UIImage.init(named: "icon_invalid", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    public var validInputImage: UIImage? = UIImage.init(named: "icon_check", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    public var displaysIcon: Bool = false {
        didSet {
            iconImage.isHidden = !displaysIcon
        }
    }
    
    public var icon: UIImage? {
        didSet {
            iconImage.setImage(icon, for: .normal)
            iconImage.isHidden = !displaysIcon
        }
    }
    
    public var errorTextColor: UIColor = .greyDark {
        didSet {
            self.errorLabel.textColor = errorTextColor
        }
    }
    
    public var bgColor = UIColor.appColor(ofType: .greyLight).withAlphaComponent(0.36) {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    
    public var placeholderColor: UIColor = UIColor.greyDark {
        didSet {
            let placeholder = self.placeholder
            self.placeholder = placeholder
        }
    }
    
    private var validation: AppRoundedTextFieldValidation = .neutral
    
    // MARK: Initialization
    
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
    
    public override func becomeFirstResponder() -> Bool {
        let responder = super.becomeFirstResponder()
        backgroundView.layer.borderColor = (responder ? UIColor.appColor(ofType: .primary) : bgColor).cgColor
        return responder
    }
    
    public override var placeholder: String? {
        didSet {
            guard  let `placeholder` = placeholder else { return }
            let attributedPlaceholder = NSMutableAttributedString(string: placeholder)
            attributedPlaceholder.addAttributes([.foregroundColor: self.placeholderColor], range: NSRange(location: 0, length: placeholder.count))
            self.attributedPlaceholder = attributedPlaceholder
        }
    }
}

// MARK: Drawing

extension AppRoundedTextField {
    public override func draw(_ rect: CGRect) {
        render()
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }
    
    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = validationImage.frame
        if validation != .neutral {
            rect.origin.x = rect.origin.x - 25
        }
        return rect
    }
    
    private func rect(forBounds bounds: CGRect) -> CGRect {
        return displaysIcon ? CGRect(x: bounds.origin.x+60, y: bounds.origin.y, width: bounds.size.width - 120, height: bounds.size.height - 22) : CGRect(x: bounds.origin.x+20, y: bounds.origin.y, width: bounds.size.width - 80, height: bounds.size.height - 22)
    }
}

// MARK: View setup

fileprivate extension AppRoundedTextField {
    func setupViews() {
        borderStyle = .none
        font = UIFont.appFont(forTextStyle: .large)
        
        addSubview(backgroundView)
        addSubview(iconImage)
        addSubview(validationImage)
        addSubview(errorLabel)
    }
    
    func setupConstraints() {
        let backgroundViewConstraints = [
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        ]
        
        let iconImageConstraits = [
            iconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconImage.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 24),
            iconImage.heightAnchor.constraint(equalToConstant: 24)
        ]
        
        let validationImageConstraits = [
            trailingAnchor.constraint(equalTo: validationImage.trailingAnchor, constant: 20),
            validationImage.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            validationImage.widthAnchor.constraint(equalToConstant: 25),
            validationImage.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        let errorLabelConstraints = [
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 2),
            trailingAnchor.constraint(equalTo: errorLabel.trailingAnchor),
            bottomAnchor.constraint(equalTo: errorLabel.bottomAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(iconImageConstraits + validationImageConstraits + backgroundViewConstraints + errorLabelConstraints)
    }
    
    func render() {
        backgroundView.layer.cornerRadius = backgroundView.bounds.size.height/2
        backgroundView.clipsToBounds = true
        iconImage.layer.cornerRadius = iconImage.bounds.size.height/2
        iconImage.clipsToBounds = true
    }
}

// MARK: Control functions

public extension AppRoundedTextField {
    func setValidation(_ validation: AppRoundedTextFieldValidation) {
        self.validation = validation
        switch validation {
        case .invalid:
            backgroundView.layer.borderColor = UIColor.appColor(ofType: .error).cgColor
            validationImage.image = invalidInputImage
            validationImage.tintColor = .appColor(ofType: .error)
            errorLabel.isHidden = false
        case .valid:
            backgroundView.layer.borderColor = isFirstResponder ? UIColor.appColor(ofType: .primary).cgColor : bgColor.cgColor
            validationImage.image = validInputImage
            validationImage.tintColor = .appColor(ofType: .primary)
            errorLabel.isHidden = true
        case .neutral:
            backgroundView.layer.borderColor = isFirstResponder ? UIColor.appColor(ofType: .primary).cgColor : bgColor.cgColor
            validationImage.image = nil
            errorLabel.isHidden = true
        }
    }
}

// MARK: Reactive

public extension Reactive where Base: AppRoundedTextField {
    
    var iconTap: ControlEvent<Void> {
        return self.base.iconImage.rx.tap
    }
    
    var validation: Binder<AppRoundedTextFieldValidation> {
        return Binder(self.base) { roundedTextField, validation -> Void in
            roundedTextField.setValidation(validation)
        }
    }
    
    var invalidInputImage: Binder<UIImage?> {
        return Binder(self.base) { roundedTextField, invalidImage -> Void in
            roundedTextField.invalidInputImage = invalidImage
        }
    }
    
    var icon: Binder<UIImage?> {
        return Binder(self.base) { roundedTextField, icon -> Void in
            roundedTextField.icon = icon
        }
    }
    
    var borderColor: Binder<UIColor> {
        return Binder(self.base) { _, color -> Void in
            self.base.layer.borderColor = color.cgColor
        }
    }
    
    var displaysIcon: Binder<Bool> {
        return Binder(self.base) { roundedTextField, displaysIcon -> Void in
            roundedTextField.displaysIcon = displaysIcon
        }
    }
    
    var errorText: Binder<String?> {
        return self.base.errorLabel.rx.text
    }
}
