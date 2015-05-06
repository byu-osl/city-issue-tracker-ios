//
//  AppModel.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 3/10/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import Foundation
import UIKit

// This file is the model in MVC

class DataModel: NSObject, Subscriber{
    
    var mediator: Mediator
    var serviceRequests: [ServiceRequest]
    
    init(newMediator: Mediator)
    {
        self.mediator = newMediator
        self.serviceRequests = []
        super.init()
        self.mediator.registerSubscriber(self)
    }
    
    // Subscriber protocol function
    func notify(event: Event)
    {
        if event is ServiceRequestsJSONEvent
        {
            var requestsJSONEvent = event as! ServiceRequestsJSONEvent // downcast
            var requestsJSON: JSON = requestsJSONEvent.requestsJSON
            self.processRequestsJSON(requestsJSON) // send the JSON
            self.sendRequestsArray()
        }
        
        if event is GetServiceRequestsArrayEvent
        {
            self.sendRequestsArray()
        }
    }
    
    func sendRequestsArray()
    {
        var event: Event = ServiceRequestsArrayEvent(requestsArray: self.serviceRequests)
        self.mediator.postEvent(event)
    }
    
    func processRequestsJSON(requestsJSON: JSON)
    {
        for var x=0; x<requestsJSON.count; x++
        {
            let requestData = requestsJSON[x]
            self.createNewRequest(requestData)
        }
    }
    
    func createNewRequest(requestData: JSON)
    {
        // Required info
        var newServiceRequest = ServiceRequest()
        newServiceRequest.serviceID = requestData["_id"].string!
        newServiceRequest.status = requestData["status"].string!
        newServiceRequest.requestedDatetime = requestData["requested_datetime"].string!
        newServiceRequest.serviceCode = requestData["service_code"].string!
        newServiceRequest.v = requestData["__v"].intValue
        
        // Optional info
        if let addressString: String = requestData["address_string"].string
        {
            newServiceRequest.addressString = addressString
        }
        
        if let long: String = requestData["long"].string
        {
            newServiceRequest.long = long
        }
        
        if let lat: String = requestData["lat"].string
        {
            newServiceRequest.lat = lat
        }
        
        if let addressString: String = requestData["long"].string
        {
            newServiceRequest.addressString = addressString
        }
        
        if let serviceDescription: String = requestData["description"].string
        {
            newServiceRequest.serviceDescription = serviceDescription
        }
        
        var foundDupe : Bool = false
        for r in self.serviceRequests
        {
            if r.serviceID == newServiceRequest.serviceID
            {
                foundDupe = true
            }
        }
        
        if !foundDupe
        {
            self.serviceRequests.append(newServiceRequest)
        }
    }
}




