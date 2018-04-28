//
//  Stack.swift
//  Record
//
//  Created by Maksim Kolesnik on 20.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import CoreData

public class Stack {
    
    public static var main: Stack {
        assert(initialized != nil, "Stack  is not setup. Run `Stack.setup(stack:autoMigration:)`")
        return initialized!
    }
    
    public let store: Store
    public let coordinator: Coordinator
    public let context: Context

    private init(store: Store, coordinator: Coordinator, context: Context) {
        self.store = store
        self.coordinator = coordinator
        self.context = context
    }
    
    private static var initialized: Stack?
    
    private static var autoMigrationOptions: [AnyHashable: Any] {
        return [NSInferMappingModelAutomaticallyOption: true,
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSSQLitePragmasOption: ["journal_mode": "WAL"]]
    }
    
    private static var sqlitePragmasOption: [AnyHashable: Any] {
        return [NSSQLitePragmasOption: ["journal_mode": "WAL"]]
    }
    
    internal var _container: Any?
    
    @available(iOS 10.0, *)
    public var persistentContainer: NSPersistentContainer? {
        return _container as? NSPersistentContainer
    }
    
    @available(iOS 10.0, *)
    @discardableResult public static func setupUsingPersistentContainer(stack modelName: String) throws -> Stack {
        let container = NSPersistentContainer(name: modelName)
        var error: Error?
        container.loadPersistentStores(completionHandler: { (storeDescription, containeRerror) in
            error = containeRerror
        })
        if let error = error {
            throw error
        }
        let context = setupContext(container: container)
        let store = Store()
        let coordinator = Coordinator()
        let stack =  Stack(store: store, coordinator: coordinator, context: context)
        Stack.initialized = stack
        stack._container = container
        return stack
        
    }
    
    @discardableResult public static func setup(stack modelName: String, autoMigration: Bool = false) throws -> Stack {
        
        guard let urlForModel = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            throw RecordError(file: #file, function: #function, message: "Not found url to model '\(modelName)' in main bundle")
        }
        guard let model = NSManagedObjectModel(contentsOf: urlForModel) else {
            throw RecordError(file: #file, function: #function, message: "NSManagedObjectModel not created of url \(urlForModel)")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = urls[urls.endIndex - 1]
        let storeURL = documentsURL.appendingPathComponent("\(modelName).sqlite")
        
        do {
            // Adding the journalling mode recommended by apple
            let options = autoMigration ? autoMigrationOptions : sqlitePragmasOption
            let persistentStore = try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
            Log.log("added persistent store: \(persistentStore)", prefix: .record, type: .success)
        } catch {
            let nserror: NSError = error as NSError
            let isMigrationError = ((nserror.code == NSPersistentStoreIncompatibleVersionHashError) || (nserror.code == NSMigrationMissingSourceModelError) || (nserror.code == NSMigrationError))
            if isMigrationError {
                let rawURL = storeURL.absoluteString
                if let shmSidecar = URL(string: (rawURL + "-shm")) {
                    try? FileManager.default.removeItem(at: shmSidecar)
                }
                if let walSidecar = URL(string: (rawURL + "-wal")) {
                    try? FileManager.default.removeItem(at: walSidecar)
                }
                try? FileManager.default.removeItem(at: storeURL)
            }
            Log.log("error adding persistent store wit error: \(error)", prefix: .record, type: .error)

            //SuperPuperDuperData.logging.log("\(#function) not added persistent store because of a mistake \(error)")
            //let persistentStore = try? persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [NSSQLitePragmasOption: ["journal_mode":"DELETE"]])
            //            SuperPuperDuperData.logging.log("\(#function) added persistent store: \(String(describing: persistentStore))")
        }
        
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator

        let savingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        savingContext.performAndWait {
            savingContext.persistentStoreCoordinator = persistentStoreCoordinator
            savingContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }

        let context = setupContext(root: mainContext, saving: savingContext)
        let store = Store()
        let coordinator = Coordinator()
        let stack =  Stack(store: store, coordinator: coordinator, context: context)
        Stack.initialized = stack
        return stack
    }
    
    @available(iOS 10.0, *)
    internal static func setupContext(container: NSPersistentContainer) -> Context {
        let context = Context(container: container)
        Context.initialized = context
        return context
    }
    
    internal static func setupContext(root: NSManagedObjectContext, saving: NSManagedObjectContext) -> Context {
        let context = Context(root: root, saving: saving)
        Context.initialized = context
        
        return context
    }
    
}

