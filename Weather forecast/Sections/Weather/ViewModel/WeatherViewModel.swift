//
//  WeatherViewModel.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import UIKit

class WeatherViewModel {
    
    
    init() {
    }
    
    var futureForcast: FutureWeather?
    var displayData: [String: [List]]?
    var sortedKeys: [String]?

    func getFutureWeatherData(location: BookMarkPlace?, onSuccess: @escaping (FutureWeather) -> Void,
                              onError: @escaping APIErrorHandler) {
        if let locData = location {
            WFDataManager.getFutureWeather(location: locData, onSuccess: { (dataSource) in
                self.futureForcast = dataSource
                self.sortDisplayData()
                onSuccess(dataSource)
            }) { (error) in
                onError(error)
            }
        }
    }
    
    func sortDisplayData() {
        if let data = futureForcast {
            let sortedData = Dictionary(grouping: data.list, by: {WFUtility.convertSecondsToDateForConversion(seconds: Double($0.dt))})
            self.displayData = sortedData
            sortedKeys = WFUtility.sortDateArray(dateArray: Array(sortedData.keys))
        }
    }

    
}
