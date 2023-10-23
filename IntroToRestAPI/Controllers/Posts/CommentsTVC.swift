//
//  CommentsTVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 18/10/2023.
//

import UIKit

class CommentsTVC: UITableViewController {
    
    var postId: Int?
    
    var comments: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        
        fetchComments()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        
        let comment = comments[indexPath.row]
        cell.textLabel?.text = comment.name
        
        return cell
    }

    private func fetchComments() {
        guard let postId else { return }
        NetworkManager.fetchComments(postId: postId) { [weak self] recievedComments, recievedError in
            if let recievedError {
                print(recievedError)
                return
            }
            if let recievedComments {
                self?.comments = recievedComments
                self?.tableView.reloadData()
            }
        }
    }
   

}
