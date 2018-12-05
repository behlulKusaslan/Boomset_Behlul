//
//  BaseViewController.swift
//  Boomset_behlul
//
//  Created by behlul on 6.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import UIKit

protocol Identifiable: class {
    static var identifier: String { get }
}

extension Identifiable where Self: NSObject {
    static var identifier: String {
        return String(describing: self)
    }
}
