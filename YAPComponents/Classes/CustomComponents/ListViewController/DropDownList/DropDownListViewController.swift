//
//  DropDownListViewController.swift
//  YAPKit
//
//  Created by Zain on 03/06/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

class DropDownListViewController: ListViewController {
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0), right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: Properties
    
    private var viewModel: DropDownListViewModelType!
    private var tableViewHeight: NSLayoutConstraint!
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, ReusableTableViewCellViewModelType>>!
    private let disposeBag = DisposeBag()
    
    // MARK: Initialization
    
    init(with viewModel: DropDownListViewModelType, title: String?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.listTitle = title
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: View cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        bindViews()
    }
    
    // MARK: KV Observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let tableView = object as? UITableView else { return }
        guard self.tableView == tableView else { return }
        
        let targetHeight = self.tableView.contentSize.height + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        
        guard self.tableView.bounds.height < maxAvailableHeight || targetHeight < maxAvailableHeight else { return }
        
        if !isCompletlyShown {
            self.tableViewHeight.constant = self.tableView.contentSize.height + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let `self` = self else { return }
            self.tableViewHeight.constant = self.tableView.contentSize.height + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            self.contentHeightChanged()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.removeObserver(self, forKeyPath: "contentSize")
        viewModel.inputs.willDismissObserver.onNext(())
    }
}

// MARK: View setup

private extension DropDownListViewController {
    func setupViews() {
        container.addSubview(tableView)
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.register(DropDownListCell.self, forCellReuseIdentifier: DropDownListCell.reuseIdentifier)
    }
    
    func setupConstraints() {
        tableView
            .alignAllEdgesWithSuperview()
        
        tableViewHeight = tableView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        tableViewHeight.isActive = true
    }
}

// MARK: Binding

private extension DropDownListViewController {
    func bindViews() {
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (_, tableView, _, viewModel) in
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reusableIdentifier) as! RxUITableViewCell
            cell.configure(with: viewModel)
            return cell
        })
        
        viewModel.outputs.dataSource.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        viewModel.outputs.dismiss.subscribe(onNext:{ [weak self] _ in self?.hide() }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind(to: viewModel.inputs.itemSelectedObserver).disposed(by: disposeBag)
    }
    
}
