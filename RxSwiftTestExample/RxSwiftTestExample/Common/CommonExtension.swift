//
//  CommonExtension.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

enum FontName {
    case regular(CGFloat)
    case bold(CGFloat)
}

//MARK: UIFont구분
extension FontName {
    var font: UIFont {
        switch self {
        case .bold(let size):
            return UIFont.boldSystemFont(ofSize: size)
        case .regular(let size):
            return UIFont.systemFont(ofSize: size)
        }
    }
}

//MARK: CollectView, TableView 식별자명
extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//MARK: CollectView, TableView EmptyView
extension UICollectionView {
    var emptyView: UIView? {
        get { return self.backgroundView }
        set {
            self.backgroundView = newValue
            self.backgroundView?.isHidden = true
        }
    }
}

//MARK: FooterView
extension Reactive where Base: UICollectionViewFlowLayout {
    public var footerSize: Binder<CGSize> {
        return Binder.init(self.base, binding: { view, size in
            view.footerReferenceSize = size
        })
    }
}


//MARK: StringRegx
extension String {
    public var fullRange: NSRange {
        return NSRange(location: 0, length: self.count)
    }
    
    public var patternMatched: String {
        let pattern: String = "(next)"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let matched = regex.matches(in: self, options: [], range: self.fullRange)
            for rs in matched {
                return String(NSString(string: self).substring(with: rs.range))
            }
        }
        return ""
    }
}
