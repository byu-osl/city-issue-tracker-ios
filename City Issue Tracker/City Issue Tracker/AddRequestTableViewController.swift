//
//  AddRequestTableViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/4/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit
import MapKit

class AddServiceRequestTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, Subscriber {
    
//    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var serviceCodeCollectionView: UICollectionView!
    @IBOutlet weak var requestDescriptionTextView: UITextView!
    @IBOutlet weak var mapImageView: UIImageView!
//    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var mediator: Mediator
    
    // To autodetect user locations
    var locationManager: CLLocationManager
//    var mapLocation: CLLocation
    let mapLocation = CLLocation(latitude: 40.25, longitude: -111.65)
    var mapRegion: MKCoordinateRegion
    var userSelectedAutoDetect: Bool
    var selectedCodeCell: ServiceCodeCollectionViewCell?
    
    // For keyboard event when calculating an address
    var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    var photoFromCamera: UIImage?
    
    var potholeServiceCode: NSString = "POTH"
    
    required init(coder aDecoder: NSCoder!)
    {
        self.mediator = appDelegate.mediator
        self.locationManager = CLLocationManager()
        self.userSelectedAutoDetect = false
        
        // set up the map
        self.mapRegion = MKCoordinateRegion(center: self.mapLocation.coordinate, span: MKCoordinateSpanMake(0.1, 0.1))
        
        super.init(coder: aDecoder)
        self.mediator.registerSubscriber(self)
        
        // connect the keyboardHidden function
        notificationCenter.addObserver(self, selector: "keyboardHidden", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color of the nav bar title
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.647, green: 0.643, blue: 0.631, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        // remove the underline color of the nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        serviceCodeCollectionView.delegate = self
        serviceCodeCollectionView.dataSource = self

        self.photo.image = self.photoFromCamera
        
        // position
        locationManager.requestWhenInUseAuthorization()
        
        self.takeSnapshotOfMap()
    }
    
    // called when the user dismisses the keyboard
    func keyboardHidden()
    {
        self.updateSnapshotLocation()
    }
    
    @IBAction func updateButtonPressed(sender: UIButton) {
        self.updateSnapshotLocation()
    }
    
    func updateSnapshotLocation()
    {
        var geoCoder: CLGeocoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.addressTextView.text, completionHandler: geocodeAddressCompleted())
    }
    
    func geocodeAddressCompleted()(placemarks: [AnyObject]!, error: NSError!)
    {
        if placemarks.count > 0
        {
            var placemark: MKPlacemark = MKPlacemark(placemark: CLPlacemark(placemark: placemarks[0] as! CLPlacemark))
            self.mapRegion = MKCoordinateRegion(center: placemark.coordinate, span: self.mapRegion.span)
            
            self.takeSnapshotOfMap()
        }
    }
    
    // Take a pic and update the map
    func takeSnapshotOfMap()
    {
        var snapshotterOptions = MKMapSnapshotOptions()
        snapshotterOptions.region = self.mapRegion
        snapshotterOptions.scale = UIScreen.mainScreen().scale
        snapshotterOptions.size = CGRect(x: 0, y: 0, width: 375, height: 375).size
        
        var snapshotter = MKMapSnapshotter(options: snapshotterOptions)
        
        snapshotter.startWithCompletionHandler(){
            snapshot, error in
            self.mapImageView.image = snapshot.image
        }
    }
    
    func getAddressFromSelection()
    {
        var geoCoder: CLGeocoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self.mapLocation, completionHandler: reverseGeocodeCompleted())
    }
    
    // Completion Handler for reverseGeocodeLocation
    func reverseGeocodeCompleted()(placemarks: [AnyObject]!, error: NSError!)
    {
        if placemarks.count > 0
        {
            var placemark: CLPlacemark = CLPlacemark(placemark: placemarks[0] as! CLPlacemark)
            self.addressTextView.text = String(format:"%@ %@\n%@, %@ %@",
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.postalCode)
        }
    }
    
    // Check if the user has authorized their location usage
    func checkLocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // If going to the map
        if segue.destinationViewController is UINavigationController
        {
            var destNavCont: UINavigationController = segue.destinationViewController as! UINavigationController
            if destNavCont.topViewController is MapViewController
            {
                var destVC: MapViewController = destNavCont.topViewController as! MapViewController
                destVC.mapRegion = self.mapRegion
            }
        }
        
        // If going to the Home page
        if segue.destinationViewController is HomeViewController
        {
            if sender is UIButton
            {
                var senderButton: UIButton = sender as! UIButton
                
                // if we want to submit an issue report before exiting
                if senderButton == self.submitButton
                {
                    self.createNewServiceRequest()
                    return
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! ServiceCodeCollectionViewCell

        cell.serviceCodeLabel.text = "Pothole"

        cell.contentView.layer.cornerRadius = 10.0;
        cell.contentView.layer.masksToBounds = true;


        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        // deselect the previous cell
        if (selectedCodeCell != nil)
        {
            selectedCodeCell?.serviceCodeLabel.backgroundColor = UIColor(red: 0.64705, green: 0.64313, blue: 0.63137, alpha: 1.0)
        }
        
        var cell: ServiceCodeCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! ServiceCodeCollectionViewCell
        // set the color to selected
        cell.serviceCodeLabel.backgroundColor = UIColor(red: 0.811, green: 0.627, blue: 0.384, alpha: 1.0)
        selectedCodeCell = cell
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func getSelectedServiceCode() -> NSString
    {
        return "POTH"
    }
    
    func createNewServiceRequest()
    {
        // store the request
        var newServiceRequest: ServiceRequest = ServiceRequest()
        
        newServiceRequest.serviceDescription = requestDescriptionTextView.text
        newServiceRequest.serviceCode = getSelectedServiceCode()
        newServiceRequest.addressString = self.addressTextView.text!
        newServiceRequest.photo = self.photo.image!
        
        var event: SaveServiceRequestEvent = SaveServiceRequestEvent(serviceRequest: newServiceRequest)
        self.mediator.postEvent(event)
    }
    
    @IBAction func unwindToAddRequest(segue: UIStoryboardSegue)
    {
        self.getAddressFromSelection()
        self.takeSnapshotOfMap()
    }
    
    func notify(event: Event)
    {
        //
    }
}










