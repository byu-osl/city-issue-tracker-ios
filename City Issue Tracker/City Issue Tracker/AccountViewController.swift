//
//  AccountViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/13/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, Subscriber {

    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var mediator: Mediator
    var serviceRequests: [ServiceRequest]!
    
    var userEmail: NSString?
    var userName: NSString?
    var userPhone: NSString?
    
    var STATIC_CELL_COUNT: Int = 4
    
    required init(coder aDecoder: NSCoder)
    {
        self.mediator = appDelegate.mediator
        
        super.init(coder: aDecoder)
        self.mediator.registerSubscriber(self)
        self.requestUserPreferences()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Set the color of the nav bar title
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.647, green: 0.643, blue: 0.631, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        // remove the underline color of the nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Get some fresh data
        self.refreshServiceRequests()
    }
    
    func requestUserPreferences()
    {
        var event: GetUserPreferencesEvent = GetUserPreferencesEvent()
        self.mediator.postEvent(event)
    }
    
    func updateUserPreferences(event: UserPreferencesEvent)
    {
        self.userEmail = event.email
        self.userName = event.name
        self.userPhone = event.phone
    }
    
    func saveUserPreferences()
    {
        var event: SaveUserPreferencesEvent = SaveUserPreferencesEvent(email: self.userEmail!, name: self.userName!, phone: self.userPhone!)
        self.mediator.postEvent(event)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return self.STATIC_CELL_COUNT
        }
        if section == 1
        {
            if (serviceRequests != nil)
            {
                return serviceRequests.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell", forIndexPath: indexPath) as! UserInfoTableViewCell
                
                cell.titleLabel.text = "Name"
                cell.userInfoTextField.text = self.userName as! String
                cell.userInfoTextField.delegate = self
                cell.userInfoTextField.cellIndex = indexPath.row
                
                return cell
            }
            if indexPath.row == 1
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell", forIndexPath: indexPath) as! UserInfoTableViewCell
                
                cell.titleLabel.text = "Email"
                cell.userInfoTextField.text = self.userEmail as! String
                cell.userInfoTextField.delegate = self
                cell.userInfoTextField.cellIndex = indexPath.row
                
                return cell
            }
            if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell", forIndexPath: indexPath) as! UserInfoTableViewCell
                
                cell.titleLabel.text = "Phone"
                cell.userInfoTextField.text = self.userPhone as! String
                cell.userInfoTextField.delegate = self
                cell.userInfoTextField.cellIndex = indexPath.row
                
                return cell
            }
            if indexPath.row == 3
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell", forIndexPath: indexPath) as! UserInfoTableViewCell
                cell.userInteractionEnabled = false
                
                cell.titleLabel.text = "Issues Reported"
                cell.userInfoTextField.text = String(self.serviceRequests.count)
                cell.userInfoTextField.delegate = self
                cell.userInfoTextField.cellIndex = indexPath.row
                
                return cell
            }
        }
            
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath) as! RequestTableViewCell
            
            var request: ServiceRequest = serviceRequests[indexPath.row]
            cell.titleLabel.text = request.getServiceCodeDescription() as? String
            cell.descriptionLabel.text = request.serviceDescription as? String
            cell.thumbnailImageView.image = request.photo
            cell.dateSubmittedLabel.text = request.requestedDatetime as? String
            cell.addressLabel.text = request.addressString as? String
            
            return cell
        }
        return UITableViewCell() // error here
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        /* This method is called after a user deselects any of the 
            text fields to edit their user info. Here their info is
            updated and saved to the AppModel */
        
        if textField is UserInfoTextField
        {
            var userInfoTextField: UserInfoTextField = textField as! UserInfoTextField
            var editedCellIndex: Int = userInfoTextField.cellIndex
            if editedCellIndex == 0
            {
                self.userName = userInfoTextField.text
            }
            if editedCellIndex == 1
            {
                self.userEmail = userInfoTextField.text
            }
            if editedCellIndex == 2
            {
                self.userPhone = userInfoTextField.text
            }
        }
        
        // send the changes to the DataModel
        self.saveUserPreferences()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 44
        }
        if indexPath.section == 1
        {
            return 100
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1
        {
            return "My Requests"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 1
        {
            var headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            headerView.backgroundView = UIView()
            headerView.textLabel.textColor = UIColor(red: 0.647, green: 0.643, blue: 0.631, alpha: 1.0)
        }
    }

    // We want fresh data!
    func refreshServiceRequests()
    {
        var event: GetServiceRequestsArrayEvent = GetServiceRequestsArrayEvent()
        self.mediator.postEvent(event)
    }
    
    func notify(event: Event)
    {
        if event is ServiceRequestsArrayEvent
        {
            var requestsArrayEvent: ServiceRequestsArrayEvent = event as! ServiceRequestsArrayEvent
            self.serviceRequests = requestsArrayEvent.requestsArray
            self.tableView.reloadData()
        }
        if event is UserPreferencesEvent
        {
            var upEvent: UserPreferencesEvent = event as! UserPreferencesEvent
            self.updateUserPreferences(upEvent)
        }
    }
}
