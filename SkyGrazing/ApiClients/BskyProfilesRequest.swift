//
//  BskyProfilesRequest.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/25.
//

import Foundation

struct BskyProfilesRequest: BskyRequestable {
    typealias Response = BskyProfiles
        
    let actors: [String]
    
    func buildQueryItems() -> [URLQueryItem] {
        return actors.map { URLQueryItem(name: "actors", value: $0) }
    }
 
    func endPoint() -> String {
        "app.bsky.actor.getProfiles"
    }

}
