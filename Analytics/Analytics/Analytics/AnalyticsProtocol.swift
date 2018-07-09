//
//  AnalyticsProtocol.swift
//  Analytics
//
//  Created by MAXIM KOLESNIK on 27.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

public protocol AnalyticsProtocol: class {
    static func report(_ event: Event, parameters: [Event.Key: Any]?) -> AnalyticsEndpointProtocol
}

public typealias OnFinishTraking = (TimeInterval) -> Void

public protocol AnalyticsTrackingProtocol {
    
    var trakingTimeInterval: TimeInterval { get }
    
    func startTracking()
    
    func finishTracking()
    
}

public protocol AnalyticsEndpointProtocol {
    
    func cancel()
    
    func execute()
}
