//
//  CodableResponses.swift
//  Boomset_behlul
//
//  Created by behlul on 5.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import Foundation

struct LoginResponse<T: Codable>: Codable {
    let data: T
}
