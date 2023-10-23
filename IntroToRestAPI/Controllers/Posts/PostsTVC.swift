//
//  PostsTVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 15/10/2023.
//

import UIKit

class PostsTVC: UITableViewController {
    
    var user: User?
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Posts"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
    
        // It is going to fetch the posts every time we come to this screen.
        // It is a bad solution, better to use 'delegate + protocol'
        fetchPosts()
    }

    private func fetchPosts() {
        
        guard let user else { return }
        
        let userId = user.id
        let postsPathForUser = "\(ApiConstants.postsPath)?userId=\(userId)"
        
        guard let postsUrl = URL(string: postsPathForUser) else { return }
        
        let task = URLSession.shared.dataTask(with: postsUrl) { [weak self] data, _, _ in
            guard let self, let data else { return }
            do {
                posts = try JSONDecoder().decode([Post].self, from: data)
            } catch { 
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    @objc private func addButtonTapped() {
        performSegue(withIdentifier: "goToNewPostVC", sender: nil)
    }
    
}


// MARK: - UITableViewDataSource

extension PostsTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        let post = posts[indexPath.row]
        postCell.textLabel?.text = post.title
        postCell.detailTextLabel?.text = post.body
        
        return postCell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postId = posts[indexPath.row].id
            
            // json in this case will be empty object, because it is a .delete request
            NetworkManager.deletePost(postId: postId) { [weak self] json, error in
                self?.posts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
//        else if editingStyle == .insert {
//
//        }
    }
}


// MARK: - UITableViewDataDelegate

extension PostsTVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToEditPostVC", sender: nil)
    }
}


// MARK: - Navigation

extension PostsTVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newPostVC = segue.destination as? NewPostVC, let user {
            newPostVC.user = user
        }
        if let editPostVC = segue.destination as? EditPostVC,
           let indexPath = tableView.indexPathForSelectedRow
        {
            editPostVC.post = posts[indexPath.row]
        }
    }
}

