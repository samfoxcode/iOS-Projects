//
//  UploadPostViewController.swift
//  
//
//  Created by Samuel Fox on 11/3/18.
//

import UIKit
import Firebase

class UploadPostViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    fileprivate var databaseRef : DatabaseReference!
    fileprivate var storageRef : StorageReference!
    fileprivate var uploadStorageTask: StorageUploadTask!
    fileprivate var imageStoragePath = ""
    
    var imagePicker = UIImagePickerController()
    
    fileprivate var showNetworkActivityIndicator = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = showNetworkActivityIndicator
        }
    }
    
    @IBOutlet var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        let addImageGesture = UITapGestureRecognizer(target: self, action: #selector(UploadPostViewController.selectImage(_:)))
        addImageGesture.numberOfTapsRequired = 1
        uploadImageView.addGestureRecognizer(addImageGesture)
    }
    
    @objc func selectImage(_ sender: UITapGestureRecognizer) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage]
        uploadImageView.image = image as? UIImage
        dismiss(animated: true, completion:nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func submitPost(_ sender: Any) {
        
        let image = uploadImageView.image!.jpegData(compressionQuality: 0.25)
        let imagePath = "Samf1596"+"/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        showNetworkActivityIndicator = true
        
        let storage = storageRef.child("IMAGES/"+imagePath)
        storage.putData(image!).observe(.success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            storage.downloadURL(completion: { (url, error) in
                if (error == nil) {
                    if let downloadUrl = url {
                        // Make you download string
                        let downloadURL = downloadUrl.absoluteString
                        self.uploadSuccess(downloadURL)
                        self.showNetworkActivityIndicator = false
                        self.uploadImageView.image = UIImage(named: "addPhoto")
                    }
                } else {
                    print("Error:\(error ?? "" as! Error)")
                }
            })

        }
        /*
        uploadStorageTask = storageRef.child(imagePath).putData(image!, metadata: metadata)  { (_, error) in
            self.showNetworkActivityIndicator = false
            
            guard error == nil else {
                print("Error uploading: \(error!)")
                return
            }
            self.uploadSuccess(imagePath)
        }
         */
        
    }
    
    func uploadSuccess(_ imagePath : String) {
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
