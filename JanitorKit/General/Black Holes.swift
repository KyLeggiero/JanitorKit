//
//  Black Holes.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 8/3/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//



private var blackholeValue: Any? {
    didSet {
        blackholeValue = nil
    }
}


private func blackholeImplementation(_ unwantedValue: Any?...) {
    blackholeValue = unwantedValue
}


private func blackholeImplementation(_ unwantedValue: Any?...) -> ReturnsViaCallback {
    blackholeValue = unwantedValue
    return .purposefullyOptedToNeverCallCallback
}



public func blackhole() { return blackholeImplementation(()) }
public func blackhole<A>(_ a: A) { return blackholeImplementation(a) }
public func blackhole<A, B>(_ a: A, _ b: B) { return blackholeImplementation(a, b) }
public func blackhole<A, B, C>(_ a: A, _ b: B, _ c: C) { return blackholeImplementation(a, b, c) }
public func blackhole<A, B, C, D>(_ a: A, _ b: B, _ c: C, _ d: D) { return blackholeImplementation(a, b, c, d) }

public func blackhole() -> ReturnsViaCallback { blackholeImplementation(()) }
public func blackhole<A>(_ a: A) -> ReturnsViaCallback { blackholeImplementation(a) }
public func blackhole<A, B>(_ a: A, _ b: B) -> ReturnsViaCallback { blackholeImplementation(a, b) }
public func blackhole<A, B, C>(_ a: A, _ b: B, _ c: C) -> ReturnsViaCallback { blackholeImplementation(a, b, c) }
public func blackhole<A, B, C, D>(_ a: A, _ b: B, _ c: C, _ d: D) -> ReturnsViaCallback { blackholeImplementation(a, b, c, d) }
