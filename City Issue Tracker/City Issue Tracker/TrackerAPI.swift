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
        let url = NSURL(string: "http://localhost:3000/requests")
        let request = NSMutableURLRequest(URL: url!)
        
        println("Body:")
        let data : NSData = serviceRequestJSON.toURLString().dataUsingEncoding(NSUTF8StringEncoding)!;
        request.HTTPBody = data;
        
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
        println(serviceRequest.serviceCode)
        serviceRequestJSON["address_string"] = JSON(serviceRequest.addressString)
        
        // Optional elements
        serviceRequestJSON["description"] = JSON(serviceRequest.serviceDescription)
        serviceRequestJSON["media_url"] = JSON(UIImageToString(serviceRequest.photo))
        
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
    
    func UIImageToString(image: UIImage) -> String
    {
        var shrunkImage: UIImage = shrinkImage(image)
        var imageString: NSData = UIImageJPEGRepresentation(shrunkImage, 0.2)
        var imageBase64String = imageString.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        return imageBase64String
    }
    
    func StringToUIImage(imageDataString: String) -> UIImage
    {
        // regex hack HARDCORE MESSY
        let imageDataStringWithoutSpaces = imageDataString.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let decodedData = NSData(base64EncodedString: imageDataStringWithoutSpaces, options: NSDataBase64DecodingOptions(rawValue: 0))
        var decodedimage = UIImage(data: decodedData!)
        return decodedimage!
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
                self.processRequestsJSON(requestsJSON) // send the JSON
            }
            else {
                println(error.localizedDescription)
            }
        }
        return
    }
    
    func processRequestsJSON(requestsJSON: JSON)
    {
        var serviceRequests: [ServiceRequest] = []
        
        for var x=0; x<requestsJSON.count; x++
        {
            let requestData = requestsJSON[x]
            var newRequest: ServiceRequest = createNewRequest(requestData)
            
            if !isDuplicateRequest(newRequest, requestsArray: serviceRequests)
            {
                serviceRequests.append(newRequest)
            }
        }
        self.sendRequestsArray(serviceRequests) // send out the new array!
    }
    
    func isDuplicateRequest(serviceRequest: ServiceRequest, requestsArray: [ServiceRequest]) -> Bool
    {
        for r in requestsArray
        {
            if r.serviceID == serviceRequest.serviceID
            {
                // It's a dupe!!
                return true
            }
        }
        return false
    }
    
    func createNewRequest(requestData: JSON) -> ServiceRequest
    {
        // Required info
        var newServiceRequest = ServiceRequest()
        newServiceRequest.serviceID = requestData["_id"].string!
        newServiceRequest.status = requestData["status"].string!
        newServiceRequest.requestedDatetime = requestData["requested_datetime"].string!
        newServiceRequest.serviceCode = requestData["service_code"].string!
        newServiceRequest.v = requestData["__v"].intValue
        
        // Optional info
        if let addressString: String = requestData["address_string"].string
        {
            newServiceRequest.addressString = addressString
        }
        
        if let long: String = requestData["long"].string
        {
            newServiceRequest.long = long
        }
        
        if let lat: String = requestData["lat"].string
        {
            newServiceRequest.lat = lat
        }
        
        if let addressString: String = requestData["long"].string
        {
            newServiceRequest.addressString = addressString
        }
        
        if let serviceDescription: String = requestData["description"].string
        {
            newServiceRequest.serviceDescription = serviceDescription
        }
        
        if let imageDataString: String = requestData["media_url"].string
        {
            var image: UIImage = StringToUIImage(imageDataString)
            newServiceRequest.photo = image
        }
        
        return newServiceRequest
    }
        
    func sendRequestsArray(serviceRequests: [ServiceRequest])
    {
        var event: Event = ServiceRequestsArrayEvent(requestsArray: serviceRequests)
        self.mediator.postEvent(event)
    }
}












