//
//  FooterLoadingView.swift
//  YAPComponents
//
//  Created by Yasir on 09/06/2022.
//

import UIKit



/// show loading at bottom for tableview
/// Usage:   if show {
///  let loading = FooterLoadingView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 64))
/// self.tableView.tableFooterView = loading
/// loading.indicator.startAnimating()
/// }else {
/// self.tableView.tableFooterView = nil
/// }
public final class FooterLoadingView: UIView {

    let indicator = UIActivityIndicatorView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeUI(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func customizeUI(frame: CGRect) {
        indicator.frame = CGRect(x: (frame.size.width/2) - 12, y: 10, width: 24, height: 24)
        self.addSubview(indicator)
    }
}
