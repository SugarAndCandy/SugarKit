//
//  Transitionable.swift
//  Router
//
//  Created by MAXIM KOLESNIK on 11.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import UIKit

public protocol Transitionable {
    associatedtype View: TransitionView
    var view: View? { get set }
    
    func push(transiton source: UIViewController, destanation: UIViewController)
    func push(transiton handler: UIViewController)
    
    func present(transiton source: UIViewController, destanation: UIViewController)
    func present(transiton handler: UIViewController)
    func presentUsingNavigationController(transiton source: UIViewController, destanation: UIViewController)
    func presentUsingNavigationController(transiton destanation: UIViewController)
    
    
    var pushtTansitionBlock: ModuleTransitionBlock { get }
    var presentTansitionBlock: ModuleTransitionBlock { get }
    var presentUsingNavigationController: ModuleTransitionBlock { get }
}

public extension Transitionable {
    var presentTansitionBlock: ModuleTransitionBlock {
        return { source, destanation  in
            self.present(transiton: source, destanation: destanation)
        }
    }
    var pushtTansitionBlock: ModuleTransitionBlock {
        return {source, destanation in
            self.push(transiton: source, destanation: destanation)
        }
    }
    var presentUsingNavigationController: ModuleTransitionBlock {
        return {source, destanation in
            self.presentUsingNavigationController(transiton: source, destanation: destanation)
        }
    }
    func push(transiton source: UIViewController, destanation: UIViewController) {
        source.navigationController?.pushViewController(destanation, animated: true)
    }
    func push(transiton destanation: UIViewController) {
        view?.asViewController?.navigationController?.pushViewController(destanation, animated: true)
    }
    func present(transiton source: UIViewController, destanation: UIViewController) {
        source.present(destanation, animated: true, completion: nil)
    }
    func present(transiton destanation: UIViewController) {
        view?.asViewController?.present(destanation, animated: true, completion: nil)
    }
    func presentUsingNavigationController(transiton source: UIViewController, destanation: UIViewController) {
        let navigation = UINavigationController(rootViewController: destanation)
        source.present(navigation, animated: true, completion: nil)
    }
    func presentUsingNavigationController(transiton destanation: UIViewController) {
        let navigation = UINavigationController(rootViewController: destanation)
        view?.asViewController?.present(navigation, animated: true, completion: nil)
    }
    
}
