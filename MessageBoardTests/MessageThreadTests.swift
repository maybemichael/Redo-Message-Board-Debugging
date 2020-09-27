//
//  MessageThreadTests.swift
//  MessageBoardTests
//
//  Created by Andrew R Madsen on 9/13/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import XCTest
@testable import Message_Board

class MessageThreadTests: XCTestCase, UITableViewDelegate {
    
    var controller: MessageThreadController?
    var threadTVC: MessageThreadsTableViewController?
    var threadDetailTVC: MessageThreadDetailTableViewController?
    var detailVC: MessageDetailViewController?
    var storyboard: UIStoryboard?
    
    override func setUp() {
        super.setUp()
        controller = MessageThreadController()
        storyboard = UIStoryboard(name: "Main", bundle: .main)
        threadTVC = storyboard?.instantiateViewController(identifier: "MessageThreadsTableViewController") as? MessageThreadsTableViewController
        threadDetailTVC = storyboard?.instantiateViewController(identifier: "MessageThreadDetailTableViewController") as? MessageThreadDetailTableViewController
        detailVC = storyboard?.instantiateViewController(identifier: "MessageDetailViewController") as? MessageDetailViewController
    }
    
    override func tearDown() {
        controller = nil
        threadTVC = nil
        threadDetailTVC = nil
        storyboard = nil
        detailVC = nil
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
            XCTAssertNoThrow(try Array(JSONDecoder().decode([String: MessageThread].self, from: data).values))
        } catch {
            XCTFail("Error decoding message threads: \(error)")
        }
        XCTAssertEqual(threads.count, 2)
    }
    
    func testFirstSegue() {
        XCTAssertNotNil(threadTVC?.messageThreadController)
        let identifiers = (threadTVC?.value(forKey: "storyboardSegueTemplates") as? [AnyObject])?.compactMap({ $0.value(forKey: "identifier") as? String }) ?? []
        XCTAssertEqual(identifiers.first!, "ViewMessageThread")
    }
    
    func testSecondSegue() {
        let identifiers = (threadDetailTVC?.value(forKey: "storyboardSegueTemplates") as? [AnyObject])?.compactMap({ $0.value(forKey: "identifier") as? String }) ?? []
        XCTAssertEqual(identifiers.first!, "AddMessage")
    }
    
    func testSegueToMessageThreadDetailVC() {
        let segue = UIStoryboardSegue(identifier: "ViewMessageThread", source: threadTVC!, destination: threadDetailTVC!)
        let message = MessageThread.Message(text: "Some Message", sender: "Miguelito", timestamp: Date())
        threadTVC?.messageThreadController.messageThreads.append(MessageThread(title: "Test Thread", messages: [message], identifier: UUID().uuidString))
        threadTVC?.tableView.selectRow(at: [0, 0], animated: false, scrollPosition: .top)
        threadTVC?.prepare(for: segue, sender: nil)
        XCTAssertNotNil(threadDetailTVC?.messageThreadController)
        XCTAssertNotNil(threadDetailTVC?.messageThread)
    }
    
    func testSegueToMessageDetailVC() {
        let segue = UIStoryboardSegue(identifier: "ViewMessageThread", source: threadTVC!, destination: threadDetailTVC!)
        let message = MessageThread.Message(text: "Some Message", sender: "Miguelito", timestamp: Date())
        let thread = MessageThread(title: "Test Thread", messages: [message], identifier: UUID().uuidString)
        threadTVC?.messageThreadController.messageThreads.append(MessageThread(title: "Test Thread", messages: [message], identifier: UUID().uuidString))
        threadTVC?.tableView.selectRow(at: [0, 0], animated: false, scrollPosition: .top)
        threadTVC?.prepare(for: segue, sender: nil)
        XCTAssertNotNil(threadDetailTVC?.messageThreadController)
        XCTAssertNotNil(threadDetailTVC?.messageThread)

        let nav = storyboard?.instantiateViewController(identifier: "DetailNavController") as! UINavigationController
        detailVC = nav.topViewController as? MessageDetailViewController
        threadDetailTVC?.messageThreadController?.messageThreads.append(thread)
        let secondSegue = UIStoryboardSegue(identifier: "AddMessage", source: threadDetailTVC!, destination: nav)
        threadDetailTVC?.prepare(for: secondSegue, sender: nil)
        XCTAssertNotNil(detailVC?.messageThreadController)
        XCTAssertNotNil(detailVC?.messageThread)
    }
}
