//
//  AppAPI.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import Moya

enum AppAPI {
	case userSearch(userName: String, page: Int)
}


enum AppAPIError: Error {
	case message
}

extension AppAPI: TargetType {
	var baseURL: URL {
		guard let url = URL(string: "https://api.github.com") else { fatalError("Bad URL Acceptor") }
		switch self {
		case .userSearch:
			return url
		}
	}
	
	var path: String {
		switch self {
		case .userSearch:
			return "/search/users"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .userSearch:
			return .get
		}
	}
	
	var sampleData: Data {
		return "Data".data(using: String.Encoding.utf8)!
	}
	
	var task: Task {
		guard let parameters = parameters else { return .requestPlain }
		switch self {
		case .userSearch:
			return .requestParameters(parameters: parameters, encoding: parameterEncoding)
		}
	}
	
	var parameters: [String: Any]? {
		switch self {
		case let .userSearch(userName: userName, page: page):
			return ["q": userName, "page": page]
		}
	}
	
	var parameterEncoding: ParameterEncoding {
		return URLEncoding.queryString
	}
	
	var headers: [String : String]? {
		return ["Authorization": "token \(CoifigProperties.authKey)"]
	}
}


extension AppAPIError: CustomStringConvertible {
	var description: String {
		return "네트워크 연결을 실패하였습니다.\n다시 시도해 주세요."
	}
}
