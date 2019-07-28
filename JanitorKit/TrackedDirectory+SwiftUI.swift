//
//  TrackedDirectory+SwiftUI.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/26/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



extension TrackedDirectory: Identifiable {
    public var id: URL { url }
}
