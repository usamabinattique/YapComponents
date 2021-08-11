//
//  DenominationAmountCollectionViewCell.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 05/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DenominationAmountCollectionViewCell: RxUICollectionViewCell {
    
    private lazy var amountLabel: UILabel = UILabelFactory.createUILabel(with: .primary, textStyle: .micro)
    private var viewModel: DenominationAmountViewModelType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Configuration
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? DenominationAmountViewModelType else { return }
        self.viewModel = viewModel
        bind(viewModel: viewModel)
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
}

extension DenominationAmountCollectionViewCell {
    func setupViews() {
        contentView.backgroundColor = UIColor.primary.withAlphaComponent(0.15)
        contentView.addSubview(amountLabel)
    }
    
    func setupConstraints() {
        amountLabel
            .centerInSuperView()
    }
    
    func bind(viewModel: DenominationAmountViewModelType) {
        viewModel.outputs.amount.bind(to: amountLabel.rx.text).disposed(by: disposeBag)
    }
}
