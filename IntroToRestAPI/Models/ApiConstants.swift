//
//  ApiUrls.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 14/10/2023.
//

import Foundation

struct ApiConstants {
    
    // Paths
    static let serverPath = "http://localhost:3000"
    
    static let usersPath = "\(serverPath)/users"
    static let postsPath = "\(serverPath)/posts"
    static let todosPath = "\(serverPath)/todos"
    static let albumsPath = "\(serverPath)/albums"
    static let photosPath = "\(serverPath)/photos"
    static let commentsPath = "\(serverPath)/comments"
    
    
    // Urls
    static let usersUrl = URL(string: usersPath)
    static let postsUrl = URL(string: postsPath)
    static let todosUrl = URL(string: todosPath)
    static let albumsUrl = URL(string: albumsPath)
    static let photosUrl = URL(string: photosPath)
    static let commentsURL = URL(string: commentsPath)
}

