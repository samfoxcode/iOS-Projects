//
//  DetailViewController.swift
//  Campus Walk
//
//  Created by Samuel Fox on 10/21/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

protocol SaveImageDelegate {
    func save(_ building : String, _ image:UIImage)
    func saveDetails(_ building : String, _ details:String)
}

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var detailTextView: UITextView!
    @IBOutlet var buildingImageView: UIImageView!
    @IBOutlet var buildingLabel: UILabel!
    @IBOutlet var changeImageNAvButton: UIBarButtonItem!
    
    var delegate : SaveImageDelegate?
    var image : UIImage?
    var buildingText = String()
    var imagePicker = UIImagePickerController()
    var keyboardVisible = false
    var savedBuildingImages = [String:UIImage]()
    var savedBuildingDetails = [String:String]()
    var previousHeight : CGFloat = 25.0
    
    func save(_ building : String, _ image : UIImage) {
        delegate?.save(building, image)
    }
    func saveDetails(_ building : String, _ details : String) {
        delegate?.saveDetails(building, details)
    }
    
    @IBAction func changeImageAction(_ sender: Any) {
        let alertView = UIAlertController(title: "Directions", message: nil, preferredStyle: .actionSheet)
        alertView.popoverPresentationController?.barButtonItem = changeImageNAvButton
        let actionLibraryPhoto = UIAlertAction(title: "Library Photo", style: .default) { (action) in
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertView.addAction(actionLibraryPhoto)
        
        let actionTakePhoto = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else {
                let alertWarning = UIAlertController(title:"Warning", message: "Camera Not Available", preferredStyle: .alert)
                alertWarning.popoverPresentationController?.barButtonItem = self.changeImageNAvButton
                let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertWarning.addAction(actionCancel)
                self.present(alertWarning, animated: true, completion: nil)
                
            }
        }
        alertView.addAction(actionTakePhoto)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(actionCancel)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveDetailChanges(_ sender: Any) {
        detailTextView.resignFirstResponder()
        if !detailTextView.text!.isEmpty {
            saveDetails(buildingText, detailTextView.text!)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        scrollView.contentSize.height = scrollView.contentSize.height + (textView.contentSize.height - previousHeight)
        previousHeight = textView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextView.delegate = self
        detailTextView.returnKeyType = .done
        if image != nil {
            buildingImageView.image = image
        }
        if let savedImage = savedBuildingImages[buildingText]{
            buildingImageView.image = savedImage
        }
        if let savedDetails = savedBuildingDetails[buildingText]{
            detailTextView.text = savedDetails
        }
        buildingLabel.text = buildingText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        if !keyboardVisible && ( self.view.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClass.regular ) {
            let userInfo = notification.userInfo!
            let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize!.height
            }
        }
        
        keyboardVisible = true
    }
    
    @objc
    func keyboardWillHide(notification:Notification) {
        if keyboardVisible && ( self.view.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClass.regular ) {
            let userInfo = notification.userInfo!
            let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize!.height
            }
        }
        keyboardVisible = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        detailTextView.resignFirstResponder()
    }
    
    func configure(_ image : UIImage, _ text : String, _ savedImages : [String:UIImage], _ savedDetails : [String:String]) {
        self.image = image
        self.buildingText = text
        self.savedBuildingImages = savedImages
        self.savedBuildingDetails = savedDetails
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage]
        buildingImageView.image = image as? UIImage
        save(buildingText, (image as? UIImage)!)
        dismiss(animated: true, completion:nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
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
