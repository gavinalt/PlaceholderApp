//
//  PlaceholderAppTests.swift
//  PlaceholderAppTests
//
//  Created by Gavin Li on 4/7/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import XCTest
@testable import PlaceholderApp

class PlaceholderAppTests: XCTestCase {
    
    var cacheStr: LocalCache<String, String>!
    var cacheInt: LocalCache<Int, Int>!
    
    override func setUp() {
        cacheStr = LocalCache.init()
        cacheInt = LocalCache.init()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCacheStr() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        cacheStr["key1"] = "value1"
        cacheStr["key2"] = "value2"
        XCTAssertEqual(cacheStr["key1"], "value1")
        XCTAssertEqual(cacheStr["key2"], "value2")
    }
    
    func testCacheInt() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        cacheInt[1] = 11
        cacheInt[2] = 22
        XCTAssertEqual(cacheInt[1], 11)
        XCTAssertEqual(cacheInt[2], 22)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
