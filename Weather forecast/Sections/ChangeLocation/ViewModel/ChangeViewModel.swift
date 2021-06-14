//
//  ChangeViewModel.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation

class ChangeViewModel {
    
    init() {
    }
    var pinnedLocations: [LocationInformation]?
    
    func pinnedLocationSaveinDB(location: LocationInformation?) {
        if pinnedLocations == nil {
            pinnedLocations = [LocationInformation]()
        }
        if let locationData = location {
            if pinnedLocations?.firstIndex(where: { $0.city == locationData.city }) == nil {
                pinnedLocations?.append(locationData)
            }
        }
    }
    
    func saveDataToDatabase() {
        if let pinnedLoc = self.pinnedLocations {
            WFDBModel.saveBookMarkData(pinnedLoc)
        }
    }
}
