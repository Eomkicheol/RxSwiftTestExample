//
//  BaseViewController.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import RxViewController

class BaseViewController: UIViewController {
   
    // MARK: Properties
    private var baseDisposeBag = DisposeBag()
    
    private(set) var didSetupConstraints = false
    private(set) var didSetupSubViews = false
    
    
    // MARK: UI Properties
    let networkIndicatorView: NetworkIndicatorView = {
        let view = NetworkIndicatorView()
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        DebugLog(self)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsUpdateConstraints()
        
        self.view.backgroundColor = .white
        
        [networkIndicatorView].forEach {
            self.view.addSubview($0)
        }
    }
    
    //뷰 컨크롤의 뷰 제약조건을 업데이트 하기 위해 호출
    override func updateViewConstraints() {
        if self.didSetupConstraints == false {
            networkIndicatorView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    //뷰컨트롤러의 뷰가 하위뷰를 표시했음을 알리기 위해 호출
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.didSetupSubViews == false {
            self.setupSubViews()
            self.didSetupSubViews = true
        }
    }
    
    // MARK: Func
    func setupConstraints() {}
    
    func setupSubViews() {}
    
    func command() {
        self.rx.viewDidDisappear
            .map {_ in false }
            .bind(to: self.rx.networking)
            .disposed(by: self.baseDisposeBag)
    }
    
    func state() {}
    
}



// MARK: - Reactive
extension Reactive where Base: BaseViewController {
    
    //네트 워크 인디게이터 뷰 바인더
    var networking: Binder<Bool> {
        return Binder(self.base) { viewController, isNetworking in
            viewController.view.bringSubviewToFront(viewController.networkIndicatorView)
            viewController.networkIndicatorView.isHidden = !isNetworking
            UIApplication.shared.isNetworkActivityIndicatorVisible = isNetworking
            
        }
    }
}
