//
//  TransferInformationView.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 11/12/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

#warning("This could not be part of components")
//import AppTranslation

public enum TransferType {
    case cashPickup
    case bankTransfer
}

public class TransferInformationView: UIView {
    
    // MARK: - Views
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var shareButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var referenceNumberHeading: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro, alignment: .center, numberOfLines: 1)
    lazy var referenceNumber: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .title2, alignment: .center, numberOfLines: 1)
    lazy var locationHeading: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro, alignment: .center, numberOfLines: 1)
    lazy var location: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .micro, alignment: .center, numberOfLines: 0)
    lazy var shareLabel: UILabel = UILabelFactory.createUILabel(with: .primary, textStyle: .small, alignment: .center, numberOfLines: 1)
    lazy var shareButton: UIButton = UIButtonFactory.createButton(backgroundColor: .clear, textColor: .primary)
    lazy var shareImageView: UIImageView = UIImageViewFactory.createImageView(mode: .scaleAspectFill, tintColor: .primary)
    
    lazy var marginView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bottomMarginView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var marginViewBWReferenceNumberAndLocationHeading: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var marginViewBWLocationAndShareButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var bottomMarginConstant: CGFloat = 10
    
    // MARK: - Init
    
    public init(transferType: TransferType) {
        super.init(frame: CGRect.zero)
        if transferType == .bankTransfer {
            locationHeading.isHidden = true
            location.isHidden = true
            shareButtonContainerView.isHidden = true
            marginViewBWReferenceNumberAndLocationHeading.isHidden = true
            marginViewBWLocationAndShareButton.isHidden = true
            shareButtonContainerView.isHidden = true
            bottomMarginConstant = 20
        }
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    internal func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.greyLight.cgColor
        referenceNumberHeading.text =  "custom_view_funds_transfer_display_text_reference_number_heading".localized
        locationHeading.text =  "custom_view_funds_transfer_display_text_location_heading".localized
        shareLabel.text =  "custom_view_funds_transfer_button_title".localized
        shareImageView.image = UIImage.sharedImage(named: "image_share_primary")?.asTemplate
        
        shareButtonContainerView.backgroundColor = .clear
        
    }
    
    // MARK: - Lifecycle
    override public func layoutSubviews() {
        layer.cornerRadius = 12.0
    }
    
    fileprivate func setupViews() {
        mainStackView.addArrangedSubview(marginView)
        mainStackView.addArrangedSubview(referenceNumberHeading)
        mainStackView.addArrangedSubview(referenceNumber)
        mainStackView.addArrangedSubview(marginViewBWReferenceNumberAndLocationHeading)
        mainStackView.addArrangedSubview(locationHeading)
        mainStackView.addArrangedSubview(location)
        shareButtonContainerView.addSubview(shareLabel)
        shareButtonContainerView.addSubview(shareImageView)
        shareButtonContainerView.addSubview(shareButton)
        mainStackView.addArrangedSubview(marginViewBWLocationAndShareButton)
        mainStackView.addArrangedSubview(shareButtonContainerView)
        mainStackView.addArrangedSubview(bottomMarginView)
        addSubview(mainStackView)
    }
    
    fileprivate func setupConstraints() {
        mainStackView
            .alignEdgesWithSuperview([.left, .right, .bottom, .top], constants: [40, 40, 0, 0])
        
        marginView
            .height(.greaterThanOrEqualTo, constant: 10)
            .height(.lessThanOrEqualTo, constant: 20)
        
        marginViewBWReferenceNumberAndLocationHeading
            .height(.greaterThanOrEqualTo, constant: 0)
            .height(.lessThanOrEqualTo, constant: 8)
        
        marginViewBWLocationAndShareButton
            .height(.greaterThanOrEqualTo, constant: 0)
            .height(.lessThanOrEqualTo, constant: 10)
        
        shareButtonContainerView
            .height(constant: 24)
        
        shareLabel
            .centerInSuperView()
        
        shareImageView
            .centerVerticallyInSuperview()
            .toRightOf(shareLabel, constant: 4)
            .height(constant: 16)
            .width(constant: 16)
        
        bottomMarginView
            .height(constant: bottomMarginConstant)
        
        shareButton
            .alignEdge(.left, withView: shareLabel)
            .alignEdge(.right, withView: shareImageView)
            .alignEdgesWithSuperview([.top, .bottom])
        
    }
}

// MARK: - Rx-Binder
extension Reactive where Base: TransferInformationView {
    public var setReferenceNumber: Binder<String?> {
        return self.base.referenceNumber.rx.text
    }
    
    public var setLocation: Binder<String?> {
        return self.base.location.rx.text
    }
    
    public var shareButtnAction: ControlEvent<Void> {
        return self.base.shareButton.rx.tap
    }
}
