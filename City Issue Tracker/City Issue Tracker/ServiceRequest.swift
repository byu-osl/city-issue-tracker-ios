//
//  Request.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 3/16/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ServiceRequest: NSObject, MKAnnotation
{
    var serviceID: NSString = ""
    var status: NSString = ""
    var requestedDatetime: NSString = ""
    var long: NSString = ""
    var lat: NSString = ""
    var v: Int = 0
    var serviceCode: NSString = "" // POTH
    var serviceDescription: NSString = ""
    var addressString: NSString = ""
    
    var photo: UIImage
    
    // MapKit elements
    var title: String
    var coordinate: CLLocationCoordinate2D
    
    override init()
    {
        self.photo = UIImage()
        self.title = ""
        self.coordinate = CLLocationCoordinate2D() // empty coord
    }
}













