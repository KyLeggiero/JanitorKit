//
//  Age.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// The age of something, such as seconds, hours, nanoseconds, etc.
public struct Age: SimpleInitializableUnitDependent {

    public typealias Unit = UnitDuration
    
    
    
    public let value: Value
    public let unit: Unit
    
    
    public init(value: Value, unit: Unit) {
        self.value = value
        self.unit = unit
    }
}



extension Age: Hashable {}



// MARK: - Foundation Extensions

extension UnitDuration: CaseIterable {
    
    public typealias AllCases = [UnitDuration]
    
    
    
    public static let allCases: AllCases = [
        .hours,
        .minutes,
        .seconds,
        .milliseconds,
        .microseconds,
        .nanoseconds,
        .picoseconds,
    ]
    
    
    public static let secondsPerDay: TimeInterval = 86_400
    public static let secondsPerWeek: TimeInterval = secondsPerDay * 7
    public static let secondsPerTropicalYear: TimeInterval = secondsPerDay * 365.24219
    
    
    /// SI Civil Days
    public static let days = UnitDuration(symbol: "d", converter: UnitConverterLinear(coefficient: secondsPerDay))
    
    /// SI Weeks
    public static let weeks = UnitDuration(symbol: "w", converter: UnitConverterLinear(coefficient: secondsPerWeek))
    
    /// SI Mean Tropical Years
    public static let years = UnitDuration(symbol: "y", converter: UnitConverterLinear(coefficient: secondsPerTropicalYear))
}



public extension BinaryFloatingPoint {
    var hours:        Age { Age(value: Age.Value(self), unit: .hours) }
    var minutes:      Age { Age(value: Age.Value(self), unit: .minutes) }
    var seconds:      Age { Age(value: Age.Value(self), unit: .seconds) }
    var milliseconds: Age { Age(value: Age.Value(self), unit: .milliseconds) }
    var microseconds: Age { Age(value: Age.Value(self), unit: .microseconds) }
    var nanoseconds:  Age { Age(value: Age.Value(self), unit: .nanoseconds) }
    var picoseconds:  Age { Age(value: Age.Value(self), unit: .picoseconds) }
}

