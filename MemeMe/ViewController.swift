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
    
    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var fill: UIColor!
    var font: Font!
    var stroke: Stroke!
    
    @IBAction func customizeFont(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "customise", sender: self)
    }
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
        
        //Converts UIView into UIImage
        //Code reference: Stack Overflow
        let renderer = UIGraphicsImageRenderer(size: memeView.bounds.size)
        let image = renderer.image { ctx in
            memeView.drawHierarchy(in: memeView.bounds, afterScreenUpdates: true)
        }
        
        let saveMeme = Meme(topLine: topTextField.text!, bottomLine: bottomTextField.text!, memedImage: image, originalImage: memeImage.image!)
        sharingItems.append(saveMeme.memedImage)
        
        CustomPhotoAlbum.sharedInstance.saveImage(image: saveMeme.memedImage)
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        
        //Clears all the content if user chooses to restart
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to clear all the changes?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            
            self.topTextField.text = "Top Line"
            self.bottomTextField.text = "Bottom Line"
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
        
        //Code reference: Stack Overflow
        if UIImagePickerController.availableCaptureModes(for: .rear) == nil {
            cameraButton.isEnabled = false
        }
        
        fill = UIColor.white
        font = Font(name: "Impact", size: 56)
        stroke = Stroke(color: UIColor.black, width: 4.0)
        makeFont()
        
    }
    
    func makeFont() {
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: stroke.color,
            NSFontAttributeName: UIFont(name: font.name, size: CGFloat(font.size))!,
            NSForegroundColorAttributeName: fill,
            NSStrokeWidthAttributeName: -(CGFloat(stroke.width))]
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        activeField = nil
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "customise" {
            
            let next = segue.destination as! CustomizeFontViewController
            next.prevVC = self
        }
    }
    
}

struct Meme {
    let topLine: String
    let bottomLine: String
    let memedImage: UIImage
    let originalImage: UIImage
}

struct Font {
    var name: String!
    var size: Double!
}

struct Stroke {
    var color: UIColor!
    var width: Double!
}
