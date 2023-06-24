//
//  GoTrekkingTests.swift
//  GoTrekkingTests
//
//  Created by eazz on 9/6/2023.
//

import XCTest
@testable import GoTrekking

final class GoTrekkingTests: XCTestCase {
    var photo: ViewController!
    var keepPhoto: ViewController!
    var DetailViewController: ViewController!
    var event: ViewController!
    var NetworkMonitor: ViewController!
    var viewController: ViewController!
    var Login: ViewController!
    var Registration: ViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        photo = storyboard.instantiateInitialViewController() as? ViewController
        keepPhoto = storyboard.instantiateInitialViewController() as? ViewController
        DetailViewController = storyboard.instantiateInitialViewController() as? ViewController
        event = storyboard.instantiateInitialViewController() as? ViewController
        NetworkMonitor = storyboard.instantiateInitialViewController() as? ViewController
        viewController = storyboard.instantiateInitialViewController() as? ViewController
        Login = storyboard.instantiateInitialViewController() as? ViewController
        Registration = storyboard.instantiateInitialViewController() as? ViewController

        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateTime() throws {
        // Given
        //let date = "2023-06-23 19:59:00 UTC"
        // When
        //let result: () = viewController.UpdateTime()
        // Then
       // XCTAssertEqual(result, date, "Result is wrong.")
        let result = viewController.UpdateTime
       // Then
        XCTAssertNil(result, "Result is not nil.")
    }
   
    
    func testgetMethod() throws {
     //let nickname = "Eason"
    //let email = "a@a.com"
        let result = Registration.getMethod
        XCTAssertNil(result, "Result is not nil.")

        
    }
    
    func testLogin() throws {
     
    }
  
    func testlocationManager() throws {
     
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
