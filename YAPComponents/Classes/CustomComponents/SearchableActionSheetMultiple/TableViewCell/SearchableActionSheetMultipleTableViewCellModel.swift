//
//  SearchableActionSheetMultipleTableViewCellModel.swift
//  YAPKit
//
//  Created by Muhammad Awais on 11/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchableActionSheetMultipleTableViewCellModelInput {
    var changeSelectState: AnyObserver<Void> { get }
}

protocol SearchableActionSheetMultipleTableViewCellModelOutput {
    var icon: Observable<UIImage?> { get }
    var title: Observable<String?> { get }
    var selected: Observable<Bool> { get }
    var showsAttributedTitle: Observable<Bool> { get }
    var attributedTitle: Observable<NSAttributedString?> { get }
    var showsIcon: Observable<Bool> { get }
    var selectStateImage: Observable<UIImage?> { get }
}

protocol SearchableActionSheetMultipleTableViewCellModelType {
    var inputs: SearchableActionSheetMultipleTableViewCellModelInput { get }
    var outputs: SearchableActionSheetMultipleTableViewCellModelOutput { get }
}

class SearchableActionSheetMultipleTableViewCellModel: SearchableActionSheetMultipleTableViewCellModelInput, SearchableActionSheetMultipleTableViewCellModelOutput, SearchableActionSheetMultipleTableViewCellModelType, ReusableTableViewCellViewModelType {
    
    var inputs: SearchableActionSheetMultipleTableViewCellModelInput { self }
    var outputs: SearchableActionSheetMultipleTableViewCellModelOutput { self }
    
    private let disposeBag = DisposeBag()
    
    var reusableIdentifier: String { SearchableActionSheetMultipleTableViewCell.reuseIdentifier }
    
    private let iconSubject: BehaviorSubject<UIImage?>
    private let titleSubject: BehaviorSubject<String?>
    private let selectedSubject: BehaviorSubject<Bool>
    private let showsAttributedTitleSubject: BehaviorSubject<Bool>
    private let attributedTitleSubject: BehaviorSubject<NSAttributedString?>
    private let showsIconSubject: BehaviorSubject<Bool>
    private let selectStateImageSubject = BehaviorSubject<UIImage?>(value: nil)
    private let changeSelectStateSubject = PublishSubject<Void>()
    private let selectedStateSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Inputs
    
    // MARK: - Outpus
    
    var icon: Observable<UIImage?> { iconSubject.asObservable() }
    var title: Observable<String?> { titleSubject.asObservable() }
    var selected: Observable<Bool> { selectedSubject.asObservable() }
    var showsAttributedTitle: Observable<Bool> { showsAttributedTitleSubject.asObservable() }
    var attributedTitle: Observable<NSAttributedString?> { attributedTitleSubject.asObservable() }
    var showsIcon: Observable<Bool> { showsIconSubject.asObservable() }
    var selectStateImage: Observable<UIImage?> { return selectStateImageSubject.asObservable() }
    var changeSelectState: AnyObserver<Void> { return changeSelectStateSubject.asObserver() }
    
    let index: Int
    
    init(_ data: SearchableDataType, index: Int, isSelected: Bool? = nil) {
        self.index = index
        iconSubject = BehaviorSubject(value: data.icon)
        titleSubject = BehaviorSubject(value: data.title)
        selectedSubject = BehaviorSubject(value: isSelected ?? data.selected)
        showsAttributedTitleSubject = BehaviorSubject(value: data.isAttributedTitle)
        attributedTitleSubject = BehaviorSubject(value: data.attributedTitle)
        showsIconSubject = BehaviorSubject(value: data.showsIcon)
        
        changeSelectStateSubject.subscribe(onNext: { [unowned self] _ in
            guard let isSelected = try? self.selectedSubject.value() else { return }
            self.selectedSubject.onNext(!isSelected)
        }).disposed(by: disposeBag)
    }
}


