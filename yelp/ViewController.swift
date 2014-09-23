//
//  ViewController.swift
//  yelp
//
//  Created by Alena Nikitina on 9/16/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, FilterViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yelpSearchBar: UISearchBar!
    @IBOutlet weak var filterLabel: UIButton!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    var service:YelpService!
    var businesses: [NSDictionary] = []
    var term: String = "Restaurants"
    var isSearchWithTerm = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor.colorWithRGBHex(0xFFFFFF)
        
        navigationItem.titleView = yelpSearchBar
        yelpSearchBar.text = term
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        
        filterLabel.layer.borderWidth = 0.5
        filterLabel.layer.borderColor = UIColor.colorWithRGBHex(0x555555).CGColor
        filterLabel.layer.cornerRadius = 5
        filterLabel.clipsToBounds = true
        UIStatusBarStyle.LightContent
        
        loadData()
        
    }
    
    func loadData(){
        tableView.hidden = true
        activityInd.startAnimating()
        
        
        let kYelpConsumerKey = "OAjC66qHopIBJbayOd2MGg";
        let kYelpConsumerSecret = "6xMUjiSP2E3q0-36df89OnpwHNQ";
        let kYelpToken = "WMgWqn77mbZdL42lGQtO4k1xYrdnBScP";
        let kYelpTokenSecret = "7Cr0-J1MqKdiLBbnypsBHWeFies";
        var searchParams = Dictionary<String, String>()
        
        if(isSearchWithTerm){
            searchParams["term"] = term
        } else {
            searchParams = YelpShared.sharedInstace.getSearchParamsWithTerm(term: term)
        }
        
        
        
        service = YelpService(consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret, accessToken: kYelpToken, accessSecret: kYelpTokenSecret)
        
        service.searchWithTerm(searchParams, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var object = response as NSDictionary
                self.businesses = object["businesses"] as [NSDictionary]
                self.tableView.updateConstraints()
                self.tableView.reloadData()
                self.activityInd.stopAnimating()
                self.tableView.hidden = false
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func searchWithFilters(message: String) {
        isSearchWithTerm = false
        yelpSearchBar.text = "Restaurants"
        loadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        yelpSearchBar.resignFirstResponder()
        yelpSearchBar.text = term
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        yelpSearchBar.resignFirstResponder()
        
        if yelpSearchBar.text != term {
            term = yelpSearchBar.text
            businesses = []
            isSearchWithTerm = true
            loadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("YelpCell") as YelpCell
        var business = businesses[indexPath.row]

        var tmbImage = business["image_url"] as String
        cell.tmbImageView.setImageWithURL(NSURL(string: tmbImage))
        
        var businessName = business["name"] as? String
        cell.nameLabel.text = "\(indexPath.row + 1). \(businessName!)"
        
        var ratingImage = business["rating_img_url"] as String
        cell.ratingImageView.setImageWithURL(NSURL(string: ratingImage))
        
        var reviewCnt = business["review_count"] as Int
        cell.reviewCntLabel.text = "\(reviewCnt) reviews"
        
        var location = business["location"] as NSDictionary
        var address = location["address"] as [String]
        var city = location["city"] as String
        cell.addressLabel.text = "\(address) \(city)"
        
        var categories = business["categories"] as [NSArray]
        cell.categoriesLabel.text = ", ".join(categories.map({ $0[0] as String}))
        if(business["distance"] != nil) {
            cell.distanceLabel.text = business["distance"] as? String
        } else {
            cell.distanceLabel.text = "0.8mi"
        }
        
        cell.priceLabel.text = "$$"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "yelpSeque") {
            
            var controller = segue.destinationViewController as FilterViewController
                controller.delegate = self
            
        }
        
    }

}

