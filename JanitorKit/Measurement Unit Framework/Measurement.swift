//
//  Measurement.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/25/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public struct Measurement<Unit: MeasurementUnit> {
    public var value: Value
    public var unit: Unit
    
    
    public init(value: Value, unit: Unit) {
        self.value = value
        self.unit = unit
    }
}



// MARK: - Conveniences

public extension Measurement {
    typealias Value = MeasurementUnit.Value
    
    
    
    init(converting measurement: Measurement<Unit>, to newUnit: Unit) {
        self = measurement.converted(to: newUnit)
    }
    
    
    static var zero: Measurement<Unit> { 0 }
}



extension Measurement: AdditiveArithmetic {
    public static func + (lhs: Measurement<Unit>, rhs: Measurement<Unit>) -> Measurement<Unit> {
        return Measurement(value: lhs.convertingToBase.value + rhs.convertingToBase.value,
                           unit: .base)
    }
    
    
    public static func += (lhs: inout Measurement<Unit>, rhs: Measurement<Unit>) {
        lhs = lhs + rhs
    }
    
    
    public static func - (lhs: Measurement<Unit>, rhs: Measurement<Unit>) -> Measurement<Unit> {
        return Measurement(value: lhs.convertingToBase.value - rhs.convertingToBase.value,
                           unit: .base)
    }
    
    
    public static func -= (lhs: inout Measurement<Unit>, rhs: Measurement<Unit>) {
        lhs = lhs - rhs
    }
}



// MARK: - General Conformance

extension Measurement: Equatable {}
extension Measurement: Hashable {}
extension Measurement: Codable {}



extension Measurement: CustomStringConvertible {
    public var description: String {
        return "\(value) \(unit.name.text(whenAmountIs: value))"
    }
}



// MARK: - SimpleInitializableUnitDependent

extension Measurement: SimpleInitializableUnitDependent {
}
