//
//  ImageVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 08/10/2023.
//

import UIKit

class ImageVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let imageURL = "https://w.forfun.com/fetch/29/2942cda3da91073bcaf9915bec9195d5.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    private func fetchImage() {
        guard let url = URL(string: imageURL) else { return }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
            // work with UI always happens in the main thread
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let error {
                    // Handling the error here...
                    print("Error:", error, terminator: "\n\n")
                    return
                } else {
                    print("Error is nil", terminator: "\n\n")
                }
                
                if let response {
                    print("Response:", response.description, terminator: "\n\n")
                } else {
                    print("Response is nil", terminator: "\n\n")
                }
                
                if let data, let image = UIImage(data: data) {
                    print("Data:", data, terminator: "\n\n")
                    self?.imageView.image = image
                } else {
                    // here we can let the user know why the image is not loaded
                    print("Data is nil", terminator: "\n\n")
                }
            }
        }
        task.resume()
    }
    
}
