//
//  ASHeadingCellViewModel.swift
//  YAPKit
//
//  Created by Zain on 27/04/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

import RxSwift

public protocol ASHeadingCellViewModelInput {
    var headingObserver: AnyObserver<String?> { get }
    var subHeadingObserver: AnyObserver<String?> { get }
}

public protocol ASHeadingCellViewModelOutput {
    var heading: Observable<String?> { get }
    var subHeading: Observable<String?> { get }
}

public protocol ASHeadingCellViewModelType {
    var inputs: ASHeadingCellViewModelInput { get }
    var outputs: ASHeadingCellViewModelOutput { get }
}

public class ASHeadingCellViewModel: ASHeadingCellViewModelType, ASHeadingCellViewModelInput, ASHeadingCellViewModelOutput, ReusableTableViewCellViewModelType {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    public var inputs: ASHeadingCellViewModelInput { return self }
    public var outputs: ASHeadingCellViewModelOutput { return self }
    public var reusableIdentifier: String { ASHeadingCell.reuseIdentifier }
    
    private let headingSubject: BehaviorSubject<String?>
    private let subHeadingSubject: BehaviorSubject<String?>
    
    // MARK: - Inputs
    public var headingObserver: AnyObserver<String?> { headingSubject.asObserver() }
    public var subHeadingObserver: AnyObserver<String?> { subHeadingSubject.asObserver() }
    
    // MARK: - Outputs
    public var heading: Observable<String?> { headingSubject.asObservable() }
    public var subHeading: Observable<String?> { subHeadingSubject.asObservable() }
    
    // MARK: - Init
    
    public init(_ headingSubject: BehaviorSubject<String?>, _ subHeadingSubject: BehaviorSubject<String?>) {
        self.headingSubject = headingSubject
        self.subHeadingSubject = subHeadingSubject
    }
}

