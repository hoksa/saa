//
//  ViewController.swift
//  Saa
//
//  Created by Hannu Oksa on 13/01/2017.
//  Copyright © 2017 Hannu Oksa. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    var cenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    var fahLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        cenLabel.center = CGPoint(x: 160, y: 285)
        cenLabel.textAlignment = .center

        fahLabel.center = CGPoint(x: 160, y: 306)
        fahLabel.textAlignment = .center
        
        self.view.addSubview(cenLabel)
        self.view.addSubview(fahLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        
        let longitude = userLocation.coordinate.longitude
        
        let apiEndpoint: String = "http://api.openweathermap.org/data/2.5/weather?lat=" + String(latitude) + "&lon=" + String(longitude) + "&units=metric&appid=" + Api.key
        
        Alamofire.request(apiEndpoint)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }
                
                guard let json = response.result.value as? [String: Any],
                    let main = json["main"] as? [String: Any],
                    let tempCen = main["temp"] as? Int
                    else {
                        print(response.result.error!)
                        return
                    }
                
                print(json)
                
                let tempFah: Int = (tempCen * 9/5) + 32
                
                self.cenLabel.text = String(tempCen) + "°C"
                self.fahLabel.text = String(tempFah) + "°F"

            }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }


}

