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
    
    
    //开始获取步数计数据
    func startPedometerUpdates() {
        steps.text = ""
        
        //判断设备支持情况
        if CMPedometer.isStepCountingAvailable() {
            //初始化并开始实时获取数据
            self.pedometer.startUpdates (from: Date(), withHandler: {
                pedometerData, error in
                //错误处理
                guard error == nil else {
                    print(error!)
                    return
                }
                
                //获取各个数据
                var text = ""
                if let distance = pedometerData?.distance {
                    //text += "行走距离: \(distance)\n"
                }
                if let numberOfSteps = pedometerData?.numberOfSteps {
                    text += "\(numberOfSteps)"
                }
                
                //在线程中更新文本框数据
                DispatchQueue.main.async{
                    self.steps.text = text
                }
            })
        
        }else {
            self.steps.text = ""
            return
        }
    }
    
    //开始获取GPS数据
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
    
    //定位数据更新
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            //获取各个数据
            traveledDistance += lastLocation.distance(from: location)
            let lineDistance = startLocation.distance(from: locations.last!)
            var text = ""
            text += "\(round(traveledDistance/1000))"
            //text += "直线距离: \(lineDistance)\n"
            print(text)
            self.gps.text = text
            
        }
        lastLocation = locations.last
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
 
    
    
}
