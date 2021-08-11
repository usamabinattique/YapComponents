//
//  CountryCollectionViewCell.swift
//  YAPKit
//
//  Created by Muhammad Awais on 15/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import UIKit

public class CountryCollectionCell: RxUICollectionViewCell {
    
    // MARK: Views
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 236/255, green: 230/255, blue: 253/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var name: UILabel = UILabelFactory.createUILabel(with: .primary, textStyle: .micro, alignment: .center, numberOfLines: 1, lineBreakMode: .byWordWrapping)
    
    // MARK: Properties
    
    private var viewModel: CountryCollectionCellViewModelType!
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    // MARK: View cycle
    
    public override func draw(_ rect: CGRect) {
        render()
    }
    
    // MARK: Cofigurations
    
    public override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? CountryCollectionCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews()
    }
    
}

// MARK: View setup

private extension CountryCollectionCell {
    func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(name)
        contentView.backgroundColor = .clear
    }
    
    func setupConstraints() {
        containerView
            .alignEdgesWithSuperview([.left, .top, .right, .bottom])
            .height(constant: 20)
        
        name
            .alignEdgesWithSuperview([.left, .right], constant: 12)
            .alignEdgesWithSuperview([.top, .bottom])
    }
    
    func render() {
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }
}

// MARK: Binding

private extension CountryCollectionCell {
    func bindViews() {
        viewModel.outputs.name.bind(to: name.rx.text).disposed(by: disposeBag)
    }
}
