//
//  Address+CoreDataProperties.swift
//  
//
//  Created by Maksim Kolesnik on 28.04.2018.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var shop: Shop?

}
