//
//  ViewController.swift
//  GoTrekking
//
//  Created by eazz on 9/6/2023.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    var timer: Timer!
    var detailsVCPrintedJson: String?
    var detailsVCTitle: String?
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var passcodeLabel: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var regButton: UIButton!
    
    
    @IBAction func regButton(_ sender: Any) {
    }
    
    
    var eventDateComponents = "2023-06-27 09:00:00 UTC"
    override func viewDidLoad() {
     eventName.isHidden = true
     eventDate.isHidden = true
        timerText.isHidden = true
        timerLabel.isHidden = true
        passcodeLabel.isHidden = true
        passcodeTextField.isHidden = true
        regButton.isHidden = true
        passcodeTextField.isEnabled = true
        
        
        let url = URL(string: "https://b.easonng520.repl.co/api/events")!
          URLSession.shared.fetchData(for: url) { (result: Result<[Event], Error>) in
            switch result {
            case .success(let Event):
                print(Event[0].name)
                print(Event[0].date)
                DispatchQueue.main.async {
                 self.eventName.text = Event[0].name
                    self.eventDate.text = Event[0].date
                    
                    self.eventName.isHidden = false
                    self.eventDate.isHidden = false
                    self.timerText.isHidden = false
                    self.timerLabel.isHidden = false
                    self.passcodeLabel.isHidden = false
                    self.passcodeTextField.isHidden = false
                    self.regButton.isHidden = false
                    
                               }
            case .failure(let error):
              // A failure, please handle
              //self.eventDateComponents = "2022-06-29 09:00:00 UTC"
                print(error)
          }
        }
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        eventLabel.isHidden = true
        timerLabel.isHidden = true
        //timerLabel.layer.borderWidth = 1.0
         passcodeTextField.isEnabled = false
        //regButton.addTarget(nil, action: #selector(ViewController.login), for: .touchUpInside)
        
        func signupButton(_ sender: UIButton) { postMethod() }

        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label
        NetworkMonitor.shared.startMonitoring()
        
    }


    @objc func UpdateTime() {
        let userCalendar = Calendar.current
        // Set Current Date
        let date = Date()
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
        let currentDate = userCalendar.date(from: components)!
        
        // Set Event Date
     
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
        let eventDate = formatter.date(from: eventDateComponents)!
        
        // Change the seconds to days, hours, minutes and seconds
        let timeLeft = userCalendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: eventDate)
        
        // Display Countdown
        timerLabel.text = "\(timeLeft.day!)d \(timeLeft.hour!)h \(timeLeft.minute!)m \(timeLeft.second!)s"
        
        // Show diffrent text when the event has passed
        endEvent(currentdate: currentDate, eventdate: eventDate)
    }
    
    func endEvent(currentdate: Date, eventdate: Date) {
        if currentdate >= eventdate {
            //timerLabel.text = "Happy New Year!"
            // Stop Timer
            eventLabel.isHidden = true
            timerLabel.isHidden = true
            passcodeTextField.isEnabled = true
            timer.invalidate()
        }else{
            eventLabel.isHidden =  false
            timerLabel.isHidden =  false
            
        }
    }
  
    
    @objc func login() {
           // 建立一個提示框
           let alertController = UIAlertController(title: "Registration", message: "Please enter your Nakename and Email", preferredStyle: .alert)
           
           // 建立兩個輸入框
           alertController.addTextField {
               (textField: UITextField!) -> Void in
               textField.placeholder = "Nickname"
           }
           alertController.addTextField {
               (textField: UITextField!) -> Void in
               textField.placeholder = "Email"
               textField.keyboardType = .emailAddress
               // 如果要輸入密碼 這個屬性要設定為 true
               //textField.isSecureTextEntry = true
           }

           // 建立[取消]按鈕
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           
           // 建立[登入]按鈕
           let okAction = UIAlertAction(title: "Sign Up", style: .default) {
               (action: UIAlertAction!) -> Void in
               let nickname = (alertController.textFields?.first)! as UITextField
               let email = (alertController.textFields?.last)! as UITextField
               
               print("Nickname : \(nickname.text!)")
               print("Email : \(email.text!)")
           }
           alertController.addAction(okAction)
           
           // 顯示提示框
           self.present(alertController, animated: true, completion: nil)
       }
  
    func postMethod() {
        /*
         The following commented code is about when you want to make a POST call with parameters, like consumer key, consumer secret e.t.c
         */
        
//        guard let components = URLComponents(string: "MY_URL") else {
//            print("Error: cannot create URLCompontents")
//            return
//        }
//        components.queryItems = [
//            URLQueryItem(name: "consumer_key", value: "MY_CONSUMER_KEY"),
//            URLQueryItem(name: "consumer_secret", value: "MY_CONSUMER_SECRET")
//        ]
//        guard let url = components.url else {
//            print("Error: cannot create URL")
//            return
//        }
        
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
        let uploadDataModel = UploadData(nickname: "Jack", email: "easonng@surgery.cuhk.edu.hk", code: "", step: "", distance: "")
        
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
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
  
    func openDetailsVC(jsonString: String, title: String) {
        detailsVCPrintedJson = jsonString
        detailsVCTitle = title
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "detailsseg", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailsseg" {
           // let destViewController = segue.destination as? DetailsViewController
           // destViewController?.title = detailsVCTitle
          //  destViewController?.jsonResults = detailsVCPrintedJson ?? ""
        }
    }
    
    
}

