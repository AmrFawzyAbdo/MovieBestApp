//
//  TopRated.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/9/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation

struct TopRated: Codable {
    let page : Int?
    let total_pages : Int?
    let results : [Results]?
}

struct Results: Codable {
    let id: Int?
    let vote_average: Float?
    let title: String?
    let poster_path: String?
    let release_date: String?
}
