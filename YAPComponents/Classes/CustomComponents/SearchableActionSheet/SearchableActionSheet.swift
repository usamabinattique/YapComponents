//
//  SearchableActionSheet.swift
//  YAPKit
//
//  Created by Zain on 11/11/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

public class SearchableActionSheet {
    
    // MARK: Properties
    
    private let viewModel: SearchableActionSheetViewModelType
    private let viewController: SearchableActionSheetViewController
    private let itemSelectedSubject = PublishSubject<Int>()
    public var itemSelected: Observable<Int> { itemSelectedSubject.asObservable() }
    private let disposeBag = DisposeBag()
    
    // MARK: Initialization
    
    public init(title: String?, searchPlaceholderText: String, items: [SearchableDataType]) {
        viewModel = SearchableActionSheetViewModel(title, searchPlaceholderText: searchPlaceholderText, items: items)
        viewController = SearchableActionSheetViewController(viewModel)
        viewModel.outputs.itemSelected.subscribe(onNext: { [weak self] in
            if $0 >= 0 {
                self?.itemSelectedSubject.onNext($0)
            }
            self?.itemSelectedSubject.onCompleted()
        }).disposed(by: disposeBag)
    }
}

// MARK: Public methods

public extension SearchableActionSheet {
    
    
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
