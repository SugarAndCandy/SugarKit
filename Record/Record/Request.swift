//
//  Request.swift
//  Sugar
//
//  Created by Maksim Kolesnik on 20.04.2018.
//  Copyright © 2018 Maksim Kolesnik. All rights reserved.
//

import CoreData

public class Request<Entity> {
    
}


extension Request where Entity: NSManagedObject {

    public static var first: Entity? {
        return first()
    }
    
    public static func first(with predicate: NSPredicate? = nil, sort sortDescriptors: [NSSortDescriptor]? = nil, in context: NSManagedObjectContext = Context.main.root) -> Entity? {
        let request = FetchRequest<Entity>.init(in: context, limit: 1, filtered: predicate, sorted: sortDescriptors).nsFetchRequest
        return executeFetchRequest(request, in: context).first
    }
}
extension Request where Entity: NSManagedObject {
    public static var all: [Entity] {
        return all()
    }
    
    public static func all(with predicate: NSPredicate? = nil, sort sortDescriptors: [NSSortDescriptor]? = nil, in context: NSManagedObjectContext = Context.main.root) -> [Entity] {
        let request = FetchRequest<Entity>(in: context, filtered: predicate, sorted: sortDescriptors).nsFetchRequest
        return executeFetchRequest(request, in: context)
    }
    
}


extension Request where Entity: NSManagedObject {
    public static func executeFetchRequest(_ request: NSFetchRequest<Entity>, in context: NSManagedObjectContext) -> [Entity] {
        var returnedEntities: [Entity]?
        context.performAndWait {
            do {
                returnedEntities = try context.fetch(request)
            } catch {
                returnedEntities = nil
            }
        }
        return returnedEntities ?? []
    }
}
