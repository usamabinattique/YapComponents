//
//  NotificationCollectionViewCellViewModel.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 26/08/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift

protocol NotificationCollectionViewCellViewModelInputs {
    var deleteNotificationObserver: AnyObserver<IndexPath> { get }
}

protocol NotificationCollectionViewCellViewModelOutputs {
    var notificationTitle: Observable<String?> { get }
    var notifocationDescription: Observable<String?> { get }
    var notificationIcon: Observable<ImageWithURL> { get }
    var deleteNotification: Observable<IndexPath> { get }
    var deletable: Observable<Bool> { get }
}

protocol NotificationCollectionViewCellViewModelType {
    var inputs: NotificationCollectionViewCellViewModelInputs { get }
    var outputs: NotificationCollectionViewCellViewModelOutputs { get }
}

class NotificationCollectionViewCellViewModel: NotificationCollectionViewCellViewModelType, ReusableCollectionViewCellViewModelType, NotificationCollectionViewCellViewModelInputs, NotificationCollectionViewCellViewModelOutputs {
    
    var reusableIdentifier: String { return NotificationCollectionViewCell.reuseIdentifier }

    // MARK: - Properties
    let disposeBag = DisposeBag()
    var inputs: NotificationCollectionViewCellViewModelInputs { return self }
    var outputs: NotificationCollectionViewCellViewModelOutputs { return self }
    
    private let notificationIconSubject: BehaviorSubject<ImageWithURL>
    private let notificationTitleSubject: BehaviorSubject<String?>
    private let notificationDescriptionSubject: BehaviorSubject<String?>
    private let deleteNotificationSubject = PublishSubject<IndexPath>()
    private let deletableSubject = BehaviorSubject<Bool>(value: true)
    
    // MARK:- Inputs
    var deleteNotificationObserver: AnyObserver<IndexPath> { return deleteNotificationSubject.asObserver() }
    
    // MARK: - Outputs
    var notificationIcon: Observable<ImageWithURL> { return notificationIconSubject.asObservable() }
    var notifocationDescription: Observable<String?> { return notificationDescriptionSubject.asObservable() }
    var notificationTitle: Observable<String?> { return notificationTitleSubject.asObservable() }
    var deleteNotification: Observable<IndexPath> { return deleteNotificationSubject.asObservable() }
    var deletable: Observable<Bool> { return deletableSubject.asObservable() }
    
    let notification: InAppNotification
    
    init(notification: InAppNotification) {
        self.notification = notification
        notificationTitleSubject = BehaviorSubject(value: notification.title)
        notificationDescriptionSubject = BehaviorSubject(value: notification.description)
        notificationIconSubject = BehaviorSubject(value: notification.imageWithUrl)
    }
}
