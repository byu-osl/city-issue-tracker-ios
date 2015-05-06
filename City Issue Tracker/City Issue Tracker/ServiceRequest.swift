//
//  Request.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 3/16/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import Foundation
import UIKit

class ServiceRequest: NSObject
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
    
    override init()
    {
        self.photo = UIImage()
    }
    
//    func setServiceID(serviceID: NSString)
//    {
//        self.serviceID = serviceID
//    }
//    
//    func setStatus(status: String)
//    {
//        self.status = status
//    }
//    
//    func setRequestedDatatime(requestedDatatime: String)
//    {
//        self.requestedDatetime = requestedDatatime
//    }
//    
//    func setLong(long: String)
//    {
//        self.long = long
//    }
//    
//    func setLat(lat: String)
//    {
//        self.lat = lat
//    }
//    
//    func setV(v: Int)
//    {
//        self.v = v
//    }
//    
//    func setServiceCode(serviceCode: String)
//    {
//        self.serviceCode = serviceCode
//    }
//    
//    func setDescription(description: String)
//    {
//        self.description = description
//    }
//    
//    func setAddressString(addressString: String)
//    {
//        self.addressString = addressString
//    }
}













