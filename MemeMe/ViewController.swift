//
//  ViewController.swift
//  MemeMe
//
//  Created by Midhet Sulemani on 08/11/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let imagePicker = UIImagePickerController()
    var activeField: UITextField?
    
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomLine: UILabel!
    @IBOutlet weak var topLine: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    @IBAction func cameraClicked(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func albumClicked(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        
        var sharingItems = [AnyObject]()
        sharingItems.append(memeImage.image!)
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Click", style: .default, handler: { action in
            print("clicked")
        }))
        self.present(alert, animated: true, completion: nil)
        
//        topTextField.isHidden = false
//        topTextField.text = "Top Line"
//        topLine.isHidden = true
//        bottomTextField.isHidden = false
//        bottomTextField.text = "Bottom Line"
//        bottomLine.isHidden = true
//        memeImage.image = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        bottomTextField.delegate = self
        bottomTextField.tag = 1
        topTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        textField.isHidden = true
        if textField.tag == 1 && textField.text != "" {
            bottomLine.text = textField.text
            bottomLine.isHidden = false
            activeField = nil
        }
        else if textField.tag == 0 && textField.text != "" {
            topLine.text = textField.text
            topLine.isHidden = false
        }
        return true
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) {
            
            if  activeField != nil {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if activeField != nil {
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
        
        if textField.tag == 1 {
            
            activeField = textField
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            memeImage.contentMode = .scaleAspectFit
            memeImage.image = pickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

}

