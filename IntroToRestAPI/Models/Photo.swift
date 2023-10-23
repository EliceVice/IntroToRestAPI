//
//  Photo.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 19/10/2023.
//

import Foundation

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}
