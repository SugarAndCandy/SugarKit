//
//  FacebookAnalytics.swift
//  FacebookAnalytics
//
//  Created by MAXIM KOLESNIK on 27.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation
import Analytics
import FBSDKCoreKit

public class FacebookAnalyticsAdapter: AnalyticsProtocol, AnalyticsEndpointProtocol {
        
    public private(set) var event: Event
    public private(set) var parameters: [Event.Name: Any]?
    public private(set) var trakingTimeInterval: TimeInterval = 0
    
    public private(set) var startTimeInterval: TimeInterval = Date().timeIntervalSince1970
    
    
    public init(event aEvent: Event, parameters aParameters: [Event.Name: Any]?) {
        event = aEvent
        parameters = aParameters
    }
    
    lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        return operationQueue
    }()
    
    public static func report(_ event: Event, parameters: [Event.Name: Any]?) -> AnalyticsEndpointProtocol {
        let facebookAnalytics = FacebookAnalyticsAdapter(event: event, parameters: parameters)
        return facebookAnalytics
    }
    
    public func startTracking() {
        startTimeInterval = Date().timeIntervalSince1970
    }
    
    public func finishTracking() {
        let currentTimeInterval = Date().timeIntervalSince1970
        trakingTimeInterval = currentTimeInterval - startTimeInterval
    }
    
    public func execute() {
        
        log(event, parameters: parameters)
    }
    
    public func cancel() {
        operationQueue.cancelAllOperations()
    }
    
    public func log(_ event: Event, parameters: [Event.Name: Any]?) {
        if let wrappedParameters = parameters?.map(transform: { ($0.rawValue, $1)}) {
            FBSDKAppEvents.logEvent(event.rawValue, parameters: wrappedParameters)
        } else {
            FBSDKAppEvents.logEvent(event.rawValue)
        }
    }
}


public extension Event.Name {
    
    public static var content: Event.Name {
        return Event.Name(FBSDKAppEventParameterNameContent)
    }
    public static var contentID: Event.Name {
        return Event.Name(FBSDKAppEventParameterNameContentID)
    }
    
    public static var contentType: Event.Name {
        return Event.Name(FBSDKAppEventParameterNameContentType)
    }
}

