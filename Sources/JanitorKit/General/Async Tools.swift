//
//  Async Tools.swift
//  JanitorKit
//
//  Created by Ky Leggiero on 2021-07-31.
//

import Foundation



public func sync<Value>(at priority: TaskPriority? = nil, _ asyncValue: @escaping () async -> Value) -> Value {
    
    let semaphore = DispatchSemaphore.init(value: 0)
    
    let awaiter = Awaiter<Value>()
    
    Task.detached(priority: priority) {
        defer { semaphore.signal() }
        awaiter.result = await asyncValue()
    }
    
    semaphore.wait()
    
    return awaiter.result!
}



private class Awaiter<Value> {
    var result = Optional<Value>.none
}
