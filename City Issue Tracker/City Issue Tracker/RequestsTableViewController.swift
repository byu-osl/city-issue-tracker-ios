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
    }
    
    @IBAction func unwindToList(seque: UIStoryboardSegue)
    {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.destinationViewController is EditServiceRequestTableViewController
        {
            var selectedServiceRequest: ServiceRequest = self.serviceRequests[self.selectedCellIndex]
            
            let destVC = segue.destinationViewController as! EditServiceRequestTableViewController
            destVC.serviceRequest = selectedServiceRequest
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
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
        
        cell.titleLabel.text = serviceRequests[indexPath.row].serviceID as? String
        cell.descriptionLabel.text = serviceRequests[indexPath.row].serviceDescription as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedCellIndex = indexPath.row // track which cell is selected
    }
}