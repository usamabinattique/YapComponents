//
//  WelcomeScreenViewModel.swift
//  App
//
//  Created by Uzair on 10/06/2021.
//

import Foundation
import RxSwift
import RxDataSources
//import Networking

public protocol OBAccountStatusViewModelInput {
    var nextObserver: AnyObserver<Void> { get }
    var backObserver: AnyObserver<Void> { get }
}

public protocol OBAccountStatusViewModelOutput {
    var next: Observable<Void> { get }
    var back: Observable<Void> { get }
    var heading: Observable<String>  { get }
    var subheading: Observable<String> { get }
    var buttonTitle: Observable<String> { get }
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
}

public protocol OBAccountStatusViewModelType {
    var inputs: OBAccountStatusViewModelInput { get }
    var outputs: OBAccountStatusViewModelOutput { get }
}

public class OBAccountStatusViewModel: OBAccountStatusViewModelInput, OBAccountStatusViewModelOutput, OBAccountStatusViewModelType {
    
    public var inputs: OBAccountStatusViewModelInput { return self }
    public var outputs: OBAccountStatusViewModelOutput { return self }
    
    private let nextSubject = PublishSubject<Void>()
    private let backSubject = PublishSubject<Void>()
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    private var headingSubject = BehaviorSubject<String>(value: "")
    private var subheadingSubject = BehaviorSubject<String>(value: "")
    private var buttonTitleSubject = BehaviorSubject<String>(value: "")
    
    // inputs
    public var nextObserver: AnyObserver<Void> { return nextSubject.asObserver() }
    public var backObserver: AnyObserver<Void> { return backSubject.asObserver() }
    
    // outputs
    public var heading: Observable<String>  { return headingSubject.asObservable() }
    public var subheading: Observable<String> { return subheadingSubject.asObservable() }
    public var buttonTitle: Observable<String> { return buttonTitleSubject.asObservable() }
    public var next: Observable<Void> { return nextSubject.asObservable() }
    public var back: Observable<Void> { return backSubject.asObservable() }
    public var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    
    public init(title: String, subTitle: String, buttonTitle: String, stages: [OBAccountStatusStage] ) {
        
        self.headingSubject = BehaviorSubject(value: title)
        self.subheadingSubject = BehaviorSubject(value: subTitle)
        self.buttonTitleSubject = BehaviorSubject(value: buttonTitle)

        generateCellViewModels(stages: stages)
    }
    
    func generateCellViewModels(stages: [OBAccountStatusStage]) {
        var cellViewModels = [ReusableTableViewCellViewModelType]()
//        cellViewModels.append(OBAccountStatusTableViewModel(isHiddenTopDottedView: true, stage: .personalDetails(state: .inProgress)))
//        cellViewModels.append(OBAccountStatusTableViewModel(stage: .companyDetails(state: .inProgress)))
//        cellViewModels.append(OBAccountStatusTableViewModel(stage: .companyDocuments(state: .inProgress)))
//        cellViewModels.append(OBAccountStatusTableViewModel(isHiddenBottomDottedView: true,stage: .shareHolderDetails(state: .inProgress)))
        
        var index = 0
        
        stages.forEach {
            cellViewModels.append(OBAccountStatusTableViewModel(isHiddenBottomDottedView: index == (stages.count-1) , stage: $0))
            index += 1
        }
        
        dataSourceSubject.onNext([SectionModel<Int, ReusableTableViewCellViewModelType>(model: 0, items: cellViewModels)])
    }
}
