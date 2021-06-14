//
//  WFDBCommon.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
import CoreData

class APPDBCommon {
    
    
    // MARK: - Adding Bookmark Data to Database

    class func addOrUpdateBookMark(with data: LocationInformation, mocType: MOCType = .main, onSuccess: @escaping (BookMarkPlace?) -> Void) {
        self.getBookMarkDataFromDB(with: data.city, mocType: mocType) { (location) in
            var bookMarkLocation = location
            if bookMarkLocation == nil {
                bookMarkLocation = WFDBManager.shared.getManagedObject(for: WFDBConstants.BookMarkPlace, withMocType: mocType) as? BookMarkPlace
            }
            if let bookMarkData = bookMarkLocation {
                bookMarkData.city = data.city
                bookMarkData.latitude = Double(data.latitude ?? 0)
                bookMarkData.longitude = Double(data.longitude ?? 0)
                bookMarkData.zip = data.zip
                bookMarkData.country = data.country
                
            }
            onSuccess(bookMarkLocation)
        }
    }
    
    private class func getBookMarkDataFromDB(with city: String?, mocType: MOCType, onFetch: @escaping (BookMarkPlace?) -> Void) {
        let mainMOC = WFDBManager.shared.getMoc(for: mocType)
        mainMOC.performAndWait {
            if let cityIs = city {
                let fetchRequest = NSFetchRequest<BookMarkPlace>.init(entityName: WFDBConstants.BookMarkPlace)
                fetchRequest.predicate = NSPredicate.init(format: "city == %@", cityIs)
                do {
                    let sort = NSSortDescriptor(key: #keyPath(BookMarkPlace.city), ascending: true)
                    fetchRequest.sortDescriptors = [sort]
                    let locationList = try mainMOC.fetch(fetchRequest)
                    let user = locationList.isEmpty ? nil : locationList.first
                    onFetch(user)
                } catch let error as NSError {
                    print(error)
                    onFetch(nil)
                }
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
