//
//  HomeViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/8/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color of the nav bar title
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.647, green: 0.643, blue: 0.631, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        // remove the underline color of the nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Change the color of the camera
        var image = cameraImageView.image
        image = image!.imageWithRenderingMode(.AlwaysTemplate)
        
//        let imageView = UIImageView
        cameraImageView.tintColor = UIColor(red: 0.282, green: 0.278, blue: 0.270, alpha: 1.0)
//        (0.282 0.278 0.270)
        cameraImageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.destinationViewController is AddServiceRequestTableViewController
        {
            var destVC: AddServiceRequestTableViewController = segue.destinationViewController as! AddServiceRequestTableViewController
            
            // if they actually selected a photo
            if self.photoImageView.image != nil
            {
                destVC.photoFromCamera = self.photoImageView.image!
            }
        }
    }

    
    @IBAction func photoLibraryButtonPressed(sender: UIButton) {
        
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        // ENABLE THE CAMERA!!!
//        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.photoImageView.image = chosenImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.performSegueWithIdentifier("SegueToAddRequest", sender: self)
    }
    
    @IBAction func takePhotoButtonPressed(sender: UIButton) {
        println("snap")
        self.performSegueWithIdentifier("SegueToAddRequest", sender: self)
    }
    @IBAction func skipPhotoButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("SegueToAddRequest", sender: self)
    }
    
    @IBAction func unwindToHome(seque: UIStoryboardSegue)
    {
        //
    }
    
}
