//
//  WFUtility.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
import UIKit
struct WFUtility {
    
    // MARK: - Converting Temperature into Units
    static func convertIntoTemp(temp: Double) -> String {
        let inTemp: UnitTemperature = .kelvin
        var outTemp: UnitTemperature = .celsius
        if let userSelectedUnits = UserDefaults.standard.value(forKey: APPUserDefaults.TemperatureUnits) as? String {
            switch userSelectedUnits {
            case Units.Celsius:
                outTemp = .celsius
            default:
                outTemp = .fahrenheit
            }
        }
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inTemp)
        let output = input.converted(to: outTemp)
        return mf.string(from: output)
    }
    
    // MARK: - Date Converters
    static func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.displayFormat
        let dateString = dateFormatter.string(from: Date())
        return  dateString
    }
    
    static func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.timeFormat
        let dateString = dateFormatter.string(from: Date())
        return  dateString
    }
    
    static func convertSecondsToTime(seconds: Double) -> String {
        let date = Date(timeIntervalSince1970: seconds)
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormats.timeFormat
        let formattedTime = formatter.string(from: date)
        return formattedTime
    }
    
    static func convertSecondsToDate(seconds: Double) -> String {
        let date = Date(timeIntervalSince1970: seconds)
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormats.displayFormat
        let formattedTime = formatter.string(from: date)
        return formattedTime
    }
    
    static func convertSecondsToDateForConversion(seconds: Double) -> String {
        let date = Date(timeIntervalSince1970: seconds)
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormats.displayFormat
        let formattedTime = formatter.string(from: date)
        return formattedTime
    }
    
    // MARK: - Date sorters
    static func sortDateArray(dateArray: [String]?) -> [String]? {
        if let data = dateArray {
            var convertedDateArray: [Date] = []
            var convertedStringArray: [String] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormats.displayFormat// yyyy-MM-dd"
            for dat in data {
                let date = dateFormatter.date(from: dat)
                if let date = date {
                    convertedDateArray.append(date)
                }
            }
            let sortedDateArray = convertedDateArray.sorted(by: { $0.compare($1) == .orderedAscending })
            for sortedDate in sortedDateArray {
                let dateString = dateFormatter.string(from: sortedDate)
                convertedStringArray.append(dateString)
            }
            return convertedStringArray
        }
        return nil
    }
    
    
    static func convertLocationToBookMarkedData(location: LocationInformation?) -> BookMarkPlace? {
        if let data = location {
            if let  bookMarkLocation = WFDBManager.shared.getManagedObject(for: WFDBConstants.BookMarkPlace, withMocType: .inMemory) as? BookMarkPlace {
                bookMarkLocation.city = data.city
                bookMarkLocation.latitude = data.latitude ?? 0
                bookMarkLocation.longitude = data.longitude ?? 0
                bookMarkLocation.country = data.country
                bookMarkLocation.zip = data.zip
                return bookMarkLocation
            }
        }
        return nil
    }
    
    static func setUnitsValue() {
        if UserDefaults.standard.value(forKey: APPUserDefaults.TemperatureUnits) == nil {
            UserDefaults.standard.setValue(Units.Celsius, forKeyPath: APPUserDefaults.TemperatureUnits)
            WFStore.shared.selectedUnit = APPUserDefaults.TemperatureUnits
        } else {
            if let units = UserDefaults.standard.value(forKey: APPUserDefaults.TemperatureUnits) as? String {
                WFStore.shared.selectedUnit = units
            }
        }
    }
    
    static func imageToShow() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return Day.Morning
        case 12..<16:
            return Day.Afternoon
        case 16..<19:
            return Day.Evening
        default:
            return Day.Night
        }
    }
    
    
    static func setImageIImageName(image: String?) -> String? {
        var imageToShow = ""

        switch image {
        case Day.Morning:
            imageToShow = "morning.png"
        case Day.Afternoon:
            imageToShow = "afternoon.png"
        case Day.Evening:
            imageToShow = "evening.png"
        default:
            imageToShow = "night.png"
        }
        return imageToShow
    }
}
