//
//  WFDataManager.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
class WFDataManager  {
    // MARK: - API call to get weather data

    class func getTodayWeather(location: LocationInformation, onSuccess: @escaping (TodayWeather) -> Void,
                               onError: @escaping APIErrorHandler) {
        let urlString = APPURL.getBaseURL() + APPURL.getTodayWeather(location: location)
        guard let url = URL(string: urlString) else { return  }
        APIClient.defaultAPISession.makeAPIRequest(toURL: url, withHttpMethod: HttpMethod.get, completion: { (results) in
            if let data = results.data {
                let decoder = JSONDecoder()
                guard let todayData = try? decoder.decode(TodayWeather.self, from: data) else { return }
                onSuccess(todayData)
            } else {
                if let statuscode = results.response?.httpStatusCode {
                    let errorData = APIError(statuscode, results.error.debugDescription)
                    onError(errorData)
                } else {
                    let errorData = APIError(results.response?.httpStatusCode ?? 400, results.error.debugDescription)
                    onError(errorData)
                }
            }
        })
    }
    // MARK: - API call to get weather  Data
    class func getFutureWeather(location: BookMarkPlace?, onSuccess: @escaping (FutureWeather) -> Void,
                               onError: @escaping APIErrorHandler) {
        let urlString = APPURL.getBaseURL() + APPURL.getFutureForcast(location: location)
        guard let url = URL(string: urlString) else { return  }
        APIClient.defaultAPISession.makeAPIRequest(toURL: url, withHttpMethod: HttpMethod.get, completion: { (results) in
            if let data = results.data {
                let decoder = JSONDecoder()
                guard let futureData = try? decoder.decode(FutureWeather.self, from: data) else { return }
                onSuccess(futureData)
            } else {
                if let statuscode = results.response?.httpStatusCode {
                    let errorData = APIError(statuscode, results.error.debugDescription)
                    onError(errorData)
                } else {
                    let errorData = APIError(results.response?.httpStatusCode ?? 400, results.error.debugDescription)
                    onError(errorData)
                }
            }
        })
    }
}
