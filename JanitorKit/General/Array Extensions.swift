//
//  Array Extensions.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/28/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension Array where Element: Identifiable {
    
    mutating func replaceOrAppend(_ changedOrNewElement: Element) -> ReplaceOrAppendResult {
        if let index = firstIndex(where: { $0.id == changedOrNewElement.id }) {
            self[index] = changedOrNewElement
            return .didReplace
        }
        else {
            self.append(changedOrNewElement)
            return .didAppend
        }
    }
    
    
    
    enum ReplaceOrAppendResult {
        case didReplace
        case didAppend
    }
}
