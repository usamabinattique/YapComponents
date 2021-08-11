//
//  YAPActionSheetViewModel.swift
//  YAPKit
//
//  Created by Zain on 03/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol YAPActionSheetViewModelInput {
    var addActionObserver: AnyObserver<YAPActionSheetAction> { get }
}

protocol YAPActionSheetViewModelOutput {
    var title: Observable<String?> { get }
    var subTitle: Observable<String?> { get }
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
}

protocol YAPActionSheetViewModelType {
    var inputs: YAPActionSheetViewModelInput { get }
    var outputs: YAPActionSheetViewModelOutput { get }
}

class YAPActionSheetViewModel: YAPActionSheetViewModelType, YAPActionSheetViewModelInput, YAPActionSheetViewModelOutput {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var inputs: YAPActionSheetViewModelInput { return self }
    var outputs: YAPActionSheetViewModelOutput { return self }
    var bigIcon: Bool = false
    
    private let titleSubject = BehaviorSubject<String?>(value: nil)
    private let subTitleSubject = BehaviorSubject<String?>(value: nil)
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    private let addActionSubject = PublishSubject<YAPActionSheetAction>()
    
    var actions = [YAPActionSheetAction]()
    
    // MARK: - Inputs
    var addActionObserver: AnyObserver<YAPActionSheetAction> { return addActionSubject.asObserver() }
    
    // MARK: - Outputs
    var title: Observable<String?> { return titleSubject.asObservable() }
    var subTitle: Observable<String?> { return subTitleSubject.asObservable() }
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    
    // MARK: - Init
    init(_ title: String?, _ subTitle: String?, bigIcon: Bool = false) {
        self.bigIcon = bigIcon
        titleSubject.onNext(title)
        subTitleSubject.onNext(subTitle)
        addActionSubject
            .map { [unowned self] action -> [YAPActionSheetAction] in
                self.actions.append(action)
                return self.actions }
            .map { $0.map {
                bigIcon == false ? YAPActionSheetTableViewCellViewModel(action: $0) : YAPActionSheetBigIconTableViewCellViewModel(action: $0)
                
            } }
            .map { [SectionModel(model: 0, items: $0)] }
            .bind(to: dataSourceSubject)
            .disposed(by: disposeBag)
    }
}
