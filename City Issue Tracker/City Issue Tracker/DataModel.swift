//
//  AppModel.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 3/10/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import Foundation
import UIKit

// This is the "model" in MVC

class DataModel: NSObject, Subscriber{
    
    var mediator: Mediator
    var serviceRequests: [ServiceRequest]
    var userDefaults: NSUserDefaults
    
    init(newMediator: Mediator)
    {
        self.mediator = newMediator
        self.serviceRequests = []
        
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        super.init()
        self.mediator.registerSubscriber(self)
    }
    
    func sendRequestsArray()
    {
        var event: Event = ServiceRequestsArrayEvent(requestsArray: self.serviceRequests)
        self.mediator.postEvent(event)
    }

    
    // get all the preferences and send them out in an event
    func sendUserPreferences()
    {
        var email: String? = self.userDefaults.stringForKey("Email")
        var name: String? = self.userDefaults.stringForKey("Name")
        var phone: String? = self.userDefaults.stringForKey("Phone")
        
        // if the values are nil, set to ""
        if email != nil{}
        else{
            email = ""
        }
        
        if name != nil{}
        else{
            name = ""
        }
        
        if phone != nil{}
        else{
            phone = ""
        }
        
        var event: UserPreferencesEvent = UserPreferencesEvent(email: email!, name: name!, phone: phone!)
        self.mediator.postEvent(event)
    }
    
    func saveUserPreferences(event: SaveUserPreferencesEvent)
    {
        self.userDefaults.setObject(event.email, forKey: "Email")
        self.userDefaults.setObject(event.name, forKey: "Name")
        self.userDefaults.setObject(event.phone, forKey: "Phone")
    }
    
    // Subscriber protocol function
    func notify(event: Event)
    {
        if event is GetServiceRequestsArrayEvent
        {
            self.sendRequestsArray()
        }
        
        if event is ServiceRequestsArrayEvent
        {
            var requestsArrayEvent: ServiceRequestsArrayEvent = event as! ServiceRequestsArrayEvent
            self.serviceRequests = requestsArrayEvent.requestsArray
        }
        if event is SaveUserPreferencesEvent
        {
            // store it
            var upEvent: SaveUserPreferencesEvent = event as! SaveUserPreferencesEvent
            self.saveUserPreferences(upEvent)
        }
        if event is GetUserPreferencesEvent
        {
            self.sendUserPreferences()
        }
    }
}




