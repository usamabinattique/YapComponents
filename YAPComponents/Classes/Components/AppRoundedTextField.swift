//
//  AppRoundedTextField.swift
//  YAPKit
//
//  Created by Zain on 21/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit

public extension UIFactory {
    class func makeAppRoundedTextField(
        with font:UIFont? = UIFont.systemFont(ofSize: 16),
        errorFont:UIFont? = UIFont.systemFont(ofSize: 12),
        placeholder:String? = nil,
        validation:AppRoundedTextFieldValidation? = .neutral,
        validImage:UIImage? = nil,
        inValidImage:UIImage? = nil,
        leftIcon:UIImage? = nil,
        displaysIcon:Bool = false,
        returnKeyType:UIReturnKeyType = .default,
        autocorrectionType:UITextAutocorrectionType = .default,
        autocapitalizationType:UITextAutocapitalizationType = .sentences,
        keyboardType:UIKeyboardType = .default,
        delegate:UITextFieldDelegate? = nil
    ) -> AppRoundedTextField {
        let textField = AppRoundedTextField()
        textField.font = font
        textField.errorLabel.font = errorFont
        textField.placeholder = placeholder
        textField.validInputImage = validImage?.withRenderingMode(.alwaysTemplate)
        textField.invalidInputImage = inValidImage?.withRenderingMode(.alwaysTemplate)
        textField.leftIcon.setImage(leftIcon, for: .normal)
        textField.validation = validation ?? .neutral
        textField.displaysIcon = displaysIcon
        textField.returnKeyType = returnKeyType
        textField.autocapitalizationType = autocapitalizationType
        textField.delegate = delegate
        textField.autocorrectionType = autocorrectionType
        textField.keyboardType = keyboardType
        return textField
    }
}

public enum AppRoundedTextFieldValidation:Hashable {
    case valid
    case invalid(_ message:String?)
    case neutral
}

public class AppRoundedTextField: UITextField {
    
    var shouldChangeText:Bool = true
    
    //Properties
    public var secondaryColor:UIColor = .darkText { didSet {
        textColor = secondaryColor
        setupPlaceholder()
    }}
    
    
    public var primaryColor:UIColor = .gray { didSet {
        if validation == .valid { validationImage.backgroundColor = primaryColor }
    
    }}
    
    public var errorColor: UIColor = .red { didSet {
        if case .invalid = validation {
            validationImage.backgroundColor = errorColor
            backgroundView.layer.borderColor = errorColor.cgColor
        }
        errorLabel.textColor = errorColor
    }}
    
    public var bgColor = UIColor.lightGray { didSet { //.withAlphaComponent(0.36)
        backgroundView.backgroundColor = bgColor.withAlphaComponent(0.36)
    }}
    
    public lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var leftIcon: UIButton = {
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
        view.layer.zPosition = -1
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
        view.layer.borderWidth = 1.6
        view.layer.borderColor = bgColor.cgColor
        return view
    }()
        
    // MARK: Control varibales
    
    public var invalidInputImage: UIImage? = UIImage() //.init(named: "icon_invalid", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    public var validInputImage: UIImage? = UIImage() //.init(named: "icon_check", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    public var displaysIcon: Bool = false { didSet {
        leftIcon.isHidden = !displaysIcon
    }}
    
    public var validation: AppRoundedTextFieldValidation = .neutral { didSet {
        setValidation(validation)
    }}
    
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
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        let responder = super.becomeFirstResponder()
        backgroundView.layer.borderColor = (responder ? primaryColor:bgColor).cgColor //appColor(ofType: .primary) : bgColor).cgColor
        return responder
    }
    
    public override var placeholder: String? {
        didSet { setupPlaceholder() }
    }
    
    fileprivate func setupPlaceholder() {
        guard  let `placeholder` = placeholder else { return }
        let attributedPlaceholder = NSMutableAttributedString(string: placeholder)
        attributedPlaceholder.addAttributes([.foregroundColor: self.secondaryColor.withAlphaComponent(0.5)], range: NSRange(location: 0, length: placeholder.count))
        self.attributedPlaceholder = attributedPlaceholder
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
        //font = UIFont.appFont(forTextStyle: .large)
        
        addSubview(backgroundView)
        addSubview(leftIcon)
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
            leftIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            leftIcon.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            leftIcon.widthAnchor.constraint(equalToConstant: 24),
            leftIcon.heightAnchor.constraint(equalToConstant: 24)
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
        leftIcon.layer.cornerRadius = leftIcon.bounds.size.height/2
        leftIcon.clipsToBounds = true
    }
}

// MARK: Control functions

public extension AppRoundedTextField {
    fileprivate func setValidation(_ validation: AppRoundedTextFieldValidation) {
        switch validation {
        case .invalid(let message):
            backgroundView.layer.borderColor = errorColor.cgColor
            validationImage.image = invalidInputImage?.asTemplate
            validationImage.tintColor = errorColor
            if let message = message { errorLabel.text = message }
            errorLabel.isHidden = false
        case .valid:
            backgroundView.layer.borderColor = (isFirstResponder ? primaryColor:bgColor).cgColor
            validationImage.image = validInputImage?.asTemplate
            validationImage.tintColor = primaryColor
            errorLabel.isHidden = true
        case .neutral:
            backgroundView.layer.borderColor = isFirstResponder ? primaryColor.cgColor:bgColor.cgColor
            validationImage.image = nil
            errorLabel.isHidden = true
        }
    }
}
