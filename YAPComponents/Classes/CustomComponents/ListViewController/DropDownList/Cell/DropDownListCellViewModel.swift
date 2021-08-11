//
//  DropDownListCellViewModel.swift
//  YAPKit
//
//  Created by Zain on 03/06/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

protocol DropDownListCellViewModelInput {
    
}

protocol DropDownListCellViewModelOutput {
    var title: Observable<String?> { get }
}

protocol DropDownListCellViewModelType {
    var inputs: DropDownListCellViewModelInput { get }
    var outputs: DropDownListCellViewModelOutput { get }
}

class DropDownListCellViewModel: DropDownListCellViewModelType, DropDownListCellViewModelInput, DropDownListCellViewModelOutput, ReusableTableViewCellViewModelType {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var inputs: DropDownListCellViewModelInput { return self }
    var outputs: DropDownListCellViewModelOutput { return self }
    var reusableIdentifier: String { return DropDownListCell.reuseIdentifier }
    
    private let titleSubject: BehaviorSubject<String?>
    
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var title: Observable<String?> { titleSubject.asObservable() }
        
    // MARK: - Init
    init(_ title: String) {
        titleSubject = BehaviorSubject<String?>(value: title)
    }
}
