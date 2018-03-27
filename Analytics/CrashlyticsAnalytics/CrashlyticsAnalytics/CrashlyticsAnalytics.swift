//
//  CrashlyticsAnalytics.swift
//  CrashlyticsAnalytics
//
//  Created by MAXIM KOLESNIK on 27.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation
import Analytics
import Crashlytics

public class CrashlyticsAnalyticsAdapter: Analytics.AnalyticsProtocol, AnalyticsEndpointProtocol {
    
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
        let facebookAnalytics = CrashlyticsAnalytics.CrashlyticsAnalyticsAdapter(event: event, parameters: parameters)
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
        let operation = AnalyticsOperation(block: { [weak self] in
            guard let aliveSelf = self else { return }
            aliveSelf.log(aliveSelf.event, parameters: aliveSelf.parameters)
        })
        operationQueue.addOperation(operation)
    }
    
    public func cancel() {
        operationQueue.cancelAllOperations()
    }
    
    public func log(_ event: Event, parameters: [Event.Name: Any]?) {
        if let wrappedParameters = parameters?.map(transform: { ($0.rawValue, $1)}) {
            Answers.logCustomEvent(withName: event.rawValue, customAttributes: wrappedParameters)
        } else {
            Answers.logCustomEvent(withName: event.rawValue, customAttributes: nil)
        }
    }
}


