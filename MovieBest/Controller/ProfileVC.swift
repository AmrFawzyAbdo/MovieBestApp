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
            
            UserDefaults.standard.set(object.name, forKey: "Name")
            UserDefaults.standard.set(object.username, forKey: "Username")
            let delay = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                let imageData = self.image.image!.pngData()
                UserDefaults.standard.set(imageData, forKey: "Image")
            })
            
        }) { error in
            
            if let _ = UserDefaults.standard.object(forKey: "Username"){
                self.nameLbl.text = UserDefaults.standard.object(forKey: "Name") as? String
                self.usernameLbl.text = "@\(UserDefaults.standard.object(forKey: "Username") as! String)"
                let imageData = UserDefaults.standard.object(forKey: "Image")
                self.image.image = UIImage(data: imageData as! Data)
            }
            print(error)

        }
    }
    
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        
        
        UserDefaults.standard.removeObject(forKey: "Token")
        UserDefaults.standard.removeObject(forKey: "SessionID")
        UserDefaults.standard.removeObject(forKey: "Username")
        UserDefaults.standard.removeObject(forKey: "Name")
        UserDefaults.standard.removeObject(forKey: "Image")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(vc, animated: true, completion: nil)
    }


}
