//
//  IdentifiableOnlyIfUsingSwiftUI.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/26/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



#if canImport(SwiftUI)
import SwiftUI



public protocol IdentifiableOnlyIfUsingSwiftUI: Hashable, Codable, Identifiable {
}
#else
public protocol IdentifiableOnlyIfUsingSwiftUI: Hashable, Codable {
    /// A type representing the stable identity of the entity associated with `self`.
    associatedtype ID : Hashable

    /// The stable identity of the entity associated with `self`.
    var id: Self.ID { get }
}
#endif
