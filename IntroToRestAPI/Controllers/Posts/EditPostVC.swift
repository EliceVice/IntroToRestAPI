//
//  EditPostVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 17/10/2023.
//

import UIKit
import Alamofire

class EditPostVC: UIViewController {

    @IBOutlet weak var postTitleTF: UITextField!
    @IBOutlet weak var postBodyTF: UITextView!

    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Post"
        
        setupUI()
    }
    
    @IBAction func editButtonTapped() {
        
        guard let post,
              let newTitle = postTitleTF.text,
              let newBody = postBodyTF.text
        else { return }
       
        let parameters: Parameters = [
            "title" : newTitle,
            "body"  : newBody
        ]
        
        let postPath = "\(ApiConstants.postsPath)/\(post.id)"
        
        AF.request(postPath, method: .patch, parameters: parameters, encoding: JSONEncoding.default).response { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func commentsButtonTapped() {
        performSegue(withIdentifier: "goToCommentsTVC", sender: nil)
    }
    
    private func setupUI() {
        guard let post else { return }
        
        postTitleTF.text = post.title
        postBodyTF.text = post.body
    }
    
}

// MARK: - Navigation

extension EditPostVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let commentsTVC = segue.destination as? CommentsTVC, let post {
            commentsTVC.postId = post.id
        }
    }
}

