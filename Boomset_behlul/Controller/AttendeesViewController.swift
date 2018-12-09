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
                noConnectionView.isHidden = true
                searchBar.isHidden = true
                tableviewBottomConstraint.constant = 0
            case .ready:
                tableView.isHidden = false
                messageView.isHidden = true
                noConnectionView.isHidden = true
                tableviewBottomConstraint.constant = 0
                searchBar.isHidden = false
                tableView.reloadData()
            case .error:
                tableView.isHidden = true
                messageView.isHidden = false
                messageImage.image = UIImage(named: "error_panda")
                messageLabel.text = NSLocalizedString("EventsViewController_error_message", comment: "")
                noConnectionView.isHidden = true
                searchBar.isHidden = true
                tableviewBottomConstraint.constant = 0
            case .noConnection:
                tableView.isHidden = false
                messageView.isHidden = true
                noConnectionView.isHidden = false
                tableviewBottomConstraint.constant = 35
                searchBar.isHidden = false
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var messageView: UIView!
    @IBOutlet weak fileprivate var messageLabel: UILabel!
    @IBOutlet weak fileprivate var messageImage: UIImageView!
    @IBOutlet weak fileprivate var noConnectionView: UIView!
    @IBOutlet weak fileprivate var searchBar: UISearchBar!
    
    // LayoutConstraints
    @IBOutlet weak private var tableviewBottomConstraint: NSLayoutConstraint!
    
    // Proporties
    var isSearching = false
    var searachedAttendees = [AttendeesResult]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if Reachability.isConnectedToNetwork() {
            state = .loading
            getAttendeesList()
        } else {
            state = .noConnection
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissKeyboard()
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

    fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - UITableViewDelegate
extension AttendeesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension AttendeesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .ready(let attendees):
            return isSearching ? searachedAttendees.count : attendees.results.count
        case .noConnection:
            let attendeesResults = KeyedArchiverManager.shared.readAttendeesResult(for: eventId)
            debugPrint(attendeesResults)
            return isSearching ? searachedAttendees.count : attendeesResults.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttendeesTableViewCell.identifier) as? AttendeesTableViewCell ?? AttendeesTableViewCell()
        switch state {
        case .ready(let attendees):
            var attendeesToShow = attendees
            if isSearching {
                attendeesToShow.results = searachedAttendees
            }
            fetchkIfMoreDataExist(indexPath: indexPath, attendees: attendeesToShow)
            cell.configureCell(with: attendeesToShow.results[indexPath.row])
            return cell
        case .noConnection:
            var attendeesToShow = KeyedArchiverManager.shared.readAttendeesResult(for: eventId)
            if isSearching {
                attendeesToShow = searachedAttendees
            }
            cell.configureCell(with: attendeesToShow[indexPath.row])
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

// MARK: - UISearchBarDelegate
extension AttendeesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = false
        guard searchText.count > 3 else { return }
        isSearching = true
        let text = searchText.lowercased()
        switch state {
        case .ready(let attendees):
            searachedAttendees = attendees.results.filter {
                $0.contact.first_name.lowercased().contains(text) || $0.contact.last_name.lowercased().contains(text)
            }
        case .noConnection:
            let offlineResults = KeyedArchiverManager.shared.readAttendeesResult(for: eventId)
            searachedAttendees = offlineResults.filter {
                $0.contact.first_name.lowercased().contains(text) || $0.contact.last_name.lowercased().contains(text)
            }
        default:
            print("do nothing in this state")
        }
        tableView.reloadData()
    }
    
}
