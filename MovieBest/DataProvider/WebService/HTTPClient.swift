//
//  HTTPClient.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/9/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation
import Alamofire


class HTTPClient {
    
    func generateToken(using url: URL, Success: @escaping (_ object: Token)-> Void, Error: @escaping (_ error: String)-> Void){
        
        Alamofire.request(url).responseJSON { response in
            do{
                let JSON = try JSONDecoder().decode(Token.self, from: response.data!)
                Success(JSON)
            }catch{
                Error(error.localizedDescription)
            }
        }
    }
    
    
    func login(using url: URL,_ parametars: [String:Any],_ header: [String:String], Success: @escaping (_ success: Login)-> Void, Error: @escaping (_ error: String)-> Void){
        
        Alamofire.request(url, method: .post, parameters: parametars, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            
            do{
                let JSON = try JSONDecoder().decode(Login.self, from: response.data!)
                if let token = JSON.request_token{
                    UserDefaults.standard.set(token, forKey: "Token")
                }
                Success(JSON)
            }catch{
                Error(error.localizedDescription)
            }
        }
    }
    
    
}

