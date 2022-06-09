//
//  UITableView+Extensions.swift
//  YAPComponents
//
//  Created by Yasir on 09/06/2022.
//

import UIKit

public extension UITableView {
    var scrollPercentage: CGFloat {
        let height = self.contentSize.height - self.frame.size.height
            let scrolledPercentage = self.contentOffset.y / height
            return scrolledPercentage
    }
}
