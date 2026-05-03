//
//  BskyCreateSessionRequest.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/05/03.
//

import Foundation

struct BskyCreateSessionRequest: BskyPostable {
    typealias Response = BskySession
    
    let identifier: String
    let password: String
    
    func endPoint() -> String {
        "com.atproto.server.createSession"
    }
}
