//
//  Account.swift
//  Boomset_behlul
//
//  Created by behlul on 5.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import Foundation
import Moya

public enum AccountTarget {
    
    static var authKey: String {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.AUTH_KEY) ?? ""
    }
    
    case login(userName: String, password: String)
    
}

extension AccountTarget: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://www.boomset.com")!
    }
    
    public var path: String {
        switch self {
        case .login: return "/apps/api/auth"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login: return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .login(let userName, let password):
            return .requestParameters(parameters: ["username": userName, "password": password], encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-Type" : "application/json",
            "Authorization" : AccountTarget.authKey == "" ? "" : "Token \(AccountTarget.authKey)"
        ]
    }
    
}

