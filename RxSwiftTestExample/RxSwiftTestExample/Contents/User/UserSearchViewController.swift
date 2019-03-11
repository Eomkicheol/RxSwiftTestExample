//
//  UserSearchViewController.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 12/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxViewController
import RxViewBinder
import RxDataSources
import SnapKit

typealias SearchSection = RxCollectionViewSectionedReloadDataSource<UserSection>

final class UserSearchViewController: BaseViewController, BindView {
    typealias ViewBinder = UserSearchViewModel
    
    // MARK: Constants
    private enum Constants {}
    
    // MARK: Properties
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    lazy var dataSource: SearchSection = SearchSection(configureCell: { [weak self] dataSource, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .searchUser(let value):
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCollectionViewCell.reuseIdentifier, for: indexPath)
            
            guard let resultCell = cell as? UserSearchCollectionViewCell else { return cell }
            resultCell.configure(value: value)
            return resultCell
        }
    })
    
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.alwaysBounceVertical = true
        view.scrollIndicatorInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        view.showsVerticalScrollIndicator = true
        view.keyboardDismissMode = .onDrag
        view.backgroundColor = .clear
        
        //emptyView
        view.emptyView = CollectionEmptyView(errorMsg: "검색된 내용이 없습니다.")
        view.emptyView?.backgroundColor = .clear
        view.emptyView?.isHidden = false
        
        //cell
        view.register(UserSearchCollectionViewCell.self, forCellWithReuseIdentifier: UserSearchCollectionViewCell.reuseIdentifier)
        
        //footer
        view.register(IndicatorFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: IndicatorFooterView.reuseIdentifier)
        
        return view
    }()
    
    // MARK: UI Properties
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        view.searchBarStyle = .prominent
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        return view
    }()
    
    
    // MARK: Initializing
    init(viewBinder: ViewBinder) {
        defer {
            self.viewBinder = viewBinder
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        configureUI()
    }
    
    // MARK: Func
    func navigationSetting() {
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        [searchBar, collectionView].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        searchBar.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(5)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func command(viewBinder: ViewBinder) {
        super.command()
        
        searchBar.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .map { ViewBinder.Command.search($0) }
            .bind(to: viewBinder.command)
            .disposed(by: self.disposeBag)
    }
    
    func state(viewBinder: ViewBinder) {
        super.state()
        
        collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        viewBinder.state
            .isNetworking
            .drive(self.rx.networking)
            .disposed(by: self.disposeBag)
        
        viewBinder.state
            .searchAction
            .do(onNext: { [weak self] in
                self?.collectionView.emptyView?.isHidden = $0.count > 0
            })
            .map { [UserSection.searchUserSection( $0.map { UserSectionItems.searchUser($0) } )]}
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}


extension UserSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource[indexPath] {
        case .searchUser:
            return UserSearchCollectionViewCell.size(width: collectionView.bounds.width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch dataSource[section] {
        case .searchUserSection:
            return .init(top: 0, left: 0, bottom: 50, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}

