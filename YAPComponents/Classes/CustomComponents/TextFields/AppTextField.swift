//
//  AppTextField.swift
//  YAPKit
//
//  Created by Zain on 23/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

open class AppTextField: UITextField {
    // MARK: - SubViews
    
    fileprivate lazy var title: UILabel = {
        let label = UILabel()
        label.font = .small
        label.textAlignment = .left
        label.textColor = .primaryDark
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .grey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var error: UILabel = {
        let label = UILabel()
        label.font = .micro
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .greyDark
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var tempPlaceholder: UILabel = {
        let label = UILabel()
        label.textColor = placeholderColor
        label.text = placeholder
        label.textAlignment = textAlignment
        label.font = font
        label.alpha = 0
        return label
    }()
    
    // MAKR: - Control properties
    
    public var invalidInputImage: UIImage? = UIImage.init(named: "icon_invalid", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    public var validInputImage: UIImage? = UIImage.init(named: "icon_check", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    
    public var validationState: AppTextField.ValidationState = .normal {
        didSet {
           // guard oldValue != validationState else { return }
            stateImage.isHidden = validationState == .normal
            stateImage.image = validationState == .valid ? validInputImage : validationState == .invalid ? invalidInputImage : nil
            stateImage.tintColor = validationState == .valid ? .primary : validationState == .invalid ? .error : .clear
            bottomBar.backgroundColor = validationState == .invalid ? .error : isFirstResponder ? .primary : .grey
            error.isHidden = validationState != .invalid
        }
    }
    
    public var showsIcon: Bool = false {
        didSet {
            icon.isHidden = !showsIcon
        }
    }
    
    public var errorText: String? {
        get { return error.text }
        set (newValue) { error.text = newValue }
    }
    
    public var titleText: String? {
        get { return title.text }
        set (newValue) { title.text = newValue }
    }
    
    public var iconImage: UIImage? {
        get { return icon.image }
        set (newValue) {
            icon.image = newValue
            showsIcon = newValue != nil
        }
    }
    
    public var errorAlignment: NSTextAlignment? {
        didSet {
            error.textAlignment = errorAlignment ?? NSTextAlignment.left
        }
    }
    
    open override var text: String? {
        didSet {
            guard text?.count ?? 0 > 0, !isFirstResponder else { return }
            title.textColor = .greyDark
            tempPlaceholder.text = nil
        }
    }
    
    open override var attributedText: NSAttributedString? {
        didSet {
            guard text?.count ?? 0 > 0, !isFirstResponder else { return }
            title.textColor = .greyDark
        }
    }
    
    public var placeholderColor: UIColor = UIColor.greyDark {
        didSet {
            let placeholder = self.placeholder
            self.placeholder = placeholder
        }
    }
    
    public override var placeholder: String? {
        didSet {
            guard  let `placeholder` = placeholder else { return }
            let attributedPlaceholder = NSMutableAttributedString(string: placeholder)
            attributedPlaceholder.addAttributes([.foregroundColor: self.placeholderColor], range: NSRange(location: 0, length: placeholder.count))
            self.attributedPlaceholder = attributedPlaceholder
        }
    }
    
    public var animatesTitleOnEditingBegin: Bool = true
    
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
        tempPlaceholder.removeFromSuperview()
    }
}

// MARK: - Responder

extension AppTextField {
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        bottomBar.backgroundColor = .primary
        title.textColor = .greyDark
        textColor = .primaryDark
        animateFocus()
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    open override func resignFirstResponder() -> Bool {
        bottomBar.backgroundColor = .grey
        title.textColor = (text == nil || text?.count ?? 0 == 0) ? .primaryDark : .greyDark
        return super.resignFirstResponder()
    }
}

// MARK: Drawing

extension AppTextField {
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = self.rect(forBounds: bounds)
        rect.size.height = rect.size.height < 55 ? 55 : rect.size.height
        return rect
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = self.rect(forBounds: bounds)
        rect.size.height = rect.size.height < 55 ? 55 : rect.size.height
        return rect
    }
    
    private func rect(forBounds bounds: CGRect) -> CGRect {
        let originY = title.frame.origin.y + title.frame.size.height
        let height = bottomBar.frame.origin.y - originY
        return showsIcon ? CGRect(x: bounds.origin.x+40, y: originY, width: bounds.size.width - 70, height: height) : CGRect(x: bounds.origin.x, y: originY, width: bounds.size.width - 30, height: height)
        
    }
}

// MARK: - View setup

private extension AppTextField {
    func setupViews() {
        addSubview(title)
        addSubview(icon)
        addSubview(stateImage)
        addSubview(bottomBar)
        addSubview(error)
    }
    
    func setupConstraints() {
        let titleConstraints = [
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            trailingAnchor.constraint(lessThanOrEqualTo: title.trailingAnchor, constant: 0),
            title.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let iconConstraints = [
            icon.leadingAnchor.constraint(equalTo: leadingAnchor),
            icon.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            bottomBar.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 4),
            icon.widthAnchor.constraint(equalToConstant: 30)
        ]
        
        let stateImageConstraints = [
            trailingAnchor.constraint(equalTo: stateImage.trailingAnchor),
            stateImage.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            stateImage.heightAnchor.constraint(equalToConstant: 20),
            stateImage.widthAnchor.constraint(equalToConstant: 20)
        ]
        
        let errorConstraints = [
            error.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: error.trailingAnchor),
            bottomAnchor.constraint(equalTo: error.bottomAnchor, constant: 3),
            error.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let bottomBarConstraints = [
            bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor),
            error.topAnchor.constraint(equalTo: bottomBar.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        NSLayoutConstraint.activate(titleConstraints + iconConstraints + stateImageConstraints + errorConstraints + bottomBarConstraints)
    }
}

// MARK: - Validation

extension AppTextField {
    public enum ValidationState {
        case normal
        case valid
        case invalid
    }
}

// MARK: Animations

private extension AppTextField {
    func animateFocus() {
        guard (text?.isEmpty ?? true) && (attributedText?.string.isEmpty ?? true) && animatesTitleOnEditingBegin else { return }

        tempPlaceholder.alpha = 0
        tempPlaceholder.text = placeholder
//        addSubview(tempPlaceholder)
        tempPlaceholder.frame = rect(forBounds: bounds)
        
        var frame = title.frame
        let originX = frame.origin.x
        frame.origin.y += 30
        frame.origin.x += title.frame.size.width*0.15
        title.frame = frame
        title.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        
//        let placeholder = self.placeholder
//        self.placeholder = nil
        
        UIView.animate(withDuration: 0.4, animations: { [unowned self] in
            self.title.transform = .identity
            var frame = self.title.frame
            frame.origin.y -= 30
            frame.origin.x = originX
            self.title.frame = frame
            self.tempPlaceholder.alpha = 1
        }) { [unowned self] completed in
            guard completed else { return }
            self.tempPlaceholder.removeFromSuperview()
//            self.placeholder = placeholder
        }
    }
}

// MARK: - Reactive

public extension Reactive where Base: AppTextField {
    
    var validationState: Binder<AppTextField.ValidationState> {
        return Binder(self.base) { textField, validation -> Void in
            textField.validationState = validation
        }
    }
    
    var icon: Binder<UIImage?> {
        return Binder(self.base) { textField, iconImage -> Void in
            textField.iconImage = iconImage
        }
    }
    
    var errorText: Binder<String?> {
        return self.base.error.rx.text
    }
    
    var titleText: Binder<String?> {
        return self.base.title.rx.text
    }
    
    var animatesTitleOnEditingBegin: Binder<Bool> {
        return Binder(self.base) { textField, animates -> Void in
            textField.animatesTitleOnEditingBegin = animates
        }
    }
}
