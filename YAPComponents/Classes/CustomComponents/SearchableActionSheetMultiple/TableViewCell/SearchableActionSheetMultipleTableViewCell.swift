//
//  SearchableActionSheetMultipleTableViewCell.swift
//  YAPKit
//
//  Created by Muhammad Awais on 11/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import UIKit
import RxSwift

class SearchableActionSheetMultipleTableViewCell: RxUITableViewCell {
    
    // MARK: - Views
    
    private lazy var icon = UIImageViewFactory.createImageView(mode: .scaleAspectFit)
    
    private lazy var titleLabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .regular)
    
    private lazy var selectStateImage = UIImageViewFactory.createImageView(mode: .scaleAspectFit)
    
    private lazy var stack = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fill, spacing: 35, arrangedSubviews: [icon, titleLabel, selectStateImage])
    
    // MARK: - Properties
    
    private var viewModel: SearchableActionSheetMultipleTableViewCellModelType!
    
    // MARK: - Initialization
    
    private func commonInit() {
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Configurations
    
    override func configure(with viewModel: Any) {
        guard let `viewModel` = viewModel as? SearchableActionSheetMultipleTableViewCellModelType else { return }
        self.viewModel = viewModel
        bindViews(viewModel)
    }
}

// MARK: - View setup

private extension SearchableActionSheetMultipleTableViewCell {
    func setupViews() {
        contentView.addSubview(stack)
    }
    
    func setupConstraints() {
        stack
            .alignEdgesWithSuperview([.left, .right], constant: 25)
            .alignEdgesWithSuperview([.top, .bottom])
        
        icon
            .height(constant: 24)
            .width(constant: 24)
            .alignEdgesWithSuperview([.top, .bottom], constant: 10)
        
        selectStateImage
            .height(constant: 32)
            .width(constant: 32)
            .alignEdgesWithSuperview([.top, .bottom], constants: [3, 1])
    }
}

// MARK: - Binding

private extension SearchableActionSheetMultipleTableViewCell {
    func bindViews(_ viewModel: SearchableActionSheetMultipleTableViewCellModelType) {
        viewModel.outputs.icon.bind(to: icon.rx.image).disposed(by: disposeBag)
        viewModel.outputs.showsIcon.map{ !$0 }.bind(to: icon.rx.isHidden).disposed(by: disposeBag)
        viewModel.outputs.selected
            .subscribe(onNext: { [weak self] in
                self?.contentView.backgroundColor = $0 ? UIColor.greyLight.withAlphaComponent(0.14) : .white
                self?.selectStateImage.image = $0 ? UIImage.sharedImage(named: "selected_icon") : UIImage.sharedImage(named: "unselected_icon")
            }).disposed(by: disposeBag)
        viewModel.outputs.showsAttributedTitle.filter{ $0 }.withLatestFrom(viewModel.outputs.attributedTitle).bind(to: titleLabel.rx.attributedText).disposed(by: disposeBag)
        viewModel.outputs.showsAttributedTitle.filter{ !$0 }.withLatestFrom(viewModel.outputs.title).bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    }
}
