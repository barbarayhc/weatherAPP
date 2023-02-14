//
//  WeatherManager.swift
//  Clima
//
//  Created by Barbara Yan on 1/2/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=22a8cf9f053d8a6c140143abc498efdc&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString) //pass over urlString into the performRequest function
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1.create a URL
        if let url = URL(string: urlString) {//initialize the url by using a structure and use urlString as the initialized value. Here the url is a optional value
        //2. create a URLsession
            let session = URLSession(configuration: .default)  //this is a thing that can perform the networking, like a browser
        //3. give the session a task
            //can use closure for the syntax because this completionHandler is the last parameter in the function
            let task = session.dataTask(with: url){(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!) //add self due to inside of a closure
                    return  //don't need to return anything, we just use RETURN to end the whole function: handle.
                }
                
                if let safeData = data {
                   // let dataString = String(data: safeData, encoding: .utf8)
                    //we can't see how does a Data data type look like, so first thing we convert it into a String, by using one of the String class's initializer, which is data, because it takes Data as input
                  //  print(dataString as Any)
                    if let weather = self.parseJson(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather) //in closure, needs to have self. before the delegate
                        //the weatherManager parameter takes the current object as the delegate
                        //the weatherManager parameter name is omitted here because the protocal set a _ to omit the parameter name 
                    }
                    
                    //if you are calling a method from the current class and you are in a closure, you need to add self before the function to not confuse the computer who is calling the method.
                    
                }}
            //this methord returns a URLSessionDataTask. so we can call the output a let task.
            //completionHandler takes a function as a value (as the input). The function returns nothing, so we need to create a function for completionHandler.
            //once the dataTask is completed, it will call the handle methord(function) in the completionHandler.
            //but we need to define the handle function outside of the scope, so the handle methord can be called from here.
            
        //4. start the task
            task.resume()
  
        }
    }
    
    func parseJson (_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //first parameter needs to be a data type, not a object, so need to add .self to change it into a data type.
            // decode function alerts error if the decode can't happen. in this case need to use do { try ....catch {}} this syntax
            // decode function will return a WeatherData object, so we need to create a variable to catch the output (this object).
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(cityName: name, temperature: temp, conditionId: id)
            print(weather)
            return weather
          } catch {
              delegate?.didFailWithError(error: error)
            return nil  //need to return something, anything
        }
    }
    
}

