//
//  ASInputCell.swift
//  YAPKit
//
//  Created by Zain on 27/04/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class ASInputCell: RxUITableViewCell {
    
    // MARK: Views
    
    lazy var textField: AppTextField = {
        let field = AppTextField()
        field.delegate = self
        field.animatesTitleOnEditingBegin = false
//        field.clearButtonMode = UITextField.ViewMode.always
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var dropDown: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .greyDark
        imageView.image = UIImage.sharedImage(named: "icon_drop_down")?.withRenderingMode(.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: Properties
    
    private var viewModel: ASInputCellViewModelType!
    private var inputType: AddressSelectionInputType!
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, ReusableTableViewCellViewModelType>>!
    
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
    
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? ASInputCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews()
    }
}

// MARK: View setup

private extension ASInputCell {
    func setupViews() {
        contentView.addSubview(textField)
        textField.addSubview(dropDown)
    }
    
    func setupConstraints() {
        
        textField
            .alignEdgesWithSuperview([.left,.right, .top, .bottom], constants:[25,25,10,0])
            .height(constant: 75)
        
        dropDown
            .alignEdgesWithSuperview([.right, .centerY])
    
    }
}

// MARK: Binding

private extension ASInputCell {
    func bindViews() {
        viewModel.outputs.text.bind(to: textField.rx.text).disposed(by: disposeBag)
        viewModel.outputs.title.bind(to: textField.rx.titleText).disposed(by: disposeBag)
        viewModel.outputs.placeholder.subscribe(onNext: { [weak self] in self?.textField.placeholder = $0 }).disposed(by: disposeBag)
        viewModel.outputs.type.subscribe(onNext: { [weak self] in
            self?.inputType = $0
          //  self?.textField.clearButtonMode = $0 == .city ? .never : .always
        }).disposed(by: disposeBag)
        viewModel.outputs.type.map{ $0.canEdit }.bind(to: dropDown.rx.isHidden).disposed(by: disposeBag)
        
        textField.rx.text.bind(to: viewModel.inputs.textObserver).disposed(by: disposeBag)
        
    }
}

// MARK: Text field delegate

extension ASInputCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        viewModel.inputs.editingBeginObserver.onNext(())
        guard inputType.canEdit else {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
}
