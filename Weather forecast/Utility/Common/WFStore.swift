//
//  WFStore.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
class WFStore {
    static let shared: WFStore = WFStore()
    var currentLocation: LocationInformation?
    var selectedUnit: String?
}
