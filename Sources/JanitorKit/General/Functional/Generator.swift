//
//  Generator.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 2019-08-04.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public typealias Generator<Result> = () -> Result
public typealias DangerousGenerator<Result> = () throws -> Result
