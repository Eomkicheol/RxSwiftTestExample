//
//  UserSearchCollectionViewCell.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 12/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

import SnapKit
import Kingfisher
import RxCocoa
import RxSwift

extension Reactive where Base: UserSearchCollectionViewCell {
    
    var imageTapped: Observable<String> {
        return base.imageViewButton.rx.tap
            .map { _ in self.base.organizationsInfo }
    }
    
    var nameTapped: Observable<String> {
        return base.nameLabelButton.rx.tap
            .map { _ in self.base.organizationsInfo }
    }
    
}

class UserSearchCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: Constants
    private enum Constants {
        static let userNameFont: UIFont = FontName.bold(14).font
        static let scoreFont: UIFont = FontName.regular(12).font
        static let imageHeight: CGFloat = 50
        
    }
    // MARK: Properties
    var organizationsInfo: String = ""
    var disposedBag = DisposeBag()
    
    // MARK: UI Properties
    var userImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var userNameView: UIView = {
        let view = UIView()
        return view
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.userNameFont
        label.textColor = .black
        return label
    }()
    
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.scoreFont
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let imageViewButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let nameLabelButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = Constants.imageHeight * 0.5
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposedBag = DisposeBag()
    }
    
    func configure(value: UserItems) {
        super.configure()
        userNameLabel.text = value.login
        userImage.kf.setImage(with: URL(string: value.avatarUrl))
        scoreLabel.text = "\(value.score)"
        
        //orgsInfo
        self.organizationsInfo = value.organizationsUrl
    }
    
    func configureUI() {
        [userImage, userNameView, scoreLabel, imageViewButton].forEach {
            self.contentView.addSubview($0)
        }
        
        [userNameLabel, nameLabelButton].forEach {
            self.userNameView.addSubview($0)
        }
        
        userImage.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        imageViewButton.snp.makeConstraints {
            $0.left.centerY.size.equalTo(userImage)
        }
        
        userNameView.snp.makeConstraints {
            $0.top.equalTo(userImage)
            $0.left.equalTo(userImage.snp.right).offset(5)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nameLabelButton.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(nameLabelButton.intrinsicContentSize.height)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(userNameView.snp.bottom).offset(3)
            $0.left.equalTo(userNameLabel)
            
        }
    }
    
    // MARK: size
    
    static func size(width: CGFloat) -> CGSize {
        
        let height: CGFloat = 50 + 3 + Constants.userNameFont.lineHeight
        
        return CGSize(width: width, height: height)
    }
}

