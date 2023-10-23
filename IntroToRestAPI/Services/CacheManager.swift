//
//  SwiftManager.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 23/10/2023.
//

import Foundation
import AlamofireImage

final class CacheManager {
    
    static let shared = CacheManager()
    
    private init() {}
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
    
}
