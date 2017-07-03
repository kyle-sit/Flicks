//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Kyle Sit on 1/31/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    //@IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Variables to be used for searching
    var movies: [NSDictionary]?
    var filteredTitles: [NSDictionary]?
    var endpoint: String!
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting delegates and data sources
        movieCollectionView.dataSource = self;
        movieCollectionView.delegate = self;
        searchBar.delegate = self;
        
        //UI specifications for navigation bar
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named: "nav_bar_bg"), for: .default)
            navigationBar.tintColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.gray.withAlphaComponent(1.0)
            shadow.shadowOffset = CGSize(width: 2, height: 2)
            shadow.shadowBlurRadius = 10;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0),
                NSShadowAttributeName : shadow
            ]
        }
        
        // Refresh Symbol when loading
        refresh()
        
        //Pull to refresh animation
        pullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function for loading symbol
    func refresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        movieCollectionView.insertSubview(refreshControl, at: 0)
    }
    
    //requesting data from API
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.movieCollectionView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    //function for pull to refresh animation
    func pullToRefresh() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    
                    self.filteredTitles = self.movies
                    
                    self.movieCollectionView.reloadData()
                }
            }
            //pull to refresh animation close
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()
    }
    
    //function to retrieve number of rows needed
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteredTitles != nil {
            return (filteredTitles?.count)!
        }
        else {
            return 0
        }
    }
    
    //function to populate cells with info
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "movieViewCell", for: indexPath) as! movieCollectionViewCell
        
        let movie = filteredTitles![indexPath.row]
        let title = movie["title"] as! String

        let baseURL = "https://image.tmdb.org/t/p/w500"
    
        if let posterPath = movie["poster_path"] as? String {
            let imageURL = NSURL(string: baseURL + posterPath)
            cell.posterView.setImageWith(imageURL! as URL)
        }
            
        cell.titleLabel?.text = title
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    //function for deselecting a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTitles = searchText.isEmpty ? movies : movies!.filter {
            ($0["title"]! as AnyObject).contains(searchText)
        }
        
        movieCollectionView.reloadData()
    }
    
    //function to start searchbar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    //function to quit searchbar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    //Segue to detail controlloer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = movieCollectionView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }
    
}
