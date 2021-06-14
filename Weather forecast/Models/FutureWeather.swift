//
//  FutureWeather.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation

struct FutureWeather: Decodable {
    let cod: String
    let message: Int64
    let cnt: Int64
    let list: [List]
    let city: City
}

struct List: Decodable {
    let dt: Int64
    let main: MainList
    let weather: [Weather]
    let clouds: Clouds
    let wind: WindList
    let visibility: Int64
    let pop: Double
    let sys: SysList
    let dt_txt: String
    
   
}

struct MainList: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let sea_level: Double
    let grnd_level: Double
    let humidity: Double
    let temp_kf: Double
}

struct WindList: Decodable {
    let speed: Double
    let deg: Double
    let gust: Double
}

struct SysList: Decodable {
    let pod: String
}


struct City: Decodable {
    let id: Int64
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int64
    let timezone: Int64
    let sunrise: Int64
    let sunset: Int64
}
