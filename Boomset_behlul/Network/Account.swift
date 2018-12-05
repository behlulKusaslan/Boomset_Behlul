//
//  Account.swift
//  Boomset_behlul
//
//  Created by behlul on 5.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import Foundation
import Moya

public enum Account {
    
    static private var authKey = ""
    
    case login(userName: String, password: String)
    
}

extension Account: TargetType {
    
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
        //    return .requestPlain
    }
    
    public var headers: [String : String]? {
        return [
            "Content-Type" : "application/json",
            "Authorization" : "\(Account.authKey)"
        ]
    }
    
}

