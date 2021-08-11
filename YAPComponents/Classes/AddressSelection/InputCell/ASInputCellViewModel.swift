//
//  ASInputCellViewModel.swift
//  YAPKit
//
//  Created by Zain on 27/04/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol ASInputCellViewModelInput {
    var textObserver: AnyObserver<String?> { get }
    var editingBeginObserver: AnyObserver<Void> { get }
    var nextObserver: AnyObserver<Void> { get }
    var nextActiveObserver: AnyObserver<Bool> { get }
    var edittingObserver: AnyObserver<Bool> { get }
}

protocol ASInputCellViewModelOutput {
    var text: Observable<String?> { get }
    var title: Observable<String> { get }
    var placeholder: Observable<String> { get }
    var type: Observable<AddressSelectionInputType> { get }
    var editingBegin: Observable<Void> { get }
    var next: Observable<Void> { get }
    var nextActive: Observable<Bool> { get }
    var editingEnd: Observable<Void> { get }
}

protocol ASInputCellViewModelType {
    var inputs: ASInputCellViewModelInput { get }
    var outputs: ASInputCellViewModelOutput { get }
}

class ASInputCellViewModel: ASInputCellViewModelType, ASInputCellViewModelInput, ASInputCellViewModelOutput, ReusableTableViewCellViewModelType {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var inputs: ASInputCellViewModelInput { return self }
    var outputs: ASInputCellViewModelOutput { return self }
    var reusableIdentifier: String { ASInputCell.reuseIdentifier }
    
    private let textSubject: BehaviorSubject<String?>
    private let titleSubject: BehaviorSubject<String>
    private let placeholderSubject: BehaviorSubject<String>
    private let typeSubject: BehaviorSubject<AddressSelectionInputType>
    private let editingBeginSubject = PublishSubject<Void>()
    private let nextSubject = PublishSubject<Void>()
    private let nextActiveSubject = BehaviorSubject<Bool>(value: false)
    
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    private let layoutTableViewSubject = PublishSubject<Void>()
    private let itemSelectedSubject = PublishSubject<Int>()
    private let dataSubject = BehaviorSubject<[String]>(value: [])
    private let edittingSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Inputs
    var textObserver: AnyObserver<String?> { textSubject.asObserver() }
    var editingBeginObserver: AnyObserver<Void> { editingBeginSubject.asObserver() }
    var nextObserver: AnyObserver<Void> { nextSubject.asObserver() }
    var nextActiveObserver: AnyObserver<Bool> { nextActiveSubject.asObserver() }
    var edittingObserver: AnyObserver<Bool> { edittingSubject.asObserver() }
    
    // MARK: - Outputs
    var text: Observable<String?> { textSubject.asObservable() }
    var title: Observable<String> { titleSubject.asObservable() }
    var placeholder: Observable<String> { placeholderSubject.asObservable() }
    var type: Observable<AddressSelectionInputType> { typeSubject.asObservable() }
    var editingBegin: Observable<Void> { editingBeginSubject.asObservable() }
    var nextActive: Observable<Bool> { nextActiveSubject.asObservable() }
    var next: Observable<Void> { nextSubject.asObservable() }
    var editingEnd: Observable<Void> { edittingSubject.filter{ !$0 }.map{ _ in }.asObservable() }
    
    // MARK: - Init
    init(_ inputType: AddressSelectionInputType, _ textSubject: BehaviorSubject<String?>) {
        self.textSubject = textSubject
        titleSubject = BehaviorSubject(value: inputType.title)
        placeholderSubject = BehaviorSubject(value: inputType.placeholder)
        typeSubject = BehaviorSubject(value: inputType)
    }
}

// MARK: Address selection input

enum AddressSelectionInputType {
    case address
    case building
    case emirate
    case city
    case poBox
    
    var canEdit: Bool { self != .emirate }
}

// MARK: Localization

fileprivate extension AddressSelectionInputType {
    var title: String {
        switch self {
        case .address:
            return "screen_meeting_location_input_text_address_title".localized
        case .building:
            return "screen_meeting_location_input_text_building_title".localized
        case .emirate:
            return "screen_meeting_location_input_text_emirate_title".localized
        case .city:
            return "screen_meeting_location_input_text_city_title".localized
        case .poBox:
            return "screen_meeting_location_input_text_pobox_title".localized
        }
    }
    
    var placeholder: String {
        switch self {
        case .address:
            return "screen_meeting_location_input_text_address_hint".localized
        case .building:
            return "screen_meeting_location_input_text_building_hint".localized
        case .emirate:
            return "screen_meeting_location_input_text_emirate_hint".localized
        case .city:
            return "screen_meeting_location_input_text_city_hint".localized
        case .poBox:
            return "screen_meeting_location_input_text_pobox_hint".localized
        }
    }
}

