//
//  Events.swift
//  Boomset_behlul
//
//  Created by behlul on 6.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import Foundation

struct Events: Codable {
    let count: Int
    let results: [EventResult]
}

struct EventResult: Codable {
    let id: Int
    let group: Group
    let name: String
    let startsat: String
    let endsat: String
    let timezone: Int
    let premium: Bool
    let created: String
    let modified: String
}

struct Group: Codable {
    let id: Int
    let name: String
    let email: String?
    let phone: String?
    let website: String?
    let fbpage: String?
    let twitter: String?
    let googleplus: String?
}


