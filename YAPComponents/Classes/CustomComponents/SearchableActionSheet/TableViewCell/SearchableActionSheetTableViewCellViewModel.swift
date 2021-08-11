//
//  SearchableActionsSheetTableViewCellViewModel.swift
//  YAPKit
//
//  Created by Zain on 10/11/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchableActionSheetTableViewCellViewModelInput {
    
}

protocol SearchableActionSheetTableViewCellViewModelOutput {
    var icon: Observable<UIImage?> { get }
    var title: Observable<String?> { get }
    var selected: Observable<Bool> { get }
    var showsAttributedTitle: Observable<Bool> { get }
    var attributedTitle: Observable<NSAttributedString?> { get }
    var showsIcon: Observable<Bool> { get }
}

protocol SearchableActionSheetTableViewCellViewModelType {
    var inputs: SearchableActionSheetTableViewCellViewModelInput { get }
    var outputs: SearchableActionSheetTableViewCellViewModelOutput { get }
}

class SearchableActionSheetTableViewCellViewModel: SearchableActionSheetTableViewCellViewModelInput, SearchableActionSheetTableViewCellViewModelOutput, SearchableActionSheetTableViewCellViewModelType, ReusableTableViewCellViewModelType {
    
    var inputs: SearchableActionSheetTableViewCellViewModelInput { self }
    var outputs: SearchableActionSheetTableViewCellViewModelOutput { self }
    
    private let disposeBag = DisposeBag()
    
    var reusableIdentifier: String { SearchableActionSheetTableViewCell.reuseIdentifier }
    
    private let iconSubject: BehaviorSubject<UIImage?>
    private let titleSubject: BehaviorSubject<String?>
    private let selectedSubject: BehaviorSubject<Bool>
    private let showsAttributedTitleSubject: BehaviorSubject<Bool>
    private let attributedTitleSubject: BehaviorSubject<NSAttributedString?>
    private let showsIconSubject: BehaviorSubject<Bool>
    
    // MARK: - Inputs
    
    // MARK: - Outpus
    
    var icon: Observable<UIImage?> { iconSubject.asObservable() }
    var title: Observable<String?> { titleSubject.asObservable() }
    var selected: Observable<Bool> { selectedSubject.asObservable() }
    var showsAttributedTitle: Observable<Bool> { showsAttributedTitleSubject.asObservable() }
    var attributedTitle: Observable<NSAttributedString?> { attributedTitleSubject.asObservable() }
    var showsIcon: Observable<Bool> { showsIconSubject.asObservable() }
    
    let index: Int
    
    init(_ data: SearchableDataType, index: Int) {
        self.index = index
        iconSubject = BehaviorSubject(value: data.icon)
        titleSubject = BehaviorSubject(value: data.title)
        selectedSubject = BehaviorSubject(value: data.selected)
        showsAttributedTitleSubject = BehaviorSubject(value: data.isAttributedTitle)
        attributedTitleSubject = BehaviorSubject(value: data.attributedTitle)
        showsIconSubject = BehaviorSubject(value: data.showsIcon)
    }
}
