//
//  Post.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 15/10/2023.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String?
    let body: String?
}


