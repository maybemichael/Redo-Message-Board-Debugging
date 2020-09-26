//
//  MessageThreadTests.swift
//  MessageBoardTests
//
//  Created by Andrew R Madsen on 9/13/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import XCTest
@testable import Message_Board

class MessageThreadTests: XCTestCase {
    
    var controller: MessageThreadController?
    var threadTableVC: MessageThreadsTableViewController?
    var threadDetailTVC: MessageThreadDetailTableViewController?
    
    override func setUp() {
        super.setUp()
        controller = MessageThreadController()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        threadTableVC = storyboard.instantiateViewController(identifier: "MessageThreadsTableViewController") as? MessageThreadsTableViewController
        threadDetailTVC = storyboard.instantiateViewController(identifier: "MessageThreadDetailTableViewController") as? MessageThreadDetailTableViewController
    }
    
    override func tearDown() {
        controller = nil
        threadTableVC = nil
        threadDetailTVC = nil
        super.tearDown()
    }
    
    func testFetchThreadFunction() {
        let expectation = XCTestExpectation(description: "Fetch Thread Call")
        controller?.fetchMessageThreads {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testCreateThreadFunction() {
        let expectation = XCTestExpectation(description: "Create Thread Call")
        controller?.createMessageThread(with: "XCTMessage") {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testMessageThreadDecode() throws {
        let url = controller!.mockDataURL
        var threads = [MessageThread]()
        do {
            let data = try Data(contentsOf: url)
            threads = try Array(JSONDecoder().decode([String: MessageThread].self, from: data).values)
        } catch {
            XCTFail("Error decoding message threads: \(error)")
        }
        XCTAssertEqual(threads.count, 2)
        XCTAssertEqual(threads.first!.messages.first!.sender, "Joe")
        XCTAssertEqual(threads.first!.identifier, "FCAB7137-1D84-40F5-94A7-8931032DAF82")
    }
    
    func testFirstSegue() {
        XCTAssertNotNil(threadTableVC?.messageThreadController)
        let identifiers = (threadTableVC?.value(forKey: "storyboardSegueTemplates") as? [AnyObject])?.compactMap({ $0.value(forKey: "identifier") as? String }) ?? []
        XCTAssertEqual(identifiers.first!, "ViewMessageThread")
    }
    
    func testSecondSegue() {
        let identifiers = (threadDetailTVC?.value(forKey: "storyboardSegueTemplates") as? [AnyObject])?.compactMap({ $0.value(forKey: "identifier") as? String }) ?? []
        XCTAssertEqual(identifiers.first!, "AddMessage")
    }
}
