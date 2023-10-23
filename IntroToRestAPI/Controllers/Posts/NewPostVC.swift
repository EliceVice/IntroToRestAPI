//
//  AddPostVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 16/10/2023.
//

import UIKit
import SwiftyJSON
import Alamofire

class NewPostVC: UIViewController {

    @IBOutlet weak var postTitleTF: UITextField!
    @IBOutlet weak var postBodyTF: UITextView!

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Post"
    }
    
}


// MARK: - IBActions

extension NewPostVC {
    
    @IBAction func postWithURLSessionTapped() {
        if let userIdForPost = user?.id,
           let postTitle = postTitleTF.text,
           let postBody = postBodyTF.text,
           let postURL = ApiConstants.postsUrl
        {
            // Setup request
            var request = URLRequest(url: postURL)
            
            // Header
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Body (we can also use SwiftyJSON here to create the body)
            let postBodyJSON: [String : Any] = [
                "userId" : userIdForPost,
                "title"  : postTitle,
                "body"   : postBody
            ]
            
            // Then we have to convert our dictionary into data
            let httpBody = try? JSONSerialization.data(withJSONObject: postBodyJSON)
            request.httpBody = httpBody
            
            // Create dataTask where we send new post
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data else { return }
                
                // We want to see the object that we get here (from data). And we can parse the data manually.
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let postUserIdFromResponse = json["userId"] as? Int,
                   let postIdFromResponse = json["id"] as? Int,
                   let postTitleFromResponse = json["title"] as? String,
                   let postBodyFromResponse = json["body"] as? String
                {
                    print("""
                    Post information from response (Manually):
                        userId: \(postUserIdFromResponse)
                        id: \(postIdFromResponse)
                        title: \(postTitleFromResponse)
                        body: \(postBodyFromResponse)
                    """)
                }
                
                // Or we can use SwiftyJSON library to parse the data (even if we don't know what the data model is)
                let json = JSON(data)
                print("""
                Post information from response (SwiftyJSON):
                    userId: \(json["userId"])
                    id: \(json["id"])
                    title: \(json["title"])
                    body: \(json["body"])
                
                full object: \n\(json)
                """)
                
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }.resume()
        }
    }
    
    @IBAction func postWithAlamofireTapped() {
        
        // Alamofire is a wrapper around URLSession
        guard let userIdForPost = user?.id,
              let postTitle = postTitleTF.text,
              let postBody = postBodyTF.text,
              let postURL = ApiConstants.postsUrl
        else { return }
        
        let parameters: Parameters = [
            "userId" : userIdForPost,
            "title"  : postTitle,
            "body"   : postBody
        ]
        
        NetworkManager.checkIfPostExists(userId: userIdForPost, title: postTitle) { [weak self] postExists in
            
            guard let self else { return }
            
            guard !postExists else {
                self.showErrorAlert(message: "Post with that title already exists")
                return
            }
            
            AF.request(postURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
                // Thanks to Alamofire now we are already on the main thread.
                
                debugPrint(response, terminator: "\n\n") // some objects have more printed parameters in debugPrint()
    //                print("Response (full): ", response, terminator: "\n\n") // it sucks
                print("Request: \n", response.request ?? "request is nil", terminator: "\n\n")
                print("Response: \n", response.response ?? "response is nil", terminator: "\n\n")
                
                switch response.result {
                    case .success(let data):
                        if let data {
                            print("User:\n\(JSON(data))")
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error): print(error)
                }
            }
        }
        
    }
    
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Whoops..",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        present(alert, animated: true)
    }
    
}
