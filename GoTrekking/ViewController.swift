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
   @IBAction func passCODE(_ sender: Any) {
        if passcodeTextField.text?.count == 6 {
            self.performSegue(withIdentifier: "Login", sender: self)
       passcodeTextField.text = ""
        getMethod()
        }
  }
   var eventDateComponents = "2023-06-23 19:59:00 UTC"
    override func viewDidLoad() {
      //  regButton.accessibilityIdentifier="regButton"
        //eventDateComponents = "2022-06-27 09:00:00 UTC"
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
                    //self.timerText.isHidden = false
                    //self.timerLabel.isHidden = false
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
            self.timerText.isHidden = true
            self.timerLabel.isHidden = true
            passcodeTextField.isEnabled = true
            timer.invalidate()
        }else{
            self.timerText.isHidden = false
            self.timerLabel.isHidden = false
            
        }
    }
    
    @objc func alert() {
        let alertController = UIAlertController(title: "!", message: "Msg", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            //print("error")
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func getMethod() {
       
       guard var components = URLComponents(string: "https://b.easonng520.repl.co/api/trekkers/code") else {
            print("Error: cannot create URLCompontents")
            return
        }
        components.queryItems = [
            URLQueryItem(name: "code", value: passcodeTextField.text),
        ]
        guard let url = components.url else {
            print("Error: cannot create URL")
            return
        }
        /*
        guard let url = URL(string: "https://b.easonng520.repl.co/api/trekkers/1") else {
            print("Error: cannot create URL")
            return
        }
         */
        print(url)
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
//        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
         
            
            guard error == nil else {
                print("Error: error calling GET")
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
                    print("Error: Could print JSON in String")
                    return
                }
                
                self.openDetailsVC(jsonString: prettyPrintedJson, title: "GET METHOD")
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func openDetailsVC(jsonString: String, title: String) {
        detailsVCPrintedJson = jsonString
        detailsVCTitle = title
        
       // DispatchQueue.main.async {
        //    self.performSegue(withIdentifier: "detailsseg", sender: self)
       // }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //if segue.identifier == "detailsseg" {
          //  let destViewController = segue.destination as? DetailsViewController
           // destViewController?.title = detailsVCTitle
           // destViewController?.jsonResults = detailsVCPrintedJson ?? ""
       // }
    }
    
}
