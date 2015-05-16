//
//  Events.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/5/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import Foundation

protocol Event {}

///// General Network Events /////
class UserLoginSuccessfulEvent: Event
{
    /* Created after a successful app login */
    init(){}
}

class ReloadServiceRequestsFromServerEvent: Event
{
    /* Created to tell the API to reload data */
    init(){}
}

///// User Preferences Events /////
class UserPreferencesEvent: Event
{
    /* Created so the DataModel saves the user preferences */
    var email: NSString
    var name: NSString
    var phone: NSString
    
    init(email: NSString, name: NSString, phone: NSString)
    {
        self.email = email
        self.name = name
        self.phone = phone
    }
}

class SaveUserPreferencesEvent: Event
{
    /* Created so the DataModel saves the user preferences */
    var email: NSString
    var name: NSString
    var phone: NSString
    
    init(email: NSString, name: NSString, phone: NSString)
    {
        self.email = email
        self.name = name
        self.phone = phone
    }
}

class GetUserPreferencesEvent: Event
{
    /* Created when a subscriber wants the User Preferences */
}

///// Service Requests Events /////
class ServiceRequestsArrayEvent: Event
{
    /* Created to deliver the requests array */
    var requestsArray: [ServiceRequest]
    
    init(requestsArray: [ServiceRequest])
    {
        self.requestsArray = requestsArray
    }
}

class SaveServiceRequestEvent: Event
{
    /* Created to deliver a new request to the server */
    var serviceRequest: ServiceRequest
    init(serviceRequest: ServiceRequest)
    {
        self.serviceRequest = serviceRequest
    }
}

class GetServiceRequestsArrayEvent: Event
{
    /* Created when a subscriber wants the requests array */
    init(){}
}




