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
    var page = 1
    
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
            case .noConnection:
                tableView.isHidden = false
                messageView.isHidden = true
                tableView.reloadData()
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

        print(Reachability.isConnectedToNetwork())
        
        // for test offline data, set state to noConnection
        //state = .noConnection
        
        state = .loading
        if case .loading = state {
            getAttendeesList()
        }
        
    }
    
    // MARK: - Function
    fileprivate func getAttendeesList() {
        eventProvider.request(.attendees(eventId: eventId, page: page)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.handleSuccess(with: response)
            case .failure(let error):
                strongSelf.state = .error(error.localizedDescription)
            }
        }
    }
    
    fileprivate func handleSuccess(with response: Response) {
        do {
            var attendees = try response.map(Attendees.self, failsOnEmptyData: false)
            // get previus attendees and add new attendees
            if case .ready(let oldAttendees) = state {
                var results = oldAttendees.results
                results.append(contentsOf: attendees.results)
                attendees.results = results
            }
            // save results
            KeyedArchiverManager.shared.writeAttendeesResult(attendees.results, for: eventId)
            state = .ready(attendees)
            // update page number if next exist
            if attendees.next != nil {
                page += 1
            }
        } catch {
            state = .error("attendees map error")
        }
    }
    
    fileprivate func fetchkIfMoreDataExist(indexPath: IndexPath, attendees: Attendees) {
        guard indexPath.row == attendees.results.count - 1,
            attendees.count > attendees.results.count else { return }
        getAttendeesList()
    }

}

// MARK: - UITableViewDelegate
extension AttendeesViewController: UITableViewDelegate {
    
}

extension AttendeesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .ready(let attendees):
            return attendees.results.count
        case .noConnection:
            let attendeesResults = KeyedArchiverManager.shared.readAttendeesResult(for: eventId)
            return attendeesResults.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttendeesTableViewCell.identifier) as? AttendeesTableViewCell ?? AttendeesTableViewCell()
        switch state {
        case .ready(let attendees):
            fetchkIfMoreDataExist(indexPath: indexPath, attendees: attendees)
            cell.configureCell(with: attendees.results[indexPath.row])
            return cell
        case .noConnection:
            let attendeesResults = KeyedArchiverManager.shared.readAttendeesResult(for: eventId)
            cell.configureCell(with: attendeesResults[indexPath.row])
            return cell
        default:
            return cell
        }
    }
    
    
}

// MARK: - State
extension AttendeesViewController {
    enum State {
        case loading
        case ready(Attendees)
        case error(String)
        case noConnection
    }
}

// MARK: - Identifiable
extension AttendeesViewController: Identifiable {
    // Sets identifier variable based on class name
}
