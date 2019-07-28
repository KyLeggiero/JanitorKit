//
//  DataSize.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// The size of some data, such as bytes, nibbles, gigabytes, mebibytes, etc.
public typealias DataSize = Measurement<BinaryDataUnit>



// MARK: - Foundation Extensions

extension BinaryDataUnit: CaseIterable {
    
    public typealias AllCases = [BinaryDataUnit]
    
    
    
    public static let allCases: AllCases = [
        .byte,
        
        .bit,
        .nibble,
        
        .yottabyte,
        .zettabyte,
        .exabyte,
        .petabyte,
        .terabyte,
        .gigabyte,
        .megabyte,
        .kilobyte,
        
        .yottabit,
        .zettabit,
        .exabit,
        .petabit,
        .terabit,
        .gigabit,
        .megabit,
        
        .kilobit,
        .yobibyte,
        .zebibyte,
        .exbibyte,
        .pebibyte,
        .tebibyte,
        .gibibyte,
        .mebibyte,
        
        .kibibyte,
        .yobibit,
        .zebibit,
        .exbibit,
        .pebibit,
        .tebibit,
        .gibibit,
        .mebibit,
        .kibibit,
    ]
}



public extension BinaryFloatingPoint {
    var bytes:      DataSize { DataSize(value: DataSize.Value(self), unit: .byte) }
    
    var bits:       DataSize { DataSize(value: DataSize.Value(self), unit: .bit) }
    
    var nibbles:    DataSize { DataSize(value: DataSize.Value(self), unit: .nibble) }
    
    var yottabytes: DataSize { DataSize(value: DataSize.Value(self), unit: .yottabyte) }
    var zettabytes: DataSize { DataSize(value: DataSize.Value(self), unit: .zettabyte) }
    var exabytes:   DataSize { DataSize(value: DataSize.Value(self), unit: .exabyte) }
    var petabytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .petabyte) }
    var terabytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .terabyte) }
    var gigabytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .gigabyte) }
    var megabytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .megabyte) }
    var kilobytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .kilobyte) }
    
    var yottabits:  DataSize { DataSize(value: DataSize.Value(self), unit: .yottabit) }
    var zettabits:  DataSize { DataSize(value: DataSize.Value(self), unit: .zettabit) }
    var exabits:    DataSize { DataSize(value: DataSize.Value(self), unit: .exabit) }
    var petabits:   DataSize { DataSize(value: DataSize.Value(self), unit: .petabit) }
    var terabits:   DataSize { DataSize(value: DataSize.Value(self), unit: .terabit) }
    var gigabits:   DataSize { DataSize(value: DataSize.Value(self), unit: .gigabit) }
    var megabits:   DataSize { DataSize(value: DataSize.Value(self), unit: .megabit) }
    var kilobits:   DataSize { DataSize(value: DataSize.Value(self), unit: .kilobit) }
    
    var yobibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .yobibyte) }
    var zebibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .zebibyte) }
    var exbibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .exbibyte) }
    var pebibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .pebibyte) }
    var tebibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .tebibyte) }
    var gibibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .gibibyte) }
    var mebibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .mebibyte) }
    var kibibytes:  DataSize { DataSize(value: DataSize.Value(self), unit: .kibibyte) }
    
    var yobibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .yobibit) }
    var zebibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .zebibit) }
    var exbibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .exbibit) }
    var pebibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .pebibit) }
    var tebibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .tebibit) }
    var gibibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .gibibit) }
    var mebibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .mebibit) }
    var kibibits:   DataSize { DataSize(value: DataSize.Value(self), unit: .kibibit) }
}
