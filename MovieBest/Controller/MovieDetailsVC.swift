//
//  MovieDetailsVC.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/10/19.
//  Copyright © 2019 Amr fawzy. All rights reserved
//

import UIKit

class MovieDetailsVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var releaseLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var overViewLbl: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    var movieID: Int!
    var movieTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movieTitle
        // Do any additional setup after loading the view.
        getDetails()
        
        self.view.backgroundColor = UIColor.black
    }
    
    
    // Getting details
    private func getDetails(){
        let connection = HTTPClient()
        connection.movieDetails(using: URL(string: URLs.movieDetails + String(movieID) + URLs.movieDetailsSec)!, Success: { object in
            self.setData(object)
        }) { error in
            print(error)
        }
    }
    
    
    // Setting data
    private func setData(_ object: MovieDetail){
        self.dateLbl.text = "Date : \(object.release_date ?? "")"
        self.rateLbl.text = "Rate : \(String((object.vote_average!)))"
        self.releaseLbl.text = object.status
        self.txtView.text = object.overview
        self.backImage.setImage(from: URL(string: URLs.ImageURL + object.backdrop_path!)!, "placeholder", .fade(0.5))
        self.frontImage.kf.indicatorType = .activity
        self.frontImage.setImage(from: URL(string: URLs.ImageURL + object.poster_path!)!, "placeholder", .flipFromTop(0.5))
        
    }
}
