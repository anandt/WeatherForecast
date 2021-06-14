//
//  DBUtility.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
import CoreData


class APPDBUtility {
    
    // MARK: - Get All Bookmarked Data from Table
    class func getAllBookMarkedLocations() -> [BookMarkPlace]? {
        let moc = WFDBManager.shared.getMoc(for: .main)
        let fetchRequest = NSFetchRequest<BookMarkPlace>.init(entityName: WFDBConstants.BookMarkPlace)
        do {
            let locationList: [BookMarkPlace] = try moc.fetch(fetchRequest)
            return locationList.isEmpty ? nil : locationList
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}



extension APPDBUtility {
    // MARK: - Deleting all Data from Bookmark Table
    class func deleteBookMark(city: String?, zip: String?) {
        let moc = WFDBManager.shared.getMoc(for: .main)
        let categoryFetchRequest = NSFetchRequest<BookMarkPlace>.init(entityName: WFDBConstants.BookMarkPlace)
        if let fetchRequest = categoryFetchRequest as? NSFetchRequest<NSFetchRequestResult> {
            if let cityIs = city, let zipCode = zip {
                let predicate = NSPredicate(format: "city == %@ AND zip == %@", cityIs, zipCode)
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
            }
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeStatusOnly
            do {
                let isSuccess = try moc.execute(deleteRequest)
                print("Catogory Data Deletion - \(isSuccess)")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    class func deleteAllBookMarks() {
        let moc = WFDBManager.shared.getMoc(for: .main)
        let categoryFetchRequest = NSFetchRequest<BookMarkPlace>.init(entityName: WFDBConstants.BookMarkPlace)
        if let fetchRequest = categoryFetchRequest as? NSFetchRequest<NSFetchRequestResult> {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeStatusOnly
            do {
                let isSuccess = try moc.execute(deleteRequest)
                print("Catogory Data Deletion - \(isSuccess)")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
}
