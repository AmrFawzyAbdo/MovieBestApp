//
//  Connectivity.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/12/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation
import Foundation


import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
