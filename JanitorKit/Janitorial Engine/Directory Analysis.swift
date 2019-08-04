//
//  Directory Analysis.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 8/3/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



internal extension TrackedDirectory {
    var filesThatShouldBeDeleted: [URL] {
        get {
            filesThathouldFileBeDeleted(in:
                url
                    .allChildren()
                    .annotatedAndSortedByDate()
                )
                .map { $0.url }
        }
    }
    
    
    private func filesThathouldFileBeDeleted(in annotatedSortedFiles: [AnnotatedFile]) -> [AnnotatedFile] {
        let oldFiles = annotatedSortedFiles.suffix(while: { annotatedFile in
            annotatedFile.age > self.oldestAllowedAge
        })
    }
}
