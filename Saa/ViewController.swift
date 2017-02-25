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
import SnapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    let savedWeatherData = UserDefaults.standard

    var cenLabel = UILabel()
    
    var fahLabel = UILabel()

    var locLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        restorationIdentifier = "ViewController"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        cenLabel.font = UIFont.systemFont(ofSize: 72, weight: UIFontWeightBlack)

        fahLabel.font = UIFont.systemFont(ofSize: 72, weight: UIFontWeightBlack)

        locLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFontWeightMedium)
        locLabel.textColor = UIColor.lightGray
 
        if let tempCen = savedWeatherData.object(forKey: "tempCen") as? Int {
            cenLabel.text = String(tempCen) + "°C"
        }

        if let tempFah = savedWeatherData.object(forKey: "tempFah") as? Int {
            fahLabel.text = String(tempFah) + "°F"
        }

        if let location = savedWeatherData.object(forKey: "location") as? String {
            locLabel.text = location
        }
        
        self.view.addSubview(cenLabel)
        self.view.addSubview(fahLabel)
        self.view.addSubview(locLabel)
        
        cenLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(locLabel.snp.bottom)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        
        fahLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cenLabel.snp.bottom).offset(-18)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }

        locLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(40)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
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
                    let tempCen = main["temp"] as? Int,
                    let location = json["name"] as? String
                    else {
                        print(response.result.error!)
                        return
                    }
                
                let tempFah: Int = (tempCen * 9/5) + 32
                
                self.cenLabel.text = String(tempCen) + "°C"
                self.fahLabel.text = String(tempFah) + "°F"
                self.locLabel.text = location
                                
                self.savedWeatherData.set(tempCen, forKey: "tempCen")
                self.savedWeatherData.set(tempFah, forKey: "tempFah")
                self.savedWeatherData.set(location, forKey: "location")
            }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }


}

