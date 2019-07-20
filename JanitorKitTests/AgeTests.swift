//
//  AgeTests.swift
//  JanitorKitTests
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import XCTest
@testable import JanitorKit



class AgeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testCustomUnits_days() {
        let numberOfSecondsPerDay = 86_400
        
        let oneDayInSeconds = Age(value: numberOfSecondsPerDay, unit: .seconds)
        let oneDayInDays = oneDayInSeconds.convert(to: .days)
        XCTAssertEqual(oneDayInDays.value, 1)
        
        XCTAssertEqual(oneDayInDays.convert(to: .seconds).value, Age.Value(numberOfSecondsPerDay))
    }
    
    
    func testCustomUnits_weeks() {
        let numberOfSecondsPerWeek = 604_800
        
        let oneWeekInSeconds = Age(value: numberOfSecondsPerWeek, unit: .seconds)
        let oneDayInDays = oneWeekInSeconds.convert(to: .weeks)
        XCTAssertEqual(oneDayInDays.value, 1)
        
        XCTAssertEqual(oneDayInDays.convert(to: .seconds).value, Age.Value(numberOfSecondsPerWeek))
    }
    
    
    func testCustomUnits_years() {
        let numberOfSecondsPerYear = 31_556_925.216
        
        let oneYearInSeconds = Age(value: numberOfSecondsPerYear, unit: .seconds)
        let oneDayInDays = oneYearInSeconds.convert(to: .years)
        XCTAssertEqual(oneDayInDays.value, 1)
        
        XCTAssertEqual(oneDayInDays.convert(to: .seconds).value, Age.Value(numberOfSecondsPerYear))
    }
}
