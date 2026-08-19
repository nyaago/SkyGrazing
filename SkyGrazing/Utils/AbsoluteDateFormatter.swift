//
//  Absolute​Date​Formatter​.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/19.
//

import Foundation

struct AbsoluteDateFormatter {
    static func string(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // 例: 2026/08/19 (日本の場合)
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    static func string(from dateString: String) -> String? {
        guard let date = ISO8601DateParser.date(from: dateString) else {
            return nil
        }
        return string(from: date)
    }
}
