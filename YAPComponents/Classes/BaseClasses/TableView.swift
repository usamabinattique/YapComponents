//
//  TableView.swift
//  iOSApp
//
//  Created by Abbas on 07/06/2021.
//

import UIKit

public class TableView: UITableView {

    init () {
        super.init(frame: CGRect(), style: .grouped)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        rowHeight = UITableView.automaticDimension
        backgroundColor = .clear
        keyboardDismissMode = .onDrag
        separatorStyle = .none
        cellLayoutMarginsFollowReadableWidth = false
        translatesAutoresizingMaskIntoConstraints = false
        estimatedRowHeight = 50
        // sectionHeaderHeight = 40
        // separatorInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
        // tableHeaderView = View(height: 1)
    }
}
