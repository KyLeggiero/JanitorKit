//
//  AnnotatedFile.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 8/3/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// A file which is annotated with some of its attributes
public struct AnnotatedFile {
    
    /// The URL of the file
    public let url: URL
    
    /// The size of the file's data
    public let size: DataSize
    
    /// The age of the file
    public let age: Age
}



public extension AnnotatedFile {
    init?(_ url: URL, fileManager: FileManager = .default) {
        do {
            let attributes = try fileManager.attributesOfItem(atPath: url.actualPath)
            let size = attributes[.size]
            let age = attributes[.userSpecifiedAge]
        }
        catch {
            return nil
        }
    }
}
