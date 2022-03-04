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
    lazy var titleLabel = UIFactory.makeLabel()
    lazy var textLabel = UIFactory.makeLabel()
    lazy var editButton = UIFactory.makeButton(with: .regular, backgroundColor: .clear, title: "common_button_edit".localized)
    lazy var fieldIcon = UIFactory.makeImageView()
    lazy var textButtonStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .bottom, distribution: .fill, spacing: 5, arrangedSubviews: [textLabel, fieldIcon])
    lazy var bottomBorder = UIView()
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
    
    var shouldShowIcon: Bool = false {
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
        titleLabel.textColor = UIColor.hexStringToUIColor(hex: "9391B1")//UIColor.greyDark //9391B1
        bottomBorder.backgroundColor = UIColor.hexStringToUIColor(hex: "DAE0F0")//.greyLight //DAE0F0
        editButton.setContentHuggingPriority(.required, for: .horizontal)
        editButton.contentHorizontalAlignment = .right
        editButton.setTitleColor(UIColor.hexStringToUIColor(hex: "5E35B1"), for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
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
