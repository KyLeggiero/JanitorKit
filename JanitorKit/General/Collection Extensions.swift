//
//  Collection Extensions.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 8/17/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension Collection {
    
    func mapToSet<ElementOfResult>(_ mapper: (Element) -> ElementOfResult) -> Set<ElementOfResult> {
        var result = Set<ElementOfResult>(minimumCapacity: count)
        
        forEach { element in
            result.insert(mapper(element))
        }
        
        return result
    }
    
    
    func forEachIgnoringReturn<Ignored>(_ processor: (Element) throws -> Ignored) rethrows {
        for element in self {
            _ = try processor(element)
        }
    }
}



public extension BidirectionalCollection {
    func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence { // TODO: Test
        guard let suffixStartIndex = try lastIndex(where: predicate) else {
            return suffix(from: startIndex)
        }
        return suffix(from: suffixStartIndex)
    }
}
