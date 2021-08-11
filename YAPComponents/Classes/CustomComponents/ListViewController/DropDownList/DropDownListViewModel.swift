//
//  DropDownListViewModel.swift
//  YAPKit
//
//  Created by Zain on 03/06/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol DropDownListViewModelInput {
    var itemSelectedObserver: AnyObserver<IndexPath> { get }
    var willDismissObserver: AnyObserver<Void> { get }
}

protocol DropDownListViewModelOutput {
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
    var itemSelected: Observable<IndexPath> { get }
    var dismiss: Observable<Void> { get }
}

protocol DropDownListViewModelType {
    var inputs: DropDownListViewModelInput { get }
    var outputs: DropDownListViewModelOutput { get }
}

class DropDownListViewModel: DropDownListViewModelType, DropDownListViewModelInput, DropDownListViewModelOutput {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var inputs: DropDownListViewModelInput { return self }
    var outputs: DropDownListViewModelOutput { return self }
    
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    private let itemSelectedSubject = PublishSubject<IndexPath>()
    private let itemSelectedObvSubject = PublishSubject<IndexPath>()
    private let dismissSubject = PublishSubject<Void>()
    private let willDismissSubject = PublishSubject<Void>()
    
    // MARK: - Inputs
    var itemSelectedObserver: AnyObserver<IndexPath> { itemSelectedObvSubject.asObserver() }
    var willDismissObserver: AnyObserver<Void> { willDismissSubject.asObserver() }
    
    // MARK: - Outputs
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { dataSourceSubject.asObservable() }
    var itemSelected: Observable<IndexPath> { itemSelectedSubject.asObservable() }
    var dismiss: Observable<Void> { dismissSubject.asObservable() }
    
    // MARK: - Init
    init(_ items: [String]) {
        
        dataSourceSubject.onNext([SectionModel<Int, ReusableTableViewCellViewModelType>(model: 0, items: items.map{ DropDownListCellViewModel($0) })])
        
        itemSelectedObvSubject.subscribe(onNext: { [weak self] in
            self?.itemSelectedSubject.onNext($0)
            self?.dismissSubject.onNext(())
            self?.itemSelectedSubject.onCompleted()
        }).disposed(by: disposeBag)
        
        willDismissSubject.subscribe(onNext: { [weak self] in
            self?.itemSelectedSubject.onCompleted()
        }).disposed(by: disposeBag)
    }
}
