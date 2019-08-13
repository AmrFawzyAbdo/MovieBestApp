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
    
    // Generate Token
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
    
    
    // Login function
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
    
    
    var results:[Results]? = []
    // Top rated movies function
    func topRated(_ page: Int = 1, Success: @escaping (_ object: TopRated, _ totalPages: Int)-> Void, Error: @escaping (_ error: String)-> Void){
        let url = URL(string: URLs.topRated + String(page))
        
        Alamofire.request(url!).responseJSON { response in
            
            do{
                let JSON = try JSONDecoder().decode(TopRated.self, from: response.data!)
                var totalPages = Int()
                if let total = JSON.total_pages{
                    totalPages = total
                    UserDefaults.standard.set(response.data!, forKey: "Go")
                }
                Success(JSON, totalPages)
            }catch{
                Error(error.localizedDescription)
            }
        }
    }
    
    
    // Details of each selected movie function
    func movieDetails(using url: URL, Success: @escaping (_ object: MovieDetail)-> Void, Error: @escaping (_ error: String)-> Void){
        Alamofire.request(url).responseJSON { response in
            do{
                let JSON = try JSONDecoder().decode(MovieDetail.self, from: response.data!)
                Success(JSON)
            }catch{
                Error(error.localizedDescription)
            }
        }
    }
    
    
    // Session creation
    func createSession(using url: URL,_ parametars: [String:Any],_ header:[String:String], Success: @escaping (_ object: Session)-> Void, Error: @escaping (_ error: String)-> Void){
        
        Alamofire.request(url, method: .post, parameters: parametars, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            
            do{
                let JSON = try JSONDecoder().decode(Session.self, from: response.data!)
                Success(JSON)
            }catch{
                Error(error.localizedDescription)
            }
        }
    }
    
    
    // Getting profile details
    func getProfileDetails(using url: URL, Success: @escaping (_ object: Profile)-> Void, Error: @escaping (_ error: String)-> Void){
        
        Alamofire.request(url).responseJSON { response in
            
            do{
                let JSON = try JSONDecoder().decode(Profile.self, from: response.data!)
                Success(JSON)
            }catch{
                Error(error.localizedDescription)
            }
        }
    }
    
    
}

