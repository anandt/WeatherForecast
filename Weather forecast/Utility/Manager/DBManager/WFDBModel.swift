//
//  WFDBModel.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
class WFDBModel {
    
    // MARK: - Save User In CoreData
    class func saveBookMarkData(_ locationData: [LocationInformation], mocType: MOCType = .main) {
        for location in locationData {
            APPDBCommon.addOrUpdateBookMark(with: location, onSuccess: { (dbUser) in
                print(dbUser ?? "")
            })
        }
        WFDBManager.shared.save(with: mocType, wait: true)
    }
}
