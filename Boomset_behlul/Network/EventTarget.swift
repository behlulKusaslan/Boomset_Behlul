//
//  EventTarget.swift
//  Boomset_behlul
//
//  Created by behlul on 6.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import Foundation
import Moya

public enum EventTarget {
    
    static var authKey: String {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.AUTH_KEY) ?? ""
    }
    
    case listEvents
    
}

extension EventTarget: TargetType {
    public var baseURL: URL {
        return URL(string: "https://www.boomset.com")!
    }
    
    public var path: String {
        switch self {
        case .listEvents: return "/apps/api/events"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .listEvents: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .listEvents: return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-Type" : "application/json",
            "Authorization" : AccountTarget.authKey == "" ? "" : "Token \(AccountTarget.authKey)"
        ]
    }
    
    
}
