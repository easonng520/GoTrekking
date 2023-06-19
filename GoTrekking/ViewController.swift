//
//  AppDelegate.swift
//  GoTrekking
//
//  Created by eazz on 9/6/2023.
//

import UIKit
import MapKit
import CoreMotion

class ViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet var postMethodButton: UIButton!
    @IBOutlet var getMethodButton: UIButton!
    @IBOutlet var putMethodButton: UIButton!
    @IBOutlet var deleteMethodButton: UIButton!
    
    @IBOutlet weak var eventName: UINavigationItem!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nickname: UITextField!

    //Timer
    var timer: Timer!
    var eventDateComponents = "2023-06-29 09:00:00 UTC"
    @IBOutlet weak var timerLabel: UILabel!
    //timer

    //Step
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    let pedometer = CMPedometer()
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance: Double = 0
    //Step
    
    
    var detailsVCPrintedJson: String?
    var detailsVCTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Start Timer
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.UpdateTime), userInfo: nil, repeats: true)
        //Start Timer
        
        //Get Event Date
        let url = URL(string: "https://b.easonng520.repl.co/api/events")!
          URLSession.shared.fetchData(for: url) { (result: Result<[Event], Error>) in
            switch result {
            case .success(let Event):
                print(Event[0].name)
                print(Event[0].date)
                DispatchQueue.main.async {
                    self.navigationController?.title = Event[0].name
                // self.eventName.text = Event[0].name
              // self.eventDateComponents = Event[0].date
                               }
            case .failure(let error):
              // A failure, please handle
              //self.eventDateComponents = "2022-06-29 09:00:00 UTC"
                print(error)
          }
        }
       //Get Event Data
        NetworkMonitor.shared.startMonitoring()
        
    }
    
 
    
    @IBAction func postMethodAction(_ sender: UIButton) { postMethod() }
    
    @IBAction func getMethodAction(_ sender: UIButton) { getMethod() }
    
    @IBAction func putMethodAction(_ sender: UIButton) { putMethod() }
    
    @IBAction func deleteMethodAction(_ sender: UIButton) { deleteMethod() }
    
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
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
             
        }.resume()
    }
    
    func getMethod() {
        /*
         The following commented code is about when you want to make a GET call with parameters, like consumer key, consumer secret e.t.c
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
        guard let url = URL(string: "https://b.easonng520.repl.co/api/events") else {
            print("Error: cannot create URL")
            return
        }
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
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func putMethod() {
        /*
         The following commented code is about when you want to make a PUT call with parameters, like consumer key, consumer secret e.t.c
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
        guard let url = URL(string: "https://reqres.in/api/users/2") else {
            print("Error: cannot create URL")
            return
        }
        
        // Create model
        struct UploadData: Codable {
            let name: String
            let job: String
        }
        
        // Add data to the model
        let uploadDataModel = UploadData(name: "Nicole", job: "iOS Developer")
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
//        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling PUT")
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
                
                self.openDetailsVC(jsonString: prettyPrintedJson, title: "PUT METHOD")
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func deleteMethod() {
        /*
         The following commented code is about when you want to make a DELETE call with parameters, like consumer key, consumer secret e.t.c
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
        guard let url = URL(string: "https://my-json-server.typicode.com/typicode/demo/posts/1") else {
            print("Error: cannot create URL")
            return
        }
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
//        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
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
                    print("Error: Cannot convert data to JSON")
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
                
                self.openDetailsVC(jsonString: prettyPrintedJson, title: "DELETE METHOD")
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
            let destViewController = segue.destination as? DetailsViewController
            destViewController?.title = detailsVCTitle
            destViewController?.jsonResults = detailsVCPrintedJson ?? ""
        }
    }
    
    @IBAction func startButtonTap(_ sender: Any) {
        let button = sender as! UIButton
        if( button.titleLabel?.text == "Start Trekking" ){
            startPedometerUpdates()
            startLocationUpdates()
            button.setTitle("Finish Trekking", for: .normal)
        }else{
            self.pedometer.stopUpdates()
            self.locationManager.stopUpdatingLocation()
             button.isEnabled = false
            //button.setTitle("Start Trekking", for: .normal)
        }
    }
    
    func startPedometerUpdates() {
        label1.text = ""
          if CMPedometer.isStepCountingAvailable() {
           
            self.pedometer.startUpdates (from: Date(), withHandler: {
                pedometerData, error in
               
                guard error == nil else {
                    print(error!)
                    return
                }
                
                //获取各个数据
                var text = "--- Steps ---\n"
                if let distance = pedometerData?.distance {
                    text += "Distance: \(distance)\n"
                }
                if let numberOfSteps = pedometerData?.numberOfSteps {
                    text += "Steps: \(numberOfSteps)\n"
                }
                
                //在线程中更新文本框数据
                DispatchQueue.main.async{
                    self.label1.text = text
                    print(text)
                }
            })
        
        }else {
            self.label1.text = "\nNot Support\n"
            return
        }
    }
    
    //GPS
    func startLocationUpdates() {
        label2.text = ""
        startLocation = nil
        traveledDistance = 0
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.distanceFilter = 10
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            
            traveledDistance += lastLocation.distance(from: location)
            let lineDistance = startLocation.distance(from: locations.last!)
            var text = "--- GPS ---\n"
            text += "Distance: \(traveledDistance)\n"
            text += "lineDistance: \(lineDistance)\n"
            label2.text = text
            print(text)
        }
        lastLocation = locations.last
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
 
    //Timer
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
        timerLabel.text = "Event will start in\n\(timeLeft.day!)d \(timeLeft.hour!)h \(timeLeft.minute!)m \(timeLeft.second!)s"
        
        // Show diffrent text when the event has passed
        endEvent(currentdate: currentDate, eventdate: eventDate)
    }
    
    func endEvent(currentdate: Date, eventdate: Date) {
        if currentdate >= eventdate {
            //timerLabel.text = "Happy New Year!"
            // Stop Timer
           // eventLabel.isHidden = true
            //timerLabel.isHidden = true
            //passcodeTextField.isEnabled = true
            timer.invalidate()
        }else{
            //eventLabel.isHidden =  false
            timerLabel.isHidden =  false
            
        }
    }
    //Timer
    
    
}
