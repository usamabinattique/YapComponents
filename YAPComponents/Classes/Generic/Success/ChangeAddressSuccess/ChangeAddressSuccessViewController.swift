//
//  ChangeAddressSuccessViewController.swift
//  YAPKit
//
//  Created by Zain on 16/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeAddressSuccessViewController: UIViewController {
    
    // MARK: Views
    
    private lazy var headingLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .title2, alignment: .center, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    private lazy var subHeadingLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .large, alignment: .center, numberOfLines: 0)
    
    private lazy var doneButton: AppRoundedButton = AppRoundedButtonFactory.createAppRoundedButton()
    
    private lazy var addressView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var  imageView = UIImageViewFactory.createImageView(mode: .scaleAspectFit, image: UIImage.init(named: "image_premium_card_rose_gold", in: yapKitBundle, compatibleWith: nil))
    
    private lazy var address = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .small, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    // MARK: - Properties
    
    let viewModel: SuccessViewModelType
    let disposeBag: DisposeBag
    
    // MARK: - Initialization
    
    init(viewModel: SuccessViewModelType) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: View cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupViews()
        setupConstraints()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        render()
    }

    #warning("need to set the status bar colors properly in ViewWillAppear & viewWillDisappear")
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle =  .default
    }
}

// MARK: View Setup

fileprivate extension ChangeAddressSuccessViewController {
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(headingLabel)
        view.addSubview(subHeadingLabel)
        view.addSubview(doneButton)
        
        view.addSubview(addressView)
        
        addressView.addSubview(imageView)
        addressView.addSubview(address)
    }
    
    func setupConstraints() {
        
        headingLabel
            .alignEdgeWithSuperviewSafeArea(.top, constant: 74)
            .alignEdgesWithSuperview([.left, .right], constants: [30, 30])
        
        subHeadingLabel
            .toBottomOf(headingLabel, constant: 10)
            .alignEdgesWithSuperview([.left, .right], constants: [29, 29])
        
        addressView
            .alignEdgesWithSuperview([.left, .right], constant: 25)
            .toBottomOf(subHeadingLabel, constant: 30)
            .height(.greaterThanOrEqualTo, constant: 110)
        
        imageView
            .alignEdgesWithSuperview([.left, .top], constant: 15)
            .height(.lessThanOrEqualTo, constant: 90)
            .width(.lessThanOrEqualTo, constant: 90)
            .alignEdgeWithSuperview(.bottom, .greaterThanOrEqualTo, constant: 15)
        
        address
            .alignEdgesWithSuperview([.top, .right, .bottom], constants: [20, 15, 20])
            .toRightOf(imageView, constant: 10)
        
        doneButton
            .centerHorizontallyInSuperview()
            .height(constant: 52)
            .width(constant: 192)
            .alignEdgeWithSuperviewSafeArea(.bottom, constant: 15)
    }
    
    func render() {
        addressView.layer.cornerRadius = 10
        addressView.layer.shadowColor = UIColor.black.cgColor
        addressView.layer.shadowOffset = CGSize(width: 0, height: 0)
        addressView.layer.shadowRadius = 15
        addressView.layer.shadowOpacity = 0.15
        
        imageView.layer.cornerRadius = 10
    }
}

// MARK: - Binding

fileprivate extension ChangeAddressSuccessViewController {
    func bind() {
        viewModel.outputs.heading.bind(to: headingLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.subHeading.bind(to: subHeadingLabel.rx.attributedText).disposed(by: disposeBag)
        viewModel.outputs.doneButtonTitle.bind(to: doneButton.rx.title(for: .normal)).disposed(by: disposeBag)
        doneButton.rx.tap.bind(to: viewModel.inputs.doneButtonObserver).disposed(by: disposeBag)
        viewModel.outputs.image.bind(to: imageView.rx.image).disposed(by: disposeBag)
        viewModel.outputs.details.bind(to: address.rx.attributedText).disposed(by: disposeBag)
    }
}
