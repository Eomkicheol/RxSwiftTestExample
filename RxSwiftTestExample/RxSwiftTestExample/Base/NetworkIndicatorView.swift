//
//  NetworkIndicatorView.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

import SnapKit

class NetworkIndicatorView: UIView {
    
    // MARK: Constants
    enum Constants {
        static let indicatorBackColor : UIColor = .black
        static let indicatorBackAlpha: CGFloat = 0.6
        static let indicatorBackLayerCornerRadius: CGFloat = 16
    }
    
    // MARK: Properties
    
    // MARK: UI Properties
    let indicatorBackView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.indicatorBackColor
        view.alpha = Constants.indicatorBackAlpha
        view.layer.cornerRadius = Constants.indicatorBackLayerCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.startAnimating()
        return view
    }()
    
    // MARK: Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Func
    private func configureUI() {
        
        [indicatorBackView].forEach { self.addSubview($0) }
        
        [indicator].forEach { self.indicatorBackView.addSubview($0) }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        indicatorBackView.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.size.equalTo(self.indicator).offset(40)
            $0.center.equalToSuperview()
            
        }
    }
}
