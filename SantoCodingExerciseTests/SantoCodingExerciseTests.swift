//
//  SantoCodingExerciseTests.swift
//  SantoCodingExerciseTests
//
//  Created by Santosh Jayapal on 18/11/18.
//  Copyright © 2018 com.santosh.project. All rights reserved.
//

import XCTest

@testable import SantoCodingExercise

class SantoCodingExerciseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
  
  func testListApi() {
    
    let listController = ListViewController()
    
    let promise = expectation(description: "Status code: 200")
    
    WebserviceManager.callGETWEbservice(api: requestApi) { status in
      switch status {
      case .success(data: let data, response: let response):
        print("Received list data ::\(String(describing: NSString(data: data, encoding: String.Encoding.ascii.rawValue))) response::\(response)")
        
        //Parse the data to get the data list array
          let listArray = (listController.parseListData(data: data))
        
        if listArray.count > 0 {
          promise.fulfill()
        }
       
      case .failed(error: let error):
         XCTFail("Error: \(error.localizedDescription)")
      case .failedMessage(message: let message):
        XCTFail("Error: \(message)")
      }
    }
    
     waitForExpectations(timeout: 15, handler: nil)
  }
  
  
    
}
