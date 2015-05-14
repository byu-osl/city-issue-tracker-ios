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
        if event is GetServiceRequestsArrayEvent
        {
            self.sendRequestsArray()
        }
        
        if event is ServiceRequestsArrayEvent
        {
            var requestsArrayEvent: ServiceRequestsArrayEvent = event as! ServiceRequestsArrayEvent
            self.serviceRequests = requestsArrayEvent.requestsArray
        }
    }
    
    func sendRequestsArray()
    {
        var event: Event = ServiceRequestsArrayEvent(requestsArray: self.serviceRequests)
        self.mediator.postEvent(event)
    }
}




