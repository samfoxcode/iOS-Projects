//
//  UploadPostViewController.swift
//  
//
//  Created by Samuel Fox on 11/3/18.
//

import UIKit
import Firebase
import Photos

class UploadPostViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    fileprivate var databaseRef : DatabaseReference!
    fileprivate var storageRef : StorageReference!
    fileprivate var uploadStorageTask: StorageUploadTask!
    fileprivate var imageStoragePath = ""
    
    var imagePicker = UIImagePickerController()
    var imageToUpload = UIImage(named: "addPhoto")
    
    fileprivate var showNetworkActivityIndicator = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = showNetworkActivityIndicator
        }
    }
    
    @IBOutlet var uploadImageView: UIImageView!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        let addImageGesture = UITapGestureRecognizer(target: self, action: #selector(UploadPostViewController.selectImage(_:)))
        addImageGesture.numberOfTapsRequired = 1
        uploadImageView.addGestureRecognizer(addImageGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
            
        case .authorized: print("Access is granted by user")
            
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {print("success")
                    
                } })
        case .restricted:
            print("User do not have access to photo album.")
                
        case .denied:
            print("User has denied the permission.") }
    }
    
    @objc func selectImage(_ sender: UITapGestureRecognizer) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImageView.alpha = 1.0
            imageToUpload = image
            uploadImageView.image = image
        }
        dismiss(animated: true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func submitPost(_ sender: Any) {
        
        print("In submit Post")
        
        let image = imageToUpload!.jpegData(compressionQuality: 0.25)
        let imagePath = "Samf1596"+"/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        showNetworkActivityIndicator = true
        
        let storage = storageRef.child("IMAGES/"+imagePath)
        
        storage.putData(image!).observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("File doesn't exist")
                    break
                case .unauthorized:
                    print("User doesn't have permission to access file")
                    break
                case .unknown:
                    print("Unknown Error")
                    break
                default:
                    print("Unhandled Error")
                    break
                }
            }
        }
        
        storage.putData(image!).observe(.success) { (snapshot) in
            print("In putData")
            // When the image has successfully uploaded, we get it's download URL
            storage.downloadURL(completion: { (url, error) in
                if (error == nil) {
                    print("Error is nil")
                    if let downloadUrl = url {
                        print("Now here")
                        // Make you download string
                        let downloadURL = downloadUrl.absoluteString
                        self.uploadSuccess(downloadURL)
                        self.showNetworkActivityIndicator = false
                        self.uploadImageView.image = UIImage(named: "addPhoto")
                        self.uploadImageView.alpha = 0.5
                    }
                } else {
                    print("HERE in error")
                    print("Error:\(String(describing: error?.localizedDescription))")
                }
            })

        }
        
    }
    
    func uploadSuccess(_ imagePath : String) {
        // TODO: Create post with correct details from flights/experiences
        let post = Post(addedByUser: "Sam", username: "Samf1596", description: "DescriptionTest", imagePath: imagePath, flights: "FlightTest", itinerary: "ItineraryTest", stays: "StaysTest", isPublic: true)
        
        databaseRef.child(FirebaseFields.Posts.rawValue).child(post.username + "\(Int(Date.timeIntervalSinceReferenceDate * 1000))").setValue(post.toObject())
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
