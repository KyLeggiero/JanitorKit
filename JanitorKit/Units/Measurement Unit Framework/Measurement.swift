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



public extension Measurement {
    typealias Value = MeasurementUnit.Value
    
    
    
    init(converting measurement: Measurement<Unit>, to newUnit: Unit) {
        self.init(value: measurement.unit.convert(value: measurement.value, to: newUnit), unit: newUnit)
    }
    
    
    var convertingToBase: Measurement<Unit> {
        return Measurement(value: unit.convertToBase(value: value), unit: Unit.base)
    }
}



extension Measurement: Equatable {}
extension Measurement: Hashable {}
