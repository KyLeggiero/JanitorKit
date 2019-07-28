//
//  Unit Conversion.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// Anything which has a value which is dependent on a unit for context
public protocol UnitDependent: HasBaseUnit where Unit: MeasurementUnit {
    
    /// The raw value, in the context of the unit
    var value: Value { get }
    
    /// The unit of the raw value
    var unit: Unit { get }
    
    
    
    typealias Value = Double
}



public extension UnitDependent {
    static var baseUnit: Unit { Unit.base }
}



// MARK: -

/// Any `UnitDependent` which can be simply initialized using solely a value and a unit
public protocol SimpleInitializableUnitDependent: UnitDependent, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    init(value: Value, unit: Unit)
}



public extension SimpleInitializableUnitDependent {
    
    init(converting other: Self, to newUnit: Self.Unit) {
        self = other.convert(to: newUnit)
    }
    
    
    /// Converts this value in its unit to a new value in the given other unit
    func convert(to otherUnit: Self.Unit) -> Self {
        return Self.init(value: unit.convert(value: self.value, to: otherUnit), unit: otherUnit)
    }
}



public extension SimpleInitializableUnitDependent {
    
    init(inBaseUnit baseUnitValue: Value) {
        self.init(value: baseUnitValue, unit: Self.baseUnit)
    }
    
    
    init<AnyInt>(value: AnyInt, unit: Unit) where AnyInt: BinaryInteger {
        self.init(value: Value(value), unit: unit)
    }
    
    
    init(floatLiteral: Value) {
        self.init(inBaseUnit: floatLiteral)
    }
    
    
    init(integerLiteral value: Int) {
        self.init(inBaseUnit: Value(value))
    }
}



// MARK: -

public protocol HasBaseUnit {

    /// The important unit of the value
    associatedtype Unit
    
    /// The unit upon which all other units of this kind are based
    static var baseUnit: Unit { get }
}



// MARK: - Conformance

extension Measurement: SimpleInitializableUnitDependent {
}
