//
//  NetworkService.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 16/10/2023.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

final class NetworkManager {
    
    // NOTE: It would print "1", "3", "2" (because request are happening in the different queue?)
    static func deletePost (
        postId: Int,
        callback: @escaping (JSON?, Error?) -> ()
    ) {
        print("1")
        
        guard let postURL = URL(string: "\(ApiConstants.postsPath)/\(postId)") else { return }
        AF.request(postURL, method: .delete, encoding: JSONEncoding.default).response { response in
            
            var recievedDataJSON: JSON?
            var recievedError: AFError?
            
            switch response.result {
            case .success(let data):
                guard let data else {
                    callback(recievedDataJSON, recievedError)
                    return
                }
                recievedDataJSON = JSON(data)
            case .failure(let error):
                recievedError = error
            }
            
            callback(recievedDataJSON, recievedError)
            
            print("2")
        }
        print("3")
    }
    
    static func fetchComments (
        postId: Int,
        callback: @escaping (_ recievedComments: [Comment]?, _ recievedError: Error?) -> ()
    ) {
        guard let commentUrl = URL(string: "\(ApiConstants.commentsPath)?postId=\(postId)") else { return }
        AF.request(commentUrl, method: .get, encoding: JSONEncoding.default).response { response in
            
            var recievedComments: [Comment]?
            var recievedError: Error?
            
            switch response.result {
            case .success(let data):
                guard let data else {
                    // In this case we would get 'nil' in 'recievedComments' and 'nil' in 'recievedError' (no data)
                    callback(recievedComments, recievedError)
                    return
                }
                do {
                    recievedComments = try JSONDecoder().decode([Comment].self, from: data)
                } catch let decoderError {
                    callback(recievedComments, decoderError) // In this case we would get 'nil' and 'Error' after failed attempt of decoding
                }
            case .failure(let error):
                recievedError = error // And if we got here, the final callback would be called with 'nil' and 'Error'
            }
            callback(recievedComments, recievedError) // this will always be called, except when the data is nil in case of .success
        }
    }
    
    static func fetchAlbums(
        userId: Int,
        callback: @escaping ([Album]?, Error?) -> ()
    ) {
        
        guard let albumURL = URL(string: "\(ApiConstants.albumsPath)?userId=\(userId)") else { return }
        
        AF.request(albumURL, method: .get, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let data else { return }
                do {
                    let albums = try JSONDecoder().decode([Album].self, from: data)
                    callback(albums, nil)
                } catch let recievedError {
                    callback(nil, recievedError)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
    
    static func fetchPhotos(
        albumId: Int,
        callback: @escaping ([Photo]?, Error?) -> ()
    ) {

        guard let photoURL = URL(string: "\(ApiConstants.photosPath)?albumId=\(albumId)") else { return }
        AF.request(photoURL, method: .get, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let data else { return }
                do {
                    let photo = try JSONDecoder().decode([Photo].self, from: data)
                    callback(photo, nil)
                } catch let recievedError {
                    callback(nil, recievedError)
                }
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
    
    static func fetchThumbnailImage(
        thumbnailURLString: String,
        callback: @escaping (UIImage?, AFError?) -> ()
    ) {
        // Wwe're trying to get data from cache. If we didn't - make the request.
        if let image = CacheManager.shared.imageCache.image(withIdentifier: thumbnailURLString) {
            callback(image, nil)
        } else {
            AF.request(thumbnailURLString).responseImage { response in
                switch response.result {
                case .success(let image):
                    // Adding image to cache
                    CacheManager.shared.imageCache.add(image, withIdentifier: thumbnailURLString)
                    callback(image, nil)
                case .failure(let error):
                    callback(nil, error)
                }
            }
        }
    }
    
    static func fetchImage(
        imageURLString: String,
        callback: @escaping (UIImage?, AFError?) -> ()
    ) {
        if let image = CacheManager.shared.imageCache.image(withIdentifier: imageURLString) {
            callback(image, nil)
        } else {
            AF.request(imageURLString).responseImage { response in
                guard let data = response.data else {
                    callback(nil, response.error)
                    return
                }
                
                if let image = UIImage(data: data) {
                    CacheManager.shared.imageCache.add(image, withIdentifier: imageURLString)
                    callback(image, nil)
                } else {
                    callback(nil, response.error)
                }
            }
        }
    }
    
    
    static func checkIfPostExists(userId: Int, title: String, completion: @escaping (_ postExists: Bool) -> Void) {
        
        guard let postUrl = URL(string: "\(ApiConstants.postsPath)?userId=\(userId)&title=\(title)") else { return }
        
        let task = URLSession.shared.dataTask(with: postUrl) { data, response, error in
            
            guard let data, let post = try? JSONDecoder().decode([Post].self, from: data) else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            if post.isEmpty {
                DispatchQueue.main.async { completion(false) }
            } else {
                DispatchQueue.main.async { completion(true) }
            }
        }
        task.resume()
    }
    
}
