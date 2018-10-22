//
//  DetailViewController.swift
//  Campus Walk
//
//  Created by Samuel Fox on 10/21/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var buildingImageView: UIImageView!
    @IBOutlet var buildingLabel: UILabel!
    @IBOutlet var changeImageNAvButton: UIBarButtonItem!
    
    var image : UIImage?
    var buildingText = String()
    var imagePicker = UIImagePickerController()
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if image != nil {
            buildingImageView.image = image
        }
        buildingLabel.text = buildingText
    }
    
    func configure(_ image : UIImage, _ text : String) {
        self.image = image
        self.buildingText = text
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage]
        buildingImageView.image = image as? UIImage
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
