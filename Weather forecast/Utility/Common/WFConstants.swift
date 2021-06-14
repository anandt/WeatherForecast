//
//  WFConstants.swift
//  Weather forecast
//
//  Created by TSHYDLOFC00110 on 13/06/21.
//

import Foundation


// MARK: - Application URL's
struct APPURL {
    static let baseUrl = getBaseURL()
    static func getTodayWeather(location: LocationInformation) -> String {
        return "weather?lat=\(String(describing: location.latitude ?? 0))&lon=\(String(describing: location.longitude ??  0))&appid=\(APIKeys.apiKey)"
    }
    static func getFutureForcast(location: BookMarkPlace?) -> String {
        return "forecast?lat=\(String(describing: location?.latitude ?? 0))&lon=\(String(describing: location?.longitude ?? 0))&appid=\(APIKeys.apiKey)"
    }
    static func getBaseURL() -> String {
        return "https://api.openweathermap.org/data/2.5/"
    }
}

// MARK: - API Key for Weather API
struct APIKeys {
    static let apiKey = "7cf7a6e2f571d051670a118e7a9d4efb"
}
// MARK: - Units for Temperature
struct Units {
    static let Celsius = "Celsius"
    static let Fahrenheit = "Fahrenheit"
}
// MARK: - Day
struct Day {
    static let Morning = "Morning"
    static let Afternoon = "Afternoon"
    static let Evening = "Evening"
    static let Night = "Night"
}


struct APPUserDefaults {
    static let TemperatureUnits: String = "TemperatureUnits"
}

struct APPNotification {
    static let TemperatureChangeNotification: String = "TemperatureChangeNotification"
}
// MARK: - Date Formats
struct DateFormats {
    static let displayFormat: String = "dd MMM yyyy"
    static let timeFormat: String = "hh:mm a"
    static let conversionDateFormat: String = "dd-MM-yyyy"
}

// MARK: - HTTP Methods
enum HttpMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}
// MARK: - Tableview Identifiers
enum TableViewCellIdentifiers: String {
    case MainCurrentCellIdentiier = "MainCurrentCellIdentiier"
    case BookMarkCellIdentiier = "BookMarkCellIdentiier"
    case WeatherCellIdentifier = "WeatherCellIdentifier"
}

// MARK: - Database Tables
struct WFDBConstants {
    static let BookMarkPlace: String = "BookMarkPlace"
}
