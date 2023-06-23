//
//  Singin.swift
//  GoTrekking
//
//  Created by eazz on 21/6/2023.
//

import Foundation
import MapKit
import CoreMotion
import UIKit
import CoreLocation

class Login: UIViewController,CLLocationManagerDelegate {
    //Step

    let pedometer = CMPedometer()
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance: Double = 0
    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var gps: UILabel!
    @IBOutlet weak var startTrekking: UIButton!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func startTrekking(_ sender: Any) {
        startPedometerUpdates()
        startLocationUpdates()
            
    }
    
    
    func startPedometerUpdates() {
        steps.text = ""
        
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates (from: Date(), withHandler: {
                pedometerData, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                
                var text = ""
                if let distance = pedometerData?.distance {
               var text1 = distance
                }
                if let numberOfSteps = pedometerData?.numberOfSteps {
                    text += "\(numberOfSteps)"
                }
                
                DispatchQueue.main.async{
                    self.steps.text = text
                }
            })
        
        }else {
            self.steps.text = ""
            return
        }
    }
    
    func startLocationUpdates() {
        gps.text = ""
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
            self.gps.text = ""
            traveledDistance += lastLocation.distance(from: location)
            //let lineDistance = startLocation.distance(from: locations.last!)
            //var text = ""
                gps.text = " \(String(format:"%.02f", traveledDistance/1000)) KM"
            //text += "\(traveledDistance)/100000.00"
           //text+="km"
            //var text1 = "\(lineDistance)"
           // gps.text = text
           // print(text)
            
        }
        lastLocation = locations.last
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
 
    
    
}
