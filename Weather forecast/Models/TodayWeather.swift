//
//  TodayWeather.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation

struct TodayWeather: Decodable {
    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Double
    let wind: Wind
    let clouds: Clouds
    let dt: Int64
    let sys: Sys
    let timezone: Int64
    let id: Int64
    let name: String
    let cod: Int64
}

struct Coordinates: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let id: Int64
    let main: String
    let description: String
    let icon: String
   
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double
}
struct Clouds: Decodable {
    let all: Int64
}

struct Sys: Decodable {
    let type: Int64
    let id: Int64
    let country: String
    let sunrise: Double
    let sunset: Double
}
