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
    //Step
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
   
    
    
    
    
 
    
    
}
