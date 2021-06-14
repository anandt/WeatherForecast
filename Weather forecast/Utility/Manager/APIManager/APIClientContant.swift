//
//  APIClientContant.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation

typealias APIMethod = HttpMethod

typealias APIHeaders = [String: String]
typealias APIParameter = [String: Any]?
typealias APIErrorHandler = (APIError) -> Void


enum APIClientConstants {
    static let reqTimeOutSeconds: TimeInterval = 100.0
}


enum APIHeadersType {
    static let accept: String = "accept"
    static let content: String = "Content-Type"
    static let json: String = "application/json"
    static let Authorization: String = "Authorization"
    static let urlEncoded: String = "application/x-www-form-urlencoded"
    
}
