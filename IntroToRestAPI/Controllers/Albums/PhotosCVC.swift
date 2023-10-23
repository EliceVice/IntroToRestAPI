//
//  PhotosCVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 19/10/2023.
//

import UIKit

class PhotosCVC: UICollectionViewController {

    var album: Album?
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photos"
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 2 - 5
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
    }
    
    private func fetchPhotos() {
        guard let album else { return }
        NetworkManager.fetchPhotos(albumId: album.id) { [weak self] photos, error in
            if let error {
                print(error)
                return
            }
            if let photos {
                self?.photos = photos
                self?.collectionView.reloadData()
            }
        }
    }
    
}


// MARK: - UICollectionViewDataSource

extension PhotosCVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let photo = photos[indexPath.row]
        cell.thumbnailUrl = photo.thumbnailUrl
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension PhotosCVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoVC()
        vc.photo = photos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
