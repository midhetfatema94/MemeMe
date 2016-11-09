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
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to clear all the changes?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            
            self.topTextField.isHidden = false
            self.topTextField.text = "Top Line"
            self.topLine.isHidden = true
            self.bottomTextField.isHidden = false
            self.bottomTextField.text = "Bottom Line"
            self.bottomLine.isHidden = true
            self.memeImage.image = nil
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
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

