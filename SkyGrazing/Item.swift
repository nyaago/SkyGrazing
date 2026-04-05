//
//  Item.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/03/22.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
