//
//  MeasurementUnit.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/25/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public protocol MeasurementUnit: Hashable {
    
    static var base: Self { get }
    
    var symbol: String { get }
    var name: String { get }
    
    
    func convertToBase(value: Value) -> Value
    func convertFromBase(value: Value) -> Value
}



public extension MeasurementUnit {
    typealias Value = CGFloat.NativeType
    
    
    func convert(value: Value, to other: Self) -> Value {
        return other.convertFromBase(value: convertToBase(value: value))
    }
}



public protocol LinearMeasurementUnit: MeasurementUnit {
    var coefficient: Value { get }
}



public extension LinearMeasurementUnit {
    
    func convertToBase(value: Value) -> Value {
        return value / coefficient
    }
    
    
    func convertFromBase(value: Value) -> Value {
        return value * coefficient
    }
}
