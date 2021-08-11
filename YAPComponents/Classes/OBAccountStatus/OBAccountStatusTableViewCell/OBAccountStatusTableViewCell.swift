//
//  OBAccountStatusTableViewCell.swift
//  App
//
//  Created by Uzair on 11/06/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

open class OBAccountStatusTableViewCell: RxUITableViewCell {
    
    // MARK: - Views
    lazy var roundedView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.primary.cgColor
        return view
    }()
    
    private lazy var bottomDottedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "onboardingLine")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var completedStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "completed")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    private lazy var containerView: UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var countLabel = UILabelFactory.createUILabel(with: .primary,
                                                       textStyle: .regular)
    
    lazy var titleLabel = UILabelFactory.createUILabel(with: .primary,
                                                       textStyle: .regular)
    
    // MARK: Properties
    private var viewModel: OBAccountStatusTableViewModel!
    
    
    // MARK: - Init
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Configurationn
    override open func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? OBAccountStatusTableViewModel else { return }
        self.viewModel = viewModel
        bind()
    }
    
    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        roundedView.layer.cornerRadius = roundedView.bounds.height/2
    }
    
}

// MARK: - View setup
private extension OBAccountStatusTableViewCell {
    func setupViews() {
//        containerView.addSubview(topDottedImageView)
        containerView.addSubview(roundedView)
        containerView.addSubview(completedStateImageView)
        containerView.addSubview(countLabel)
        containerView.addSubview(bottomDottedImageView)
        containerView.addSubview(titleLabel)
        contentView.addSubview(containerView)
    }
    
    func setupConstraints() {
        
        containerView
            .alignAllEdgesWithSuperview()
            .centerVerticallyInSuperview()
        
        roundedView
            .alignEdgeWithSuperview(.top)
            .alignEdgeWithSuperview(.left, constant: 30)
            .height(constant: 42)
            .width(constant: 42)
        
        completedStateImageView
            .alignEdgeWithSuperview(.top)
            .alignEdgeWithSuperview(.left, constant: 30)
            .height(constant: 42)
            .width(constant: 42)
        
        countLabel
            .horizontallyCenterWith(roundedView)
            .verticallyCenterWith(roundedView)
            .horizontallyCenterWith(completedStateImageView)
            .verticallyCenterWith(completedStateImageView)
        
        bottomDottedImageView
            .toBottomOf(roundedView)
            .horizontallyCenterWith(roundedView)
            .toBottomOf(completedStateImageView)
            .horizontallyCenterWith(completedStateImageView)
            .alignEdgeWithSuperview(.bottom)
            .width(constant: 2)
            .height(constant: 42)
        
        titleLabel
            .toRightOf(roundedView, constant: 18)
            .alignEdgeWithSuperview(.right, constant: 18)
            .verticallyCenterWith(roundedView)
    }
    
    func bind() {
        
        viewModel.isHiddenBottomDottedView.bind(to: bottomDottedImageView.rx.isHidden).disposed(by: disposeBag)
        viewModel.titleLabel.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.countLabel.bind(to: countLabel.rx.text).disposed(by: disposeBag)
        viewModel.state.subscribe(onNext: { [weak self] in
            
            switch $0 {
            
            case .completed:
                self?.completedStateImageView.isHidden = false
                self?.roundedView.isHidden = true
                self?.countLabel.isHidden = true
                self?.titleLabel.textColor = .primaryDark
                
            case .inProgress:
                self?.titleLabel.textColor = .primary
                self?.countLabel.textColor = .primary
                self?.roundedView.layer.borderColor = UIColor.primary.cgColor
                self?.completedStateImageView.isHidden = true
                self?.roundedView.isHidden = false
                self?.titleLabel.font = UIFont.appFont(forTextStyle: .large, weight: .regular)
                
            case .notIntiated:
                self?.titleLabel.textColor = .greyDark
                self?.countLabel.textColor = .greyDark
                self?.roundedView.layer.borderColor = UIColor.greyDark.cgColor
                self?.completedStateImageView.isHidden = true
                self?.roundedView.isHidden = false
            }
            
        }).disposed(by: disposeBag)
    }
}

