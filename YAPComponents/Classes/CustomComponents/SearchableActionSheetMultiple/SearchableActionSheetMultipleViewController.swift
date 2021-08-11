//
//  SearchableActionSheetMultiple.swift
//  YAPKit
//
//  Created by Muhammad Awais on 11/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class SearchableActionSheetMultipleViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var sheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var holder: UIView = {
        let view = UIView()
        view.backgroundColor = .greyLight
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .large, numberOfLines: 0)
    
    private lazy var collectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isDirectionalLockEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var searchBar: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.font = .small
        textfield.placeholder = "Search"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var searchIcon = UIImageViewFactory.createImageView(mode: .scaleAspectFit, image: UIImage.sharedImage(named: "icon_search"), tintColor: .greyDark)
    
    private lazy var searchStack = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fill, spacing: 7, arrangedSubviews: [searchIcon, searchBar])
    
    private lazy var collectionStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .center, distribution: .fill, spacing: 0, arrangedSubviews: [collectionView, separatorView, searchView])
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.greyLight.withAlphaComponent(0.36)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var saperator: UIView = {
        let view = UIView()
        view.backgroundColor = .greyLight
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Properties
    
    private var start: CGFloat = 0
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, ReusableTableViewCellViewModelType>>!
    private var collectionDataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<Int, ReusableCollectionViewCellViewModelType>>!
    private var viewModel: SearchableActionSheetMultipleViewModelType!
    var window: UIWindow?
    var tableViewBottom: NSLayoutConstraint!
    var items: [CountryCollectionCellViewModel] = []
    
    // MARK: - Initialization
    
    init(_ viewModel: SearchableActionSheetMultipleViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        bindViews(viewModel)
        addGestureRecognisers()
        bindCollectionView()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        holder.roundView()
        sheetView.layer.cornerRadius = 18
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetView.clipsToBounds = true
        searchView.roundView()
        
        sheetView.frame = CGRect(x: sheetView.frame.origin.x, y: view.bounds.height, width: sheetView.bounds.width, height: sheetView.bounds.height)
        
        completeShow(0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.window?.resignKey()
        view.window?.removeFromSuperview()
        window = nil
        self.viewModel.inputs.viewDidDisappearObserver.onNext(())
    }
    
    // MARK: - Gestures
    
    private func addGestureRecognisers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.cancelsTouchesInView = false
        sheetView.addGestureRecognizer(pan)
    }

}

// MARK: - View setup

private extension SearchableActionSheetMultipleViewController {
    func setupViews() {
        
        view.addSubview(sheetView)
        sheetView.addSubview(holder)
        sheetView.addSubview(titleLabel)
        searchView.addSubview(searchStack)
        sheetView.addSubview(collectionStackView)
        sheetView.addSubview(saperator)
        sheetView.addSubview(tableView)
        
        tableView.register(SearchableActionSheetMultipleTableViewCell.self, forCellReuseIdentifier: SearchableActionSheetMultipleTableViewCell.reuseIdentifier)
        
        collectionView.register(CountryCollectionCell.self, forCellWithReuseIdentifier: CountryCollectionCell.reuseIdentifier)
        
//        collectionView.isHidden = true
//        separatorView.isHidden = true
    }
    
    func setupConstraints() {
        
        sheetView
            .alignEdgesWithSuperview([.left, .right])
            .height(constant: UIScreen.main.bounds.height*0.88)
            .alignEdgeWithSuperview(.bottom, .lessThanOrEqualTo, constant: 0)
        
        holder
            .alignEdgeWithSuperview(.top, constant: 15)
            .height(constant: 4)
            .width(constant: 60)
            .centerHorizontallyInSuperview()
        
        titleLabel
            .alignEdgesWithSuperview([.left, .right], constant: 25)
            .toBottomOf(holder, constant: 20)
        
        searchView
            .height(constant: 30)
            .alignEdgeWithSuperview(.right, constant: 25)
            .alignEdgeWithSuperview(.left)
        
        searchStack
            .alignEdgesWithSuperview([.left, .right], constant: 15)
            .alignEdgesWithSuperview([.top, .bottom])
        
        collectionStackView
            .alignEdgesWithSuperview([.left, .right], constants: [ 23, 0])
            .toBottomOf(titleLabel, constant: 13)
        
        separatorView
            .height(constant: 15)
        
        collectionView
            .height(constant: 20)
            .alignEdgesWithSuperview([.left, .right])
        
        searchIcon
            .height(constant: 18)
            .width(constant: 18)
        
        saperator
            .toBottomOf(searchView, constant: 25)
            .alignEdgesWithSuperview([.left, .right])
            .height(constant: 1)
        
        
        tableView
            .toBottomOf(saperator)
            .alignEdgesWithSuperview([.left, .right])
        
        tableViewBottom = sheetView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        tableViewBottom.isActive = true
    }
    
    private func addCollectionView() {
//        view.addSubview(collectionView)
//        
//        let constraints = [
//            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
//            collectionView.bottomAnchor.constraint(equalTo: searchStack.topAnchor, constant: 16),
//            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 23)
//        ]
//
//        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Bind view

private extension SearchableActionSheetMultipleViewController {
    func bindViews(_ viewModel: SearchableActionSheetMultipleViewModelType) {
        viewModel.outputs.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.searchPlaceholder.subscribe(onNext: { [weak self] in
            self?.searchBar.placeholder = $0
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.bind(to: viewModel.inputs.searchTextObserver).disposed(by: disposeBag)
        
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (_, tableView, _, viewModel) in
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reusableIdentifier) as! ConfigurableTableViewCell
            cell.configure(with: viewModel)
            return cell as! UITableViewCell
        })
        
        viewModel.outputs.sectionModels.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SearchableActionSheetMultipleTableViewCellModel.self).map{ $0 }
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.itemSelectedObserver.onNext($0.index)
                $0.inputs.changeSelectState.onNext(())
            }).disposed(by: disposeBag)
        
        self.viewModel.outputs.hideCollectionView.bind(to: collectionView.rx.isHidden).disposed(by: disposeBag)
        self.viewModel.outputs.hideCollectionView.bind(to: separatorView.rx.isHidden).disposed(by: disposeBag)
        
        self.viewModel.outputs.scrollCollectionView.subscribe(onNext: { [weak self] row in
            self?.collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .right, animated: false)
        }).disposed(by: disposeBag)
    }
    
    func bindCollectionView() {
//        collectionDataSource = RxCollectionViewSectionedReloadDataSource(configureCell: { (_, collectionView, indexPath, viewModel) in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reusableIdentifier, for: indexPath) as! RxUICollectionViewCell
//            cell.configure(with: viewModel)
//            return cell
//        })
//
//        viewModel.outputs.dataSource.bind(to: collectionView.rx.items(dataSource: collectionDataSource)).disposed(by: disposeBag)
        viewModel.outputs.refreshCollectionView.subscribe(onNext: { [weak self] items in
            self?.items = items
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension SearchableActionSheetMultipleViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.items.count > 0 ? items.count+1 : 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionCell.reuseIdentifier, for: indexPath) as! CountryCollectionCell
        if indexPath.item < items.count {
            let data = self.items[indexPath.item]
            cell.configure(with: data)
            cell.isHidden = false
            return cell
        } else {
            let data = CountryCollectionCellViewModel("")
            cell.configure(with: data)
            cell.isHidden = true
            return cell
        }
    }
}

// MARK: - Actions

private extension SearchableActionSheetMultipleViewController {
    @objc
    private func closeAction(_ tap: UITapGestureRecognizer) {
        guard tap.location(in: view).y < sheetView.frame.origin.y else { return }
        viewModel.inputs.closeObserver.onNext(())
        completeHide(0)
    }
    
    @objc
    private func handlePan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            start = pan.location(in: sheetView).y
            
        case .changed:
            changePosition(pan.location(in: view).y - start)
            
        case .ended:
            let progress = ((sheetView.frame.origin.y - (view.bounds.height - sheetView.bounds.height)) / sheetView.bounds.height)
            let velocity = pan.velocity(in: view).y
            if progress < 0.25 {
                velocity < 900 ? completeShow(velocity) : completeHide(velocity)
            } else {
                velocity > -900 ? completeHide(velocity) : completeShow(velocity)
            }
            
        default:
            break
        }
    }
}

// MARK: - Gesture recogniser handling

private extension SearchableActionSheetMultipleViewController {
    
    func changePosition(_ y: CGFloat) {
        guard y >= (view.bounds.height - sheetView.bounds.height) else { return }
        var frame = sheetView.frame
        frame.origin.y = y
        sheetView.frame = frame
        let progress = ((sheetView.frame.origin.y - (view.bounds.height - sheetView.bounds.height)) / sheetView.bounds.height)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5 * (1 - progress))
    }
    
    func completeShow(_ velocity: CGFloat) {
        let distance = sheetView.frame.origin.y - (view.bounds.height - sheetView.bounds.height)
        
        var time: TimeInterval = abs(velocity) > 0 ? TimeInterval(abs(distance)/abs(velocity)) : 0.25
        time = time > 0.25 ? 0.25 : time
        
        UIView.animate(withDuration: time) {
            self.sheetView.frame.origin.y = self.view.bounds.height - self.sheetView.bounds.height
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    func completeHide(_ velocity: CGFloat) {
        let distance = view.bounds.height - sheetView.frame.origin.y
        
        var time: TimeInterval = abs(velocity) > 0 ? TimeInterval(abs(distance)/abs(velocity)) : 0.25
        time = time > 0.25 ? 0.25 : time
        
        UIView.animate(withDuration: time, animations: {
            self.sheetView.frame.origin.y = self.view.bounds.height
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (completed) in
            guard completed else { return }
            self.sheetView.isHidden = true
            self.navigationController?.dismiss(animated: false, completion: nil)
        }
    }
}

// MARK: - Keyboard handling

private extension SearchableActionSheetMultipleViewController {

    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableViewBottom.constant = keyboardSize.height
            UIView.animate(withDuration: 0.25) { [unowned self] in
                self.view.layoutSubviews()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        tableViewBottom.constant = 0
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutSubviews()
        }
    }
}

extension SearchableActionSheetMultipleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 70, height: collectionView.bounds.height)
//    }
}

