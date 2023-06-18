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
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var passcodeLabel: UILabel!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var regButton: UIButton!
    let eventDateComponents = "2023-06-29 09:00:00 UTC"
    //let eventDateComponents =  eventDate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        regButton.addTarget(nil, action: #selector(ViewController.login), for: .touchUpInside)

        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label
        let url = URL(string: "https://b.easonng520.repl.co/api/events")!
          URLSession.shared.fetchData(for: url) { (result: Result<[Event], Error>) in
            switch result {
            case .success(let Event):
                print(Event[1].name)
                print(Event[1].date)
                DispatchQueue.main.async {
                    self.eventLabel.text = Event[1].name

                self.timerLabel.text = Event[1].date

                }
            case .failure(let error):
              // A failure, please handle
                print(error)
          }
        }

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
            timerLabel.text = "Happy New Year!"
            // Stop Timer
            timer.invalidate()
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
               let acc = (alertController.textFields?.first)! as UITextField
               let password = (alertController.textFields?.last)! as UITextField
               
               print("Nickname : \(acc.text!)")
               print("Email : \(password.text!)")
           }
           alertController.addAction(okAction)
           
           // 顯示提示框
           self.present(alertController, animated: true, completion: nil)
       }
       
    
}

