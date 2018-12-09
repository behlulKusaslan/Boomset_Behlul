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
                noConnectionView.isHidden = true
                tableviewBottomConstraint.constant = 0
            case .ready:
                tableView.isHidden = false
                messageView.isHidden = true
                noConnectionView.isHidden = true
                tableviewBottomConstraint.constant = 0
                tableView.reloadData()
            case .error:
                tableView.isHidden = true
                messageView.isHidden = false
                messageImage.image = UIImage(named: "error_panda")
                messageLabel.text = NSLocalizedString("EventsViewController_error_message", comment: "")
                noConnectionView.isHidden = true
                tableviewBottomConstraint.constant = 0
            case .noConnection:
                tableView.isHidden = false
                messageView.isHidden = true
                noConnectionView.isHidden = false
                tableviewBottomConstraint.constant = 35
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var messageView: UIView!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var messageImage: UIImageView!
    @IBOutlet weak fileprivate var noConnectionView: UIView!
    
    // LayoutConstraints
    @IBOutlet weak private var tableviewBottomConstraint: NSLayoutConstraint!

    
    // Proprties
    fileprivate var offlineEvents: [EventResult]?
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            state = .loading
            getEventsList()
        } else {
            offlineEvents = KeyedArchiverManager.shared.readEvents()
            state = .noConnection
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Function
    fileprivate func getEventsList() {
        eventProvider.request(.listEvents) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
                    var events = try response.map(Events.self, failsOnEmptyData: false)
                    // save events
                    let eventsResult = events.results.sorted { $0.modified < $1.modified }
                    events.results = eventsResult
                    KeyedArchiverManager.shared.writeEventResults(events)
                    strongSelf.state = .ready(events)
                } catch {
                    print("response map error")
                }
            case .failure(let error):
                strongSelf.state = .error(error.errorDescription ?? "")
            }
        }
    }
    
    fileprivate func goToAttendeesViewController(with eventId: Int) {
        let storyboardName = UIStoryboard.Storyboard.events.filename
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: AttendeesViewController.identifier) as? AttendeesViewController {
            destinationViewController.eventId = eventId
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        print("Log Out")
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.AUTH_KEY)
        KeyedArchiverManager.shared.deleteAll()
        navigationController?.popToRootViewController(animated: true)
    }

}

// MARK: - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch state {
        case .ready(let events):
            let eventId = events.results[indexPath.row].id
            goToAttendeesViewController(with: eventId)
        case .noConnection:
            guard let offlineEvents = offlineEvents else { return }
            let eventId = offlineEvents[indexPath.row].id
            goToAttendeesViewController(with: eventId)
        default:
            print("do nothing")
        }
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
        switch state {
        case .ready(let events):
            return events.results.count
        case .noConnection:
            guard let offlineEvents = offlineEvents else { return 0 }
            return offlineEvents.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.identifier) as? EventsTableViewCell ?? EventsTableViewCell()
        switch state {
        case .ready(let events):
            cell.configureCell(with: events.results[indexPath.row])
            return cell
        case .noConnection:
            guard let offlineEvents = offlineEvents else { return cell }
            cell.configureCell(with: offlineEvents[indexPath.row])
            return cell
        default:
            return cell
        }
    }
    
}

// MARK: - Identifiable
extension EventsViewController: Identifiable {
    // Sets identifier variable based on class name
}

// MARK: - State
extension EventsViewController {
    enum State {
        case loading
        case ready(Events)
        case error(String)
        case noConnection
    }
}
