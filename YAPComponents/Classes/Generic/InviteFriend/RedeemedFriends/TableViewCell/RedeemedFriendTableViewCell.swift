//
//  RedeemedFriendTableViewCell.swift
//  YAP
//
//  Created by Zain on 25/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RedeemedFriendTableViewCell: RxUITableViewCell {
    
    // MARK: Views
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .small)
    
    // MARK: Properties
    private var viewModel: RedeemedFriendTableViewCellViewModelType!

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
    
    // MARK: Layouting
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        profileImage.roundView()
    }
    
    // MARK: Configuration
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? RedeemedFriendTableViewCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews()
    }

}

// MARK: View setup

private extension RedeemedFriendTableViewCell {
    func setupViews() {
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
    }
    
    func setupConstraints() {
        profileImage
            .alignEdgesWithSuperview([.left, .top, .bottom], constants: [25, 10, 10])
            .height(constant: 45)
            .width(constant: 45)
        
        nameLabel
            .toRightOf(profileImage, constant: 20)
            .centerVerticallyInSuperview()
            .alignEdgeWithSuperview(.right, constant: 25)
    }
}

// MARK: Bindind

private extension RedeemedFriendTableViewCell {
    func bindViews() {
        viewModel.outputs.name.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.image.bind(to: profileImage.rx.loadImage()).disposed(by: disposeBag)
    }
}
