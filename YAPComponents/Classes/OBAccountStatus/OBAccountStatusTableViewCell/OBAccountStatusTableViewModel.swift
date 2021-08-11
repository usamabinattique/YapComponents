//
//  OBAccountStatusTableViewModel.swift
//  App
//
//  Created by Uzair on 14/06/2021.
//

import Foundation
import RxSwift

class OBAccountStatusTableViewModel : ReusableTableViewCellViewModelType {
    
    // MARK: - Properties
    var reusableIdentifier: String { return OBAccountStatusTableViewCell.reuseIdentifier }
    private let disposeBag = DisposeBag()
    private var isHiddenBottomDottedViewSubject: BehaviorSubject<Bool>
    private var titleLabelSubject :  BehaviorSubject<String>
    private var countLabelSubject :  BehaviorSubject<String>
    private var stateSubject :  BehaviorSubject<OBStages>
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var isHiddenBottomDottedView: Observable<Bool>{ isHiddenBottomDottedViewSubject.asObservable() }
    var titleLabel : Observable<String>{ titleLabelSubject.asObservable() }
    var countLabel : Observable<String>{ countLabelSubject.asObservable() }
    var state : Observable<OBStages>{ stateSubject.asObservable() }

    public init(isHiddenBottomDottedView: Bool = false, stage: OBAccountStatusStage) {
        isHiddenBottomDottedViewSubject = BehaviorSubject(value: isHiddenBottomDottedView)
        
        titleLabelSubject = BehaviorSubject(value: stage.title)
        countLabelSubject = BehaviorSubject(value: stage.count)
        
        switch stage {
        case .personalDetails(state: let state), .companyDocuments(state: let state), .companyDetails(state: let state), .shareHolderDetails(state: let state):
            stateSubject = BehaviorSubject(value: state)
        }
    }
}
