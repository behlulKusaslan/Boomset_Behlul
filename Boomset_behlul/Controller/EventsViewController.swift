//
//  EventsViewController.swift
//  Boomset_behlul
//
//  Created by behlul on 6.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import UIKit
import Moya

class EventsViewController: UIViewController {

    let eventProvider = MoyaProvider<EventTarget>()
    
    // MARK: - View State
    private var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                break
            case .ready:
                break
            case .error:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventProvider.request(.listEvents) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
                    print(try response.filterSuccessfulStatusCodes().mapJSON())
                    print(try response.mapJSON())
                    let event = try response.map(Event.self, failsOnEmptyData: false)
                    debugPrint(event)
                } catch {
                    print("response map error")
                }
            case .failure(let error):
                strongSelf.state = .error(error.errorDescription ?? "")
            }
        }
        
    }

}

// MARK: - Identifiable
extension EventsViewController: Identifiable {
    
}

extension EventsViewController {
    enum State {
        case loading
        case ready([Event])
        case error(String)
    }
}
