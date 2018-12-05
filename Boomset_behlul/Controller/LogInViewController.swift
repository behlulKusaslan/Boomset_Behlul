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
    
    // MARK:- IBOutlet
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    fileprivate let accountProvider = MoyaProvider<Account>()

    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test request
        accountProvider.request(.login(userName: "testaccount@boomset.com", password: "Boomsettest123")) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    print(try response.mapJSON())
                    //let token = try response.map(LoginResponse<Loginresult>.self).data.token
                    let loginresult = try response.map(Loginresult.self)
                    print(loginresult)
                } catch {
                    print("response map error")
                }
            case .failure(let error):
                print("Login error \(error.errorDescription ?? "")")
            }
        }
    }
    
    // MARK:- IBAction
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        
    }


}

