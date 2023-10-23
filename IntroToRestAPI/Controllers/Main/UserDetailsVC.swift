//
//  UserDetailsVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 15/10/2023.
//

import UIKit
import MapKit

class UserDetailsVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let user else { return }
        
        nameLabel.text = user.name
        usernameLabel.text = user.username
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        websiteLabel.text = user.website
    }
    
}

// MARK: - IBActions

extension UserDetailsVC {
    @IBAction func locationButttonTapped() {
        guard let user,
              let address = user.address,
              let geo = address.geo,
              let lat = geo.lat,
              let lng = geo.lng,
              let latitude = Double(lat),
              let longitude = Double(lng)
        else { return }

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = user.name
        mapItem.openInMaps()
        
        // MARK: An alternative could be creating Map Kit View (MKMapView) item on storyboard
    }
    
    @IBAction func postsButtonTapped() {
        let storyboard = UIStoryboard(name: "Posts", bundle: nil)
        guard let postsTVC = storyboard.instantiateViewController(withIdentifier: "PostsTVC") as? PostsTVC else { return }
        postsTVC.user = user
        navigationController?.pushViewController(postsTVC, animated: true)
    }
    
    @IBAction func albumsButtonTapped() {
        let storyboard = UIStoryboard(name: "Albums", bundle: nil)
        guard let albumsTVC = storyboard.instantiateViewController(withIdentifier: "AlbumsTVC") as? AlbumsTVC else { return }
        albumsTVC.user = user
        navigationController?.pushViewController(albumsTVC, animated: true)
    }
    
    @IBAction func todosButtonTapped() {
        
    }
    
}

