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
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        /*
         The sourceType property wants a value of the enum named        UIImagePickerControllerSourceType, which gives 3 options:
         
         UIImagePickerControllerSourceType.PhotoLibrary
         UIImagePickerControllerSourceType.Camera
         UIImagePickerControllerSourceType.SavedPhotosAlbum
         
         */
        present(imagePicker, animated: true, completion: nil)
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
