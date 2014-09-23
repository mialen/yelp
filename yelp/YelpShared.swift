//
//  YelpShared.swift
//  yelp
//
//  Created by Alena Nikitina on 9/21/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import Foundation

class YelpShared {
    var filters =
    [
        Filter(name: "Price", options:
            [
                Option(name: "$$$", value: "", isSelected: false)
            ]
        ),
        Filter(name: "Most Popular", options:
            [
                Option(name: "Open Now", value: "", isSelected: false),
                Option(name: "Hot & New", value: "", isSelected: false),
                Option(name: "Offering a Deal", value: "", isSelected: false),
                Option(name: "Delivery", value: "", isSelected: false)
            ]
        ),
        Filter(name: "Distance", options:
            [
                Option(name: "Auto",        value: "40000"),
                Option(name: "0.3 miles",   value: "482.803"),
                Option(name: "1 mile",      value: "1609.34"),
                Option(name: "5 miles",     value: "8046.72"),
                Option(name: "20 miles",    value: "32186.9")
            ],
            selectedIndex: 0
        ),
        Filter(name: "Sort by", options:
            [
                Option(name: "Best Match",  value: "0"),
                Option(name: "Distance",    value: "1"),
                Option(name: "Rating",      value: "2")
            ],
            selectedIndex: 0
        ),
        Filter(name: "Categories", options:
            [
                Option(name: "American (New)",          value: "newamerican",       isSelected: false),
                Option(name: "Chinese",                 value: "chinese",           isSelected: false),
                Option(name: "Cuban",                   value: "cuban",             isSelected: false),
                Option(name: "French",                  value: "french",            isSelected: false),
                Option(name: "German",                  value: "german",            isSelected: false),
                Option(name: "Greek",                   value: "greek",             isSelected: false),
                Option(name: "Indian",                  value: "indpak",            isSelected: false),
                Option(name: "Italian",                 value: "italian",           isSelected: false),
                Option(name: "Japanese",                value: "japanese",          isSelected: false),
                Option(name: "Russian",                 value: "russian",           isSelected: false),
                Option(name: "Seafood",                 value: "seafood",           isSelected: false),
                Option(name: "Vegetarian",              value: "vegetarian",        isSelected: false),
                Option(name: "Vietnamese",              value: "vietnamese",        isSelected: false)
            ]
        )
    ]
    
    func getSearchParamsWithTerm(term: String? = "Restaurants") -> [String: String] {
        var params = Dictionary<String, String>()
        params["term"] = term!
        params["limit"] = "20"
        params["offset"] = "0"
        params["sort"] = filters[3].options[filters[3].selectedIndex!].value
        params["radius_filter"] = filters[2].options[filters[2].selectedIndex!].value
        params["location"] = "San Jose"
        params["cli"] = "37.400428,-121.925681"
        
        if filters[1].options[1].isSelected! {
            params["deals_filter"] = "1"
        } else {
            params["deals_filter"] = "0"
        }
        
        var selectedCategories = Array<String>()
        for option in filters[4].options {
            if option.isSelected! {
                selectedCategories.append(option.value)
            }
        }
        params["category_filter"] = ",".join(selectedCategories)
        return params
    }
    
    class var sharedInstace: YelpShared {
    struct Static {
        static let instance: YelpShared = YelpShared()
        }
        return Static.instance
    }
    
    
}
class Option {
    var name = ""
    var value = ""
    var isSelected: Bool?
    
    init(name: String, value: String, isSelected: Bool? = false) {
        self.name = name
        self.value = value
        self.isSelected = isSelected
    }
}

class Filter {
    var name = ""
    var options = Array<Option>()
    var selectedIndex: Int?
    
    init(name: String, options: [Option], selectedIndex: Int? = 0) {
        self.name = name
        self.options = options
        self.selectedIndex = selectedIndex
    }
}
