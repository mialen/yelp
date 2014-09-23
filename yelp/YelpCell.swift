//
//  YelpCell.swift
//  yelp
//
//  Created by Alena Nikitina on 9/18/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

class YelpCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tmbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCntLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //tmbImageView.layer.borderColor = UIColor.whiteColor()
        
        //tmbImageView.layer.borderWidth = 3.0
        tmbImageView.layer.cornerRadius = 5
        tmbImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
