//
//  RegistrationViewController.swift
//  GoTrekking
//
//  Created by eazz on 21/6/2023.
//

import Foundation
import UIKit
class Registration: UIViewController {
    var detailsVCPrintedJson: String?
    var detailsVCTitle: String?
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
       @IBAction func submitAction(_ sender: Any) {
       
           if self.nickname.hasText && isValidEmailAddress(emailAddressString:self.email.text!){
               postMethod()
               //regOK(msgString: "AAA")
               self.nickname.text = ""
               self.email.text = ""
           }else{
               alert()
           }
           
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.nickname.text = "aaa"
        //self.email.text = "easonng@surgery.cuhk.edu.hk"
    // Do any additional setup after loading the view.
    }

    
    func postMethod() {
               
        guard let url = URL(string: "https://b.easonng520.repl.co/api/trekkers") else {
            print("Error: cannot create URL")
            return
        }
        
        // Create model
        struct UploadData: Codable {
            let nickname: String
            let email: String
            let code: String
            let step: String
            let distance: String
        }
        
        // Add data to the model
        let uploadDataModel = UploadData(nickname: nickname.text!, email:  email.text!, code: "", step: "", distance: "")

        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = jsonData
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
//        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
 
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                
               self.openDetailsVC(jsonString: prettyPrintedJson, title: "POST METHOD")
                print(prettyPrintedJson)
              
                DispatchQueue.main.async {
                    self.regOK(msgString: "AAAA")
                }
              
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    

    func openDetailsVC(jsonString: String, title: String) {
        detailsVCPrintedJson = jsonString
        detailsVCTitle = title
        
//        DispatchQueue.main.async {
  //          self.performSegue(withIdentifier: "detailsseg", sender: self)
    //    }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailsseg" {
          //  let destViewController = segue.destination as? DetailsViewController
           // destViewController?.title = detailsVCTitle
           // destViewController?.jsonResults = detailsVCPrintedJson ?? ""
        }
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

    @objc func alert() {
        let alertController = UIAlertController(title: "!", message: "Input invalid", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            //print("Error")
        })
        alertController.addAction(okAction)
       self.present(alertController, animated: true, completion: nil)
    }

    @objc func regOK(msgString: String) {
        let alertController = UIAlertController(title: "Registration Successful", message: "Your passCODE:\(msgString) ", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            //print("Error")
        })
        alertController.addAction(okAction)
       self.present(alertController, animated: true, completion: nil)
    }
    
}
