//
//  SearchableActionSheetMultipleViewModel.swift
//  YAPKit
//
//  Created by Muhammad Awais on 11/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol SearchableActionSheetMultipleViewModelInput {
    var searchTextObserver: AnyObserver<String?> { get }
    var itemSelectedObserver: AnyObserver<Int> { get }
    var closeObserver: AnyObserver<Void> { get }
    var viewDidDisappearObserver: AnyObserver<Void> { get }
}

protocol SearchableActionSheetMultipleViewModelOutput {
    var sectionModels: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
    var dataSource: Observable<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]> { get }
    var title: Observable<String?> { get }
    var searchPlaceholder: Observable<String?> { get }
    var itemsSelected: Observable<[Int]> { get }
    var itemDisSelected: Observable<Int> { get }
    var refreshCollectionView: Observable<[CountryCollectionCellViewModel]> { get }
    var hideCollectionView: Observable<Bool> { get }
    var scrollCollectionView: Observable<Int> { get }
}

protocol SearchableActionSheetMultipleViewModelType {
    var inputs: SearchableActionSheetMultipleViewModelInput { get }
    var outputs: SearchableActionSheetMultipleViewModelOutput { get }
}

class SearchableActionSheetMultipleViewModel: SearchableActionSheetMultipleViewModelInput, SearchableActionSheetMultipleViewModelOutput, SearchableActionSheetMultipleViewModelType {
    
    var inputs: SearchableActionSheetMultipleViewModelInput { self }
    var outputs: SearchableActionSheetMultipleViewModelOutput { self }
    
    private let disposeBag = DisposeBag()
    private var selectedItems: [Int] = []
    
    private let sectionModelsSubject: BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>
    private var dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]>(value: [])
    private let titleSubject: BehaviorSubject<String?>
    private let searchPlaceholderSubject: BehaviorSubject<String?>
    private let textSubject: BehaviorSubject<String?>
    private let itemsSelectedSubject = PublishSubject<[Int]>()
    private let closeSubject = PublishSubject<Void>()
    private let itemSelectedSubject = PublishSubject<Int>()
    private let viewDidDisappearSubject = PublishSubject<Void>()
    private let itemsDisSelectedSubject = PublishSubject<Int>()
    private let refreshCollectionViewSubject = BehaviorSubject<[CountryCollectionCellViewModel]>(value: [])
    private let hideCollectionViewSubject = BehaviorSubject<Bool>(value: true)
    private let scrollCollectionViewSubject = PublishSubject<Int>()
    
    private let items: [EnumeratedData]
    
    // MARK: - Inputs
    
    var itemSelectedObserver: AnyObserver<Int> { itemSelectedSubject.asObserver() }
    var searchTextObserver: AnyObserver<String?> { textSubject.asObserver() }
    var closeObserver: AnyObserver<Void> { closeSubject.asObserver() }
    var viewDidDisappearObserver: AnyObserver<Void> { viewDidDisappearSubject.asObserver() }
    
    // MARK: - Ouputs
    
    var sectionModels: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { sectionModelsSubject.asObservable() }
    var title: Observable<String?> { titleSubject.asObservable() }
    var searchPlaceholder: Observable<String?> { searchPlaceholderSubject.asObservable() }
    var itemsSelected: Observable<[Int]> { itemsSelectedSubject.asObservable() }
    var itemDisSelected: Observable<Int> { itemsDisSelectedSubject.asObservable() }
    var dataSource: Observable<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    var refreshCollectionView: Observable<[CountryCollectionCellViewModel]> { return refreshCollectionViewSubject.asObservable() }
    var hideCollectionView: Observable<Bool> { hideCollectionViewSubject.asObservable() }
    var scrollCollectionView: Observable<Int> { return scrollCollectionViewSubject.asObservable() }
    
    // MARK: - Initialization
    
    init(_ title: String? = nil, searchPlaceholderText: String = "Search", items: [SearchableDataType]) {
        var dummySelectedItems: [Int] = []
        var data = [EnumeratedData]()
        var index = 0
        for item in items {
            data.append((index: index, data: item))
            if item.selected {
                selectedItems.append(index)
                dummySelectedItems.append(index)
            }
            index += 1
        }
        self.items = data
        itemsSelectedSubject.onNext(selectedItems)
        titleSubject = BehaviorSubject(value: title)
        searchPlaceholderSubject = BehaviorSubject(value: searchPlaceholderText)
        textSubject = BehaviorSubject(value: nil)
        
        sectionModelsSubject = BehaviorSubject(value: [SectionModel(model: 0, items: self.items.map{ SearchableActionSheetMultipleTableViewCellModel($0.data, index: $0.index, isSelected: dummySelectedItems.contains($0.index) ? true:false) })])
        search()
        
        closeSubject.subscribe(onNext: { [weak self] in
            self?.itemSelectedSubject.onNext(-1)
            self?.itemSelectedSubject.onCompleted()
        }).disposed(by: disposeBag)
        
        itemSelectedSubject.subscribe(onNext: { [unowned self] index in
            guard index >= 0 else {
                return
            }
            guard let removeAt = self.selectedItems.firstIndex(of: index) else {
                self.selectedItems.append(index)
                let viewModels = self.selectedItems.map { CountryCollectionCellViewModel(self.items[$0].data.title) }
                self.hideCollectionViewSubject.onNext(false)
                self.itemsSelectedSubject.onNext(self.selectedItems)
                self.refreshCollectionViewSubject.onNext(viewModels)
                return
            }
            self.selectedItems.remove(at: removeAt)
            let viewModels = self.selectedItems.map { CountryCollectionCellViewModel(self.items[$0].data.title) }
            if viewModels.isEmpty {
                self.hideCollectionViewSubject.onNext(true)
            }
            self.refreshCollectionViewSubject.onNext(viewModels)
            self.itemsSelectedSubject.onNext(self.selectedItems)
            self.itemsDisSelectedSubject.onNext(index)
        }).disposed(by: disposeBag)
        
        viewDidDisappearSubject.subscribe(onNext: { [unowned self] _ in
            self.itemsSelectedSubject.onNext(self.selectedItems)
        }).disposed(by: disposeBag)
        
        if !selectedItems.isEmpty {
            let viewModels = self.selectedItems.map { CountryCollectionCellViewModel(self.items[$0].data.title) }
            self.hideCollectionViewSubject.onNext(false)
            self.refreshCollectionViewSubject.onNext(viewModels)
        }
        
        
        refreshCollectionView.delay(RxTimeInterval.milliseconds(50), scheduler: MainScheduler.instance).map { ($0.count-1) }.bind(to: scrollCollectionViewSubject).disposed(by: disposeBag)
    }
}

// MARK: - Search

private extension SearchableActionSheetMultipleViewModel {
    func search() {
        textSubject
            .map{ [unowned self] text -> [EnumeratedData] in
                if (text?.isEmpty ?? true){
                    return self.items
                }  else {
                    return self.items.filter{ $0.data.title.lowercased().contains(text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) }
                } }
            .map{
                [SectionModel(model: 0, items: $0.map{ SearchableActionSheetMultipleTableViewCellModel($0.data, index: $0.index, isSelected: self.selectedItems.contains($0.index) ? true:false)
                })] }
            .bind(to: sectionModelsSubject)
            .disposed(by: disposeBag)
    }
}

