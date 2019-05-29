//
//  Router.swift
//  Router
//
//  Created by MAXIM KOLESNIK on 11.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import UIKit

import Foundation

import UIKit

public typealias ModuleTransitionBlock = (UIViewController, UIViewController) -> Void

public struct ModulePromise<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    public func perform(moduleInput: (Base) -> Void) {
        moduleInput(self.base)
    }
}

public protocol Presenter: AnyObject {
    associatedtype ViewType
    var view: ViewType? { get }
    func configure()
}

public protocol TransitionView: AnyObject {
    associatedtype PresenterType: Presenter
    var presenter: PresenterType { get set }
}

public protocol TransitionFactory {
    associatedtype ViewType: TransitionView
    func instantiateModuleTransitionHandler() -> ViewType
}

public enum TransitionError: Error {
    case castError
}

public struct Transition<T: UIViewController> {
    public private(set) weak var source: T?
    public init(source: T) {
        self.source = source
    }
    
    @discardableResult
    public func openModule<Factory, Presenter>(using factory: Factory, with transitionBlock: ModuleTransitionBlock) throws -> ModulePromise<Presenter>
        where Factory: TransitionFactory,
        Presenter == Factory.ViewType.PresenterType {
            let destanation = factory.instantiateModuleTransitionHandler()
            let presenter = destanation.presenter
            presenter.configure()
            let module = ModulePromise(presenter)
            guard let vc1 = source else { throw TransitionError.castError }
            guard let vc2 = destanation as? UIViewController else { throw TransitionError.castError }
            transitionBlock(vc1, vc2)
            return module
    }
}

