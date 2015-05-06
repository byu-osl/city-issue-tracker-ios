//
//  Mediator.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 4/8/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import Foundation

class Mediator: NSObject
{
    var dataModel: DataModel!
    var trackerAPI: TrackerAPI!
    var subscribers: [Subscriber]!
    
    override init()
    {
        self.subscribers = []
        
        super.init()
        
        // create the model and api
        self.trackerAPI = TrackerAPI(newMediator: self)
        self.dataModel = DataModel(newMediator: self)
        
//        self.forceReloadDataFromServer()
        var event: Event = ReloadServiceRequestsFromServerEvent()
        self.postEvent(event)
        
        // start the refresh timer
        var refreshTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector:"refreshTimerCalled", userInfo: nil, repeats: true)
    }
    
    func registerSubscriber(newSubscriber: Subscriber)
    {
        subscribers.append(newSubscriber)
    }
    
    func refreshTimerCalled()
    {
        var event: Event = ReloadServiceRequestsFromServerEvent()
        self.postEvent(event)
    }
    
//    func forceReloadDataFromServer()
//    {
//        /* load and store the newest data */
//        
//        trackerAPI.reloadDataFromServer()
//        var requestsJSON = trackerAPI.getLatestRequestsJSON()
//        dataModel.processRequests(requestsJSON)
//    }
    
//    func getRequests() -> [Request]
//    {
//        return dataModel.getRequests()
//    }
    
    func postEvent(event: Event)
    {
        for s in subscribers
        {
            s.notify(event)
        }
    }
    
//    func notifyOfNewRequests()
//    {
//        self.dataModel.processRequests(trackerAPI.getLatestRequestsJSON())
//        self.notifySubscribers()
//    }
}