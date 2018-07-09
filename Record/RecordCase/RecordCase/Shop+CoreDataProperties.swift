//
//  Shop+CoreDataProperties.swift
//  
//
//  Created by Maksim Kolesnik on 28.04.2018.
//
//

import Foundation
import CoreData


extension Shop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shop> {
        return NSFetchRequest<Shop>(entityName: "Shop")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var user: User?
    @NSManaged public var address: Address?

}
