//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FilterViewControllerDelegate {

    var businesses: [Business] = []
    var searchData: [Business] = []
    @IBOutlet weak var tableView: UITableView!
    var searchBar : UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        self.navigationItem.titleView = self.searchBar
        
        // loading
        CozyLoadingActivity.show("Loading...", disableUI: true)
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            
            if error != nil {
                print(error)
                CozyLoadingActivity.hide()
                return
                
            }
            self.businesses = businesses
            self.searchData = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
            print(businesses.count)
            self.tableView.reloadData()
            CozyLoadingActivity.hide()
        })
        
//        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
//        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.searchBar .resignFirstResponder()
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCell") as! BusinessCell
        let bussinessCell = searchData[indexPath.row]
        if bussinessCell.imageURL == nil {
            cell.imageView?.image = UIImage.animatedImageNamed("yelp-1", duration: 1)
        } else {
            cell.imageView?.setImageWithURL(bussinessCell.imageURL!)
        }
        cell.titleLabel.text = "\(bussinessCell.name!)"
        cell.ratingImageView.setImageWithURL(bussinessCell.ratingImageURL!)
        cell.reviewLabel.text = "\(bussinessCell.reviewCount!)"
        cell.addressLabel.text = "\(bussinessCell.address!)"
        cell.categoriesLabel.text = "\(bussinessCell.categories!)"
        cell.distanceLabel.text = "\(bussinessCell.distance!)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar)
        
        if (searchText.characters.count > 0) {
            var tmpBusiness : [Business] = []
            for businessElement in self.businesses {
                if (businessElement.name?.rangeOfString(searchText) != nil) {
                    tmpBusiness.append(businessElement)
                }
            }
            
            self.searchData = tmpBusiness
        } else {
            self.searchData = self.businesses
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FilterViewController
        
        // to run filter delegate
        filtersViewController.delegate = self
        
    }
    
    func filtersViewController(filtersViewController: FilterViewController, didUpdateFilters filters: [String], lastSelectedDistance lastSelected: Double) {
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: filters, deals: nil) { (businessResponse :[Business]!, error: NSError!) -> Void in
            if error != nil {
                print(error)
                return
            }
            self.searchBar.text = "";
            self.businesses.removeAll()
            self.searchData.removeAll()
            self.businesses = businessResponse
            self.searchData = businessResponse
            
            for business in businessResponse {
                print(business.name!)
                print(business.address!)
            }
            print(businessResponse.count)
            self.tableView.reloadData()
        }
        
    }

}
