//
//  Observable+Extension.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 03/01/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    public static func createForever(element: Element) -> Observable<Element> {
        Observable.create { observer in
            observer.onNext(element)
            return Disposables.create()
        }
    }
}
