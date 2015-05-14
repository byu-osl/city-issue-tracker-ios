//
//  User.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/5/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import Foundation

class User: NSObject
{
    var email: NSString = ""
    var firstName: NSString = ""
    var lastName: NSString = ""
    var phone: NSString = ""
    
    var isLoggedIn: Bool
    
    override init()
    {
        self.isLoggedIn = false
    }
}











