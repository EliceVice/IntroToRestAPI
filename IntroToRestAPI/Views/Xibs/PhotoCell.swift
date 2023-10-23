//
//  PhotoCell.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 19/10/2023.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var acticityIndicator: UIActivityIndicatorView!
    
    var thumbnailUrl: String? {
        didSet {
            getThumbnailURL()
        }
    }

    private func getThumbnailURL() {
        guard let thumbnailUrl else { return }
        NetworkManager.fetchThumbnailImage(thumbnailURLString: thumbnailUrl) { [weak self] image, error in
            if let error {
                print(error)
                return
            }
            self?.acticityIndicator.stopAnimating()
            self?.imageView.image = image
        }
    }
    
}
