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
    case attendees(eventId: Int, page: Int)
    
}

extension EventTarget: TargetType {
    public var baseURL: URL {
        return URL(string: "https://www.boomset.com")!
    }
    
    public var path: String {
        switch self {
        case .listEvents: return "/apps/api/events"
        case .attendees(let eventId,_): return "/apps/api/events/\(eventId)/attendees"
        //case .attendees(let eventId, let page): return "/apps/api/events/\(eventId)/attendees"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .listEvents, .attendees(_,_): return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .listEvents: return .requestPlain
        // TODO: test this later
        case .attendees(_, let page): return  .requestParameters(parameters: ["page" : page], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-Type" : "application/json",
            "Authorization" : AccountTarget.authKey == "" ? "" : "Token \(AccountTarget.authKey)"
        ]
    }
    
    
}
