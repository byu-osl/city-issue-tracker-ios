//
//  HomeViewController.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 5/8/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
//    @IBOutlet weak var photoImageView: UIView!
    @IBOutlet weak var photoImageView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!
    var photoImage: UIImage!
    
    var picker = UIImagePickerController()
    
    ////////////////////////////
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var error: NSError?

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
        
//        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // eh
        // ENABLE THE CAMERA!!!
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        picker.cameraCaptureMode = .Photo
        picker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext        
        
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Back }
        if let captureDevice = devices.first as? AVCaptureDevice  {
            
            captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &error))
            captureSession.sessionPreset = AVCaptureSessionPresetMedium
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                
//                previewLayer.bounds = self.photoImageView.bounds
                
                // update the frame to use in photo sizing
                self.photoImageView.layoutIfNeeded()
                let hi = self.photoImageView.bounds
                let okay = self.photoImageView.frame
                previewLayer.frame = self.photoImageView.bounds
//                previewLayer.position = CGPoint(x: 150.0, y: 195.0)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                
                photoImageView.layer.addSublayer(previewLayer)
            }
        }
        
    }
    
    // Get a photo from the library
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage

        self.photoImage = chosenImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.performSegueWithIdentifier("SegueToAddRequest", sender: self)
    }
    
    @IBAction func takePhotoButtonPressed(sender: UIButton) {
        println("snap")
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let imageFromCamera = UIImage(data: imageData)
                self.photoImage = imageFromCamera
                self.performSegueWithIdentifier("SegueToAddRequest", sender: self)
            }
        }
    }
    
    @IBAction func skipPhotoButtonPressed(sender: UIButton) {
        println("skip")
        self.performSegueWithIdentifier("SegueToAddRequest", sender: self)
    }
    
    @IBAction func photoLibraryButtonPressed(sender: UIButton) {
        
        // Get a photo from the library
        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func unwindToHome(seque: UIStoryboardSegue)
    {
        //
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
            if self.photoImage != nil
            {
                destVC.photoFromCamera = self.photoImage!
            }
        }
    }
    
}
