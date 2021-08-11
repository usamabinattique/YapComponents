//
//  StaticAppTextField.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 03/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

open class StaticAppTextField: UIView {

    // MARK: - SubViews
    lazy var titleLabel = UILabelFactory.createUILabel(with: .primary, textStyle: .small)
    lazy var textLabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .large, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    lazy var editButton = UIButtonFactory.createButton(title:  "common_button_edit".localized, backgroundColor: .clear)
    lazy var textButtonStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .bottom, distribution: .fill, spacing: 5, arrangedSubviews: [textLabel])
    lazy var buttomBorder = UIView()
    lazy var contentStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .fill, distribution: .fill, spacing: 5, arrangedSubviews: [titleLabel, textButtonStackView, buttomBorder])
    
    // MARK: - Properties
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
        titleLabel.textColor = UIColor.greyDark
        buttomBorder.backgroundColor = .greyLight
        editButton.setContentHuggingPriority(.required, for: .horizontal)
        editButton.contentHorizontalAlignment = .right
        editButton.setTitleColor(.primary, for: .normal)
        editButton.titleLabel?.font = UIFont.appFont(forTextStyle: .small)
    }
    
    func setupConstraints() {
        contentStackView.alignEdgesWithSuperview([.left, .top, .right, .bottom], constants: [0, 5, 0, 5])
        buttomBorder.height(constant: 1)
        height(.greaterThanOrEqualTo, constant: 64)
    }
}

// MARK: - StaticAppTextField+Rx
extension Reactive where Base: StaticAppTextField {
    public var title: Binder<String?> {
        return Binder(self.base) { field, title in
            field.titleLabel.text = title
        }
    }
    
    public var text: Binder<String?> {
        return Binder(self.base) { field, text in
            field.textLabel.text = text
        }
    }
    
    public var editObserver: ControlEvent<Void> {
        return base.editButton.rx.tap
    }
}
