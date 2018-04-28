//
//  EntityDescriptionable.swift
//  Record
//
//  Created by Maksim Kolesnik on 28.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import CoreData

public protocol EntityDescriptionable: class {
    static func entityDescription(in context: NSManagedObjectContext) -> NSEntityDescription?
}
