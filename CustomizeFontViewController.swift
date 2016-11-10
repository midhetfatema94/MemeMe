//
//  CustomizeFontViewController.swift
//  MemeMe
//
//  Created by Midhet Sulemani on 10/11/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit

class CustomizeFontViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let fontNames = [["name": "Impact", "value": "Impact"], ["name": "HelveticaNeue Condensed Black", "value": "HelveticaNeue-CondensedBlack"] , ["name": "Courier", "value": "Courier-Bold"], ["name": "Copperplate", "value": "Copperplate-Bold"]]
    let fontSizes: [Double] = [36, 48, 56, 62]
    let colors = [["name": "Red", "value": UIColor.red], ["name": "Black", "value": UIColor.black], ["name": "White", "value": UIColor.white], ["name": "Gray", "value": UIColor.gray], ["name": "Blue", "value": UIColor.blue]]
    let strokeWidth = [1.0, 2.0, 3.0, 4.0, 5.0]
    var whichPicker = "Font"
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerToolbar: UIToolbar!
    
    var finalFont: Font!
    var finalStroke: Stroke!
    var finalFill: UIColor!
    var prevVC: ViewController!
    
    @IBAction func useCustomization(_ sender: UIBarButtonItem) {
        
        prevVC.fill = finalFill
        prevVC.font = finalFont
        prevVC.stroke = finalStroke
        prevVC.makeFont()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func donePicker(_ sender: UIBarButtonItem) {
        
        picker.isHidden = true
        pickerToolbar.isHidden = true
        
    }
    
    @IBAction func changeFontNameOrSize(_ sender: UIButton) {
        
        picker.isHidden = false
        pickerToolbar.isHidden = false
        whichPicker = "Font"
        picker.reloadAllComponents()
    }
    
    @IBAction func changeFillColor(_ sender: UIButton) {
        
        picker.isHidden = false
        pickerToolbar.isHidden = false
        whichPicker = "Fill"
        picker.reloadAllComponents()
    }
    
    @IBAction func changeStrokeColorOrWidth(_ sender: UIButton) {
        
        picker.isHidden = false
        pickerToolbar.isHidden = false
        whichPicker = "Stroke"
        picker.reloadAllComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finalFont = Font(name: "Impact", size: 56)
        finalFill = UIColor.white
        finalStroke = Stroke(color: UIColor.black, width: 4.0)
        
        changeFont()
    }
    
    func changeFont() {
        
        let textAttributes:[String:Any] = [
            NSStrokeColorAttributeName: finalStroke.color,
            NSFontAttributeName: UIFont(name: finalFont.name, size: CGFloat(finalFont.size))!,
            NSForegroundColorAttributeName: finalFill,
            NSStrokeWidthAttributeName: -(CGFloat(finalStroke.width))]
        let attributedLabel = NSAttributedString(string: "My Font", attributes: textAttributes)
        
        testLabel.attributedText = attributedLabel
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch whichPicker {
            case "Font", "Stroke":
                return 2
            default:
                return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch whichPicker {
        case "Font":
            if component == 0 {
                return fontNames.count
            }
            else {
                return fontSizes.count
            }
        case "Stroke":
            if component == 0 {
                return colors.count
            }
            else {
                return strokeWidth.count
            }
        default:
            return colors.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch whichPicker {
        case "Font":
            if component == 0 {
                finalFont.name = fontNames[row]["value"]
            }
            else {
                finalFont.size = fontSizes[row]
            }
            changeFont()
        case "Stroke":
            if component == 0 {
                finalStroke.color = colors[row]["value"] as! UIColor!
            }
            else {
                finalStroke.width = strokeWidth[row]
            }
            changeFont()
        default:
            finalFill = colors[row]["value"] as! UIColor!
            changeFont()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch whichPicker {
        case "Font":
            if component == 0 {
                return fontNames[row]["name"]
            }
            else {
                return String(fontSizes[row])
            }
        case "Stroke":
            if component == 0 {
                return colors[row]["name"] as? String
            }
            else {
                return String(strokeWidth[row])
            }
        default:
            return colors[row]["name"] as? String
        }
    }
}
