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
        
        
        // Clear CollectionView background
        self.topRatedCollection.backgroundColor = UIColor.clear
        self.topRatedCollection.backgroundView = View.init(frame: CGRect.zero)
        
        //Set view background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "21.jpg")!)
    }

    
    // Handling refresh
    @objc private func handleRefresh(){
        if Connectivity.isConnectedToInternet{
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

//                UserDefaults.standard.setValue(self.results, forKey: "Go")

            }) { error in
                
            }
        }else{
            
            if let data = UserDefaults.standard.object(forKey: "Go") as? Data{
                let JSON = try? JSONDecoder().decode(TopRated.self, from: data)
                self.results = JSON!.results
            }
            self.topRatedCollection.reloadData()
            
            // Alert message
            let alert = UIAlertController(title: "Error", message: "Can't fetich images , check your internet connection", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // Loading more cells , Pageing
    fileprivate func loadMore(){
        if Connectivity.isConnectedToInternet{
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
        }else{
            // Toast Alert
            showAlert(backgroundColor: .red, textColor: .white, message: "Can't load more , check your connection")
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
        
        if Connectivity.isConnectedToInternet{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
            vc.movieID = results![indexPath.row].id
            vc.movieTitle = results![indexPath.row].title
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            showAlert(backgroundColor: .darkGray, textColor: .white, message: "Check , your internet connection")
        }
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


extension UIViewController {
    
    func showAlert(backgroundColor:UIColor, textColor:UIColor, message:String)
    {
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = UIFont(name: "", size: 15)
        label.adjustsFontSizeToFitWidth = true
        
        label.backgroundColor =  backgroundColor //UIColor.whiteColor()
        label.textColor = textColor //TEXT COLOR
        
        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        label.frame = CGRect(x: appDelegate.window!.frame.size.width, y: 64, width: appDelegate.window!.frame.size.width, height: 44)
        
        label.alpha = 1
        
        appDelegate.window!.addSubview(label)
        
        var basketTopFrame: CGRect = label.frame;
        basketTopFrame.origin.x = 0;
        
        UIView.animate(withDuration
            :2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                label.frame = basketTopFrame
        },  completion: {
            (value: Bool) in
            UIView.animate(withDuration:2.0, delay: 2.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                label.alpha = 0
            },  completion: {
                (value: Bool) in
                label.removeFromSuperview()
            })
        })
    }
}

