//
//  SuccessViewController.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 27/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SuccessViewControlle: UIViewController {
    
    // MARK: - Init
    init(viewModel: SuccessViewModelType) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Views
    private lazy var headingLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .title2, alignment: .center, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    private lazy var subHeadingLabel: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .large, alignment: .center, numberOfLines: 0)
    private lazy var doneButton: AppRoundedButton = AppRoundedButtonFactory.createAppRoundedButton()
    
    // MARK: - Properties
    let viewModel: SuccessViewModelType
    let disposeBag: DisposeBag
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setup()
        bind()
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

// MARK: - Setup
fileprivate extension SuccessViewControlle {
    func setup() {
        setupViews()
        hideBackButton()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor =  .white
        view.addSubview(headingLabel)
        view.addSubview(subHeadingLabel)
        view.addSubview(doneButton)
    }
    
    func setupConstraints() {
        
        headingLabel
            .alignEdgeWithSuperviewSafeArea(.top, constant: 74)
            .alignEdgesWithSuperview([.left, .right], constants: [30, 30])
        
        subHeadingLabel
            .toBottomOf(headingLabel, constant: 10)
            .alignEdgesWithSuperview([.left, .right], constants: [29, 29])
        
        doneButton
            .centerHorizontallyInSuperview()
            .height(constant: 52)
            .width(constant: 192)
            .alignEdgeWithSuperviewSafeArea(.bottom, constant: 15)
    }
}

// MARK: - Bind
fileprivate extension SuccessViewControlle {
    func bind() {
        viewModel.outputs.heading.bind(to: headingLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.subHeading.bind(to: subHeadingLabel.rx.attributedText).disposed(by: disposeBag)
        viewModel.outputs.doneButtonTitle.bind(to: doneButton.rx.title(for: .normal)).disposed(by: disposeBag)
        doneButton.rx.tap.bind(to: viewModel.inputs.doneButtonObserver).disposed(by: disposeBag)
    }
}
