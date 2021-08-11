//
//  YAPActionSheetTableViewCell.swift
//  YAPKit
//
//  Created by Zain on 03/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class YAPActionSheetTableViewCell: RxUITableViewCell {
    
    // MARK: Views
    
    private lazy var stack: UIStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fill, spacing: 15)
    private lazy var labelsStackView: UIStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .fill, distribution: .fill, spacing: 5)
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor =  .clear
        imageView.tintColor =  .primary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var iconView : IconView = {
        let view = IconView()
        view.biggerIcon = bigIcon
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var title: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .large)
    private lazy var subtitle: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .small, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .greyLight
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Properties
    
    private var viewModel: YAPActionSheetTableViewCellViewModelType!
    var bigIcon: Bool = false
    
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: Configuration
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? YAPActionSheetTableViewCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews()
    }
    
    // MARK: View cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        render()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        render()
    }
}

// MARK: View setup

extension YAPActionSheetTableViewCell {
    func setupViews() {
        contentView.addSubview(stack)
        
        labelsStackView.addArrangedSubview(title)
        labelsStackView.addArrangedSubview(subtitle)
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(labelsStackView)
        
        contentView.addSubview(separator)
        
        title.adjustsFontSizeToFitWidth = true
    }
    
    func setupConstraints() {
        stack
            .alignEdgesWithSuperview([.left, .top, .right, .bottom], constants: [25, 15, 10, 15])
            .height(constant: 60)
        
        iconView
            .width(constant: 42)
            .height(constant: 42)
        
        separator
            .alignEdgesWithSuperview([.left, .right, .bottom])
            .height(constant: 1)
    }
    
    func render() {
        icon.roundView()
    }
}

// MARK: Binding

private extension YAPActionSheetTableViewCell {
    func bindViews() {
        viewModel.outputs.icon.bind(to: iconView.imageView.rx.image).disposed(by: disposeBag)
        viewModel.outputs.title.bind(to: title.rx.text).disposed(by: disposeBag)
        viewModel.outputs.subtitle.bind(to: subtitle.rx.text).disposed(by: disposeBag)
        viewModel.outputs.subtitle.map { $0 == nil }.bind(to: subtitle.rx.isHidden).disposed(by: disposeBag)
        viewModel.outputs.icon.map { $0 == nil }.bind(to: icon.rx.isHidden).disposed(by: disposeBag)
    }
}
