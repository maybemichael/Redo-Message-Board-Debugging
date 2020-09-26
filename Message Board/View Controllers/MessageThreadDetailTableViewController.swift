//
//  MessageThreadDetailTableViewController.swift
//  Message Board
//
//  Created by Spencer Curtis on 8/7/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class MessageThreadDetailTableViewController: UITableViewController {
    
    // MARK: - Properties

    var messageThread: MessageThread? {
        didSet {
            print("Message thread: \(messageThread)")
        }
    }
    var messageThreadController: MessageThreadController? {
        didSet {
            print("Message thread controller: \(messageThreadController)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = messageThread?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThread?.messages.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)

        let message = messageThread?.messages[indexPath.row]
        
        cell.textLabel?.text = message?.text
        cell.detailTextLabel?.text = message?.sender
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddMessage" {
            guard let nav = segue.destination as? UINavigationController, let detailVC = nav.topViewController as? MessageDetailViewController else { return }
            detailVC.messageThreadController = messageThreadController
            detailVC.messageThread = messageThread
            print("made it through guard let")
//            destinationVC.messageThreadController = messageThreadController
//            destinationVC.messageThread = messageThread
        }
    }
}
