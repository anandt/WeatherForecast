//
//  WFDBManager.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation
import CoreData


enum MOCType {
    case main
    case child
    case inMemory
}

enum CoreDataSaveResult {
    case success
    case failure(NSError)
    
    public func error() -> NSError? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
}
class WFDBManager {
    static let shared: WFDBManager = WFDBManager()
    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: String? = {
        guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                           FileManager.SearchPathDomainMask.userDomainMask,
                                                                           true).first else {
            return nil
        }
        return documentsDirectory
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "Weather_forecast", withExtension: "momd") else {
            return nil
        }
        guard let model = NSManagedObjectModel.init(contentsOf: modelURL) else {
            return nil
        }
        return model
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let model = self.managedObjectModel else {
            return nil
        }
        guard let documentDirectory = self.applicationDocumentsDirectory else {
            return nil
        }
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        let url = URL.init(fileURLWithPath: documentDirectory).appendingPathComponent("Weather_forecast")
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            let storeMetaData = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: url, options: options)
            let isPscCompatible = model.isConfiguration(withName: nil, compatibleWithStoreMetadata: storeMetaData)
        } catch {
        }
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            var dict = [String: AnyObject]()
            let failureReason = "Failed to initialize the application's persistentStore"
            dict[NSLocalizedDescriptionKey] = failureReason as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            
        }
        return coordinator
    }()
    
    private lazy var memoryResidentPSC: NSPersistentStoreCoordinator? = {
        guard let model = self.managedObjectModel else {
            return nil
        }
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        
        do {
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            let failureReason = "Failed to initialize the application's persistentStore"
            dict[NSLocalizedDescriptionKey] = failureReason as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            
        }
        return coordinator
    }()
    
    
    lazy var mainMOC: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var memoryResidentMOC: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.memoryResidentPSC
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func save(with mocType: MOCType, wait: Bool = false, completion: ((CoreDataSaveResult) -> Void)? = nil) {
        
        let moc = self.getMoc(for: mocType)
        let block = {
            if moc.hasChanges {
                do {
                    try moc.save()
                    completion?(CoreDataSaveResult.success)
                } catch {
                    let nserror = error as NSError
                    completion?(CoreDataSaveResult.failure(nserror))
                }
            }
        }
        wait ? moc.performAndWait(block) : moc.perform(block)
    }
    
    func getManagedObject(for entity: String, withMocType mocType: MOCType) -> NSManagedObject? {
        
        let moc = self.getMoc(for: mocType)
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: moc)
        guard let vEntityDescription = entityDescription else {
            return nil
        }
        return NSManagedObject.init(entity: vEntityDescription, insertInto: moc)
    }
    
    func getMoc(for mocType: MOCType) -> NSManagedObjectContext {
        
        switch mocType {
        case .inMemory:
            return memoryResidentMOC
        default:
            return mainMOC
        }
    }
    
    func getPscToUpdateCatalogDate() {
        _ = persistentStoreCoordinator
    }
    
}
