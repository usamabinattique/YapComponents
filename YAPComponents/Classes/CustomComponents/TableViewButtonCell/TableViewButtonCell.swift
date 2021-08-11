//
//  TableViewButtonCell.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 17/11/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class TableViewButtonCell: RxUITableViewCell {
    
    // MARK: - Views
    lazy var button = UIButtonFactory.createButton()
    
    // MARK: Properties
    private var viewModel: TableViewButtonCellViewModelType!
    
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
    
    // MARK: Configration
    public override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? TableViewButtonCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews()
    }
}

// MARK: Setup views
private extension TableViewButtonCell {
    func setupViews() {
        contentView.addSubview(button)
    }
    
    func setupConstraints() {
        button
            .centerHorizontallyInSuperview()
            .alignEdgeWithSuperview(.top, constant: 30)
            .alignEdgeWithSuperview(.bottom)
            .height(constant: 52)
            .width(constant: 200)
    }
    
}

// MARK: Binding
private extension TableViewButtonCell {
    func bindViews() {
        
        viewModel.outputs.title.bind(to: button.rx.title(for: .normal)).disposed(by: disposeBag)
        
        viewModel.outputs.buttonType.unwrap().subscribe(onNext: {[weak self] type in
            switch type {
            case .fill:
                self?.button.setTitleColor(.white, for: .normal)
                self?.button.backgroundColor = .primary
            case .light:
                self?.button.setTitleColor(.primary, for: .normal)
                self?.button.backgroundColor = .clear
            }
        }).disposed(by: disposeBag)
        
        button.rx.tap.bind(to: viewModel.inputs.buttonObserver).disposed(by: disposeBag)
    }
}
