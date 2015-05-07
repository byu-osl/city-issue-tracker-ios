//
//  AddRequestTableViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/4/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit
import MapKit

class AddServiceRequestTableViewController: UITableViewController,  Subscriber {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var requestPhoto: UIImageView!
    @IBOutlet weak var requestDescriptionTextView: UITextView!
    @IBOutlet weak var requestServiceCodeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addressTextField: UITextField!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var mediator: Mediator
    
    // To autodetect user locations
    var locationManager = CLLocationManager()
    
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
        if segue.sourceViewController is TakePhotoViewController
        {
            var takePhotoViewController: TakePhotoViewController = segue.sourceViewController as! TakePhotoViewController
            
            if takePhotoViewController.photoSaved
            {
                self.requestPhoto.image = takePhotoViewController.photoToSave
            }
        }
        
        if segue.sourceViewController is MapViewController
        {
            var mapViewController: MapViewController = segue.sourceViewController as! MapViewController
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
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func autoDetectPressed(sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.description
    }
    
    // Check if the user has authorized their location usage
    func checkLocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse
        {
            locationManager.requestWhenInUseAuthorization()
        }
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










