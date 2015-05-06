//
//  Events.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/5/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import Foundation

protocol Event {}

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

class GetServiceRequestsJSONEvent: Event
{
    /* Created when a subscriber wants the requestsJSON */
    init(){}
}

class ServiceRequestsJSONEvent: Event
{
    /* Created to deliver the requestsJSON data */
    var requestsJSON: JSON
    
    init(requestsJSON: JSON)
    {
        self.requestsJSON = requestsJSON
    }
}

class GetServiceRequestsArrayEvent: Event
{
    /* Created when a subscriber wants the requests array */
    init(){}
}

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




