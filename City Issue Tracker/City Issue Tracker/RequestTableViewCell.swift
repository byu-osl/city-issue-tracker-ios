//
//  RequestTableViewCell.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/2/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        var contentSubViews = thumbnailImageView.subviews
        
        for viewToRemove in contentSubViews
        {
            viewToRemove.removeFromSuperview()
        }
        
        
        var houseImage = UIImage(named:"house-on-fire.jpg")
        let houseView = UIImageView(image: houseImage!)
        
        houseView.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        thumbnailImageView.addSubview(houseView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

