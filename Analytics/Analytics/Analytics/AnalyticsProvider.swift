//
//  AnalyticsProvider.swift
//  Analytics
//
//  Created by MAXIM KOLESNIK on 26.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

public struct AnalyticsProvider<Report, Analytics> where Report: Reportable, Analytics: AnalyticsProtocol {

    public init() { }

    @discardableResult
    public func log(_ report: Report, force execute: Bool = true) -> AnalyticsEndpointProtocol  {
        let analytics = Analytics.report(report.event, parameters: report.parametres)
        if execute { analytics.execute() }
        return analytics
    }
    
    @discardableResult
    public func report(after traking: @escaping (TimeInterval) -> Report) -> TrackingAnalytics {
        let tracking = TrackingAnalytics(onFinishTraking: { (time) in
            let report = traking(time)
            let analytics = Analytics.report(report.event, parameters: report.parametres)
            analytics.execute()
        })
        return tracking
    }
}


