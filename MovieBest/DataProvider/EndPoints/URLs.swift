//
//  URLs.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/9/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation

struct URLs {
    
    static let API_KEY = "59d12757221e54ee4d053292b69101bd"
    
    static let baseURL = "https://api.themoviedb.org/3/"
    
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
    
    static let generate_Token = URLs.baseURL + "authentication/token/new?api_key=" + URLs.API_KEY
    
    static let loginURL = URLs.baseURL + "authentication/token/validate_with_login?api_key=" + URLs.API_KEY
    
    static let topRated = URLs.baseURL + "movie/top_rated?api_key=" + URLs.API_KEY + "&language=en-US&page="
    
    static let ImageURL = URLs.baseImageURL
    
    static let movieDetails = URLs.baseURL + "movie/"
    
    static let movieDetailsSec = "?api_key=" + URLs.API_KEY + "&language=en-US"
    
    static let sessionURL = URLs.baseURL + "authentication/session/new?api_key=" + URLs.API_KEY
    
    static let profileURL = URLs.baseURL + "account?api_key=" + URLs.API_KEY + "&session_id="
    
    static let profileImageURL = "https://secure.gravatar.com/avatar/"
    
}
