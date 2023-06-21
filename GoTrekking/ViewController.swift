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

    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var passcodeLabel: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var or: UILabel!
    
    @IBAction func regButton(_ sender: Any) {
    }
    
    
    var eventDateComponents = "2023-06-27 09:00:00 UTC"
    override func viewDidLoad() {
        eventTitle.isHidden = true
        eventDate.isHidden = true
        timerText.isHidden = true
        timerLabel.isHidden = true
        passcodeLabel.isHidden = true
        passcodeTextField.isHidden = true
        or.isHidden = true
        regButton.isHidden = true
        passcodeTextField.isEnabled = true
        
        
        let url = URL(string: "https://b.easonng520.repl.co/api/events")!
        URLSession.shared.fetchData(for: url) { (result: Result<[Event], Error>) in
            switch result {
            case .success(let Event):
                print(Event[0].name)
                print(Event[0].date)
                DispatchQueue.main.async {
                    // self.navTitle.title = Event[0].name
                    self.eventTitle.text = Event[0].name
                    self.eventDate.text = Event[0].date
                    
                    self.eventTitle.isHidden = false
                    self.eventDate.isHidden = false
                    self.timerText.isHidden = false
                    self.timerLabel.isHidden = false
                    self.passcodeLabel.isHidden = false
                    self.passcodeTextField.isHidden = false
                    self.or.isHidden = false
                    
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
           
            // Stop Timer
   //         eventLabel.isHidden = true
    //        timerLabel.isHidden = true
            passcodeTextField.isEnabled = true
            timer.invalidate()
        }else{
            //eventLabel.isHidden =  false
            //timerLabel.isHidden =  false
            
        }
    }
    
    
    
}
