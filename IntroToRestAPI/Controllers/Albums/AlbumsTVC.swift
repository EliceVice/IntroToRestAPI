//
//  PostsTVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 15/10/2023.
//

import UIKit

class AlbumsTVC: UITableViewController {

    var user: User?
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAlbums()
        
        title = "Albums"
    }
    
    private func fetchAlbums() {
        guard let user else { return }
        NetworkManager.fetchAlbums(userId: user.id) { [weak self] albums, error in
            if let error {
                print(error)
            }
            if let albums {
                self?.albums = albums
                self?.tableView.reloadData()
            }
        }
    }

}


// MARK: - UITableViewDataSource

extension AlbumsTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        
        let album = albums[indexPath.row]
        cell.textLabel?.text = album.title
        return cell
    }
}


// MARK: - UITableViewDataDelegate

extension AlbumsTVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPhotosCVC", sender: nil)
    }
}


// MARK: - Navigation

extension AlbumsTVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photosCVC = segue.destination as? PhotosCVC,
           let indexPath = tableView.indexPathForSelectedRow
        {
            photosCVC.album = albums[indexPath.row]
        }
    }
}

