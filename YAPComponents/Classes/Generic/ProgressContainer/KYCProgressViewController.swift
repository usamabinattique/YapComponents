//
//  KYCProgressViewController.swift
//  OnBoarding
//
//  Created by Zain on 06/06/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

public class KYCProgressViewController: UIViewController {
    
    // MARK: Views
    
    private lazy var progressView: OnBoardingProgressView = {
        let progressVeiw = OnBoardingProgressView()
        progressVeiw.setProgress(0.775)
        progressVeiw.showsProgressView = true
        progressVeiw.showsCompletionView = true
        return progressVeiw
    }()
    
    // MARK: Properties
    
    private var viewModel: KYCProgressViewModelType!
    private let disposeBag = DisposeBag()
    private var childNavigation: UINavigationController!
    private var childView: UIView!
    
    // MARK: Initialization
    
    public init(viewModel: KYCProgressViewModelType, withChildNavigation childNav: UINavigationController) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.childNavigation = childNav
        self.childView = childNav.view
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()
        bindViews()
    }
}

// MARK: View setup

fileprivate extension KYCProgressViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(progressView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        addChild(childNavigation)
        view.addSubview(childView)
        childNavigation.didMove(toParent: self)
        
    }
    
    func setupContraints() {
        progressView
            .alignEdgesWithSuperview([.left, .right], constant: 25)
            .alignEdgeWithSuperviewSafeArea(.top, constant: 20)
            .height(constant: 40)
        
        childView
            .toBottomOf(progressView)
            .alignEdgesWithSuperview([.left, .right, .bottom])
    }
}

// MARK: Binding

fileprivate extension KYCProgressViewController {
    func bindViews() {
        viewModel.outputs.progress.bind(to: progressView.rx.progress).disposed(by: disposeBag)
        viewModel.outputs.progress.filter{ 1 == $0 }.map{ _ in true }.bind(to: progressView.rx.animateCompletion).disposed(by: disposeBag)
        viewModel.outputs.progressCompletion.bind(to: progressView.rx.animateCompletion).disposed(by: disposeBag)
        progressView.rx.tapBack.bind(to: viewModel.inputs.backTapObserver).disposed(by: disposeBag)
        viewModel.outputs.disableBackButton.bind(to: progressView.rx.disableBackButton).disposed(by: disposeBag)
        viewModel.outputs.hideBackButton.bind(to: progressView.rx.hideBackButton).disposed(by: disposeBag)
    }
}

