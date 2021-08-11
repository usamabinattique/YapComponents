//
//  OBAccountStatusViewController.swift
//  App
//
//  Created by Uzair on 10/06/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

public class OBAccountStatusViewController: UIViewController {
    
    private lazy var headerLabel : UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .title2, alignment: .center)
    
    private lazy var subTitleLabel : UILabel = UILabelFactory.createUILabel(with: .greyMedium, textStyle: .regular, alignment: .center, numberOfLines: 0)
    
    private lazy var workIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Work-Icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var letsStartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 26
        button.titleLabel?.font = UIFont.appFont(forTextStyle: .large, weight: .medium)
        return button
    }()
    
    private lazy var centreView : UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var viewModel: OBAccountStatusViewModelType!
    private var disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, ReusableTableViewCellViewModelType>>!
    
    // MARK: Initialization
    
    public init(viewModel: OBAccountStatusViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupSubViews()
        setupConstraints()
        bindViews()
        bindTableView()
        addBackButton(.backEmpty)
    }
    
    public override func onTapBackButton() {
        viewModel.inputs.backObserver.onNext(())
    }

}

// MARK: View setup

private extension OBAccountStatusViewController {
    
    func setupSubViews() {
        view.backgroundColor = .white
        view.addSubview(headerLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(workIconImage)
//        view.addSubview(tableView)
        view.addSubview(letsStartButton)
        centreView.addSubview(tableView)
        view.addSubview(centreView)
        
        tableView.register(OBAccountStatusTableViewCell.self, forCellReuseIdentifier: OBAccountStatusTableViewCell.reuseIdentifier)
    }
    
    func setupConstraints() {
        
        headerLabel
            .alignEdgeWithSuperviewSafeArea(.top, constant: 20)
            .alignEdgesWithSuperview([.left, .right], constants: [24, 24])
            .centerHorizontallyInSuperview()
        
        subTitleLabel
            .toBottomOf(headerLabel,constant:8)
            .alignEdgesWithSuperview([.left, .right], constants: [24, 24])
            .centerHorizontallyInSuperview()
        
        workIconImage
            .toBottomOf(subTitleLabel, constant:0)
            .height(constant: 180)
            .width(constant: 180)
            .centerHorizontallyInSuperview()
        
        centreView
            .toBottomOf(workIconImage,constant:-20)
            .toTopOf(letsStartButton,constant:2)
            .alignEdgesWithSuperview([.left, .right], constants: [24, 24])
        
        tableView
            .alignEdgesWithSuperview([.left, .right], constants: [0, 0])
            .centerVerticallyInSuperview()
            .height(constant: view.frame.height * 0.37)
        
        letsStartButton
            .alignEdgeWithSuperviewSafeArea(.bottom,constant:20)
            .width(constant: 201)
            .height(constant: 53)
            .centerHorizontallyInSuperview()
    }
}

// MARK: Binding
private extension OBAccountStatusViewController {
    
    func bindTableView() {
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (_, tableView, _, viewModel) in
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reusableIdentifier) as! RxUITableViewCell
            cell.configure(with: viewModel)
            return cell
        })
        viewModel.outputs.dataSource.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    func bindViews() {
        letsStartButton.rx.tap.bind(to: viewModel.inputs.nextObserver).disposed(by: disposeBag)
        viewModel.outputs.heading.bind(to: headerLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.subheading.bind(to: subTitleLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.buttonTitle.bind(to: letsStartButton.rx.title(for: .normal)).disposed(by: disposeBag)
    }
}
