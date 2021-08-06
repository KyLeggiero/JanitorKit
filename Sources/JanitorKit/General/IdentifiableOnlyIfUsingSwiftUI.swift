//
//  IdentifiableOnlyIfUsingSwiftUI.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 2019-07-26.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



#if canImport(SwiftUI)
import SwiftUI



public typealias IdentifiableOnlyIfUsingSwiftUI = Identifiable



#else
public protocol IdentifiableOnlyIfUsingSwiftUI {
    
    /// A type representing the stable identity of the entity associated with an instance.
    associatedtype ID : Hashable

    /// The stable identity of the entity associated with this instance.
    var id: Self.ID { get }
}
#endif
