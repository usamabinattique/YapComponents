//
//  DropDownList.swift
//  YAPKit
//
//  Created by Zain on 03/06/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

public class DropDownList {
    
    // MARK: Properties
    private let viewController: DropDownListViewController
    private let viewModel: DropDownListViewModel
    
    // MARK: Initialization
    public init(title: String?, items: [String], itemSelectionHandler:@escaping (_: IndexPath) -> Void?) {
        viewModel = DropDownListViewModel(items)
        viewController = DropDownListViewController(with: viewModel, title: title)
        viewModel.outputs.itemSelected.subscribe(onNext: { itemSelectionHandler($0) }).disposed(by: viewModel.disposeBag)
    }
    
    // MARK: Show
    
    public func show(in viewController: UIViewController) {
        self.viewController.show(in: viewController)
    }
    
}
