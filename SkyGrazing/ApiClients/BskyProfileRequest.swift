//
//  ApiBase.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/03/22.
//

import Foundation
struct BskyProfileRequest: BskyRequestable {
    
    typealias Response = BskyProfile
        
    let actor: String
    
    func buildQueryItems() -> [URLQueryItem] {
        [URLQueryItem(name: "actor", value: actor)]
    }
 
    func endPoint() -> String {
        "app.bsky.actor.getProfile"
    }
}
