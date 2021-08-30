//
//  CollectionViewCell.swift
//  iOSApp
//
//  Created by Abbas on 07/06/2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        self.layer.masksToBounds = true
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}

