//
//  UIRoundedTextField.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 18/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//TODO UIRoundedTextField screen Needs to be refacrtor.

public class UIRoundedTextField: UITextField {
    
    // MARK: - Properties
    public lazy var validImageView: UIView = {
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightView.clipsToBounds = true
        rightViewContainer.addSubview(rightView)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_check", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.appColor(ofType: .primary)
        imageView.frame = CGRect(x: 5, y: 0, width: 25, height: 20)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        rightView.addSubview(imageView)
        
        return rightViewContainer
    }()
    
    public lazy var inValidImageView: UIView = {
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightView.clipsToBounds = true
        rightViewContainer.addSubview(rightView)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_invalid", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.appColor(ofType: .error)
        imageView.frame = CGRect(x: 5, y: 0, width: 30, height: 20)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        rightView.addSubview(imageView)
        
        return rightViewContainer
    }()
    
    public lazy var noImageView: UIView = {
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        let rightView = UIView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        rightView.clipsToBounds = true
        rightViewContainer.addSubview(rightView)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_close_purple", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.appColor(ofType: .grey)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 16)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        rightView.addSubview(imageView)
        
        return rightViewContainer
    }()
    
    
    public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    public var borderWidth: CGFloat = 1.5 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    public var backGroundColor: UIColor = UIColor.appColor(ofType: .greyLight).withAlphaComponent(0.36) {
        didSet {
            self.layer.backgroundColor = backGroundColor.cgColor
        }
    }
    
    fileprivate var changeBorderColor: Bool = false {
        didSet {
            layer.borderColor = changeBorderColor ? UIColor.appColor(ofType: .primary).cgColor : UIColor.clear.cgColor
        }
    }
    
    public var placeHolder: String? = "Email or phone number" {
        didSet {
            self.placeholder = placeholder
            commonInit()
        }
    }
    
    public var placeHolderTextColor: UIColor?  = UIColor.greyDark {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeHolder ?? "",
                                                       attributes: [NSAttributedString.Key.foregroundColor: placeHolderTextColor ?? UIColor.greyDark])
        }
    }
    
    public override var isEnabled: Bool {
        willSet {
            textColor = newValue ? UIColor.darkText : UIColor.gray
        }
    }
    
    public var cornerRadius: Bool = true
    
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
        textFieldConfiguration()
        textFieldClearMode()
        borderStyle = .none
        clipsToBounds = true
        delegate = self
    }
    
    func textFieldConfiguration() {
        self.rightViewMode = .always
        self.rightView = noImageView
        self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 2.0))
        leftView.backgroundColor = UIColor.clear
        self.leftView = leftView
        leftViewMode = .always
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        self.placeholder = placeHolder
        attributedPlaceholder = NSAttributedString(string: placeHolder ?? "",
        attributes: [NSAttributedString.Key.foregroundColor: placeHolderTextColor ?? UIColor.greyDark])
        self.layer.backgroundColor = backGroundColor.cgColor
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if cornerRadius {
            layer.cornerRadius = bounds.height / 2
        }
    }
    
    public var isInputValid: TextFieldValidationStatus = .valid {
        didSet {
            switch isInputValid {
            case .valid:
                self.rightView =  validImageView
            case .inValid:
                self.rightView =  inValidImageView
            case .notDetermined:
                self.rightView =  noImageView
            }
        }
    }
    
    func textFieldClearMode() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldClearModeAction(tapGestureRecognizer:)))
        noImageView.isUserInteractionEnabled = true
        noImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func textFieldClearModeAction(tapGestureRecognizer: UITapGestureRecognizer) {
        text = ""
        sendActions(for: .valueChanged)
    }
    
}

extension UIRoundedTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.changeBorderColor = true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.changeBorderColor = false
    }
    
}
extension Reactive where Base: UIRoundedTextField {
    public var isInputValid: Binder<TextFieldValidationStatus> {
        return Binder(self.base) { textField, isValid in
            textField.isInputValid = isValid
            if textField.text == "" {
                textField.noImageView.isHidden = true
            }else{
                textField.noImageView.isHidden = false
            }
        }
    }
}
