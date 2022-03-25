//
//  StaticAppTextField.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 03/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation


import YAPComponents
import UIKit

open class StaticAppTextField: UIView {

    // MARK: - SubViews
    public lazy var titleLabel = UIFactory.makeLabel()
    public lazy var textLabel = UIFactory.makeLabel()
    public lazy var editButton = UIFactory.makeButton(with: UIFont.systemFont(ofSize: 16.0), backgroundColor: .clear, title: "Edit")
    public lazy var fieldIcon = UIFactory.makeImageView()
    public lazy var textButtonStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .bottom, distribution: .fill, spacing: 5, arrangedSubviews: [textLabel, fieldIcon])
    public lazy var bottomBorder = UIView()
    lazy var contentStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .fill, distribution: .fill, spacing: 5, arrangedSubviews: [titleLabel, textButtonStackView, bottomBorder])
    
    
    // MARK: - Properties
    
    public var titleColor: UIColor = UIColor.hexStringToUIColor(hex: "5E35B1") {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    public var textColor: UIColor = UIColor.hexStringToUIColor(hex: "272262") {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    public var titleFont: UIFont = .systemFont(ofSize: 14, weight: .regular) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    public var textFont: UIFont = .systemFont(ofSize: 14, weight: .regular) {
        didSet {
            textLabel.font = textFont
            textLabel.lineBreakMode = .byWordWrapping
            textLabel.numberOfLines = 0
        }
    }
    
    public var textFieldIcon: UIImage = UIImage() {
        didSet {
            fieldIcon.image = textFieldIcon
        }
    }
    
    public var shouldShowIcon: Bool = false {
        didSet {
            fieldIcon.isHidden = !shouldShowIcon
        }
    }
    
    var isEditable: Bool = false {
        didSet {
            if !textButtonStackView.subviews.contains(editButton) && isEditable {
                textButtonStackView.addArrangedSubview(editButton)
            } else {
                editButton.removeFromSuperview()
            }
        }
    }
    
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
}

// MARK: - View Setup
private extension StaticAppTextField {
    func setupViews() {
        addSubview(contentStackView)
        titleLabel.textColor = UIColor.hexStringToUIColor(hex: "9391B1")
        bottomBorder.backgroundColor = UIColor.hexStringToUIColor(hex: "DAE0F0")
        editButton.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        editButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        editButton.setTitleColor(UIColor.hexStringToUIColor(hex: "5E35B1"), for: UIControl.State.normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    func setupConstraints() {
        contentStackView.alignEdgesWithSuperview([.left, .top, .right, .bottom], constants: [0, 5, 0, 5])
        bottomBorder.height(constant: 1)
        height(.greaterThanOrEqualTo, constant: 64)
    }
}

public extension UIFactory {
    
    class func makeStaticTextField(title: String = String(),
                                   titleColor: UIColor = UIColor.hexStringToUIColor(hex: "272262"),
                                   titleFont: UIFont,
                                   text: String = String(),
                                   textColor: UIColor = UIColor.hexStringToUIColor(hex: "272262"),
                                   textFont: UIFont,
                                   fieldIcon: UIImage = UIImage(),
                                   shouldShowIcon: Bool = false,
                                   isEditable: Bool = false) -> StaticAppTextField {
        let field = StaticAppTextField()
        field.titleLabel.text = title
        field.titleColor = titleColor
        field.titleFont = titleFont
        field.textLabel.text = text
        field.textColor = textColor
        field.textFont = textFont
        field.isEditable = isEditable
        field.fieldIcon.image = fieldIcon
        field.shouldShowIcon = shouldShowIcon
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
}
