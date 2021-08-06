//
//  Directory Analysis.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 2019-08-03.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



internal extension TrackedDirectory {
    func filesThatShouldBeDeleted() async -> Set<URL> {
        filesThathouldFileBeDeleted(
            in:
                url
                .allChildren()
                .annotatedAndSortedWithOldestAtStart()
        )
            .mapToSet { $0.url }
    }
    
    
    private func filesThathouldFileBeDeleted(in annotatedSortedFiles: [AnnotatedFile]) -> Set<AnnotatedFile> { // TODO: Test
        
        let totalSize = annotatedSortedFiles
            .lazy
            .map { $0.size }
            .reduce(into: .zero, +=)
        
        var cleanedSizeSoFar = DataSize.zero
        
        var sizeAfterCleaning: DataSize {
            return totalSize - cleanedSizeSoFar
        }
        
        let oldFiles = Set(annotatedSortedFiles
            .suffix(while: { annotatedFile in
                let shouldClean = annotatedFile.age > self.oldestAllowedAge
                if shouldClean {
                    cleanedSizeSoFar += annotatedFile.size
                }
                return shouldClean
            })
        )
        
        if sizeAfterCleaning < largestAllowedTotalSize {
            return oldFiles
        }
        else {
            let bigFiles = Set(annotatedSortedFiles
                .lazy
                .filter { !oldFiles.contains($0) }
                .suffix(while: { annotatedFile in
                    cleanedSizeSoFar += annotatedFile.size
                    return sizeAfterCleaning < largestAllowedTotalSize
                })
            )
            
            return oldFiles + bigFiles
        }
    }
}
