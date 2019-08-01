//
//  BoundPointer.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/29/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



/// A hybrid of a SwiftUI `Binding` and a JanitorKit `Pointer`
@propertyWrapper
public struct BoundPointer<Pointee> {
    
    @Pointer
    private var internalPointer_onlySetOrGetWithBinding: Pointee
    
    public var wrappedValue: Pointee {
        get { binding.value }
        nonmutating set { binding.value = newValue }
    }
    
    public private(set) var binding: Binding<Pointee>
    
    public var didSet: OnValueDidChange {
        get { _internalPointer_onlySetOrGetWithBinding.onPointeeDidChange }
        nonmutating set { _internalPointer_onlySetOrGetWithBinding.onPointeeDidChange = newValue }
    }
    
    
    public init(initialValue: Pointee/*, didSet: @escaping OnValueDidChange*/) {
        self._internalPointer_onlySetOrGetWithBinding = *initialValue

        self.binding = .constant(initialValue)
        self.binding = Binding(
            getValue: self.getValueForBinding,
            setValue: self.setValueFromBinding
        )

//        self._internalPointer_onlySetOrGetWithBinding.didSet = didSet
//        /* UNDO: */self.wrappedValue = initialValue
    }
    
    
    private nonmutating func getValueForBinding() -> Pointee {
        return internalPointer_onlySetOrGetWithBinding
    }


    private nonmutating func setValueFromBinding(to newValue: Pointee) {
        internalPointer_onlySetOrGetWithBinding = newValue
    }
    
    
    
    public typealias OnValueDidChange = Pointer<Pointee>.OnPointeeDidChange
}
