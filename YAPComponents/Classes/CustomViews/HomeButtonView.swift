//
//  HomeButtonView.swift
//  YAP
//
//  Created by Zain on 27/11/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


public class HomeButtonView: UIView {
    
    // MARK: Views
    
    fileprivate lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primary
        button.tintColor = .white
        button.setImage(UIImage.init(named: "icon_home_add", in: yapKitBundle, compatibleWith: nil)?.asTemplate, for: .normal)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var analyticsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primary
        button.tintColor = .white
        button.setImage(UIImage.init(named: "icon_home_analytics", in: yapKitBundle, compatibleWith: nil)?.asTemplate, for: .normal)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addTitle = UILabelFactory.createUILabel(with: .primary, textStyle: .micro, alignment: .center, text: "Add money")
    
    private lazy var analyticsTitle = UILabelFactory.createUILabel(with: .primary, textStyle: .micro, alignment: .center, text: "Analytics")
    
    private lazy var addStack = UIStackViewFactory.createStackView(with: .vertical, alignment: .center, distribution: .fill, spacing: 7, arrangedSubviews: [addButton, addTitle])
    
    private lazy var analyticsStack = UIStackViewFactory.createStackView(with: .vertical, alignment: .center, distribution: .fill, spacing: 7, arrangedSubviews: [analyticsButton, analyticsTitle])
    
    private lazy var stack = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fill, spacing: 50, arrangedSubviews: [addStack, analyticsStack])
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    
    // MARK: Drawings
    
    override public func draw(_ rect: CGRect) {
        addButton.roundView()
        analyticsButton.roundView()
    }
    
    // MARK: Public methods
    
    public func setProgress(_ progress: CGFloat) {
        let coeficient: CGFloat = 0.4
        let progress = progress > 1 ? 1 : progress < coeficient ? 0 : (progress - coeficient) * (1/coeficient)
        
        self.alpha = progress
    }
}

// MARK: View setup

private extension HomeButtonView {
    func setupViews() {
        addSubview(stack)
    }
    
    func setupConstraints() {
        stack
            .centerInSuperView()
        
        addButton
            .height(constant: 36)
            .width(constant: 36)
        
        analyticsButton
            .height(with: .height, ofView: addButton)
            .width(with: .width, ofView: addButton)
        
        height(.greaterThanOrEqualTo, constant: 65)
    }
    
    func setOpacity(for isEnabled: Bool) {
        let alpha: CGFloat = isEnabled ? 1 : 0.5
        addButton.alpha = alpha
        analyticsButton.alpha = alpha
        addTitle.alpha = alpha
        analyticsTitle.alpha = alpha
    }
}

// MARK: Reactive

extension Reactive where Base: HomeButtonView {
    public var tap: Observable<Int> {
        return Observable.merge(self.base.addButton.rx.tap.map { self.base.addButton.tag }, self.base.analyticsButton.rx.tap.map { self.base.analyticsButton.tag })
    }
    
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.addButton.isEnabled = value
            control.analyticsButton.isEnabled = value
            control.setOpacity(for: value)
        }
    }
}
