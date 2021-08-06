//
//  Set Extensions.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 2019-08-17.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension Set {
    
    static func + (lhs: Set<Element>, rhs: Set<Element>) -> Set<Element> { lhs.union(rhs) }
    static func += (lhs: inout Set<Element>, rhs: Set<Element>) { lhs.formUnion(rhs) }
}
