//
//  AddRequestTableViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/4/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit

class AddServiceRequestTableViewController: UITableViewController, Subscriber {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var requestPhoto: UIImageView!
    @IBOutlet weak var requestDescriptionTextView: UITextView!
    @IBOutlet weak var requestServiceCodeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addressTextField: UITextField!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var mediator: Mediator
    
    var potholeServiceCode: NSString = "POTH"
    
    required init(coder aDecoder: NSCoder!)
    {
        self.mediator = appDelegate.mediator
        super.init(coder: aDecoder)
        self.mediator.registerSubscriber(self)
    }
    
    func notify(event: Event)
    {
    }
    
    @IBAction func unwindToAddRequest(segue: UIStoryboardSegue)
    {
        var takePhotoViewController: TakePhotoViewController = segue.sourceViewController as! TakePhotoViewController
        
        if takePhotoViewController.photoSaved
        {
            self.requestPhoto.image = takePhotoViewController.photoToSave
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        
        if sender is UIBarButtonItem
        {
            var senderButton: UIBarButtonItem = sender as! UIBarButtonItem
            
            if senderButton == self.saveButton
            {
                self.createNewServiceRequest()
                return
            }
        }
    }
    
    func getSelectedServiceCode() -> NSString
    {
        var index: Int = requestServiceCodeSegmentedControl.selectedSegmentIndex
        var serviceCode: NSString = ""
        
        if index == 0
        {
            serviceCode = potholeServiceCode
        }
        
        return serviceCode
    }
    
    func createNewServiceRequest()
    {
        // store the request
        var newServiceRequest: ServiceRequest = ServiceRequest()
        
        newServiceRequest.serviceDescription = requestDescriptionTextView.text
        newServiceRequest.serviceCode = getSelectedServiceCode()
        newServiceRequest.addressString = self.addressTextField.text
        newServiceRequest.photo = self.requestPhoto.image!
        
        var event: SaveServiceRequestEvent = SaveServiceRequestEvent(serviceRequest: newServiceRequest)
        self.mediator.postEvent(event)
    }
}










