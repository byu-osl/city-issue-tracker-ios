//
//  TrackerAPI.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 4/6/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit
import Foundation

extension Dictionary {
    
    func toURLString() -> NSString {
        var urlString = ""
        
        for (paramNameObject, paramValueObject) in self {
            var paramNameEncoded = paramNameObject as! String
            var paramValueEncoded = paramValueObject as! String
            
            var oneUrlPiece = paramNameEncoded + "=" + paramValueEncoded
            
            urlString = urlString + (urlString == "" ? "" : "&") + oneUrlPiece
        }
        
        return urlString
    }
}

class TrackerAPI: NSObject, Subscriber{
    
    //    // set this up as a singleton
    //    class var sharedInstance: TrackerAPI {
    //        struct Singleton {
    //            static let instance = TrackerAPI(newMediator)
    //        }
    //        return Singleton.instance
    //    }
    
    var mediator: Mediator
    var requestsJSON: JSON
    
    let maxImageHeight: CGFloat = 600
    let maxImageWidth: CGFloat = 600
    
    init(newMediator: Mediator)
    {
        self.mediator = newMediator
        self.requestsJSON = [:]
        super.init()
        self.mediator.registerSubscriber(self)
    }
    
    // Subscriber Protocol Function
    func notify(event: Event)
    {
        // if someone wants us to reload server data
        if event is ReloadServiceRequestsFromServerEvent
        {
            self.reloadDataFromServer()
        }
        
        if event is GetServiceRequestsJSONEvent
        {
            self.sendRequestsJSON()
        }
        
        if event is SaveServiceRequestEvent
        {
            var saveServiceRequestEvent = event as! SaveServiceRequestEvent
            var serviceRequest: ServiceRequest = saveServiceRequestEvent.serviceRequest
            self.postServiceRequest(serviceRequest)
            println("SEND IT OFF BRO")
        }
    }
    
    func postServiceRequest(serviceRequest: ServiceRequest)
    {
        var serviceRequestJSON: [String: AnyObject] = self.convertServiceRequestToJSON(serviceRequest).dictionaryObject!
        let url = NSURL(string: "http://localhost:3000/requests.json")
        let request = NSMutableURLRequest(URL: url!)
        
        println(serviceRequestJSON.toURLString())
        
        let data : NSData = serviceRequestJSON.toURLString().dataUsingEncoding(NSUTF8StringEncoding)!;
        request.HTTPBody = data;
        println("Body:")
        println(request.HTTPBody)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var response: NSURLResponse?
        var error: NSError?
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()) { response, maybeData, error in
            if let data = maybeData
            {
                let response = NSString(data: data, encoding: NSUTF8StringEncoding)
                println(response)
                
                // reload the data now!
                var event: Event = ReloadServiceRequestsFromServerEvent()
                self.mediator.postEvent(event)
            }
            else {
                println(error.localizedDescription)
            }
        }
    }

    func convertServiceRequestToJSON(serviceRequest: ServiceRequest) -> JSON
    {
        var serviceRequestJSON: JSON = [:] // create empty JSON
        
        // Required elements
        serviceRequestJSON["service_code"] = JSON(serviceRequest.serviceCode)
        serviceRequestJSON["address_string"] = JSON(serviceRequest.addressString)
        
        // Optional elements
        serviceRequestJSON["description"] = JSON(serviceRequest.serviceDescription)
        serviceRequestJSON["media_url"] = UIImageToJSON(serviceRequest.photo)
        
        // User elements
//        serviceRequestJSON["email"] = JSON()
//        serviceRequestJSON["first_name"] = JSON()
//        serviceRequestJSON["last_name"] = JSON()
//        serviceRequestJSON["phone"] = JSON()
        
        return serviceRequestJSON
    }
    
    func shrinkImage(image: UIImage) -> UIImage
    {
        var aspectRatio: CGFloat = image.size.height / image.size.width
        var shrinkFactor: CGFloat = 0.0
        var newHeight: CGFloat = 0.0
        var newWidth: CGFloat = 0.0
        
        if (image.size.height <= maxImageHeight && image.size.width <= maxImageWidth)
        {
            // it doesn't need to be shrunk!
            return image
        }
        
        // if height is biggest, shrink height
        if image.size.height > image.size.width
        {
            shrinkFactor = maxImageHeight / image.size.height
            newHeight = maxImageHeight
            newWidth = image.size.width * shrinkFactor
        }
        else // if the width is biggest, shrink the height
        {
            shrinkFactor = maxImageWidth / image.size.width
            newWidth = maxImageWidth
            newHeight = image.size.height * shrinkFactor
        }
        
        // Resize the image now
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(shrinkFactor, shrinkFactor))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func UIImageToJSON(image: UIImage) -> JSON
    {
        var shrunkImage: UIImage = shrinkImage(image)
        var imageString: NSData = UIImageJPEGRepresentation(shrunkImage, 0.8)
        let imageBase64String = imageString.base64EncodedStringWithOptions(.allZeros)
        var imageJSON: JSON = JSON(imageBase64String)
        return imageJSON
    }
    
    func JSONToUIImage(imageDataJSON: JSON) -> UIImage
    {
        var base64ImageData: String = imageDataJSON.string!
        let decodedData: NSData = NSData(base64EncodedString: base64ImageData, options: NSDataBase64DecodingOptions(rawValue: 0))!
        var image: UIImage = UIImage(data: decodedData)!
        return image
    }
    
    func sendRequestsJSON()
    {
        /* Send all the requestsJSON data to the mediator through an event */
        
        var event: Event = ServiceRequestsJSONEvent(requestsJSON: self.requestsJSON)
        self.mediator.postEvent(event)
    }
    
    func saveRequestsJSON(inputJSON: JSON)
    {
        self.requestsJSON = inputJSON
        self.sendRequestsJSON() // notify the mediator of new stuff!
    }
    
    func reloadDataFromServer()
    {
        println("Skipping login..")
        let url = NSURL(string: "http://localhost:3000/requests.json")
        let request = NSMutableURLRequest(URL: url!)
        
        //        // piece the username and password together
        //        let authString = usernameInput + ":" + passwordInput
        //
        //        // run through base64Encoding
        //        let plainData = (authString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        //        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
        //        println(base64String)
        //
        //        // add "Basic" to the front of the string
        //        let finalAuthString = "Basic " + base64String!
        //        request.addValue(finalAuthString, forHTTPHeaderField:"Authorization")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()) { response, maybeData, error in
            if let data = maybeData
            {
                let response = NSString(data: data, encoding: NSUTF8StringEncoding)
                var requestsJSON = JSON(data: data)
                self.saveRequestsJSON(requestsJSON)
            }
            else {
                println(error.localizedDescription)
            }
        }
        
        return
    }
   
}












