//
//  NotificationCollectionViewCell.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 26/08/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NotificationCollectionViewCell: RxUICollectionViewCell {
    
    private lazy var cornerRadiusView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 12.0
        view.layer.masksToBounds = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.sharedImage(named: "icon_close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .greyDark
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var notificationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage.sharedImage(named: "icon_notification")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 3
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var notificationTitle: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .micro)
    
    private lazy var notificationDescription: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    private var viewModel: NotificationCollectionViewCellViewModelType!
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = false
        contentView.clipsToBounds = false
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Configuration
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? NotificationCollectionViewCellViewModelType else { return }
        self.viewModel = viewModel
        bind(viewModel: viewModel)
        alpha = 1
    }
    
    // MARK: Layouting
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        notificationIcon.layer.cornerRadius = notificationIcon.bounds.width/2
        
        cornerRadiusView.layer.shadowColor = UIColor.black.cgColor
        cornerRadiusView.layer.shadowOpacity = 0.2
        cornerRadiusView.layer.shadowOffset = .zero
        cornerRadiusView.layer.shadowRadius = 5
        cornerRadiusView.layer.cornerRadius = 12.0
        cornerRadiusView.layer.masksToBounds = false
    }
    
    // MARK: Delete
    func deleteCell() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.cornerRadiusView.frame.origin.y = self?.contentView.bounds.height ?? 0
            self?.alpha = 0.0
        }) { [weak self] _ in
            guard let `self` = self else { return }
            self.cornerRadiusView.removeFromSuperview()
            self.contentView.addSubview(self.cornerRadiusView)
            self.setupConstraints()
        }
    }
    
}

// MARK: SetupViews
private extension NotificationCollectionViewCell {
    func setupViews() {
        contentView.backgroundColor = .clear
        cornerRadiusView.addSubview(notificationIcon)
        cornerRadiusView.addSubview(stackView)
        cornerRadiusView.addSubview(cancelButton)
        
        stackView.addArrangedSubview(notificationTitle)
        stackView.addArrangedSubview(notificationDescription)
        
        contentView.addSubview(cornerRadiusView)
    }
    
    func setupConstraints() {
        
        cornerRadiusView
            .alignEdgesWithSuperview([.left, .right, .top, .bottom], constants: [7.5, 7.5, 15, 15])
        
        cancelButton
            .alignEdgesWithSuperview([.top, .right])
            .width(constant: 40)
            .height(constant: 40)
        
        notificationIcon
            .alignEdgeWithSuperview(.left, constant: 15)
            .alignEdgeWithSuperview(.top, .greaterThanOrEqualTo, constant: 25)
            .centerVerticallyInSuperview()
            .width(constant: 60)
            .height(constant: 60)
        
        stackView
            .toRightOf(notificationIcon, constant: 15)
            .centerVerticallyInSuperview()
            .alignEdgeWithSuperview(.top, .greaterThanOrEqualTo, constant: 10)
            .alignEdgeWithSuperview(.right, constant: 15)
    }
    
    func bind(viewModel: NotificationCollectionViewCellViewModelType) {
        viewModel.outputs.notificationIcon.bind(to: notificationIcon.rx.loadImage()).disposed(by: disposeBag)
        viewModel.outputs.notificationTitle.bind(to: notificationTitle.rx.text).disposed(by: disposeBag)
        viewModel.outputs.notifocationDescription.bind(to: notificationDescription.rx.text).disposed(by: disposeBag)
        
        cancelButton.rx.tap.map { [unowned self] in self.indexPath }.bind(to: viewModel.inputs.deleteNotificationObserver).disposed(by: disposeBag)
        
        viewModel.outputs.deletable.map { !$0 }.bind(to: cancelButton.rx.isHidden ).disposed(by: disposeBag)
    }
}
