//
//  FilterViewController.swift
//  yelp
//
//  Created by Alena Nikitina on 9/21/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func searchWithFilters(message: String)
    func loadData()
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!

    @IBOutlet weak var navBar: UINavigationBar!
    
    var delegate: FilterViewControllerDelegate!
    var service:YelpService!
    var collapsedSectionIndex =
    [
        "Price": false,
        "Most Popular": false,
        "Distance": true,
        "Sort by": true,
        "Categories": true
    ]
    var collapsedCountForCategories = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navBar.sizeThatFits(CGSizeMake(320,100))
        navBar.bounds = CGRectMake(0,0,320,100);

        
        SearchButton.layer.borderWidth = 0.5
        SearchButton.layer.borderColor = UIColor.colorWithRGBHex(0x555555).CGColor
        SearchButton.layer.cornerRadius = 5
        SearchButton.clipsToBounds = true
        
        CancelButton.layer.borderWidth = 0.5
        CancelButton.layer.borderColor = UIColor.colorWithRGBHex(0x555555).CGColor
        CancelButton.layer.cornerRadius = 5
        CancelButton.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        
        setuptableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setuptableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func handleCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    func handleFilterForMostPopular(sender: AnyObject!) -> Void {
        var switchView = sender as UISwitch
        
        let filter = YelpShared.sharedInstace.filters[1]
        var option = filter.options[switchView.tag]
        option.isSelected! = !option.isSelected!
    }
    
    func handleFilterForCategories(sender: AnyObject!) -> Void {
        var switchView = sender as UISwitch
        
        let filter = YelpShared.sharedInstace.filters[4]
        var option = filter.options[switchView.tag]
        option.isSelected! = !option.isSelected!
    }

    @IBAction func handleSearchButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.delegate.searchWithFilters("")
            
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return YelpShared.sharedInstace.filters.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var filter = YelpShared.sharedInstace.filters[section] as Filter
        
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        headerView.backgroundColor = UIColor.colorWithRGBHex(0xF5F5F5)
        
        var label = UILabel(frame: CGRect(x: 0, y: 20, width: 300, height: 15))
        label.font = UIFont(name: label.font.fontName, size: 13)
        label.textColor = UIColor.colorWithRGBHex(0x999999)
        label.text = "\(filter.name)"
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var filter = YelpShared.sharedInstace.filters[section] as Filter
        if (collapsedSectionIndex[filter.name]!) {
            if filter.name == "Categories" {
                return collapsedCountForCategories + 1
            }
            else {
                return 1
            }
        }
        else {
            return filter.options.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")
        cell.textLabel!.font = UIFont.systemFontOfSize(15.0)

        var filter = YelpShared.sharedInstace.filters[indexPath.section] as Filter
        var option = filter.options[indexPath.row]
        
        if filter.name == "Price" {
            let itemsPrice = ["$", "$$", "$$$", "$$$$"]
            let segmentedControl = UISegmentedControl(items: itemsPrice)
            segmentedControl.frame = CGRect(x: 10, y: 10, width: 280, height: 25)
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.tintColor = UIColor.colorWithRGBHex(0xAAAAAA)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.addSubview(segmentedControl)
            
           
        } else if filter.name == "Most Popular" {
            
            cell.textLabel!.text = option.name
            
            var switchView = UISwitch(frame: CGRectZero)

            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryView = switchView
            switchView.tag = indexPath.row
            switchView.on = option.isSelected!
            switchView.addTarget(self, action: "handleFilterForMostPopular:", forControlEvents: UIControlEvents.ValueChanged)
        }
        else if filter.name == "Distance" {
            
            var idx = filter.selectedIndex
            
            if collapsedSectionIndex[filter.name]! {
                cell.textLabel!.text = (filter.options[idx!] as Option).name
            } else {
                if idx == indexPath.row {
                    cell.backgroundColor = UIColor.colorWithRGBHex(0xAAAAAA)
                    cell.textLabel!.textColor = UIColor.whiteColor()
                }
                cell.textLabel!.text = option.name
            }
        }
        else if filter.name == "Sort by" {
            
            var idx = filter.selectedIndex
            
            if collapsedSectionIndex[filter.name]! {
                cell.textLabel!.text = (filter.options[idx!] as Option).name
            }
            else {
                if idx == indexPath.row {
                    cell.backgroundColor = UIColor.colorWithRGBHex(0xAAAAAA)
                    cell.textLabel!.textColor = UIColor.whiteColor()
                }
                cell.textLabel!.text = option.name
            }
        }
        else if filter.name == "Categories" {
            
            if indexPath.row == self.collapsedCountForCategories && self.collapsedSectionIndex[filter.name]! {
                cell.textLabel?.textAlignment = NSTextAlignment.Center
                cell.textLabel?.textColor = UIColor.colorWithRGBHex(0x999999)
                cell.backgroundColor = UIColor.colorWithRGBHex(0xF5F5F5)
                cell.textLabel?.text = "See All"
            }
            else {
                cell.textLabel?.text = option.name
                
                var switchView = UISwitch(frame: CGRectZero)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.accessoryView = switchView
                switchView.tag = indexPath.row
                switchView.on = option.isSelected!
                switchView.addTarget(self, action: "handleFilterForCategories:", forControlEvents: UIControlEvents.ValueChanged)
                
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return YelpShared.sharedInstace.filters[section].name
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var filter = YelpShared.sharedInstace.filters[indexPath.section]
        var indexSet = NSMutableIndexSet(index: indexPath.section)
        
        if filter.name == "Most Popular" {
            
        }
        else if filter.name == "Distance" {
            
            if !collapsedSectionIndex[filter.name]! {
                filter.selectedIndex = indexPath.row
            }
            
            collapsedSectionIndex[filter.name]! = !collapsedSectionIndex[filter.name]!
            tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        else if filter.name == "Sort by" {
            
            if !collapsedSectionIndex[filter.name]! {
                filter.selectedIndex = indexPath.row
            }
            collapsedSectionIndex[filter.name]! = !collapsedSectionIndex[filter.name]!
            tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        else if filter.name == "Categories" {
            
            if indexPath.row == collapsedCountForCategories {
                collapsedSectionIndex[filter.name] = false
                tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            
        }
    }
    
}
