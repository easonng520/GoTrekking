//
//  GoTrekking.swift
//  GoTrekking
//
//  Created by eazz on 21/6/2023.
//

import Foundation
import UIKit

class GoTrekking: UIViewController, UITextFieldDelegate {
    let fullScreenSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        let regButton = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        regButton.text = "Register Now"
        regButton.backgroundColor = .red
        regButton.borderStyle = .roundedRect
        regButton.textColor = .white
        regButton.textAlignment = .center
        regButton.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.4)

        self.view.addSubview(regButton)

        let passcodeTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        passcodeTextField.placeholder = "passCODE"
        passcodeTextField.borderStyle = .roundedRect
        passcodeTextField.clearButtonMode = .whileEditing
        passcodeTextField.keyboardType = .emailAddress
        passcodeTextField.returnKeyType = .done
        passcodeTextField.textColor = UIColor.white
        passcodeTextField.textAlignment = .center
        //passcodeTextField.backgroundColor = UIColor.lightGray
        passcodeTextField.delegate = self
        passcodeTextField.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.3)
        self.view.addSubview(passcodeTextField)
        
        // Check with Valid Email Address
         let validEmailAddressValidationResult = isValidEmailAddress(emailAddressString: "my.EmailAddress@gmail.com")
         print(validEmailAddressValidationResult)

        // Check with invalid Email Address
         let inValidEmailAddressValidationResult = isValidEmailAddress(emailAddressString: "my.EmailAddress@gmail.c")
         print(inValidEmailAddressValidationResult)
        // Do any additional setup after loading the view.
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
      
      var returnValue = true
      let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
      
      do {
          let regex = try NSRegularExpression(pattern: emailRegEx)
          let nsString = emailAddressString as NSString
          let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
          
          if results.count == 0
          {
              returnValue = false
          }
          
      } catch let error as NSError {
          print("invalid regex: \(error.localizedDescription)")
          returnValue = false
      }
      
      return  returnValue
  }

}

