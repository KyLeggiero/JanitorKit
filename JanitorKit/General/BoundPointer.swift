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
public struct BoundPointer<Value>: DynamicProperty/*, BindingConvertible*/ {
    
    @Pointer
    private var internalPointer_onlySetOrGetWithBinding: Value
    
    public var wrappedValue: Value {
        get { binding.value }
        nonmutating set { binding.value = newValue }
    }
    
    public private(set) var binding: Binding<Value>
    
    public var didSet: OnValueDidChange {
        get { _internalPointer_onlySetOrGetWithBinding.onPointeeDidChange }
        nonmutating set { _internalPointer_onlySetOrGetWithBinding.onPointeeDidChange = newValue }
    }
    
    
    public init(wrappedValue: Value/*, didSet: @escaping OnValueDidChange = { _ in }*/) {
        self._internalPointer_onlySetOrGetWithBinding = *wrappedValue

        self.binding = .constant(wrappedValue)
        self.binding = Binding(
            get: self.getValueForBinding,
            set: self.setValueFromBinding
        )

//        self._internalPointer_onlySetOrGetWithBinding.onPointeeDidChange = didSet
    }
    
    
    private nonmutating func getValueForBinding() -> Value {
        return internalPointer_onlySetOrGetWithBinding
    }


    private nonmutating func setValueFromBinding(to newValue: Value) {
        internalPointer_onlySetOrGetWithBinding = newValue
    }
    
    
    
    public typealias OnValueDidChange = Pointer<Value>.OnPointeeDidChange
}
