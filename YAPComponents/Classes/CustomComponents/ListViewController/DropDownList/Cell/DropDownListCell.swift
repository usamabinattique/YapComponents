//
//  DropDownListCell.swift
//  YAPKit
//
//  Created by Zain on 03/06/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DropDownListCell: RxUITableViewCell {

    // MARK: Views
    
    private lazy var title = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .small, alignment: .left, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .greyLight
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Properties
    
    private var viewModel: DropDownListCellViewModelType!
    
    // MARK: Initializaion
    
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
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? DropDownListCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews()
    }

}

// MARK: View setup

private extension DropDownListCell {
    func setupViews() {
        contentView.addSubview(title)
        contentView.addSubview(separator)
        contentView.backgroundColor = .white
    }
    
    func setupConstraints() {
        title
            .alignEdgesWithSuperview([.left, .top, .right], constants: [25, 18, 25])
        
        separator
            .toBottomOf(title, constant: 17)
            .alignEdgesWithSuperview([.left, .right, .bottom])
            .height(constant: 1)
    }
}

// MARK: Binding

private extension DropDownListCell {
    func bindViews() {
        viewModel.outputs.title.bind(to: title.rx.text).disposed(by: disposeBag)
    }
}
