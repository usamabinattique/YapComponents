//
//  ChangeProfilePhotoViewModel.swift
//  YAP
//
//  Created by Wajahat Hassan on 01/03/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol ChangeProfilePhotoViewModelInputs {
    var backObserver: AnyObserver<Void> { get }
    var resultObserver: AnyObserver<UIImage> { get }
}

protocol ChangeProfilePhotoViewModelOutputs {
    var back: Observable<Void> { get }
    var result: Observable<UIImage> { get }
    var cameraSourceType: Observable<PhotoSource> { get }
}

protocol ChangeProfilePhotoViewModelType {
    var inputs: ChangeProfilePhotoViewModelInputs { get }
    var outputs: ChangeProfilePhotoViewModelOutputs { get }
}

class ChangeProfilePhotoViewModel: ChangeProfilePhotoViewModelType, ChangeProfilePhotoViewModelInputs, ChangeProfilePhotoViewModelOutputs {
    
    var inputs: ChangeProfilePhotoViewModelInputs { return self }
    var outputs: ChangeProfilePhotoViewModelOutputs { return self }
    
    private var backSuject = PublishSubject<Void>()
    private var resultSubject = PublishSubject<UIImage>()
    private var cameraSourceTypeSubject: BehaviorSubject<PhotoSource>
    
    // MARK: Inputs
    internal var backObserver: AnyObserver<Void> { return backSuject.asObserver() }
    internal var resultObserver: AnyObserver<UIImage> { return resultSubject.asObserver() }
    
    // MARK: Outputs
    internal var back: Observable<Void> { return backSuject.asObservable() }
    internal var result: Observable<UIImage> { return resultSubject.asObservable() }
    internal var cameraSourceType: Observable<PhotoSource> { return cameraSourceTypeSubject.asObservable() }
    
    // MARK: Class Properties
    internal let disposeBag = DisposeBag()
    
    // MARK: Init
    init(sourceType: PhotoSource) {
        cameraSourceTypeSubject =  BehaviorSubject(value: sourceType)
    }
}
