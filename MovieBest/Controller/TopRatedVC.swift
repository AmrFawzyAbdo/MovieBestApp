//
//  TopRatedVC.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/9/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import UIKit
import Kingfisher

class TopRatedVC: UIViewController {

    //Outlets
    @IBOutlet weak var topRatedCollection: UICollectionView!
    //Var
    private let identifier = "TopRatedCell"
    private var results: [Results]? = []
    lazy var refresher : UIRefreshControl = { () -> UIRefreshControl in
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return ref
}()
    private var connection: HTTPClient!
    private var isloading = false
    private var currentPage = 1
    private var lastPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topRatedCollection.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        self.topRatedCollection.dataSource = self
        self.topRatedCollection.delegate = self
        DispatchQueue.global(qos: .background).async {
            self.handleRefresh()
        }
        topRatedCollection.addSubview(refresher)
    }
    
    @objc private func handleRefresh(){
        
    DispatchQueue.main.async {
    self.refresher.endRefreshing()
    }
    self.connection = HTTPClient()
    guard !isloading else {return}
    isloading = true
    connection.topRated(Success: { object, totalPages in
        self.results = object.results
        self.isloading = false
        self.topRatedCollection.reloadData()
        self.currentPage = 1
        self.lastPage = totalPages
            
        }) { error in
            print(error)
    }
}
    
    fileprivate func loadMore(){
        
        guard !isloading else {return}
        guard currentPage < lastPage else {return}
        isloading = true
        connection.topRated(currentPage + 1, Success: { (object, totalPages) in
            for data in object.results!{
                self.results?.append(data)
            }
            self.isloading = false
            self.topRatedCollection.reloadData()
            self.currentPage += 1
            self.lastPage = totalPages
            
        }) { error in
            print(error)
        }
    }


}


extension TopRatedVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.results!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TopRatedCell
        cell.titleLbl.text = results![indexPath.row].title
        cell.dateLbl.text = results![indexPath.row].release_date
        cell.avarageLbl.text = String(results![indexPath.row].vote_average!)
        cell.image.kf.indicatorType = .activity
        cell.image.setImage(from: URL(string: URLs.ImageURL + results![indexPath.row].poster_path!)!, "placeholder", .flipFromTop(0.5))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
        vc.movieID = results![indexPath.row].id
        vc.movieTitle = results![indexPath.row].title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TopRatedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (UIScreen.main.bounds.width - 30)/2
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let count = self.results?.count
        if indexPath.row == count!-1{
            //load more
            self.loadMore()
        }
    }
}
