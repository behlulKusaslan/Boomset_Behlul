//
//  ViewController.swift
//  Boomset_behlul
//
//  Created by behlul on 5.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import UIKit
import Moya

class LogInViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    fileprivate let accountProvider = MoyaProvider<AccountTarget>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fill textFields
        userNameTextField.text = "testaccount@boomset.com"
        passwordTextField.text = "Boomsettest123"
    }
    
    // MARK: - Functions
    fileprivate func logIn(userName: String, password: String) {
        accountProvider.request(.login(userName: userName, password: password)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let loginresult = try response.map(Loginresult.self)
                    // Save token
                    UserDefaults.standard.set(loginresult.token, forKey: UserDefaultsKey.AUTH_KEY)
                    print(AccountTarget.authKey)
                    strongSelf.goToEventsViewController()
                } catch {
                    print("response map error")
                }
            case .failure(let error):
                print("Login error \(error.errorDescription ?? "")")
            }
        }
    }
    
    fileprivate func goToEventsViewController() {
        let storyboardName = UIStoryboard.Storyboard.events.filename
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: EventsViewController.identifier) as? EventsViewController {
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    // MARK: - IBAction
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard let userName = userNameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        logIn(userName: userName, password: password)
    }
}

