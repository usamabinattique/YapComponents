//
//  YAPAlert.swift
//  YAPKit
//
//  Created by Zain on 16/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
//import RxCocoa
//import RxSwift

open class YAPAlert: UIView {
    
    // MARK: Views
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var alertLabel: UILabel = {
        let label = UIFactory.makeLabel(numberOfLines: 0, lineBreakMode: .byWordWrapping)
        label.textColor = .blue //with: .primary, textStyle: .micro,
        label.setContentHuggingPriority(.init(250), for: .horizontal)
        return label
    }()
    
    //Added with reactive extension
    public lazy var actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        //button.titleLabel?.font = .micro
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.init(251), for: .horizontal)
        return button
    }()
    
    private lazy var horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var iconAdded: Bool = false
    private var buttonAdded: Bool = false
    private var shown: Bool = false
    
    // MARK: Properties
    
    public var alertType: YAPAlert.AlertType = .error {
        didSet {
            render()
        }
    }
    
    public var text: String? {
        didSet {
            alertLabel.text = text
        }
    }
    
    private var direction: AlertDirection = .top
    
    /*public var textStyle: AppTextStyle? {
        didSet {
            guard let style = textStyle else { return }
            alertLabel.font = .appFont(forTextStyle: style)
            if buttonAdded { actionButton.titleLabel?.font = .appFont(forTextStyle: style) }
        }
    }*/
    
    public var icon: UIImage? {
        didSet {
            if !iconAdded {
                iconAdded = true
                horizontalStack.insertArrangedSubview(iconImageView, at: 0)
                iconImageView
                    .height(constant: 22)
                    .width(with: .height, ofView: iconImageView)
                //if let style = textStyle { actionButton.titleLabel?.font = .appFont(forTextStyle: style) }
            }
            iconImageView.image = icon
        }
    }
    
    public var actionTitle: String? {
        didSet {
            if !buttonAdded {
                buttonAdded = true
                horizontalStack.addArrangedSubview(actionButton)
                actionButton
                    .width(constant: 130)
            }
            actionButton.setTitle(actionTitle, for: .normal)
        }
    }
    
    public var attributedActionTitle: NSAttributedString? {
        didSet {
            if !buttonAdded {
                buttonAdded = true
                horizontalStack.addArrangedSubview(actionButton)
                actionButton
                    .width(constant: 130)
            }
            actionButton.setAttributedTitle(attributedActionTitle, for: .normal)
        }
    }
    
    var movingConstraint: NSLayoutConstraint!
    
    // MAKR: Initializaion
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupConstraints()
        render()
    }
    
}

// MARK: View setup

private extension YAPAlert {
    func setupViews() {
        addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(alertLabel)
    }
    
    func setupConstraints() {
        horizontalStack
            .alignEdgesWithSuperview([.left, .top, .right, .bottom], constants: [20, 8, 20, 8])
        
    }
    
    func render() {
        switch alertType {
        case .success:
            iconImageView.isHidden = true
            actionButton.isHidden = true
            backgroundColor = UIColor.init(red: 236/255, green: 250/255, blue: 243/255, alpha: 1)
            alertLabel.textColor = UIColor.init(red: 0/255, green: 185/255, blue: 174/255, alpha: 1)
            
        case .error:
            iconImageView.isHidden = true
            actionButton.isHidden = true
            backgroundColor = UIColor.init(red: 255/255, green: 244/255, blue: 243/255, alpha: 1)
            alertLabel.textColor = UIColor.init(red: 244/255, green: 71/255, blue: 116/255, alpha: 1)
            
        case .notificaiton:
            iconImageView.isHidden = false
            actionButton.isHidden = false
            backgroundColor = .blue //.primary
            alertLabel.textColor = .white
            iconImageView.tintColor = .white
        }
    }
}

// MARK: Show/Hide alert

public extension YAPAlert {
    func show(inView view: UIView, type: YAPAlert.AlertType, text: String, from direction: YAPAlert.AlertDirection = .top, autoHides: Bool = true, autoHideDuration: TimeInterval = 5) {
        self.direction = direction
        alertLabel.text = text
        guard !shown else { return }
        shown = true
        showWithAnimation(inView: view, type: type, text: text, from: direction, autoHides: autoHides, autoHideDuration: autoHideDuration)
    }
    
    func hide(_ completion: (() -> Void)? = nil) {
        guard shown else { return }
        shown = false
        if direction == .top {
            self.movingConstraint.constant = bounds.height
        } else {
            self.movingConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.superview?.layoutIfNeeded()
        }) { (completed) in
            guard completed else { return }
            completion?()
            self.removeFromSuperview()
        }
    }
    
    func cancelAnimations() {
        self.layer.removeAllAnimations()
    }
    
    private func showWithAnimation(inView view: UIView, type: YAPAlert.AlertType, text: String, from direction: YAPAlert.AlertDirection = .top, autoHides: Bool = true, autoHideDuration: TimeInterval = 5) {
        self.alertType = type
        self.text = text
        self.alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        width(with: .width, ofView: view)
        
        switch direction {
        case .left:
            movingConstraint = view.leadingAnchor.constraint(equalTo: trailingAnchor)
            alignEdgeWithSuperviewSafeArea(.top)
        case .top:
            movingConstraint = view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: bounds.height)
            alignEdgesWithSuperview([.left, .right])
        case .right:
            movingConstraint = leadingAnchor.constraint(equalTo: view.trailingAnchor)
            alignEdgeWithSuperviewSafeArea(.top)
        case .bottom:
            movingConstraint = topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            alignEdgesWithSuperview([.left, .right])
        }
        movingConstraint.isActive = true
        view.layoutIfNeeded()
        
        switch direction {
        case .left:
            movingConstraint.constant = -1 * bounds.width
        case .top:
            movingConstraint.constant = 0
        case .right:
            movingConstraint.constant = bounds.width
        case .bottom:
            movingConstraint.constant = bounds.height
        }
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            view.layoutIfNeeded()
        }
        
        guard autoHides else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + autoHideDuration) { [weak self] in self?.hide() }
    }
}

// MARK: Alert Type

public extension YAPAlert {
    enum AlertType {
        case success
        case error
        case notificaiton
    }
}

// MAKR: Alert Direction

public extension YAPAlert {
    enum AlertDirection {
        case left
        case top
        case right
        case bottom
    }
}
