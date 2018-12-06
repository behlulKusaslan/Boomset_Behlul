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

        // get events list
        eventProvider.request(.listEvents) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
                    let events = try response.map(Events.self, failsOnEmptyData: false)
                    strongSelf.state = .ready(events)
                } catch {
                    print("response map error")
                }
            case .failure(let error):
                strongSelf.state = .error(error.errorDescription ?? "")
            }
        }
        
    }

}

// MARK: - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Go to attendees view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

// MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let events) = state else { return 0 }
        return events.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.identifier) as? EventsTableViewCell ?? EventsTableViewCell()
        guard case .ready(let events) = state else { return cell }
        cell.configureCell(with: events.results[indexPath.row])
        return cell
    }
    
    
}

// MARK: - Identifiable
extension EventsViewController: Identifiable {
    
}

// MARK: - State
extension EventsViewController {
    enum State {
        case loading
        case ready(Events)
        case error(String)
    }
}
