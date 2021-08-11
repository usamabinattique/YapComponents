//
//  GuidedTourViewModel.swift
//  YAP
//
//  Created by Muhammad Awais on 17/03/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

protocol GuidedTourViewInputs {
    var nextGuidedTourObserver: AnyObserver<Void> { get }
    var viewDidLoadObserver: AnyObserver<Void> { get }
    var skipObserver: AnyObserver<Void> { get }
}

protocol GuidedTourViewOutputs {
    var currentGuidedTourCircle: Observable<GuidedCircle?>{ get }
    var guidedTourTitle: Observable<String?>{ get }
    var guidedTourDescription: Observable<String?>{ get }
    var guidedTourNextButtonTitle: Observable<String?>{ get }
    var guidedTourStepsTitle: Observable<String?>{ get }
    var skip: Observable<Void> { get }
    var completed: Observable<Void> { get }
    var hideSkip: Observable<Bool> { get }
}

protocol GuidedTourViewModelType {
    var inputs: GuidedTourViewInputs { get }
    var outputs: GuidedTourViewOutputs { get }
}

class GuidedTourViewModel: GuidedTourViewModelType, GuidedTourViewInputs, GuidedTourViewOutputs {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var inputs: GuidedTourViewInputs { return self }
    var outputs: GuidedTourViewOutputs { return self }
    
    private let viewDidLoadObserverSubject = PublishSubject<Void>()
    private var guidedTours: [GuidedTour] = []
    private var totalSteps: Int = 0
    private let nextGuidedTourSubject = PublishSubject<Void>()
    private let currentGuidedTourCircleSubject = BehaviorSubject<GuidedCircle?>(value: nil)
    private let guidedTourTitleSubject = BehaviorSubject<String?>(value: nil)
    private let guidedTourDescriptionSubject = BehaviorSubject<String?>(value: nil)
    private let guidedTourNextButtonTitleSubject = BehaviorSubject<String?>(value: nil)
    private let guidedTourStepsTitleSubject = BehaviorSubject<String?>(value: nil)
    private let skipSubject = PublishSubject<Void>()
    private let completedSubject = PublishSubject<Void>()
    private let hideSkipSubject = BehaviorSubject<Bool>(value: false)
    
    //MARK: - Inputs
    var nextGuidedTourObserver: AnyObserver<Void>{ return nextGuidedTourSubject.asObserver() }
    var viewDidLoadObserver: AnyObserver<Void> { return viewDidLoadObserverSubject.asObserver() }
    var skipObserver: AnyObserver<Void> { skipSubject.asObserver() }
    
    //MARK: - Outputs
    var guidedTourTitle: Observable<String?> { return guidedTourTitleSubject.asObserver() }
    var guidedTourDescription: Observable<String?> { return guidedTourDescriptionSubject.asObserver() }
    var guidedTourNextButtonTitle: Observable<String?> { return guidedTourNextButtonTitleSubject.asObserver() }
    var guidedTourStepsTitle: Observable<String?> { return guidedTourStepsTitleSubject.asObserver() }
    var currentGuidedTourCircle: Observable<GuidedCircle?>{ return currentGuidedTourCircleSubject.asObservable() }
    var skip: Observable<Void> { skipSubject.asObservable() }
    var completed: Observable<Void> { completedSubject.asObservable() }
    var hideSkip: Observable<Bool> { return hideSkipSubject.asObserver() }
    
    // MARK: - Init
    public init(guidedToursArray: [GuidedTour]) {
        loadGuidedTours(objects: guidedToursArray)
        totalSteps = guidedToursArray.count
        viewDidLoadObserverSubject.subscribe(onNext: { [weak self] _ in
            self?.loadNextGuidedTour()
        }).disposed(by: disposeBag)
        nextGuidedTourSubject.subscribe(onNext: { [weak self] _ in
            self?.loadNextGuidedTour()
        }).disposed(by: disposeBag)
    }
}

extension GuidedTourViewModel {
    fileprivate func loadGuidedTours(objects: [GuidedTour]) {
        let guidedTours = Array(objects.reversed())
        self.guidedTours = guidedTours
    }
    
    private func loadNextGuidedTour() {
        if guidedTours.isEmpty {
            completedSubject.onNext(())
        }
        guard let guidedTour = guidedTours.popLast() else {
            return
        }
        if guidedTours.isEmpty {
            self.hideSkipSubject.onNext(true)
        }
        currentGuidedTourCircleSubject.onNext(guidedTour.circle)
        guard let title = guidedTour.title, let description = guidedTour.tourDescription else {
            return
        }
        guidedTourTitleSubject.onNext(title)
        guidedTourDescriptionSubject.onNext(description)
        guidedTourNextButtonTitleSubject.onNext(guidedTour.buttonTitle)
        let remainingTours = totalSteps - guidedTours.count
        guidedTourStepsTitleSubject.onNext(totalSteps > 1 ? String(remainingTours) + "/" + String(totalSteps) : "")
    }
}
