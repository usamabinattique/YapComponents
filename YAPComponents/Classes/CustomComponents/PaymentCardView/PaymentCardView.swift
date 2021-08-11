    //
//  PaymentCardView.swift
//  YAPKit
//
//  Created by Muhammad Hussaan Saeed on 04/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


open class PaymentCardView: UIView {

    private lazy var pcImageView: UIImageView = UIImageViewFactory.createImageView()
    private lazy var pcNameLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .micro)
    private lazy var cardTitle: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .micro)
    private lazy var pcNumberLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro)
    private lazy var secureImageView: UIImageView = UIImageViewFactory.createImageView()
    private lazy var secureLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro)
    private lazy var pcDetailButton: AppRoundedButton = {
        let button = AppRoundedButtonFactory.createAppRoundedButton()
        button.titleLabel?.font = UIFont.appFont(forTextStyle: .micro)
        button.setTitle("screen_payment_card_detail_button_card_details".localized, for: .normal)
        return button
    }()

    private lazy var secureStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .leading, distribution: .fill, spacing: 9)
    private lazy var pcInfoStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .fill, distribution: .fill, spacing: 5)

    private var pcImageViewContraint: NSLayoutConstraint?
    
    private let disposeBag = DisposeBag()
    public var viewModel: PaymentCardViewModelType

    public init(viewModel: PaymentCardViewModelType) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        commonInit()
    }

    public override init(frame: CGRect) {
        self.viewModel = PaymentCardViewModel(paymentCardName: "", paymentCardNumber: "", imageUrl: (nil, nil))
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.viewModel = PaymentCardViewModel(paymentCardName: "", paymentCardNumber: "", imageUrl: (nil, nil))
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false
        setupViews()
        setupConstraints()
        localize()
        bind(viewModel: viewModel)
    }

    func setupViews() {

        secureStackView.addArrangedSubview(secureImageView)
        secureStackView.addArrangedSubview(secureLabel)
        pcInfoStackView.addArrangedSubview(pcNameLabel)
        pcInfoStackView.addArrangedSubview(cardTitle)
        pcInfoStackView.addArrangedSubview(pcNumberLabel)
        addSubview(secureStackView)
        addSubview(pcInfoStackView)
        addSubview(pcImageView)
        
//        pcNameLabel.isHidden = true
        
//        pcImageView.addSubview(pcCardNameLabel)
//        pcCardNameLabel.font = .appFont(ofSize: 10)
    }

    func setupDetailable() {
        addSubview(pcDetailButton)

        pcDetailButton
            .height(constant: 24)
            .toRightOf(pcImageView, constant: 31)
            .toBottomOf(secureStackView, constant: 10)
            .alignEdgesWithSuperview([.right, .bottom], constants: [0, 15])

        pcImageView
            .height(constant: 130)
        
//        pcCardNameLabel
//            .alignEdgesWithSuperview([.left, .right], constant: 3)
//            .centerVerticallyInSuperview()
        
    }

    func setupNonDetailable() {
        pcImageView
            .height(constant: 100)

        secureStackView
            .alignEdgeWithSuperview(.bottom, constant: 8)
    }

    func setupConstraints() {
        
        pcImageView
            .alignEdgesWithSuperview([.left, .top, .bottom])
            .height(with: .width, ofView: pcImageView, multiplier: 1.583)

        pcInfoStackView
            .toRightOf(pcImageView, constant: 31)
            .alignEdgesWithSuperview([.top, .right], constants: [15, 0])

        secureStackView
            .toRightOf(pcImageView, constant: 31)
            .toBottomOf(pcInfoStackView, .greaterThanOrEqualTo, constant: 10)
            .alignEdgeWithSuperview(.right)

        secureImageView
            .height(constant: 16)
            .width(constant: 16)

    }
    
    public func animate() {
        UIView.animate(withDuration: 0.5) {
            self.pcInfoStackView.alpha = 0
            self.secureStackView.alpha = 0
            self.viewModel.outputs.detailable.subscribe(onNext: { [unowned self] detailable in
                if detailable {
                    self.pcDetailButton.alpha = 0
                }
            }).dispose()
        }
        var imageViewCenter = pcImageView.center
        imageViewCenter.x = bounds.size.width/2
        UIView.animate(withDuration: 0.5) {
            self.pcImageView.center = imageViewCenter
        }
    }

    func localize() {

        pcImageView.image = UIImage.sharedImage(named: "image_spare_card")
        secureImageView.image = UIImage.sharedImage(named: "icon_secure")
        secureLabel.text = "screen_payment_card_detail_text_secure".localized

    }

    func bind(viewModel: PaymentCardViewModelType?) {
        guard let viewModel = viewModel else { return }

        viewModel.outputs.detailable.subscribe(onNext: { [weak self] detailable in
            guard let `self` = self else { return }
            if detailable {
                self.setupDetailable()
                self.bindDetailButton(viewModel: viewModel)
            } else { self.setupNonDetailable() }
        }).disposed(by: disposeBag)

        viewModel.outputs.pcName.bind(to: pcNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.pcNumber.bind(to: pcNumberLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.outputs.pcImageUrl.bind(to: pcImageView.rx.loadImage()).disposed(by: disposeBag)
        viewModel.outputs.cardTitle.bind(to: cardTitle.rx.text).disposed(by: disposeBag)

    }

    func bindDetailButton(viewModel: PaymentCardViewModelType) {
        pcDetailButton.rx.tap.bind(to: viewModel.inputs.detailObserver).disposed(by: disposeBag)
    }
}

public extension Reactive where Base: PaymentCardView {

    var pcName: AnyObserver<String> {
        return self.base.viewModel.inputs.pcNameOberver
    }

    var pcNumber: AnyObserver<String> {
        return self.base.viewModel.inputs.pcNumberOberver
    }

    var detailTap: ControlEvent<Void> {
        return ControlEvent(events: self.base.viewModel.outputs.detail)
    }
    
    var pcImageUrl: AnyObserver<ImageWithURL> {
        return self.base.viewModel.inputs.pcImageUrlObserver
    }
    
    var cardTitle: AnyObserver<String?> {
        return self.base.viewModel.inputs.cardTitleObserver
    }
}
