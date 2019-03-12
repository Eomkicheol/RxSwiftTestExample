//
//  UserSearchViewModel.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 12/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import RxSwift
import RxViewBinder
import RxOptional
import RxCocoa

final class UserSearchViewModel: ViewBindable {
    // MARK: Constants
    private enum Constants {}
    
    // MARK: Command
    enum Command {
        case search(String)
        case loadMoreSearch(String)
    }
    
    // MARK: Action
    struct Action {
        let searchAction: BehaviorRelay<[UserItems]> = BehaviorRelay(value: [])
        let isNetworking: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let nextPage: BehaviorRelay<String> = BehaviorRelay(value: "")
        let loadMoreIndicator: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    }
    
    // MARK: State
    struct State {
        let searchAction: Driver<[UserItems]>
        let isNetworking: Driver<Bool>
        let loadMoreIndicator: Driver<Bool>
        
        
        init(action: Action) {
            searchAction = action.searchAction.asDriver(onErrorJustReturn: []).skip(1)
            isNetworking = action.isNetworking.asDriver(onErrorJustReturn: false)
            loadMoreIndicator = action.loadMoreIndicator.asDriver(onErrorJustReturn: false).skip(1)
        }
    }
    
    // MARK: Properties
    let action = Action()
    lazy var state = State(action: action)
    
    var itemMaxCount: Int = 0
    var page: Int = 1
    
    init() {
    }
    
    deinit {
        DebugLog(self)
    }
    
    func binding(command: Command) {
        switch command {
        case .search(let name):
            self.searchGitHub(userName: name)
        case .loadMoreSearch(let name):
            self.loadMoreIndicator()
            self.fetchListMore(userName: name)
        }
    }
    
    private func searchGitHub(userName: String) {
        let page: Int = 1
        
        let response = Observable<String>.just(userName)
            .do(onNext: { [weak self] _ in
                self?.action.isNetworking.accept(true)
            })
            .map { $0 }
            .share(replay: 1, scope: .whileConnected)
        
        
        let nextPage = response
            .flatMap { AppService.shared.requestResponse(.userSearch(userName: $0, page: page))}
            .map { $0.response?.allHeaderFields["Link"] as? String }
            .filterNil()
            .map { $0.patternMatched }
        
        
        let searchModel = response
            .flatMap { AppService.shared.requestResponse(.userSearch(userName: $0, page: page)).map(UserModel.self)}
            .map { ($0.items, $0.totalCount) }
        
        nextPage.bind(to: action.nextPage).disposed(by: disposeBag)
        
        searchModel
            .do(onNext: { [weak self] _ in
                self?.action.isNetworking.accept(false)
                }, onError: { [weak self] _ in
                    self?.action.isNetworking.accept(false)
            })
            .subscribe { [weak self] (event) in
                self?.action.isNetworking.accept(false)
                if let result = event.element {
                    self?.itemMaxCount = result.1
                    self?.action.searchAction.accept(result.0)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func loadMoreIndicator() {
        Observable<Void>.just(())
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }
                return self.action.searchAction.value.count < self.itemMaxCount
            }
            .bind(to: action.loadMoreIndicator)
            .disposed(by: disposeBag)
    }
    
    private func fetchListMore(userName: String) {
        guard action.isNetworking.value == false else { return }
        guard action.searchAction.value.count < self.itemMaxCount else { return }
        
        let nextPage = self.action.nextPage.value
        
        if nextPage == "next" {
            self.page += 1
        }
        
        let response = Observable<String>.just(userName)
            .do(onNext: { [weak self] _ in
                self?.action.isNetworking.accept(true)
            })
            .filter { [weak self] _ in self?.page ?? 1 >= 1}
            .map { $0 }
            .share(replay: 1, scope: .whileConnected)
        
        let resultNextPage = response
            .flatMap { [weak self] in AppService.shared.requestResponse(.userSearch(userName: $0, page: self?.page ?? 1))
            }
            .map { $0.response?.allHeaderFields["Link"] as? String }
            .filterNil()
            .map { $0.patternMatched }
        
        let searchMoreModel = response
            .flatMap { [weak self] in AppService.shared.requestResponse(.userSearch(userName: $0, page: self?.page ?? 1)).map(UserModel.self)
            }
            .map { ($0.items, $0.totalCount)}
            .do(onNext: { [weak self] _ in
                self?.action.isNetworking.accept(false)
                }, onError: { [weak self] _ in
                    self?.action.isNetworking.accept(false)
            })
        
        resultNextPage.bind(to: self.action.nextPage).disposed(by: disposeBag)
        
        searchMoreModel .subscribe({ [weak self] (event: Event) in
                if let result = event.element {
                    self?.itemMaxCount = result.1
                    var newData = self?.action.searchAction.value ?? []
                    newData.append(contentsOf: result.0)
                    self?.action.searchAction.accept(newData)
                }
            })
        .disposed(by: disposeBag)
    }
}
