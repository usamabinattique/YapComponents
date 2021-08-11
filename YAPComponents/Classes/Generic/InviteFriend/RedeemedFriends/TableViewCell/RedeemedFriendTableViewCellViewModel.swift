//
//  RedeemedFriendTableViewCellViewModel.swift
//  YAP
//
//  Created by Zain on 25/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift

protocol RedeemedFriendTableViewCellViewModelInput {
    
}

protocol RedeemedFriendTableViewCellViewModelOutput {
    var name: Observable<String?> { get }
    var image: Observable<(String?, UIImage?)> { get }
}

protocol RedeemedFriendTableViewCellViewModelType {
    var inputs: RedeemedFriendTableViewCellViewModelInput { get }
    var outputs: RedeemedFriendTableViewCellViewModelOutput { get }
}

class RedeemedFriendTableViewCellViewModel: RedeemedFriendTableViewCellViewModelType, RedeemedFriendTableViewCellViewModelInput, RedeemedFriendTableViewCellViewModelOutput, ReusableTableViewCellViewModelType {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var inputs: RedeemedFriendTableViewCellViewModelInput { return self }
    var outputs: RedeemedFriendTableViewCellViewModelOutput { return self }
    var reusableIdentifier: String { return RedeemedFriendTableViewCell.reuseIdentifier }
    
    private let nameSubject = BehaviorSubject<String?>(value: nil)
    private let imageSubject = BehaviorSubject<(String?, UIImage?)>(value: (nil, nil))
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var name: Observable<String?> { return nameSubject.asObservable() }
    var image: Observable<(String?, UIImage?)> { return imageSubject.asObservable() }
    
    let friend: RedeemedFriend!
    
    // MARK: - Init
    init(_ friend: RedeemedFriend) {
        self.friend = friend
        
        nameSubject.onNext(friend.name)
        imageSubject.onNext((friend.imageURL, friend.name.initialsImage(color: .secondaryGreen)))
    }
}
