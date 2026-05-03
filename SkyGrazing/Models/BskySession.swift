//
//  BskySession.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/05/03.
//

import Foundation

struct BskySession: Decodable {
    let did: String
    let handle: String
    let accessJwt: String
    let refreshJwt: String
}
