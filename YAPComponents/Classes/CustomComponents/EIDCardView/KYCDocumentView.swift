//
//  KYCDocumentView.swift
//  YAPKit
//
//  Created by Zain on 06/08/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class KYCDocumentView: UIView {
    
    private lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor = .white
        imageView.tintColor = .primary
        imageView.layer.cornerRadius = 21
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var validationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(self.attributedString("common_button_edit".localized ), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    private lazy var horizontalStack: UIStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fill, spacing: 15)
    private lazy var mainStack: UIStackView = UIStackViewFactory.createStackView(with: .vertical, spacing: 20)
    private lazy var topStack: UIStackView = UIStackViewFactory.createStackView(with: .vertical, spacing: 5)
    private lazy var bottomStack: UIStackView = UIStackViewFactory.createStackView(with: .vertical, spacing: 5)
    private lazy var titleLabel: UILabel = UILabelFactory.createUILabel(with: .white, textStyle: .large, alignment: .left, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    private lazy var detailsLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .small, alignment: .left, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    private lazy var subTitleLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .small, alignment: .left, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    private lazy var subDetailsLabel: UILabel = UILabelFactory.createUILabel(with: .white, textStyle: .large, alignment: .left, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    fileprivate let tapSubject = PublishSubject<Void>()
    
    public var titleColor: UIColor = .greyDark {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    public var subTitleColors: UIColor = .greyDark {
        didSet {
            detailsLabel.textColor = subTitleColors
            subDetailsLabel.textColor = subTitleColors
        }
    }
    
    public var viewBackgroundColor: UIColor = .primary {
        didSet {
            backgroundColor = viewBackgroundColor
        }
    }
    
    // MARK: Control properties
    
    public var viewType: KYCDocumentView.ViewType = .detailsAndSubDetails {
        didSet {
            bottomStack.isHidden = viewType == .detailsOnly
            editButton.isHidden = viewType == .detailsOnly
        }
    }
    
    public var validation: KYCDocumentView.Validation = .notDetermined {
        didSet {
            validationImage.isHidden = validation == .notDetermined
            rightView.isHidden = validation == .notDetermined
            switch validation {
            case .valid:
                validationImage.image = UIImage(named: "icon_check", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                validationImage.tintColor = .white
                validationImage.backgroundColor = .primary
                validationImage.layer.cornerRadius = 16
            case .invalid:
                validationImage.image =  UIImage(named: "icon_invalid_document", in: yapKitBundle, compatibleWith: nil)
                validationImage.tintColor = .error
            case .notDetermined:
                validationImage.image = nil
            }
        }
    }
    
    public var title: String? = nil {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var details: String? = nil {
        didSet {
            detailsLabel.text = details
        }
    }
    
    public var subTitle: String? = nil {
        didSet {
            subTitleLabel.text = subTitle
        }
    }
    
    public var subDetails: String? = nil {
        didSet {
            subDetailsLabel.text = subDetails
        }
    }
    
    public var icon: UIImage? = nil {
        didSet {
            iconImage.image = icon
        }
    }
    
    public var validateIcon: UIImage? = nil {
        didSet {
            validationImage.image = validateIcon
        }
    }
    
    // MAKR: Initialization
    
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
        backgroundColor = .primary
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(_tapped(_:))))
        setupViews()
        setupConstraints()
    }
}

// MARK: View setup

private extension KYCDocumentView {
    func setupViews() {
        addSubview(iconImage)
        addSubview(validationImage)
        addSubview(editButton)
        addSubview(horizontalStack)
        
        horizontalStack.addArrangedSubview(mainStack)
        horizontalStack.addArrangedSubview(rightView)
        
        mainStack.addArrangedSubview(topStack)
        mainStack.addArrangedSubview(bottomStack)
        
        topStack.addArrangedSubview(titleLabel)
        topStack.addArrangedSubview(detailsLabel)
        
        bottomStack.addArrangedSubview(subTitleLabel)
        bottomStack.addArrangedSubview(subDetailsLabel)
    }
    
    func setupConstraints() {
        iconImage
            .alignEdgeWithSuperview(.left, constant: 20)
            .width(constant: 42)
            .height(constant: 42)
            .alignEdge(.top, withView: topStack)
        
        validationImage
            .alignEdgeWithSuperview(.right, constant: 20)
            .alignEdge(.centerY, withView: iconImage)
            .width(constant: 32)
            .height(constant: 32)
        
        horizontalStack
            .toRightOf(iconImage, constant: 23)
            .alignEdgesWithSuperview([.top, .bottom, .right], constants: [33, 33, 20])
        
        editButton
            .alignEdge(.centerX, withView: validationImage)
            .alignEdge(.centerY, withView: bottomStack)
            .width(constant: 40)
            .height(constant: 25)
        
        rightView
            .height(with: .height, ofView: validationImage)
            .width(with: .width, ofView: validationImage)
    }
}

// MARK: Drawing

extension KYCDocumentView {
    public override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}

// MARK: Helper functions

extension KYCDocumentView {
    private func attributedString(_ string: String) -> NSAttributedString? {
        let attribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.appFont(forTextStyle: .micro),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: string, attributes: attribute)
        return attributedString
    }
    
    @objc
    private func _tapped(_ sender: UIGestureRecognizer) {
        tapSubject.onNext(())
    }
}

// MARK: Enums

public extension KYCDocumentView {
    enum ViewType {
        case detailsOnly
        case detailsAndSubDetails
    }
    
    enum Validation {
        case valid
        case invalid
        case notDetermined
    }
}

// MARK: Reactive

extension Reactive where Base: KYCDocumentView {
    public var viewType: Binder<KYCDocumentView.ViewType> {
        return Binder(self.base) { docView, viewType in
            docView.viewType = viewType
        }
    }
    
    public var validation: Binder<KYCDocumentView.Validation> {
        return Binder(self.base) { docView, validation in
            docView.validation = validation
        }
    }
    
    public var title: Binder<String?> {
        return Binder(self.base) { docView, title in
            docView.title = title
        }
    }
    
    public var subTitle: Binder<String?> {
        return Binder(self.base) { docView, subTitle in
            docView.subTitle = subTitle
        }
    }
    
    public var details: Binder<String?> {
        return Binder(self.base) { docView, details in
            docView.details = details
        }
    }
    
    public var subDetails: Binder<String?> {
        return Binder(self.base) { docView, subDetails in
            docView.subDetails = subDetails
        }
    }

    public var icon: Binder<UIImage?> {
        return Binder(self.base) { docView, icon in
            docView.icon = icon
        }
    }
    
    public var validationImage: Binder<UIImage?> {
        return Binder(self.base) { docView, image in
            docView.validateIcon = image
        }
    }
    
    public var tap: Observable<Void> {
        return self.base.tapSubject.asObservable()
    }
}
