//
//  Observable.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

public final class Observable<Value> {
    
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void // event
    }
    
    public var value: Value {
        didSet { notifyObservers() }
    }
    
    init(value: Value) {
        self.value = value
    }
    
    private var observers = [Observer<Value>]()
    
    // MARK: - subscribe/unsubscribe/notify
    public func subscribe(on observer: AnyObject, observerBlock: @escaping (Value) -> Void ) {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(self.value) // ?
    }
    
    public func unsubscribe(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    public func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async { observer.block(self.value) }
        }
    }
}

