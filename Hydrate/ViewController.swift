//
//  ViewController.swift
//  Hydrate
//
//  Created by Alex Yoshida on 2021-09-18.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    //initalize
    @IBOutlet weak var FirstNameTextField: UITextField!
    var agecounter = 0
    
    
    @IBOutlet weak var Age: UILabel!
    @IBAction func AgeStepper(_ sender: UIStepper) {
        var x: Double = 0.0
        if let a = userDefaults.value(forKey: "Age") as? String, let aDouble = Double(a) {
            sender.minimumValue = -aDouble
            //min = 0
            sender.maximumValue = 120-aDouble
            //max = 120
            x=aDouble
        }
        print(x)
        print(sender.value)
        Age.text = String(Int(x) + Int(sender.value))
    }
    

    
    @IBOutlet weak var Height: UILabel!
    @IBAction func HeightStepper(_ sender: UIStepper) {
        sender.maximumValue = 96
        var i = 0
        var q = 0
        //set min
        if (userDefaults.value(forKey: "Height") as! String) != ""{
            let text = userDefaults.value(forKey: "Height") as! String
            
            var a = false
            if text.count > 3 {
                a = true
            }
            
            let index3 = text.index(text.startIndex, offsetBy: 0) //will call succ 2 times
            let lastChar2: Character = text[index3] //now we can index!
            let o = String(lastChar2)
            let p = Double(o)!
            q = Int(p) - 4
            let f = Double(q)
            
            
            let index2 = text.index(text.startIndex, offsetBy: 2) //will call succ 2 times
            let lastChar: Character = text[index2] //now we can index!
            let x = String(lastChar)
            let y = Double(x)!
            sender.minimumValue = -(y + (f*12.0))
            //min - 4"0
            sender.maximumValue = 50-(y + (f*12.0))
            //max - 9"0
            
            if a == false{
                i = Int(x)!
            } else
            {
                i = Int(x)! + 10
            }
        }
        var inches = 0
        
        if Int(sender.value) >= -i{
            inches = (Int(sender.value) + i)%12
        } else
        {
            inches = 12 + (i+Int(sender.value))
        }
        var foot = 0
        if Int(sender.value) + i >= 0
        {
            foot = ((Int(sender.value) + i)/12) + 4 + q
        }else{
            if (abs(Int(sender.value)) - i)%12 == 0
            {
                foot = -((abs(Int(sender.value)) - i) / 12) + 4 + q
            } else{
                foot = -((abs(Int(sender.value)) - i) / 12) + 4 + q - 1
            }

        }
        Height.text = String(foot) + "\"" + String(abs(inches))
    }
    
    
    @IBOutlet weak var ExcerciseDays: UILabel!
    @IBAction func ExcerciseDaysStepper(_ sender: UIStepper) {
        
        var x: Int = 0
        if let a = userDefaults.value(forKey: "ExcerciseDays") as? String, let aDouble = Double(a) {
            sender.minimumValue = -(aDouble/5)
            //min - 0
            sender.maximumValue = 199 - (aDouble/5)
            //max - 995
            x=Int(aDouble)
        }
        ExcerciseDays.text = String(x + ((Int(sender.value))*5))
    }
    
    
    
    @IBOutlet weak var Weight: UILabel!
    @IBAction func WeightStepper(_ sender: UIStepper) {
        var l = 0
        var t: Double = 0.0
        if (userDefaults.value(forKey: "Weight") as! String) != ""{
            let text = userDefaults.value(forKey: "Weight") as! String
            if text.count==5
            {
                let hundreds: Character = text[text.index(text.startIndex, offsetBy: 0)]
                let tens: Character = text[text.index(text.startIndex, offsetBy: 1)]
                
                let x = String(hundreds)
                let y = String(tens)
                t = (Double(x)!*100) + (Double(y)!*10)
            }
            else{
                let tens: Character = text[text.index(text.startIndex, offsetBy: 0)]
                let y = String(tens)
                t = (Double(y)!*10)
            }
            
            sender.minimumValue = -(t/5)
            //min - 0
            sender.maximumValue = 199 - (t/5)
            //Max - 995

            l = Int(t)
        }
        
        Weight.text = String(l + Int(sender.value*5)) + "lb"
    }
    
    @IBOutlet weak var Genders: UISegmentedControl!
    @IBAction func Gender(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            userDefaults.setValue("Male", forKey: "Gender")
        }
        else{
            userDefaults.setValue("Female", forKey: "Gender")
        }
    }
    
    @IBOutlet weak var ConfirmButton: UIButton!
   
    
    let userDefaults = UserDefaults()
    
    
    
    //start of app
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupElements()
        
        FirstNameTextField.text = userDefaults.value(forKey: "FirstName") as? String
        
        Age.text = userDefaults.value(forKey: "Age") as? String
        
        Height.text = userDefaults.value(forKey: "Height") as? String

        Weight.text = userDefaults.value(forKey: "Weight") as? String
        
        ExcerciseDays.text = userDefaults.value(forKey: "ExcerciseDays") as? String
        
        if userDefaults.value(forKey: "Gender") as? String == "Female"{
        Genders.selectedSegmentIndex = 1
        }
        
        self.FirstNameTextField.delegate = self
    }
    
    //keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //decorate
    func setupElements() {
        //style elements
        Utilities.styleTextField(FirstNameTextField)

        Utilities.styleFilledButton(ConfirmButton)
        
    }
    
    //Button
    @IBAction func didTapButton() {
        
        
        userDefaults.setValue(String(FirstNameTextField.text!), forKey: "FirstName")
        
        userDefaults.setValue(Age.text!, forKey: "Age")
        
        userDefaults.setValue(Height.text!, forKey: "Height")
        
        userDefaults.setValue(Weight.text!, forKey: "Weight")
        
        userDefaults.setValue(ExcerciseDays.text!, forKey: "ExcerciseDays")
        
        
        let vc=storyboard?.instantiateViewController(identifier: "other") as! OtherViewController
        vc.modalPresentationStyle = .fullScreen
        vc.Name = FirstNameTextField.text
        vc.Age = Age.text
        vc.Gender = (userDefaults.value(forKey: "Gender") as! String)
        vc.Weight = Weight.text
        vc.Height = Height.text
        vc.Minutes = ExcerciseDays.text
        present(vc, animated: true)
    }

}

