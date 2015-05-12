//
//  RequestsTableViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/1/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit

class RequestsTableViewController: UITableViewController, Subscriber {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var mediator: Mediator
    var selectedCellIndex: Int
    
    var serviceRequests: [ServiceRequest]!

    required init(coder aDecoder: NSCoder!)
    {
        self.mediator = appDelegate.mediator
        self.selectedCellIndex = 0
        super.init(coder: aDecoder)
        self.mediator.registerSubscriber(self)
    }
    
    func notify(event: Event)
    {
        if event is ServiceRequestsArrayEvent
        {
            var requestsArrayEvent: ServiceRequestsArrayEvent = event as! ServiceRequestsArrayEvent
            self.serviceRequests = requestsArrayEvent.requestsArray
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color of the nav bar title
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.647, green: 0.643, blue: 0.631, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        // remove the underline color of the nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Get some fresh data
        self.refreshServiceRequests()
    }
    
    
    // We want fresh data!
    func refreshServiceRequests()
    {
        var event: GetServiceRequestsArrayEvent = GetServiceRequestsArrayEvent()
        self.mediator.postEvent(event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (serviceRequests != nil)
        {
            return serviceRequests.count
        }
        return 0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCell", forIndexPath: indexPath) as! RequestTableViewCell
        
        cell.titleLabel.text = serviceRequests[indexPath.row].serviceCode as? String
        cell.titleLabel.text = "Pothole"
        cell.descriptionLabel.text = serviceRequests[indexPath.row].serviceDescription as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedCellIndex = indexPath.row // track which cell is selected
    }
}
