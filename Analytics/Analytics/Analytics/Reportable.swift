//
//  Reportable.swift
//  Analytics
//
//  Created by MAXIM KOLESNIK on 26.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

public protocol Reportable {
    var event: Event { get }
    var parametres: [Event.Name: Any]? { get }
}
