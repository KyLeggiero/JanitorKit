//
//  DataSize.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// The size of some data, such as bytes, nibbles, gigabytes, mebibytes, etc.
public struct DataSize: SimpleInitializableUnitDependent {

    public typealias Unit = UnitInformationStorage
    
    
    
    public let value: Value
    public let unit: Unit
    
    
    public init(value: Value, unit: Unit) {
        self.value = value
        self.unit = unit
    }
}



extension DataSize: Hashable {}



// MARK: - Foundation Extensions

extension UnitInformationStorage: CaseIterable {
    
    public typealias AllCases = [UnitInformationStorage]
    
    
    
    public static let allCases: AllCases = [
        .bytes,
        
        .bits,
        .nibbles,
        
        .yottabytes,
        .zettabytes,
        .exabytes,
        .petabytes,
        .terabytes,
        .gigabytes,
        .megabytes,
        .kilobytes,
        
        .yottabits,
        .zettabits,
        .exabits,
        .petabits,
        .terabits,
        .gigabits,
        .megabits,
        
        .kilobits,
        .yobibytes,
        .zebibytes,
        .exbibytes,
        .pebibytes,
        .tebibytes,
        .gibibytes,
        .mebibytes,
        
        .kibibytes,
        .yobibits,
        .zebibits,
        .exbibits,
        .pebibits,
        .tebibits,
        .gibibits,
        .mebibits,
        .kibibits,
    ]
}



extension BinaryFloatingPoint {
    var bytes:      DataSize { DataSize(value: DataSize.Value(self), unit: .bytes) }
    var bits:       DataSize { DataSize(value: DataSize.Value(self), unit: .bits) }
    var nibbles:    DataSize { DataSize(value: DataSize.Value(self), unit: .nibbles) }
    var yottabytes: DataSize { DataSize(value: DataSize.Value(self), unit: .yottabytes) }
    var zettabytes: DataSize { DataSize(value: DataSize.Value(self), unit: .zettabytes) }
    var exabytes:   DataSize { DataSize(value: DataSize.Value(self), unit: .exabytes) }
    var petabytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .petabytes) }
    var terabytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .terabytes) }
    var gigabytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .gigabytes) }
    var megabytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .megabytes) }
    var kilobytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .kilobytes) }
    var yottabits:  DataSize { DataSize(value: DataSize.Value(self), unit: .yottabits) }
    var zettabits:  DataSize { DataSize(value: DataSize.Value(self), unit: .zettabits) }
    var exabits:    DataSize { DataSize(value: DataSize.Value(self), unit: .exabits) }
    var petabits:   DataSize { DataSize(value: DataSize.Value(self), unit: .petabits) }
    var terabits:   DataSize { DataSize(value: DataSize.Value(self), unit: .terabits) }
    var gigabits:   DataSize { DataSize(value: DataSize.Value(self), unit: .gigabits) }
    var megabits:   DataSize { DataSize(value: DataSize.Value(self), unit: .megabits) }
    var kilobits:   DataSize { DataSize(value: DataSize.Value(self), unit: .kilobits) }
    var yobibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .yobibytes) }
    var zebibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .zebibytes) }
    var exbibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .exbibytes) }
    var pebibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .pebibytes) }
    var tebibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .tebibytes) }
    var gibibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .gibibytes) }
    var mebibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .mebibytes) }
    var kibibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .kibibytes) }
    var yobibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .yobibits) }
    var zebibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .zebibits) }
    var exbibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .exbibits) }
    var pebibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .pebibits) }
    var tebibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .tebibits) }
    var gibibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .gibibits) }
    var mebibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .mebibits) }
    var kibibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .kibibits) }
}
