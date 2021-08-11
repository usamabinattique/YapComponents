//
//  SuccessViewModel.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 27/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift


protocol SuccessViewModelInputs {
    var doneButtonObserver: AnyObserver<Void> { get }
}

protocol SuccessViewModelOutputs {
    var heading: Observable<String?> { get }
    var subHeading: Observable<NSAttributedString?> { get }
    var doneButton: Observable<Void> { get }
    var doneButtonTitle: Observable<String?> { get }
    var image: Observable<UIImage?> { get }
    var details: Observable<NSAttributedString?> { get }
}

protocol SuccessViewModelType {
    var inputs: SuccessViewModelInputs { get }
    var outputs: SuccessViewModelOutputs { get }
}

public class SuccessViewModel: SuccessViewModelType, SuccessViewModelInputs, SuccessViewModelOutputs {
    
    var inputs: SuccessViewModelInputs { return self}
    var outputs: SuccessViewModelOutputs { return self }
    
    let headingSubject = BehaviorSubject<String?>(value: nil)
    let subHeadingSubject = BehaviorSubject<NSAttributedString?>(value: nil)
    let doneButtonSubject = PublishSubject<Void>()
    let doneButtonTitleSubject = BehaviorSubject<String?>(value: nil)
    let imageSubject = BehaviorSubject<UIImage?>(value: nil)
    let detailsSubject = BehaviorSubject<NSAttributedString?>(value: nil)
    
    //Inputs
    var doneButtonObserver: AnyObserver<Void> { return doneButtonSubject.asObserver() }
    
    //Outputs
    var doneButton: Observable<Void> { return doneButtonSubject.asObservable() }
    var heading: Observable<String?> { return headingSubject.asObservable() }
    var subHeading: Observable<NSAttributedString?> { return subHeadingSubject.asObservable() }
    var doneButtonTitle: Observable<String?> { return doneButtonTitleSubject.asObservable() }
    var image: Observable<UIImage?> { return imageSubject.asObservable() }
    var details: Observable<NSAttributedString?> { return detailsSubject.asObservable() }
    
   public init() {
       
    }
    
}
