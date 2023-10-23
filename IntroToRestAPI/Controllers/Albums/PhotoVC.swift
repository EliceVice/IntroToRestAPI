//
//  PhotoVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 23/10/2023.
//

import UIKit

class PhotoVC: UIViewController {
    
    var photo: Photo?

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // VC config
        view.backgroundColor = .systemBackground
        
        // Subviews
        view.addSubview(photoImageView)
        view.addSubview(activityIndicator)
        
        downloadPhoto()
    }
    
    override func viewWillLayoutSubviews() {
        let size = view.frame.width
        photoImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: size,
            height: size
        )
        photoImageView.center = view.center
        activityIndicator.center = photoImageView.center
    }

    private func downloadPhoto() {
        guard let photo,
              let imagePath = photo.url
        else {
            return
        }
        
        NetworkManager.fetchImage(imageURLString: imagePath) { [weak self] image, error in
            
            guard let image, error == nil else { return }
            
            self?.photoImageView.image = image
            self?.activityIndicator.stopAnimating()
        }
    }
    
}
