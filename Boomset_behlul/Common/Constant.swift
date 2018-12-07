//
//  Constant.swift
//  Boomset_behlul
//
//  Created by behlul on 6.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import Foundation
import UIKit

struct UserDefaultsKey {
    static let AUTH_KEY = "AuthKey"
    static let ARCHIVER_ATTENDEES = "archiverAttendeesKey"
}

extension UIStoryboard {
    enum Storyboard: String {
        case events
        
        var filename: String {
            return rawValue.capitalized
        }
    }
}
