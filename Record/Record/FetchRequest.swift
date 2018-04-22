//
//  FetchRequest.swift
//  Sugar
//
//  Created by MAXIM KOLESNIK on 22.04.2018.
//  Copyright © 2018 Maksim Kolesnik. All rights reserved.
//

import Foundation
import CoreData

public struct FetchRequest<Entity: NSManagedObject> {
    
    public init(in context: NSManagedObjectContext, batchSize: Int = 20, limit: Int? = nil, filtered predicate: NSPredicate? = nil, sorted:[NSSortDescriptor]? = nil) {
        let entityName = AnyEntityNaming.init(objectType: Entity.self).entityName
        nsFetchRequest = NSFetchRequest<Entity>(entityName: entityName)
        nsFetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        nsFetchRequest.fetchBatchSize = batchSize
        if let predicate = predicate {
            nsFetchRequest.predicate = predicate
        }
        nsFetchRequest.sortDescriptors = sorted
        if let limit = limit { nsFetchRequest.fetchLimit = limit }
    }
    
    public init(in context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Entity>) {
        self.nsFetchRequest = fetchRequest
    }
    
    public var nsFetchRequest: NSFetchRequest<Entity>
}
