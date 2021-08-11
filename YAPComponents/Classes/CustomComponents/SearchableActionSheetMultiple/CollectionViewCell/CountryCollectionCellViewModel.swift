//
//  CountryCollectionCellViewModel.swift
//  YAPKit
//
//  Created by Muhammad Awais on 15/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
import RxSwift

protocol CountryCollectionCellViewModelInput {
    
}

protocol CountryCollectionCellViewModelOutput {
    var name: Observable<String?> { get }
}

protocol CountryCollectionCellViewModelType {
    var inputs: CountryCollectionCellViewModelInput { get }
    var outputs: CountryCollectionCellViewModelOutput { get }
}

public class CountryCollectionCellViewModel: CountryCollectionCellViewModelType, CountryCollectionCellViewModelInput, CountryCollectionCellViewModelOutput, ReusableCollectionViewCellViewModelType {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var inputs: CountryCollectionCellViewModelInput { return self }
    var outputs: CountryCollectionCellViewModelOutput { return self }
    public var reusableIdentifier: String { return CountryCollectionCell.reuseIdentifier }
    
    private let nameSubject = BehaviorSubject<String?>(value: nil)
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var name: Observable<String?> { return nameSubject.asObservable() }
    
    // MARK: - Init
    
    public init(_ name: String) {
        nameSubject.onNext(name)
    }
}

