//
//  ViewController.swift
//  AnalyticsExample
//
//  Created by MAXIM KOLESNIK on 27.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import UIKit
import Analytics
import FacebookAnalytics

public struct ViewDidLoadReport: Reportable {
    public var event: Event {
        return Event.ViewDidLoad
    }
    public var parametres: [Event.Name: Any]? {
        return [Event.Name.viewControllerName: name]
    }
    
    var name: String
    init(name: String) {
        self.name = name
    }

}

public extension Event {
    public static var ViewDidLoad: Event {
        return Event("view_did_load")
    }
}

public extension Event.Name {
    public static var viewControllerName: Event.Name {
        return Event.Name("view_controller_name")
    }
}


public class ViewController: UIViewController {
    public var provider = AnalyticsProvider<ViewDidLoadReport, FacebookAnalyticsAdapter>()

//    public let viewDidLoadProvier = AnalyticsProvider<ViewDidLoadReport, FacebookAnalyticsAdapter>()
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

