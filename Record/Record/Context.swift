//
//  Context.swift
//  Record
//
//  Created by Maksim Kolesnik on 20.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation
import CoreData


public typealias SaveCompletionHandler = (Bool, Error?) -> ()

public class Context {
    
    public static var main: Context {
        assert(initialized != nil, "Context is not setup")
        return initialized!
    }
    
    public var root: NSManagedObjectContext
    public var saving: NSManagedObjectContext
    
    public init(root: NSManagedObjectContext, saving: NSManagedObjectContext) {
        self.root = root
        self.saving = saving
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension Context {
    public static func save(with block: @escaping (NSManagedObjectContext) -> Void) throws {
        let savingContext = Context.main.saving
        let local = context(with: savingContext)
        var returnedError: Error?
        local.performAndWait {
            block(local)
            do { try saveToPersistentStore(local) }
            catch { returnedError = error }
        }
        if let error = returnedError { throw error }

    }
    
    public static func save(changes: @escaping (NSManagedObjectContext) -> Void, completion: SaveCompletionHandler?) {
    let savingContext = Context.main.saving
    let local = context(with: savingContext)
        local.perform {
            changes(local)
            saveToPersistentStore(local, completion: completion)
        }
    }
    
}
extension Context {

    public static func newPrivateQueuContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        Log.log("Created new private queue context: \(context)", prefix: .record, type: .success)
        return context
    }
    
    public static func context(with parent: NSManagedObjectContext) -> NSManagedObjectContext {
        let context = newPrivateQueuContext()
            context.parent = parent
        obtainPermanentIDsBeforeSaving(context)
        return context
    }
    
    private static func obtainPermanentIDsBeforeSaving(_ context: NSManagedObjectContext) {
        NotificationCenter.default.addObserver(Context.main, selector: #selector(contextWillSave(_:)), name: Notification.Name.NSManagedObjectContextWillSave, object: context)
    }
    
    @objc func contextWillSave(_ motification: Notification) {
        guard let context = motification.object as? NSManagedObjectContext else { return }
        let insertedObjects = context.insertedObjects
        
        if insertedObjects.count > 0 {
            try? context.obtainPermanentIDs(for: Array(insertedObjects))
        }
    }
    
    internal static var initialized: Context?
}

extension Context {
    public struct SavingOptions: OptionSet {
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        static let onlySelf = SavingOptions(rawValue: 1 << 1)
        static let withParent = SavingOptions(rawValue: 1 << 2)
        static let synchronously = SavingOptions(rawValue: 1 << 3)
    }
}

extension Context {
    public static func saveOnlySelf(_ context: NSManagedObjectContext) throws {
        var returnedError: Error?
        save(with: context, options: [.onlySelf, .synchronously], completion: { (success, error) in
            if let error = error { returnedError = error }
        })
        if let returnedError = returnedError { throw returnedError }
    }
    
    public static func saveOnlySelf(_ context: NSManagedObjectContext, completion: SaveCompletionHandler?) {
        save(with: context, options: .onlySelf, completion: completion)
    }
    
    public static func saveToPersistentStore(_ context: NSManagedObjectContext) throws {
        var returnedError: Error?
        save(with: context, options: [.withParent, .synchronously], completion: { (success, error) in
            if let error = error { returnedError = error }
        })
      if let returnedError = returnedError { throw returnedError }
    }
    
    public static func saveToPersistentStore(_ context: NSManagedObjectContext, completion: SaveCompletionHandler?) {
        save(with: context, options: .withParent, completion: completion)

    }
}

extension Context {
    static public func save(with context: NSManagedObjectContext, options: SavingOptions, completion: SaveCompletionHandler?) {
        var hasChanges = false
        
        if context.concurrencyType == NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType {
            hasChanges = context.hasChanges
        } else {
            context.performAndWait {
                hasChanges = context.hasChanges
            }
        }
        
        if !hasChanges {
            DispatchQueue.main.async {
                completion?(false, nil)
            }
            return
        }
        
        let shouldSaveParentContexts = options.contains(.withParent) && context.parent != nil
        let shoulSaveOnlySelf = options.contains(.onlySelf)
        let shouldSaveSynchronously = options.contains(.synchronously)
        
        let savingBlock = {
            var returnedError: Error?
            do {
                try context.save()
            } catch {
                returnedError = error
            }
            
            if shoulSaveOnlySelf {
                completion?(returnedError == nil, returnedError)
            } else {
                if shouldSaveParentContexts {
                    save(with: context.parent!, options: [.withParent, .synchronously], completion: completion)
                } else {
                    completion?(returnedError == nil, returnedError)
                }
            }
        }
        
        if shouldSaveSynchronously {
            context.performAndWait(savingBlock)
        } else {
            context.perform(savingBlock)
        }
    }
}
