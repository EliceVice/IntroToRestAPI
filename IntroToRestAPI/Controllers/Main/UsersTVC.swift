//
//  UsersTVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 14/10/2023.
//

import UIKit

class UsersTVC: UITableViewController {
 
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        
        fetchUsers()
    }
    
    private func fetchUsers() {
        guard let usersUrl = ApiConstants.usersUrl else { return }
        
        let task = URLSession.shared.dataTask(with: usersUrl) { [weak self] data, response, error in
            
            guard let self else { return }
            
//            print("Error:", error ?? "nil")
//            print("Response:", response ?? "nil")
//            print("Data:", data  ?? "nil")
            
            if let data {
                do {    
                    self.users = try JSONDecoder().decode([User].self, from: data)
//                    print(users)
                } catch {
                    print(error)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }

}


// MARK: - UITableViewDataSource

extension UsersTVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        let user = users[indexPath.row]
        
        userCell.textLabel?.text = user.name
        userCell.detailTextLabel?.text = user.email
        
        return userCell
    }
}


// MARK: - UITableViewDelegate

extension UsersTVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let userDetailsVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsVC") as? UserDetailsVC else { return }
        
        userDetailsVC.user = user
        
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
}


