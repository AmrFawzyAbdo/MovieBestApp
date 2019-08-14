//
//  LoginVC.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/9/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var sampleImageView: UIImageView!
    
    //Vars
    var connection: HTTPClient!
    var token: Token!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting background image of this view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "0.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // Login button action
    @IBAction func loginBtn(_ sender: Any) {
        if Connectivity.isConnectedToInternet{
            self.connection = HTTPClient()
            let url = URL(string: URLs.generate_Token)
            connection.generateToken(using: url!, Success: { token in
                self.token = token
                //            self.loginOL.isEnabled = true
                print(token)
                guard let username = self.usernameTF.text else {return}
                guard let password = self.passwordTF.text else {return}
                
                
                let url = URL(string: URLs.loginURL)
                let headers = ["content-type": "application/json"]
                let parameters = [
                    "username": username,
                    "password": password,
                    "request_token": token.request_token ?? ""
                ]
                
                self.connection.login(using: url!, parameters as [String : Any], headers, Success: { success in
                    if let _ = success.success{
                        self.setSessionID()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "TabBar")
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        print("Can't login")
                        let alert = UIAlertController(title: "Error", message: "Invalid username OR password", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
                        }
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                })
                { error in
                    
                }
                
            }) { error in
                print(error)
            }
            
        }else{
            
            let alert = UIAlertController(title: "Oops",message: "No internet ,Check data or WIFI connection",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings",style: UIAlertAction.Style.default,handler: self.openSettings))
            alert.addAction(UIAlertAction(title: "Cancel",style: UIAlertAction.Style.default,handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // Open settings function
    func openSettings(alert: UIAlertAction!) {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    // Setting session ID
    func setSessionID(){
        let headers = ["content-type": "application/json"]
        let parameters = ["request_token": UserDefaults.standard.object(forKey: "Token")]
        
        connection.createSession(using: URL(string: URLs.sessionURL)!, parameters as [String : Any], headers, Success: { (object) in
            print("sessionID \(object.session_id ?? "")")
            UserDefaults.standard.set(object.session_id, forKey: "SessionID")
        }) { error in
            print(error)
        }
    }
}
