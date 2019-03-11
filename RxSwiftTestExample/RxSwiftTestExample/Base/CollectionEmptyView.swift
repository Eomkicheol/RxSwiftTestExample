//
//  CollectionEmptyView.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

import SnapKit

class CollectionEmptyView: UIView {
    
    // MARK: Constants
    enum Constants {
        static let labelFont: UIFont = FontName.regular(14).font
        static let labelColor: UIColor = UIColor(red: 136/255, green: 139/255, blue: 144/255, alpha: 1.0)
    }
    
    // MARK: UI Properties
    let errorImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icError50"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.labelFont
        label.textColor = Constants.labelColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Initializing
    init(errorMsg: String) {
        self.init()
        
        [errorImageView, errorLabel].forEach { self.addSubview($0) }
        
        errorLabel.text = errorMsg
        
        errorImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.top.equalTo(self.errorImageView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

