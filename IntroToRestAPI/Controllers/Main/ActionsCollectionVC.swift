//
//  ActionsCollectionVC.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 08/10/2023.
//

import UIKit


enum UserActions: String, CaseIterable {
    case downloadImage = "Download image"
    case showUsers = "Show users"
}

class ActionsCollectionVC: UICollectionViewController {
    
    private let userActions = UserActions.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


// MARK: - UICollectionViewDataSource

extension ActionsCollectionVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let actionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell", for: indexPath) as! ActionCell
        actionCell.titleLabel.text = userActions[indexPath.row].rawValue
        
        return actionCell
    }
}


// MARK: - UICollectionViewDelegate

extension ActionsCollectionVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.row]
        switch userAction {
            case .downloadImage: performSegue(withIdentifier: "GoToImageVC", sender: nil)
            case .showUsers: performSegue(withIdentifier: "GoToUsersTVC", sender: nil)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ActionsCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (view.window?.windowScene?.screen.bounds.width ?? 100) - 50, height: 150)
    }
}

