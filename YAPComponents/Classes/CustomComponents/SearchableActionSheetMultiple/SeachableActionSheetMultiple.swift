//
//  SeachableActionSheetMultiple.swift
//  YAPKit
//
//  Created by Muhammad Awais on 11/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

public class SearchableActionSheetMultiple {
    
    // MARK: Properties
    
    private let viewModel: SearchableActionSheetMultipleViewModelType
    private let viewController: SearchableActionSheetMultipleViewController
    private let itemsSelectedSubject = PublishSubject<[Int]>()
    private let itemDisSelectedSubject = PublishSubject<Int>()
    public var itemsSelected: Observable<[Int]> { itemsSelectedSubject.asObservable() }
    public var itemDisSelected: Observable<Int> { itemDisSelectedSubject.asObservable() }
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initialization
    
    public init(title: String?, searchPlaceholderText: String, items: [SearchableDataType]) {
        viewModel = SearchableActionSheetMultipleViewModel(title, searchPlaceholderText: searchPlaceholderText, items: items)
        viewController = SearchableActionSheetMultipleViewController(viewModel)
        viewModel.outputs.itemsSelected.subscribe(onNext: { [weak self] in
            self?.itemsSelectedSubject.onNext($0)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.itemDisSelected.subscribe(onNext: { [weak self] index in
            self?.itemDisSelectedSubject.onNext(index)
        }).disposed(by: disposeBag)
    }
}

// MARK: Public methods

public extension SearchableActionSheetMultiple {
    func show() {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        
        alertWindow.rootViewController = YAPActionSheetRootViewController(nibName: nil, bundle: nil)
        alertWindow.backgroundColor = .clear
        alertWindow.windowLevel = .alert + 1
        alertWindow.makeKeyAndVisible()
        
        let nav = UINavigationController(rootViewController: viewController)
        nav.navigationBar.isHidden = true
        nav.modalPresentationStyle = .overCurrentContext
        
        alertWindow.rootViewController?.present(nav, animated: false, completion: nil)
        
        viewController.window = alertWindow
    }
}

// MARK: Root View controller

private class YAPActionSheetRootViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIApplication.shared.statusBarStyle
        }
    }
}

