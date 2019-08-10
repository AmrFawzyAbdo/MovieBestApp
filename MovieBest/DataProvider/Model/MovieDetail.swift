//
//  MovieDetail.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/10/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation

struct MovieDetail: Codable {
    let backdrop_path: String?
    let overview: String?
    let poster_path: String?
    let release_date: String?
    let status: String?
    let vote_average: Float?
}
