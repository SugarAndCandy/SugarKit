//
//  Router.swift
//  Router
//
//  Created by MAXIM KOLESNIK on 11.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

import UIKit
public typealias ModuleTransitionBlock = (_ sourceModuleTransitionHandler: UIViewController, _ destinationModuleTransitionHandler: UIViewController) -> Void

public struct Moduling<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    public func perform(moduleInput: (_ presenter: Base) -> Void) {
        moduleInput(self.base)
    }
}

public protocol TransitionView: class {
    associatedtype Presenter
    var presenter: Presenter { get set }
    var asViewController: UIViewController? { get }
}

public extension TransitionView {
    var asViewController: UIViewController? { return nil }
}

public extension TransitionView where Self: UIViewController {
    var asViewController: UIViewController? { return self  }
}

public protocol FactoryProtocol {
    associatedtype TransitionHandler: TransitionView
    func instantiateModuleTransitionHandler() -> TransitionHandler
}

public enum TransitionError: Error {
    case castError
}

public struct Transition<T: TransitionView> {
    public weak var source: T?
    public init(source aSource: T) {
        source = aSource
    }
    @discardableResult public func openModule<Factory, Presenter>(using factory: Factory, with transitionBlock: ModuleTransitionBlock) throws -> Moduling<Presenter>
        where Factory: FactoryProtocol, Presenter == Factory.TransitionHandler.Presenter {
            let destanation = factory.instantiateModuleTransitionHandler()
            let presenter = destanation.presenter
            let module = Moduling(presenter)
            guard let vc1 = source?.asViewController else { throw TransitionError.castError }
            guard let vc2 = destanation.asViewController else { throw TransitionError.castError }
            transitionBlock(vc1, vc2)
            return module
    }
}

