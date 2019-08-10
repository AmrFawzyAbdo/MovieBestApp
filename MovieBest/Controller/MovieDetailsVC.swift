//
//  MovieDetailsVC.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/10/19.
//  Copyright © 2019 Amr fawzy. All rights reserved
//

import UIKit

class MovieDetailsVC: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var releaseLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var overViewLbl: UILabel!
    var movieID: Int!
    var movieTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movieTitle
        // Do any additional setup after loading the view.
        getDetails()
    }
    

    private func getDetails(){
        let connection = HTTPClient()
        connection.movieDetails(using: URL(string: URLs.movieDetails + String(movieID) + URLs.movieDetailsSec)!, Success: { object in
            self.setData(object)
        }) { error in
            print(error)
        }
    }
    
    private func setData(_ object: MovieDetail){
        self.dateLbl.text = object.release_date
        self.rateLbl.text = String((object.vote_average!))
        self.releaseLbl.text = object.status
        self.overViewLbl.text = object.overview
        self.backImage.setImage(from: URL(string: URLs.ImageURL + object.backdrop_path!)!, "placeholder", .fade(0.5))
        self.frontImage.kf.indicatorType = .activity
        self.frontImage.setImage(from: URL(string: URLs.ImageURL + object.poster_path!)!, "placeholder", .flipFromTop(0.5))
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
