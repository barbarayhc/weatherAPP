//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var weatherManger = WeatherManager()
    let locationManager = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //request user permission of using their location
        locationManager.requestLocation()
        
        weatherManger.delegate = self //need to set this WeatherViewController as the delegate of weatherManager
        //this WeatherviewController is the delegate of the textField
        searchTextField.delegate = self
        
        
    }
    
}

//MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        //to dismiss the keyboard after click search button
        searchTextField.endEditing(true)
        //print(searchTextField.text!)
    }
    
    //a function that makes the return button on keyboard work (in this case the GO button)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        //print(searchTextField.text!)
        return true
    }
    
    //input validation: if user hasn't input anything, we can remind them to type something.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please enter a city"
            return false
        }
    }
    //clear textField after enter return key
    func textFieldDidEndEditing(_ textField: UITextField) {
        //to make sure city is not nil, as city here is a optional string data type
        if let city = searchTextField.text {
            weatherManger.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
   
}


//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {

    func didUpdateWeather (_ weatherMananger: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { //due to the completion handler takes long time to do the networking, we use this line of code to prevent the APP crashs due to long time waiting for the data fetch
            self.temperatureLabel.text = weather.temperatureString //this is a closure, use self
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}



//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("found location")
       if let location = locations.last {
           locationManager.stopUpdatingLocation()
           let lat = location.coordinate.latitude
           let lon = location.coordinate.longitude
           weatherManger.fetchWeather(latitude: lat, longitude: lon)
       }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
