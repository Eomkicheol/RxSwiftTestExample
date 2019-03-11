//
//  BaseCollectionViewCell.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    private(set) var didSetupConstraints = false
    
    override func updateConstraints() {
        if self.didSetupConstraints == false {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    func configure() {
        self.setNeedsUpdateConstraints()
    }
    
    func setupConstraints() {}
    
}
