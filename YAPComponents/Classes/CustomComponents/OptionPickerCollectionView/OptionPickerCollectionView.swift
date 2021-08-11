//
//  OptionPickerCollectionView.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 13/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class OptionPickerCollectionView: UIView {
    
    // MARK: - Views
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OptionPickerCollectionViewCell.self, forCellWithReuseIdentifier: OptionPickerCollectionViewCell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 0, height: 0)
        collectionView.backgroundColor = .white
        collectionView.setCollectionViewLayout(layout, animated: true)
//        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 2.5 //(UIScreen.main.bounds.width - (62 * 8)) / 62
        return collectionView
    }()
    
    // MARK: - Properties
    fileprivate lazy var dataSubject: BehaviorSubject<[OptionPickerItem<PaymentCardBlockOption>]> = {
        let subject = BehaviorSubject<[OptionPickerItem<PaymentCardBlockOption>]>(value: [])
        return subject
    }()
    private var disposeBag = DisposeBag()
    
    var itemSpacing: CGFloat = 20 {
        didSet {
            layoutCollectionView()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setupViews()
        setupConstraints()
        bind()
        layoutCollectionView()
    }
    
    public override func layoutSubviews() {
        layoutCollectionView()
    }
    
    // MARK: - Setup
    private func setupViews() {
        addSubview(collectionView)
    }
    
    private func layoutCollectionView() {
        guard let numberOfItems = try? dataSubject.value().count else { return }
        let itemWidth = (bounds.size.width / CGFloat(numberOfItems)) - ((itemSpacing / 2) * CGFloat(numberOfItems - 1))
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: itemWidth, height: bounds.height)
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = itemSpacing
    }
    
    private func setupConstraints() {
        collectionView.alignAllEdgesWithSuperview()
    }
    
    private func bind() {
        dataSubject.bind(to: collectionView.rx.items) { collectionView, item, optionPickerItem in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionPickerCollectionViewCell.reuseIdentifier, for: IndexPath(item: item, section: 0)) as! OptionPickerCollectionViewCell
            cell.configure(with: optionPickerItem)
            return cell
            }.disposed(by: disposeBag)
    }
}

// MARK: - OptionPickerCollectionView + Rx
public extension Reactive where Base: OptionPickerCollectionView {
    var paymentCardOptionsObserver: AnyObserver<[OptionPickerItem<PaymentCardBlockOption>]> {
        return base.dataSubject.asObserver()
    }
    
    var modelSelected: Observable<PaymentCardBlockOption> {
        return base.collectionView.rx.modelSelected(OptionPickerItem<PaymentCardBlockOption>.self).map { $0.value }
    }
}
