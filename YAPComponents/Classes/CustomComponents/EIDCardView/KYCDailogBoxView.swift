//
//  KYCDailogBoxView.swift
//  YAPKit
//
//  Created by Aurangzaib on 6/28/21.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


public enum DialogButtonType {
    case yes
    case no
}


public class KYCDailogBoxView: UIView {
    
    //MARK: - UI Components
    
    private lazy var detailLabel: UILabel = UILabelFactory
                .createUILabel(with: .primary,
                               textStyle: .small,
                               alignment: .left,
                               numberOfLines: 0)
    
    fileprivate lazy var leftButton = UIButtonFactory.createButton(backgroundColor: .clear)
    
    fileprivate lazy var rightButton = UIButtonFactory.createButton(backgroundColor: .clear)
    
    private lazy var buttonStack: UIStackView = UIStackViewFactory
                .createStackView(with: .horizontal,
                                 alignment: .center,
                                 distribution: .fillEqually,
                                 spacing: 15,
                                 arrangedSubviews: [leftButton, rightButton])
    
    
    // MARK: - Control properties
    
    public var detailColor: UIColor = .greyDark {
        didSet {
            detailLabel.textColor = detailColor
        }
    }
    
    public var detailText: String? = nil {
        didSet {
            detailLabel.text = detailText
        }
    }
    
    public var buttonTitleColor: UIColor = .greyDark {
        didSet {
            leftButton.setTitleColor(buttonTitleColor, for: .normal)
            rightButton.setTitleColor(buttonTitleColor, for: .normal)
        }
    }
    
    public var buttonsTitleColor: UIColor = .greyDark {
        didSet {
            leftButton.setTitleColor(buttonTitleColor, for: .normal)
            rightButton.setTitleColor(buttonTitleColor, for: .normal)
        }
    }
    
    public var buttonsBGColor: UIColor = .greyDark {
        didSet {
            leftButton.backgroundColor = buttonsBGColor
            rightButton.backgroundColor = buttonsBGColor
        }
    }
    
    public var leftButtonTitle: String = "" {
        didSet {
            leftButton.setTitle(leftButtonTitle, for: .normal)
        }
    }
    
    public var leftButtonBorderColor: UIColor = .primary {
        didSet {
            leftButton.layer.borderColor = leftButtonBorderColor.cgColor
        }
    }
    
    public var rightButtonTitle: String = "" {
        didSet {
            rightButton.setTitle(rightButtonTitle, for: .normal)
        }
    }
    
    public var rightButtonBorderColor: UIColor = .primary {
        didSet {
            rightButton.layer.borderColor = leftButtonBorderColor.cgColor
        }
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public convenience init(with detailText: String, leftButtonTitle: String, rightButtonTitle: String) {
        self.init(frame: .zero)
        
        detailLabel.text = detailText
        leftButton.setTitle(leftButtonTitle, for: .normal)
        rightButton.setTitle(rightButtonTitle, for: .normal)
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        isUserInteractionEnabled = true
        setupViews()
        setupConstraints()
        render()
    }
}

private extension KYCDailogBoxView {
    func setupViews() {
        [detailLabel, buttonStack].forEach(self.addSubview)
    }
    
    func setupConstraints() {
        
        detailLabel
            .alignEdgesWithSuperview([.top, .left, .right], constants: [10, 24, 24])
        
        buttonStack
            .toBottomOf(detailLabel, constant: 20)
            .alignEdgesWithSuperview([.left, .bottom, .right], constants: [24, 10, 24])
            .height(constant: 66)
        
        [leftButton, rightButton].forEach{ (button) in
            button
                .height(constant: 56)
        }
    }
    
    func render() {
        [leftButton,rightButton].forEach { (button) in
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.greyDark.cgColor
        }
    }
}

// MARK: Reactive

extension Reactive where Base: KYCDailogBoxView {
  
    public var title: Binder<String?> {
        return Binder(self.base) { docView, title in
            docView.detailText = title
        }
    }
    
    public var leftTap: ControlEvent<Void>  {
        return self.base.leftButton.rx.tap
    }
    
    public var rightTap: ControlEvent<Void>  {
        return self.base.rightButton.rx.tap
    }
    
    public var tap: Observable<Void> {
        return Observable.merge(self.base.leftButton.rx.tap
                                    .do(onNext: { _ in
                                        self.restButtonView()
                                        self.updateLeftSelected(button: self.base.leftButton)
                                    }),
                                self.base.rightButton.rx.tap
                                    .do(onNext: { _ in
                                        self.restButtonView()
                                        self.updateLeftSelected(button: self.base.rightButton)
                                    })
        )
    }
    
    
    private func updateLeftSelected(button: UIButton) {
        button.backgroundColor = UIColor.greyLight
        button.setTitleColor(.primary, for: .normal)
        button.layer.borderColor = UIColor.primary.cgColor
    }
    
    private func restButtonView() {
        self.base.buttonTitleColor = .primaryDark
        self.base.leftButtonBorderColor = .primary
        self.base.rightButtonBorderColor = .primary
        self.base.buttonsBGColor = .white
        self.base.render()
    }
}
