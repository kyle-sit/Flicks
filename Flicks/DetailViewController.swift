//
//  DetailViewController.swift
//  Flicks
//
//  Created by Kyle Sit on 2/9/17.
//  Copyright © 2017 Kyle Sit. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

        let title = movie["title"] as! String
        titleLabel.text = title
        
        let overview = movie["overview"] as! String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        //let baseURL = "https://image.tmdb.org/t/p/w500"
        
        var smallImageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w45")!)
        var largeImageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/original")!)
        
        if let posterPath = movie["poster_path"] as? String {
        //let posterPath = movie["poster_path"] as? String
            smallImageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w45" + posterPath)!)
            largeImageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/original" + posterPath)!)
        }

        //let smallImageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w45")!)
        //let largeImageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/original")!)
        
        self.posterImage.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                self.posterImage.alpha = 0.0
                self.posterImage.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    self.posterImage.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    self.posterImage.setImageWith(
                        largeImageRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.posterImage.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
