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



public func blackhole() { blackholeImplementation(()) }
public func blackhole<A>(_ a: A) { blackholeImplementation(a) }
public func blackhole<A, B>(_ a: A, _ b: B) { blackholeImplementation(a, b) }
public func blackhole<A, B, C>(_ a: A, _ b: B, _ c: C) { blackholeImplementation(a, b, c) }
public func blackhole<A, B, C, D>(_ a: A, _ b: B, _ c: C, _ d: D) { blackholeImplementation(a, b, c, d) }
