//
//  MainViewModel.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//


import Foundation
import CoreLocation
class MainViewModel {
    
    init() {
    }
    
    var bookmarkedData: [BookMarkPlace]?
    var locationForcast: TodayWeather?
    
    func getCurrentLocation(onSuccess: @escaping (LocationInformation?) -> Void)  {
        WFLocationManager.shared.start { (info) in
            onSuccess(info)
            WFLocationManager.shared.stop()
        }
    }
    
    
    func gettodaysWeatherData(location: LocationInformation?, onSuccess: @escaping (TodayWeather) -> Void,
                              onError: @escaping APIErrorHandler) {
        if let locData = location {
            WFDataManager.getTodayWeather(location: locData, onSuccess: { (dataSource) in
                self.locationForcast = dataSource
                onSuccess(dataSource)
            }) { (error) in
                onError(error)
            }
        }
    }
    
    func getbookMarkData() {
        bookmarkedData = APPDBUtility.getAllBookMarkedLocations()
    }
    
    func deleteBookMarkData(bookMark: BookMarkPlace) {
        if let data = bookmarkedData {
            if let indexOfItem = data.firstIndex(where: { ($0.city == bookMark.city) && ($0.zip == bookMark.zip)}) {
                bookmarkedData?.remove(at: indexOfItem)
                APPDBUtility.deleteBookMark(city: data[indexOfItem].city, zip: data[indexOfItem].zip)
            }
        }
    }
 
}
