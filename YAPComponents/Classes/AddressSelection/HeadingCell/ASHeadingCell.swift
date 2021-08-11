//
//  ASHeadingCell.swift
//  YAPKit
//
//  Created by Zain on 27/04/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

public class ASHeadingCell: RxUITableViewCell {
    
    // MARK: Views
    
    private lazy var heading = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .title2, alignment: .center, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    private lazy var subHeading = UILabelFactory.createUILabel(with: .greyDark, textStyle: .small, alignment: .center, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    private lazy var stack = UIStackViewFactory.createStackView(with: .vertical, alignment: .center, distribution: .fill, spacing: 10, arrangedSubviews: [heading, subHeading])
    
    // MARK: Properties
    
    private var viewModel: ASHeadingCellViewModelType!
    
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    // MARK: Configurations
    
    public override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? ASHeadingCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews()
    }
    
}

// MARK: View setup

private extension ASHeadingCell {
    func setupViews() {
        contentView.addSubview(stack)
    }
    
    func setupConstraints() {
        stack
            .alignEdgesWithSuperview([.left, .top, .right, .bottom], constants: [25, 30, 25, 30])
    }
}

// MARK: Binding

private extension ASHeadingCell {
    func bindViews() {
        viewModel.outputs.heading.bind(to: heading.rx.text).disposed(by: disposeBag)
        viewModel.outputs.subHeading.bind(to: subHeading.rx.text).disposed(by: disposeBag)
    }
}
