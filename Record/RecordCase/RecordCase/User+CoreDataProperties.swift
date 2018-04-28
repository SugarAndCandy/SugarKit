//
//  User+CoreDataProperties.swift
//  
//
//  Created by Maksim Kolesnik on 28.04.2018.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var shops: Set<Shop>?

}

// MARK: Generated accessors for shops
extension User {

    @objc(addShopsObject:)
    @NSManaged public func addToShops(_ value: Shop)

    @objc(removeShopsObject:)
    @NSManaged public func removeFromShops(_ value: Shop)

    @objc(addShops:)
    @NSManaged public func addToShops(_ values: Set<Shop>)

    @objc(removeShops:)
    @NSManaged public func removeFromShops(_ values: Set<Shop>)

}
