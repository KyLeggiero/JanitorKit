//
//  Prefab Functions.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 8/6/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// Simply and immediately returns what it's given
public func echo<Echo>(_ echo: Echo) -> Echo { echo }


/// Simply and immediately calls what it's given
@discardableResult
public func call(_ blindCallback: BlindCallback) -> CallbackReturnType {
    blindCallback()
}


/// Creates a callback caller, which when called will pass the given value to the callback. This is useful for calling
/// many callbacks all at once which all get the same value.
///
/// ```
/// var arrayOfCallbacks = [(String) -> Void]()
///
/// // ... later ...
///
/// arrayOfCallbacks.forEach(call(passing: "Foobar"))
/// ```
///
/// - Parameter input: The value to pass to the callback
///
/// - Returns: A function which will pass `input` to any function passed to it
public func call<Input>(passing input: Input) -> (_ callback: Callback<Input>) -> CallbackReturnType {
    return { callback in
        return callback(input)
    }
}
