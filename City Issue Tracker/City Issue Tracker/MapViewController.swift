//
//  MapViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/7/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var locationManager: CLLocationManager
//    var mapLocation: CLLocation?
    var mapRegion: MKCoordinateRegion?
    
    required init(coder aDecoder: NSCoder)
    {
        self.locationManager = CLLocationManager()
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color of the nav bar title
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.647, green: 0.643, blue: 0.631, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        // Remove the underline color of the nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Set initial location
        self.loadMap()
        
//        checkLocationAuthorizationStatus()
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.destinationViewController is AddServiceRequestTableViewController
        {
            var destVC: AddServiceRequestTableViewController = segue.destinationViewController as! AddServiceRequestTableViewController
            
            var senderButton: UIBarButtonItem = sender as! UIBarButtonItem
            
            if senderButton == self.saveButton
            {
//                var mapCentLat = mapView.centerCoordinate.latitude
//                var mapCentLong =  mapView.centerCoordinate.longitude
//                destVC.mapLocation = CLLocation(latitude: mapCentLat, longitude: mapCentLong)
                destVC.mapRegion = mapView.region
            }
        }
    }
    
    func checkLocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func loadMap() {
        mapView.region = self.mapRegion!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
