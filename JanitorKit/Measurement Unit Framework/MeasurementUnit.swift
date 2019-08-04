//
//  MeasurementUnit.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/25/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



// MARK: - MeasurementUnit

public protocol MeasurementUnit: IdentifiableOnlyIfUsingSwiftUI, CaseIterable where AllCases: RandomAccessCollection {

    static var base: Self { get }
    
    var symbol: String { get }
    var name: PluralizableString { get }
    
    
    func convertToBase(value: Value) -> Value
    func convertFromBase(value: Value) -> Value
}



public extension MeasurementUnit {
    typealias Value = CGFloat.NativeType
}



// MARK: - LinearMeasurementUnit

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



// MARK: - SwiftUI.Identifiable

public extension MeasurementUnit {
    var id: String {
        return symbol
    }
}



public extension LinearMeasurementUnit {
    var id: Value {
        return coefficient
    }
}
