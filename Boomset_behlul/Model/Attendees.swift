//
//  Attendees.swift
//  Boomset_behlul
//
//  Created by behlul on 6.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import Foundation

// All proporties not implemented

struct Attendees: Codable {
    let count: Int
    let previous: String?
    let next: String?
    var results: [AttendeesResult]
}

struct AttendeesResult: Codable {
    let id: Int
    let contact: AttendeesContact
    let workInfo: AttendeesWorkInfo
    //let answers: []
    //let checkInInfo: []
    //let transaction: []
    let quantity: Int
    let total: String
    let paid: Int
    let created: String
    let modified: String
    
    enum CodingKeys: String, CodingKey {
        case workInfo = "work_info"
        //case checkinInfo = "checkin_info"
        
        case id
        case contact
        //case answers
        //case transaction
        case quantity
        case total
        case paid
        case created
        case modified
    }
}

struct AttendeesContact: Codable {
    let prefix: String?
    let first_name: String
    let last_name: String
    let email: String
}

struct AttendeesWorkInfo: Codable {
    let website: String?
    let fax: String?
    let title: String?
    let company: String
}
