//
//  FilterViewController.swift
//  Yelp
//
//  Created by Le Thanh Tan on 11/19/15.
//  Copyright © 2015 Le Thanh Tan. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func filtersViewController( filtersViewController: FilterViewController, didUpdateFilters filters: [String], lastSelectedDistance lastSelected: Double)
    
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var delegate: FilterViewControllerDelegate?
    var result : [NSDictionary] = [NSDictionary]();
    
    var switchStates = [Int:Bool]()
    var referenceCell: SwitchCell!
    let distanceArray = [0, 0.3, 1, 5, 20]
    var lastSelected: NSIndexPath?
    var shouldShowAllCategoris = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.fetchCategoriesFromServer()
    }
    
    func fetchCategoriesFromServer() {
           self.result = self.yelpCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell") as! SwitchCell
            cell.label.text = "Offering a Deal"
            cell.swtichs.on = false
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("distanceCell") as! DistanceCell
            cell.accessoryType = .None
            if (indexPath.row == 0) {
                cell.longLabel.text = "Auto"
            } else {
                cell.longLabel.text = "\(self.distanceArray[indexPath.row]) miles"
            }
            return cell
            
        } else if indexPath.section == 2 {
            
            
        } else if indexPath.section == 3 {
            if shouldShowAllCategoris {
                
            } else {
                // show See all
                if (indexPath.row == self.result.count) {
                    print("HERE")
                    let cell = UITableViewCell()
                    cell.textLabel?.text = "See all"
                    cell.textLabel?.textAlignment = .Center
                    return cell
                }
            }

            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell") as! SwitchCell
            print("index : \(indexPath.row) range : \(self.result.count)")
            let title = self.result[indexPath.row].objectForKey("name")
            cell.label.text = "\(title!)"
            cell.swtichs.on = switchStates[indexPath.row] ?? false
            cell.delegate = self
            return cell
            
        }
        let cellReturn = UITableViewCell()
        return cellReturn

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            if self.lastSelected != nil {
                let cell = tableView.cellForRowAtIndexPath(self.lastSelected!)
                cell?.accessoryType = .None
            }
            
            let newCell = tableView.cellForRowAtIndexPath(indexPath)
            newCell?.accessoryType = .Checkmark
            self.lastSelected = indexPath
        } else if (indexPath.section == 3) {
            self.shouldShowAllCategoris = true
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 5
        } else if section == 2 {
            return 1
        } else {
            if shouldShowAllCategoris {
                return self.result.count
            } else {
                return self.result.count + 1
            }

        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 3) {
            if shouldShowAllCategoris {
                return 50
            } else {
                if (indexPath.row == 0 ||
                    indexPath.row == 1 ||
                    indexPath.row == 2 ||
                    indexPath.row == 3 ||
                    indexPath.row == 4 ||
                    indexPath.row == (self.result.count)) {
                        return 50
                } else {
                    return 0.001
                }
            }
        }
        
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title : String = ""
        if section == 0 {
            
        } else if (section == 1) {
            title = "Distance"
        } else if (section == 2) {
            title = "Sort By"
        } else if (section == 3) {
            title = "Category"
        }
        
        return title
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.00001
        }
        
        return 20
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    @IBAction func onCancelClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        var selectedCategories = [String]()
        for (row,isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(self.result[row].objectForKey("code") as! String)
            }
        }
        
        var valueSelected = 0.0
        if lastSelected != nil {
            valueSelected = self.distanceArray[(lastSelected?.row)!]
        }
        
        self.delegate?.filtersViewController(self, didUpdateFilters: selectedCategories, lastSelectedDistance: valueSelected)
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValued value: Bool) {
        let indexPath = self.tableView.indexPathForCell(switchCell)!
        switchStates[indexPath.row] = value
        
        print("Filter view controller \(indexPath)")
    }
    
    func yelpCategories() -> [[String: String]] {
        return [["name" : "Afghan", "code": "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            ["name" : "Arabian", "code": "arabian"],
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Armenian", "code": "armenian"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Asturian", "code": "asturian"],
            ["name" : "Australian", "code": "australian"],
            ["name" : "Austrian", "code": "austrian"],
            ["name" : "Baguettes", "code": "baguettes"],
            ["name" : "Bangladeshi", "code": "bangladeshi"],
            ["name" : "Barbeque", "code": "bbq"],
            ["name" : "Basque", "code": "basque"],
            ["name" : "Bavarian", "code": "bavarian"],
            ["name" : "Beer Garden", "code": "beergarden"],
            ["name" : "Beer Hall", "code": "beerhall"],
            ["name" : "Beisl", "code": "beisl"],
            ["name" : "Belgian", "code": "belgian"],
            ["name" : "Bistros", "code": "bistros"],
            ["name" : "Black Sea", "code": "blacksea"],
            ["name" : "Brasseries", "code": "brasseries"],
            ["name" : "Brazilian", "code": "brazilian"],
            ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name" : "British", "code": "british"],
            ["name" : "Buffets", "code": "buffets"],
            ["name" : "Bulgarian", "code": "bulgarian"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Burmese", "code": "burmese"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Cafeteria", "code": "cafeteria"],
            ["name" : "Cajun/Creole", "code": "cajun"],
            ["name" : "Cambodian", "code": "cambodian"],
            ["name" : "Canadian", "code": "New)"],
            ["name" : "Canteen", "code": "canteen"],
            ["name" : "Caribbean", "code": "caribbean"],
            ["name" : "Catalan", "code": "catalan"],
            ["name" : "Chech", "code": "chech"],
            ["name" : "Cheesesteaks", "code": "cheesesteaks"],
            ["name" : "Chicken Shop", "code": "chickenshop"],
            ["name" : "Chicken Wings", "code": "chicken_wings"],
            ["name" : "Chilean", "code": "chilean"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Comfort Food", "code": "comfortfood"],
            ["name" : "Corsican", "code": "corsican"],
            ["name" : "Creperies", "code": "creperies"],
            ["name" : "Cuban", "code": "cuban"],
            ["name" : "Curry Sausage", "code": "currysausage"],
            ["name" : "Cypriot", "code": "cypriot"],
            ["name" : "Czech", "code": "czech"],
            ["name" : "Czech/Slovakian", "code": "czechslovakian"],
            ["name" : "Danish", "code": "danish"],
            ["name" : "Delis", "code": "delis"],
            ["name" : "Diners", "code": "diners"],
            ["name" : "Dumplings", "code": "dumplings"],
            ["name" : "Eastern European", "code": "eastern_european"],
            ["name" : "Ethiopian", "code": "ethiopian"],
            ["name" : "Fast Food", "code": "hotdogs"],
            ["name" : "Filipino", "code": "filipino"],
            ["name" : "Fish & Chips", "code": "fishnchips"],
            ["name" : "Fondue", "code": "fondue"],
            ["name" : "Food Court", "code": "food_court"],
            ["name" : "Food Stands", "code": "foodstands"],
            ["name" : "French", "code": "french"],
            ["name" : "French Southwest", "code": "sud_ouest"],
            ["name" : "Galician", "code": "galician"],
            ["name" : "Gastropubs", "code": "gastropubs"],
            ["name" : "Georgian", "code": "georgian"],
            ["name" : "German", "code": "german"],
            ["name" : "Giblets", "code": "giblets"],
            ["name" : "Gluten-Free", "code": "gluten_free"],
            ["name" : "Greek", "code": "greek"],
            ["name" : "Halal", "code": "halal"],
            ["name" : "Hawaiian", "code": "hawaiian"],
            ["name" : "Heuriger", "code": "heuriger"],
            ["name" : "Himalayan/Nepalese", "code": "himalayan"],
            ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
            ["name" : "Hot Dogs", "code": "hotdog"],
            ["name" : "Hot Pot", "code": "hotpot"],
            ["name" : "Hungarian", "code": "hungarian"],
            ["name" : "Iberian", "code": "iberian"],
            ["name" : "Indian", "code": "indpak"],
            ["name" : "Indonesian", "code": "indonesian"],
            ["name" : "International", "code": "international"],
            ["name" : "Irish", "code": "irish"],
            ["name" : "Island Pub", "code": "island_pub"],
            ["name" : "Israeli", "code": "israeli"],
            ["name" : "Italian", "code": "italian"],
            ["name" : "Japanese", "code": "japanese"],
            ["name" : "Jewish", "code": "jewish"],
            ["name" : "Kebab", "code": "kebab"],
            ["name" : "Korean", "code": "korean"],
            ["name" : "Kosher", "code": "kosher"],
            ["name" : "Kurdish", "code": "kurdish"],
            ["name" : "Laos", "code": "laos"],
            ["name" : "Laotian", "code": "laotian"],
            ["name" : "Latin American", "code": "latin"],
            ["name" : "Live/Raw Food", "code": "raw_food"],
            ["name" : "Lyonnais", "code": "lyonnais"],
            ["name" : "Malaysian", "code": "malaysian"],
            ["name" : "Meatballs", "code": "meatballs"],
            ["name" : "Mediterranean", "code": "mediterranean"],
            ["name" : "Mexican", "code": "mexican"],
            ["name" : "Middle Eastern", "code": "mideastern"],
            ["name" : "Milk Bars", "code": "milkbars"],
            ["name" : "Modern Australian", "code": "modern_australian"],
            ["name" : "Modern European", "code": "modern_european"],
            ["name" : "Mongolian", "code": "mongolian"],
            ["name" : "Moroccan", "code": "moroccan"],
            ["name" : "New Zealand", "code": "newzealand"],
            ["name" : "Night Food", "code": "nightfood"],
            ["name" : "Norcinerie", "code": "norcinerie"],
            ["name" : "Open Sandwiches", "code": "opensandwiches"],
            ["name" : "Oriental", "code": "oriental"],
            ["name" : "Pakistani", "code": "pakistani"],
            ["name" : "Parent Cafes", "code": "eltern_cafes"],
            ["name" : "Parma", "code": "parma"],
            ["name" : "Persian/Iranian", "code": "persian"],
            ["name" : "Peruvian", "code": "peruvian"],
            ["name" : "Pita", "code": "pita"],
            ["name" : "Pizza", "code": "pizza"],
            ["name" : "Polish", "code": "polish"],
            ["name" : "Portuguese", "code": "portuguese"],
            ["name" : "Potatoes", "code": "potatoes"],
            ["name" : "Poutineries", "code": "poutineries"],
            ["name" : "Pub Food", "code": "pubfood"],
            ["name" : "Rice", "code": "riceshop"],
            ["name" : "Romanian", "code": "romanian"],
            ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
            ["name" : "Rumanian", "code": "rumanian"],
            ["name" : "Russian", "code": "russian"],
            ["name" : "Salad", "code": "salad"],
            ["name" : "Sandwiches", "code": "sandwiches"],
            ["name" : "Scandinavian", "code": "scandinavian"],
            ["name" : "Scottish", "code": "scottish"],
            ["name" : "Seafood", "code": "seafood"],
            ["name" : "Serbo Croatian", "code": "serbocroatian"],
            ["name" : "Signature Cuisine", "code": "signature_cuisine"],
            ["name" : "Singaporean", "code": "singaporean"],
            ["name" : "Slovakian", "code": "slovakian"],
            ["name" : "Soul Food", "code": "soulfood"],
            ["name" : "Soup", "code": "soup"],
            ["name" : "Southern", "code": "southern"],
            ["name" : "Spanish", "code": "spanish"],
            ["name" : "Steakhouses", "code": "steak"],
            ["name" : "Sushi Bars", "code": "sushi"],
            ["name" : "Swabian", "code": "swabian"],
            ["name" : "Swedish", "code": "swedish"],
            ["name" : "Swiss Food", "code": "swissfood"],
            ["name" : "Tabernas", "code": "tabernas"],
            ["name" : "Taiwanese", "code": "taiwanese"],
            ["name" : "Tapas Bars", "code": "tapas"],
            ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name" : "Tex-Mex", "code": "tex-mex"],
            ["name" : "Thai", "code": "thai"],
            ["name" : "Traditional Norwegian", "code": "norwegian"],
            ["name" : "Traditional Swedish", "code": "traditional_swedish"],
            ["name" : "Trattorie", "code": "trattorie"],
            ["name" : "Turkish", "code": "turkish"],
            ["name" : "Ukrainian", "code": "ukrainian"],
            ["name" : "Uzbek", "code": "uzbek"],
            ["name" : "Vegan", "code": "vegan"],
            ["name" : "Vegetarian", "code": "vegetarian"],
            ["name" : "Venison", "code": "venison"],
            ["name" : "Vietnamese", "code": "vietnamese"],
            ["name" : "Wok", "code": "wok"],
            ["name" : "Wraps", "code": "wraps"],
            ["name" : "Yugoslav", "code": "yugoslav"]]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//extension FilterViewController: SwitchCellDelegate {
//}
