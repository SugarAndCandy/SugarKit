//
//  FacebookAnalytics.swift
//  FacebookAnalytics
//
//  Created by MAXIM KOLESNIK on 27.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation
import FBSDKCoreKit

public class FacebookAnalyticsAdapter: AnalyticsProtocol, AnalyticsEndpointProtocol {
        
    public private(set) var event: Event
    public private(set) var parameters: [Event.Name: Any]?
    
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
    
    public func execute() {
        let _event = self.event
        let _parameters = self.parameters
        let oper = AnalyticsOperation(block: {
            FacebookAnalyticsAdapter.log(_event, parameters: _parameters)
        })
        operationQueue.addOperation(oper)
    }
    
    public func cancel() {
        operationQueue.cancelAllOperations()
    }
    
    static func log(_ event: Event, parameters: [Event.Name: Any]?) {
        if let wrappedParameters = parameters?.map(transform: { ($0.rawValue, $1)}) {
            FBSDKAppEvents.logEvent(event.rawValue, parameters: wrappedParameters)
        } else {
            FBSDKAppEvents.logEvent(event.rawValue)
        }
    }
    
    public func log(_ event: Event, parameters: [Event.Name: Any]?) {
        FacebookAnalyticsAdapter.log(event, parameters: parameters)
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

