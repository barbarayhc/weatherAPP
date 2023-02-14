//
//  WeatherData.swift
//  Clima
//
//  Created by Barbara Yan on 6/2/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

//Codable is a typealias that combined decodable protocal and encodable protocal into one protocal
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]  //because the weather is an Array
}

struct Main: Codable {
    let temp: Double
    
}


struct Weather: Codable {
    let description: String
    let id: Int
}
