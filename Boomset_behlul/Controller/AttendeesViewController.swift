//
//  AttendeesViewController.swift
//  Boomset_behlul
//
//  Created by behlul on 6.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import UIKit
import Moya

class AttendeesViewController: UIViewController {
    
    var eventId: Int!
    
    let eventProvider = MoyaProvider<EventTarget>()
    
    // MARK: - View State
    private var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                tableView.isHidden = true
                messageView.isHidden = false
                messageImage.image = UIImage(named: "loading_panda")
                messageLabel.text = NSLocalizedString("EventsViewController_loading_message", comment: "")
            case .ready:
                tableView.isHidden = false
                messageView.isHidden = true
                tableView.reloadData()
            case .error:
                tableView.isHidden = true
                messageView.isHidden = false
                messageImage.image = UIImage(named: "error_panda")
                messageLabel.text = NSLocalizedString("EventsViewController_error_message", comment: "")
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var messageView: UIView!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var messageImage: UIImageView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        state = .loading
        
        eventProvider.request(.attendees(eventId: eventId, page: 2)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                debugPrint(response.request)
                do {
                    debugPrint(try response.mapJSON())
                    let attendees = try response.map(Attendees.self, failsOnEmptyData: false)
                    debugPrint(attendees)
                } catch {
                    strongSelf.state = .error("attendees map error")
                }
            case .failure(let error):
                strongSelf.state = .error(error.localizedDescription)
            }
        }
        
    }

}

// MARK: - UITableViewDelegate
extension AttendeesViewController: UITableViewDelegate {
    
}

extension AttendeesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

// MARK: - State
extension AttendeesViewController {
    enum State {
        case loading
        case ready(Events) // TODO: change into attendees
        case error(String)
    }
}

// MARK: - Identifiable
extension AttendeesViewController: Identifiable {
    // Sets identifier variable based on class name
}
