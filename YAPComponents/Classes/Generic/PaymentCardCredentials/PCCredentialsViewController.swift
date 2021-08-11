//
//  PCCredentialsViewController.swift
//  YAPKit
//
//  Created by Muhammad Hussaan Saeed on 12/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 Break ma
 */
public class PCCredentialsViewController: UIViewController {
    
    // MARK: - Init
    public init(viewModel: PCCredentialsViewModelType) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Views
    lazy var container: UIView = UIView()
    private lazy var pcImageView: UIImageView = {
        let imageView = UIImageViewFactory.createImageView()
        return imageView
    }()
    
    private lazy var pcTypeLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro, alignment: .center, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    private lazy var pcNameLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .large, alignment: .center, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    private lazy var pcNumberTitleLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro, text: "Card number")
    private lazy var pcNumberLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .large)
    private lazy var pcValidityTitleLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro, text: "Valid until")
    private lazy var pcValidityLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .large)
    private lazy var pcCVVTitleLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro, alignment: .right, text: "CVV")
    private lazy var pcCVVLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .large, alignment: .right)
    private lazy var clossButton: UIButton = {
        let button = UIButtonFactory.createButton(title: "", backgroundColor: .clear)
        button.setImage(UIImage(named: "icon_close", in: yapKitBundle, compatibleWith: nil), for: .normal)
        return button
    }()
    
    private lazy var pcStackView: UIStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .center, distribution: .fill, spacing: 10)
    private lazy var numberStackView: UIStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .leading, distribution: .fill, spacing: 2)
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.primary.withAlphaComponent(0.14)
        button.setTitleColor(.primary, for: .normal)
        button.titleLabel?.font = .micro
        button.setTitle("screen_menu_display_text_copy".localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var completeStackView: UIStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .bottom, distribution: .fillProportionally, spacing: 5, arrangedSubviews: [numberStackView, copyButton])
    
    private lazy var validityStackView: UIStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .leading, distribution: .fill, spacing: 2)
    private lazy var cvvStackView: UIStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .leading, distribution: .fill, spacing: 2)
    
    private lazy var cvvValidityStackView: UIStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .fill, distribution: .fill, spacing: 2)
    
    private lazy var scrollStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fillEqually, spacing: 0)
    
    //private lazy var cardTitleLabel = UILabelFactory.createUILabel(with: .white, textStyle: .micro, alignment: .center, numberOfLines: 0)
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var pageControl: AppPageControl = {
        let pageControl = AppPageControl()
        pageControl.pages = 2
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - Properties
    let viewModel: PCCredentialsViewModelType
    let disposeBag: DisposeBag
    
    // MARK: - View Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind(viewModel: viewModel)
    }
    
   
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.container
            .centerVerticallyInSuperview()
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut],
                       animations: {
                self.view.layoutIfNeeded()
        })
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        copyButton.layer.cornerRadius = copyButton.bounds.height/2
    }
}

// MARK: - Setup
fileprivate extension PCCredentialsViewController {
    func setup() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
        pcStackView.addArrangedSubview(pcImageView)
        pcStackView.addArrangedSubview(pcTypeLabel)
        pcStackView.addArrangedSubview(pcNameLabel)
        
        //pcImageView.addSubview(cardTitleLabel)
        
        
        
        
        
        numberStackView.addArrangedSubview(pcNumberTitleLabel)
        numberStackView.addArrangedSubview(pcNumberLabel)
        
        validityStackView.addArrangedSubview(pcValidityTitleLabel)
        validityStackView.addArrangedSubview(pcValidityLabel)
        
        cvvStackView.addArrangedSubview(pcCVVTitleLabel)
        cvvStackView.addArrangedSubview(pcCVVLabel)
        
        cvvValidityStackView.addArrangedSubview(validityStackView)
        cvvValidityStackView.addArrangedSubview(cvvStackView)
        
        scrollStackView.addArrangedSubview(completeStackView)
        scrollStackView.addArrangedSubview(cvvValidityStackView)
        
        scrollView.addSubview(scrollStackView)
        
        container.addSubview(pcStackView)
        container.addSubview(pageControl)
        container.addSubview(scrollView)
        container.addSubview(clossButton)
        
        container.layer.cornerRadius = 20
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        
        //cardTitleLabel.font = .appFont(ofSize: 10)
        
        view.addSubview(container)
    }
    
    func setupConstraints() {
        
        pcImageView
            .height(with: .width, ofView: pcImageView, multiplier: 1.583)
            .width(constant: 100)
        
        container
            .toBottomOf(view, priority: .defaultLow)
            .alignEdgesWithSuperview([.left, .right], constant: 25)
        
        pcStackView
            .alignEdgeWithSuperview(.top, constant: 38)
            .centerHorizontallyInSuperview()
            .alignEdgeWithSuperview(.left, constant: 15)
        
        scrollView
            .alignEdgesWithSuperview([.top, .left, .right, .bottom], constants: [38, 30, 30, 30])
        
        scrollStackView
            .alignEdgesWithSuperview([.left, .right])
            .toBottomOf(pcStackView, constant: 30)
        
        
        self.copyButton
            .width(constant: 60)
            .height(constant: 22)
            

        completeStackView
            .width(with: .width, ofView: scrollView)
        
        pageControl
            .toBottomOf(pcStackView, constant: 90)
            .height(constant: 30)
            .centerHorizontallyInSuperview()
            .alignEdgeWithSuperview(.bottom, constant: 30)
        
        clossButton
            .alignEdgesWithSuperview([.top, .right], constant: 17)
        
    }
}

// MARK: - Bind
fileprivate extension PCCredentialsViewController {
    func bind(viewModel: PCCredentialsViewModelType) {
        clossButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.closeObserver.onNext(())
                self?.viewModel.inputs.closeObserver.onCompleted() })
            .disposed(by: disposeBag)
        
        copyButton.rx.tap.bind(to: viewModel.inputs.copyCardNumberObserver).disposed(by: disposeBag)
        
        viewModel.outputs.title
            .bind(to: pcNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.name.bind(to: pcTypeLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.outputs.panNumber
            .bind(to: pcNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.validity
            .bind(to: pcValidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.cvv
            .bind(to: pcCVVLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.currentPage
            .subscribe(onNext: { [weak self] in self?.pageControl.setPageSelected(UInt($0)) })
            .disposed(by: disposeBag)
        
        viewModel.outputs.image.bind(to: pcImageView.rx.loadImage()).disposed(by: disposeBag)
        
        scrollView.rx.currentPage
            .bind(to: viewModel.inputs.currentPageObserver)
            .disposed(by: disposeBag)
    }
}
