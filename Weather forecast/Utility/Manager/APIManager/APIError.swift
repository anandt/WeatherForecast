//
//  APIError.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
struct APIError {
    let statusCode: Int
    let statusMessage: String
    init(_ code: Int, _ msg: String) {
        self.statusCode = code
        self.statusMessage = msg
    }
}
struct LocationError {
    let errorMessage: String
    init(_ msg: String) {
        self.errorMessage = msg
    }
}
