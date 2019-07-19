//
//  URL Operators.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/18/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension URL {
    
    static func / (lhs: URL, rhs: String) -> URL {
        return lhs.appendingPathComponent(rhs)
    }
    
    
    static func /= (lhs: inout URL, rhs: String) {
        lhs = lhs / rhs
    }
}



prefix func ~/ (rhs: String) -> URL {
    return URL.User.relativeToHome(path: rhs)
}



prefix operator ~/
