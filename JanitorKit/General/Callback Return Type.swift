//
//  Callback Return Type.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// Okay so I had this idea where any time you have a function that doesn't return normally but instead promises to call
/// a callback should have some way for the compiler to enforce that. And I figure the most natural way to do that in
/// the current Swift language version is to have that function return a standard "callback type". So if you miss
/// calling the callback on a branch it'll complain that there's a void return from a non-void function, and if you
/// call the callback without returning it'll complain that the value is unused. I don't know if this will end up being
/// a Good Idea™, but I figure this smaller project is a great place to try it out.
public enum ReturnsViaCallback {
    /// Signifies that you acknowledge that this is indeed a branch where the callback is not called, but promise that
    /// this is because it will be called from some external function which doesn't follow this pattern of having a
    /// special callback return type.
    case willReturnFromUntypedContext
}



/// The return type used by callback blocks
public typealias CallbackReturnType = Void



public typealias BlindCallback = () -> CallbackReturnType
public typealias Callback<Result> = (Result) -> CallbackReturnType
public typealias ChainedCallback<UltimateResult> = (Callback<UltimateResult>) -> ReturnsViaCallback
