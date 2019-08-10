//
//  ProfileVC.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/10/19.
//  Copyright © 2019 Amr fawzy. All rights reserved
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileDetails()
//        createSession()
        // Do any additional setup after loading the view.
    }
    
    private func getProfileDetails(/*object: Session*/){
        let connection = HTTPClient()
        let sessionID = UserDefaults.standard.object(forKey: "SessionID") as! String
        let url = URLs.profileURL + sessionID
        connection.getProfileDetails(using: URL(string: url)!, Success: { (object) in
            self.nameLbl.text = object.name
            self.usernameLbl.text = "@" + object.username!
            self.image.setImage(from: URL(string: URLs.profileImageURL + (object.avatar?.gravatar?.hash)! + ".jpg?s=64")!, "placeholder", .fade(0.5))
        }) { error in
            print(error)
        }
    }
    
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "Token")
        UserDefaults.standard.removeObject(forKey: "SessionID")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(vc, animated: true, completion: nil)
    }


}
