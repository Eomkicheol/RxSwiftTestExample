//
//  IndicatorFooterView.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

import SnapKit

final class IndicatorFooterView: UICollectionReusableView {
    
    // MARK: Constants
    enum Constants {
        static let indicatorScale: CGFloat = 1.6
    }
    
    // MARK: UI Properties
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .white)
    
    
    // MARK: Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        indicator.color = .red
        indicator.startAnimating()
        
        [indicator].forEach { self.addSubview($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicator.snp.makeConstraints {
          $0.center.equalToSuperview()
        }
        
    }
}


