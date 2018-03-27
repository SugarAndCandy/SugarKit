//
//  TrackingAnalytics.swift
//  Analytics
//
//  Created by Maksim Kolesnik on 27.03.18.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

public class TrackingAnalytics: AnalyticsTrackingProtocol {
    public var trakingTimeInterval: TimeInterval = 0
    
    public func startTracking() {
        trakingTimeInterval = Date().timeIntervalSince1970
    }
    
    public var onFinishTraking: OnFinishTraking
    public init(onFinishTraking: @escaping OnFinishTraking) {
        self.onFinishTraking = onFinishTraking
        startTracking()
    }
    
    public func finishTracking() {
        trakingTimeInterval = Date().timeIntervalSince1970 - trakingTimeInterval
        onFinishTraking(trakingTimeInterval)
    }
    
}
