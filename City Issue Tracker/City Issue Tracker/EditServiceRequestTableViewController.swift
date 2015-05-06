//
//  EditServiceRequestTableViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/6/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit

class EditServiceRequestTableViewController: UITableViewController, Subscriber {
    
    @IBOutlet weak var serviceRequestTypeLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var serviceDescriptionTextView: UITextView!
    @IBOutlet weak var addressTextView: UITextView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var mediator: Mediator
    
    var serviceRequest: ServiceRequest
    
    required init(coder aDecoder: NSCoder!)
    {
        self.serviceRequest = ServiceRequest() // create an empty one... possible issues here!
        self.mediator = appDelegate.mediator
        super.init(coder: aDecoder)
        self.mediator.registerSubscriber(self)
    }
    
    func notify(event: Event)
    {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.serviceRequestTypeLabel.text = self.serviceRequest.serviceCode as String
        self.serviceDescriptionTextView.text = self.serviceRequest.serviceDescription as String
        self.addressTextView.text = self.serviceRequest.addressString as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
