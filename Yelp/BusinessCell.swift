//
//  BusinessCell.swift
//  Yelp
//
//  Created by Le Thanh Tan on 11/18/15.
//  Copyright © 2015 Le Thanh Tan. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
