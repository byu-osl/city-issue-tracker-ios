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
        
        // Clear all the custom subviews from the old cell
        var customSubViews = thumbnailImageView.subviews
        for viewToRemove in customSubViews
        {
            viewToRemove.removeFromSuperview()
        }
        
        var houseImage = UIImage(named:"house-on-fire.jpg")
        let houseView = UIImageView(image: houseImage!)
        
        // Put the image inside a circle
        houseView.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        houseView.layer.cornerRadius = 32
        houseView.layer.masksToBounds = true
        
        // Change the selected color
        var bgColorView: UIView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.282, green: 0.278, blue: 0.270, alpha: 1.0)
        bgColorView.layer.masksToBounds = true
        self.selectedBackgroundView = bgColorView
        
        thumbnailImageView.addSubview(houseView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

