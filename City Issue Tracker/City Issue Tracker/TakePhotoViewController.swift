//
//  TakePhotoViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/2/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit

class TakePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var photoImageView: UIImageView!
    var photoToSave: UIImage = UIImage()
    var photoSaved: Bool = false
    
    @IBAction func takePhotoPressed(sender: UIButton) {
        
    }
    
    @IBAction func selectPhotoPressed(sender: UIButton) {
        
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        //        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.photoImageView.image = chosenImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        photoToSave = nil

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        
        var senderButton: UIBarButtonItem = sender as! UIBarButtonItem
        
//        segue.destinationViewController
        if senderButton == self.saveButton
        {
            // if they actually selected a photo
            if self.photoImageView.image != nil
            {
                self.photoToSave = self.photoImageView.image!
                self.photoSaved = true
            }
            return
        }
        
    }

}
