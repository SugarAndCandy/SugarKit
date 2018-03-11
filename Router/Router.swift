//
//  Router.swift
//  Router
//
//  Created by MAXIM KOLESNIK on 11.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

import UIKit
typealias ModuleTransitionBlock = (_ sourceModuleTransitionHandler: UIViewController, _ destinationModuleTransitionHandler: UIViewController) -> Void

struct Moduling<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    func perform(moduleInput: (_ presenter: Base) -> Void) {
        moduleInput(self.base)
    }
}

protocol TransitionView: class {
    associatedtype Presenter
    var presenter: Presenter { get set }
    var asViewController: UIViewController? { get }
}

extension TransitionView {
    var asViewController: UIViewController? { return nil }
}

extension TransitionView where Self: UIViewController {
    var asViewController: UIViewController? { return self  }
}

protocol FactoryProtocol {
    associatedtype Transition: TransitionView
    func instantiateModuleTransitionHandler() -> Transition
    static func instantiateModuleTransitionHandler() -> Transition
    
}

extension FactoryProtocol {
    func instantiateModuleTransitionHandler() -> Transition {
        return type(of: self).instantiateModuleTransitionHandler()
    }
}

enum TransitionError: Error {
    case castError
}

struct Transition<T: TransitionView> {
    weak var source: T?
    
    @discardableResult func openModule<Factory, Presenter>(using factory: Factory, with transitionBlock: ModuleTransitionBlock) throws -> Moduling<Presenter>
        where Factory: FactoryProtocol, Presenter == Factory.Transition.Presenter {
            let destanation = factory.instantiateModuleTransitionHandler()
            let presenter = destanation.presenter
            let module = Moduling(presenter)
            guard let vc1 = source?.asViewController else { throw TransitionError.castError }
            guard let vc2 = destanation.asViewController else { throw TransitionError.castError }
            transitionBlock(vc1, vc2)
            return module
    }
}

extension Transition where T: UIViewController {
    
}
