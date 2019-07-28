//
//  DurationMeasurementUnit.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/26/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public struct DurationMeasurementUnit: LinearMeasurementUnit {
    
    public static var base = DurationMeasurementUnit.second
    
    public var coefficient: Value
    public var symbol: String
    public var name: String
}



public extension DurationMeasurementUnit {
    static let year = DurationMeasurementUnit(coefficient: meanTropicalYear.coefficient, symbol: "y", name: "year")
    static let meanTropicalYear = DurationMeasurementUnit(coefficient: day.coefficient * 365.242_190_402, symbol: "y", name: "mean tropical year")
    static let tropicalYear = meanTropicalYear
    static let solarYear = meanTropicalYear
    static let siderealYear = DurationMeasurementUnit(coefficient: day.coefficient * 365.256_363_004, symbol: "y", name: "sidereal year")
    static let anomalisticYear = DurationMeasurementUnit(coefficient: day.coefficient * 365.259_636, symbol: "y", name: "anomalistic year")
    static let gaussianYear = DurationMeasurementUnit(coefficient: day.coefficient * 365.256_898_3, symbol: "y", name: "Gaussian year")
    static let julianYear = DurationMeasurementUnit(coefficient: day.coefficient * 365.25, symbol: "a", name: "Julian year")
    
    static let day = DurationMeasurementUnit(coefficient: ephemerisDay.coefficient, symbol: "d", name: "day")
    static let ephemerisDay = DurationMeasurementUnit(coefficient: hour.coefficient * 24, symbol: "d", name: "ephemeris day")
    static let meanSolarDay = DurationMeasurementUnit(coefficient: second.coefficient * 86_400.002, symbol: "d", name: "mean solar day")
    
    static let hour = DurationMeasurementUnit(coefficient: minute.coefficient * 60, symbol: "h", name: "hour")
    static let minute = DurationMeasurementUnit(coefficient: second.coefficient * 60, symbol: "m", name: "minute")
    static let second = DurationMeasurementUnit(coefficient: 1, symbol: "s", name: "second")
    
    static let decisecond = DurationMeasurementUnit(coefficient: second.coefficient / 10, symbol: "ds", name: "decisecond")
    static let centisecond = DurationMeasurementUnit(coefficient: second.coefficient / 100, symbol: "cs", name: "centisecond")
    static let millisecond = DurationMeasurementUnit(coefficient: second.coefficient / 1_000, symbol: "ms", name: "millisecond")
    static let microsecond = DurationMeasurementUnit(coefficient: second.coefficient / 1_000_000, symbol: "μs", name: "microsecond")
    static let nanosecond = DurationMeasurementUnit(coefficient: second.coefficient / 1_000_000_000, symbol: "ns", name: "nanosecond")
    static let picosecond = DurationMeasurementUnit(coefficient: second.coefficient / 1_000_000_000_000, symbol: "ps", name: "picosecond")
}



public extension DurationMeasurementUnit {
    static let week = DurationMeasurementUnit(coefficient: day.coefficient * 7, symbol: "w", name: "week")
}
