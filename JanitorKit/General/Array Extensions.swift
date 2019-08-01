//
//  Array Extensions.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/28/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension Array where Element: Identifiable {
    
    func firstIndex(ofElementWithId needleId: Element.ID) -> Index? {
        return firstIndex(where: { $0.id == needleId })
    }
    
    
    @discardableResult
    mutating func replaceOrAppend(_ changedOrNewElement: Element) -> ReplaceOrAppendResult {
        if let index = firstIndex(ofElementWithId: changedOrNewElement.id) {
            self[index] = changedOrNewElement
            return .didReplace
        }
        else {
            self.append(changedOrNewElement)
            return .didAppend
        }
    }
    
    
    @discardableResult
    mutating func remove(firstElementWithId itemId: Element.ID) -> RemoveResult? {
        if let itemIndex = firstIndex(ofElementWithId: itemId) {
            let removedElement = remove(at: itemIndex)
            return .removedSuccessfully(removedElement: removedElement)
        }
        else {
            return .noSuchElementFound
        }
    }
    
    
    
    enum ReplaceOrAppendResult {
        case didReplace
        case didAppend
    }
    
    
    
    enum RemoveResult {
        case noSuchElementFound
        case removedSuccessfully(removedElement: Element)
    }
}
