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
    let eventDateComponents = "2038-12-24 18:00:00 UTC"
    //let eventDateComponents =  eventDate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true) // Repeat "func Update() " every second and update the label
        let url = URL(string: "https://b.easonng520.repl.co/api/events")!
          URLSession.shared.fetchData(for: url) { (result: Result<[Event], Error>) in
            switch result {
            case .success(let Event):
              // A list of todos!
                print(Event[1].date)
                DispatchQueue.main.async {

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
    
    
}

